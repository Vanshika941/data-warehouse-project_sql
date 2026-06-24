USE DateWarehouse;

-- Check for Nulls or Duplicates in primary with NO RESULT as Expectation
 SELECT cst_id, count(*) FROM silver.crm_cust_info
 group by cst_id Having COUNT(*) > 1 OR cst_id IS NULL

select* from (select* , row_number() over(partition by cst_id order by cst_create_date) as flag_last
from silver.crm_cust_info where cst_id is not null )t
where flag_last =1

-- Check for Unwanted Spaces
SELECT cst_gndr from bronze.crm_cust_info
where cst_gndr != TRIM(cst_gndr) ;

-- DATA STANDARDIZATION AND CONSISTENCY
SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info
select * from silver.crm_cust_info
-- Check for Invalid Data Orders
select* from silver.crm_prd_info
where prd_start_dt < prd_end_dt

select * from silver.erp_px_cat_g1v2 ;

