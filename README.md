**Mariner Data Engineering dbt Project**

# Getting started

## Install dependencies

Install [just](https://github.com/casey/just). We use this to create script recipes.
```
winget install --id Casey.Just --exact
```

Use Just to 1) setup venv 2) install project requirements.
```
just build
```

## Common recipes

Sqlfluff
```
# Sqlfluff fix all changed files between current branch and main
just fix_changed
# Aliased
just fc
# Or to lint
just lc

# Sqlfluff fix, search for file (wildcard auto added)
just fix sod_positions
# Aliased
just f sod_positions
# Or to lint
just l sod_positions
```


# Resources
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Review this [dbt-tips](https://github.com/erika-e/dbt-tips)


# Tooling

## VS Code Extensions
### [dbt Power User](https://github.com/AltimateAI/vscode-dbt-power-user)
### [Better Jinja](https://github.com/samuelcolvin/jinjahtml-vscode)

### [dbt-shortcuts](https://github.com/magnusfoldager/dbt-shortcuts)

## Other Packages
### [dbt-osmosis](https://z3z1ma.github.io/dbt-osmosis/docs/intro)


# Approach
- [Extracting schema and model names from the filename](https://discourse.getdbt.com/t/extracting-schema-and-model-names-from-the-filename/575)
