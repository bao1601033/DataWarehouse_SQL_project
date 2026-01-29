IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO
CREATE VIEW gold.dim_customer AS
SELECT
ROW_NUMBER() OVER(ORDER BY cr.cst_id) AS customer_key,
cr.cst_id AS customer_id,
cr.cst_key AS customer_number,
cr.cst_firstname AS firstname,
cr.cst_lastname AS lastname,
CASE WHEN cr.cst_gndr <> 'N/A' THEN cr.cst_gndr
     ELSE cu.gen 
END AS gender,
cu.bdate AS birthdate,
lo.cntry AS country,
cr.cst_marital_status AS marital_status,
cr.cst_create_date AS create_date
FROM silver.crm_cust_info cr LEFT JOIN silver.cust_az12 cu ON cr.cst_key = cu.cid
                             LEFT JOIN silver.loc_A101 lo ON cr.cst_key = lo.cid



IF OBJECT_ID('gold.dim_product', 'V') IS NOT NULL
    DROP VIEW gold.dim_product;
GO
CREATE VIEW gold.dim_product AS
SELECT 
ROW_NUMBER () OVER (ORDER BY prd_start_dt,pr.prd_key) AS product_key,
pr.prd_id AS product_id,
pr.cat_id AS category_id,
pr.prd_key AS product_number, 
pr.prd_nm AS product_name,
px.cat AS category,
px.subcat AS subcategory,
px.maintenance AS maintenance,
pr.prd_cost AS product_cost,
pr.prd_line AS product_line,
pr.prd_start_dt AS start_date,
pr.prd_end_dt AS end_date
FROM silver.prd_info pr LEFT JOIN silver.px_cat_g1v2 px ON pr.cat_id = px.id

IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO
CREATE VIEW gold.fact_sales AS
SELECT 
sd.sls_ord_num AS  order_number,
gcu.customer_key,
gpr.product_key,
sd.sls_order_dt AS order_date,
sd.sls_ship_dt AS shipping_date,
sd.sls_due_dt AS due_date,
sls_sales AS sales_amount,
sd.sls_quantity AS quantity,
sd.sls_price AS price
FROM silver.sales_details sd LEFT JOIN gold.dim_customer gcu ON sd.sls_cust_id = gcu.customer_id
							 LEFT JOIN gold.dim_product gpr ON sd.sls_prd_key = gpr.product_number
