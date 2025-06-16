import json
import io
import sys
import argparse
import logging
from pathlib import Path

import duckdb
import polars as pl


# Set up logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s")
logger = logging.getLogger(__name__)


def arg_parser(args_list: list = None):
    parser = argparse.ArgumentParser()

    if args_list is None:
        args_list = sys.argv[1:]

    parser.add_argument(
        "--run_results",
        type=Path,
        default=Path("//mh-file/ActiveBatchShare/prod/ops/prod_artifacts/run_results.json"),
        required=False,
        help="Path to run_results.json"
    )
    parser.add_argument(
        "--manifest",
        type=Path,
        default=Path("//mh-file/ActiveBatchShare/prod/ops/dbt/rev360//manifest.json"),
        required=False,
        help="Path to manifest.json",
    )

    args, unknown = parser.parse_known_args()
    return args


class dbtArtifacts:
    def __init__(self, run_results: Path, manifest: Path, **kwargs):
        logger.info("Initializing dbtArtifacts with run_results: %s and manifest: %s", run_results, manifest)
        self.kwargs = kwargs
        self.run_results_dict = self.load_from_file(run_results)
        self.manifest_dict = self.load_from_file(manifest)

        # Run results
        self.results = pl.read_json(io.StringIO(json.dumps(self.run_results_dict["results"])))
        self.args = pl.read_json(io.StringIO(json.dumps(self.run_results_dict["args"])))
        self.elapsed_time = self.run_results_dict["elapsed_time"]
        self.metadata = pl.read_json(io.StringIO(json.dumps(self.run_results_dict["metadata"])))

        # Manifest
        logger.info("Parsing manifest nodes...")
        clean_nodes = []
        for k, v in self.manifest_dict["nodes"].items():
            try:
                clean_nodes.append(dict(v))
            except Exception as e:
                logger.warning(f"Skipping malformed node: {k} due to error: {e}")
        logger.info("Loaded %d manifest nodes", len(clean_nodes))

        self.nodes = pl.DataFrame(clean_nodes, infer_schema_length=5000)

        self.sources = pl.DataFrame(
            [{**v} for k, v in self.manifest_dict["sources"].items()],
            infer_schema_length=500
        )


    def load_from_file(self, file_path):
        logger.info("Loading file: %s", file_path)
        if file_path.is_file():
            with open(file_path, "r") as fp:
                return json.load(fp)
        else:
            raise FileNotFoundError(f"File not found: {file_path}")


def main():
    logger.info("Starting script...")
    args = arg_parser()

    artifacts = dbtArtifacts(run_results=args.run_results, manifest=args.manifest)

    df_results = artifacts.results
    logger.info("Loaded %d dbt results", df_results.height)

    sql = f"""
    select
        execution_time::decimal(12,2) as run_time_sec
        , (run_time_sec / 60)::decimal(12,2) as run_time_min
        , status as status
        , (adapter_response::json).rows_affected::int as rows_affected
        , case
            when unique_id ilike 'model%' then 'model'
            when unique_id ilike 'test%' then 'test'
            when unique_id ilike 'operation%' then 'operation'
            end::text as type
        , relation_name as node_name
    from artifacts.df_results
    where 1=1
        and type <> 'operation'
    order by
        case
            when status ilike 'fail%' then 1
            when status ilike 'error%' then 2
            when status ilike 'warn' then 3
            else 4
        end,
        run_time_sec desc,
        type,
        status
    limit 80
    """

    logger.info("Executing summary SQL...")
    duckdb.sql(sql).show(max_rows=80, max_width=160)
    logger.info("Script complete.")


if __name__ == "__main__":
    main()
