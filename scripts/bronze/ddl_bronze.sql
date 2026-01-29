CREATE DATABASE CRM
USE CRM
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;


IF OBJECT_ID ('bronze.crm_cust_info', 'U') IS NOT NULL
   DROP TABLE bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info (
cst_id INT,
cst_key VARCHAR(20),
cst_firstname VARCHAR(100),
cst_lastname VARCHAR(100),
cst_marital_status VARCHAR(10),
cst_gndr VARCHAR(10),
cst_create_date DATETIME
);
GO
IF OBJECT_ID ('bronze.prd_info', 'U') IS NOT NULL
   DROP TABLE bronze.prd_info;
CREATE TABLE bronze.prd_info(
prd_id INT,
prd_key VARCHAR(20),
prd_nm VARCHAR(100),
prd_cost INT,
prd_line VARCHAR(10),
prd_start_dt DATETIME,
prd_end_dt DATETIME
);
GO 

IF OBJECT_ID ('bronze.sales_details', 'U') IS NOT NULL
   DROP TABLE bronze.sales_details;
CREATE TABLE bronze.sales_details(
sls_ord_num NVARCHAR(20) ,
sls_prd_key NVARCHAR(20),
sls_cust_id NVARCHAR(20),
sls_order_dt INT,
sls_ship_dt INT,
sls_due_dt INT,
sls_sales INT,
sls_quantity INT,
sls_price INT
);
GO 
IF OBJECT_ID ('bronze.cust_az12', 'U') IS NOT NULL
   DROP TABLE bronze.cust_az12;
CREATE TABLE bronze.cust_az12(
cid VARCHAR(20),
bdate DATETIME,
gen VARCHAR(10)
);
GO
IF OBJECT_ID ('bronze.loc_A101', 'U') IS NOT NULL
   DROP TABLE bronze.loc_A101;
CREATE TABLE bronze.loc_A101(
cid VARCHAR(20),
cntry VARCHAR(20)
);
GO
IF OBJECT_ID ('bronze.px_cat_g1v2', 'U') IS NOT NULL
   DROP TABLE bronze.px_cat_g1v2;
CREATE TABLE bronze.px_cat_g1v2(
id VARCHAR(20),
cat VARCHAR(100),
subcat VARCHAR(100),
maintenance VARCHAR(20)
);
GO

