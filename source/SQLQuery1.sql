USE DateWarehouse
SELECT * FROM gold.fact_sales f 
left join gold.dim_customer c
ON  c.customer_key = f.customer_key
WHERE c.customer_key IS NULL
