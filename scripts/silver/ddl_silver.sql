IF OBJECT_ID ('silver.crm_cust_info', 'U') IS NOT NULL
   DROP TABLE silver.crm_cust_info;
CREATE TABLE silver.crm_cust_info (
cst_id INT,
cst_key VARCHAR(20),
cst_firstname VARCHAR(100),
cst_lastname VARCHAR(100),
cst_marital_status VARCHAR(10),
cst_gndr VARCHAR(10),
cst_create_date DATETIME,
dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO
IF OBJECT_ID ('silver.prd_info', 'U') IS NOT NULL
   DROP TABLE silver.prd_info;
CREATE TABLE silver.prd_info(
prd_id INT,
cat_id VARCHAR(20),
prd_key VARCHAR(20),
prd_nm VARCHAR(100),
prd_cost INT,
prd_line VARCHAR(20),
prd_start_dt DATETIME,
prd_end_dt DATETIME,
dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO 

IF OBJECT_ID ('silver.sales_details', 'U') IS NOT NULL
   DROP TABLE silver.sales_details;
CREATE TABLE silver.sales_details(
sls_ord_num NVARCHAR(20) ,
sls_prd_key NVARCHAR(20),
sls_cust_id NVARCHAR(20),
sls_order_dt date,
sls_ship_dt date,
sls_due_dt date,
sls_sales INT,
sls_quantity INT,
sls_price INT,
dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO 
IF OBJECT_ID ('silver.cust_az12', 'U') IS NOT NULL
   DROP TABLE silver.cust_az12;
CREATE TABLE silver.cust_az12(
cid VARCHAR(20),
bdate DATETIME,
gen VARCHAR(10),
dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO
IF OBJECT_ID ('silver.loc_A101', 'U') IS NOT NULL
   DROP TABLE silver.loc_A101;
CREATE TABLE silver.loc_A101(
cid VARCHAR(20),
cntry VARCHAR(20),
dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO
IF OBJECT_ID ('silver.px_cat_g1v2', 'U') IS NOT NULL
   DROP TABLE silver.px_cat_g1v2;
CREATE TABLE silver.px_cat_g1v2(
id VARCHAR(20),
cat VARCHAR(100),
subcat VARCHAR(100),
maintenance VARCHAR(20),
dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO
