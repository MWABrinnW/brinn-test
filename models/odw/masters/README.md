# **DBT Pipeline Execution Guide**

This document provides instructions on running **dbt** jobs for the **masters data pipeline**, covering both **routine incremental runs** and **ad-hoc reprocessing**.

## **Dependencies**
Given the fluid nature of changes in dbt, if a list of current dependenceies is needed, use the following selector (or similar) to list dependencies. The `dbt list` command only displays the models and does not build or run them.

#### **Selectors:**
 ```
-s +bld_accounts+2,config.materialized:incremental +bld_holdings+2,config.materialized:incremental orion__bld_holdings
 ```
### **Incremental Tables**

**Masters** *(net new)*
- odw.build.bld_accounts
- odw.int_holdings

**Orion**

Upstream incremental tables that produce both accounts and holdings for Orion records

- datalake.orion.base_vw_asset
- datalake.orion.base_vw_assetvalue
- datalake.orion.base_vw_costbasisunrealized
- datalake.orion.base_vw_product
- odw.orion.bld_accounts
- odw.orion.bld_holdings

**Custodian**

Returns `has_custodian_feed`, `is_prime_broker`, etc.
- edw.custodian.bld_custodian_accounts
    - edw.custodian.bld_custodian_cash_balances
    - edw.custodian.bld_custodian_holdings
    - edw.custodian.int_fidelity_baystate_accounts
    - edw.custodian.int_fidelity_mps_accounts
    - edw.custodian.int_fidelity_mwa_accounts
    - edw.custodian.int_fidelity_swag_accounts
    - datalake.tda__int_accounts
    - edw.custodian.bld_securities

**Salesforce (CRM)**

Returns the CRM values in the normalized models
- odw.build.bld_salesforce_compass_accounts



## **How to Run in dbt?**

### **Incremental Run**

#### **Why?**  
To insert or refresh records in the **masters data pipeline** for a **dynamic date range**.

#### **How?**  
- The daily run uses a **lookback period** derived from the **variable dictionary macro** (`cvar.sql`).  
- `end_date` defaults to **today** (`current_date()`).  
- The `lookback` period determines the `start_date` from `end_date`.  
- The resulting **date range** is used to evaluate **new or updated records** per system key, per effective date.

#### **Variables:**  
```yaml
end_date: current_date()  # Default value (today)
lookback: 7               # Default lookback period (7 days)
dev_day_filer: 7          # (DEV only) default lookback window (7 days)
```

_**Important:**_ *In DEV, the dbt selector should include --vars "{'dev_day_filter':7}" **IF** the `lookback` is greater than 7; otherwise the following condition will return `false`. If the lookback is greater than 7, the `dev_day_filter` should be an equal or greater value.*

```sql
-- restrict lookback window in dev.
datediff('day', {{ start_date }}, {{ end_date }}) <= {{ dev_filter }}
```
The selector builds all upstream incremental tables of the explicit models, one downstream dependency, and any modified views.

#### **Selectors:**
 ```
 -s +bld_accounts+1,config.materialized:incremental +bld_holdings+1,config.materialized:incremental orion__bld_holdings state:modified,config.materialized:view
 ```


### **Reprocess (Ad-Hoc) Run**

### **Why?**  
Insert or refresh records in the **masters data pipeline** for an **explicit date range**.

### **How?**  
- The daily run uses a **lookback period** derived from the **variable dictionary macro** (`cvar.sql`).  
- The `end_date` variable is **explicitly passed** to determine the `start_date`.  
- The resulting **date range** is used to evaluate **new or updated records** per system key, per effective day.

### **Variables:**  
```yaml
end_date: 'yyyy-MM-dd'  # Explicitly passed
lookback: 7             # Default (7 days)
```
#### **Selectors:**
The selector builds all upstream incremental tables of the explicit models, one downstream dependency, and any modified views.
```
 -s +bld_accounts+1,config.materialized:incremental +bld_holdings+1,config.materialized:incremental orion__bld_holdings state:modified,config.materialized:view --vars "{'end_date':'yyyy-MM-dd}"`
```