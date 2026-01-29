CREATE PROCEDURE silver.load_silver AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		SET @start_time = GETDATE()
		PRINT'>>TRUNCATE THEN INSERT TABLE: silver.crm_cust_info '
		TRUNCATE TABLE silver.crm_cust_info;
		INSERT INTO silver.crm_cust_info(
		   cst_id,
		   cst_key,
		   cst_firstname,
		   cst_lastname,
		   cst_marital_status,
		   cst_gndr,
		   cst_create_date
		)
		SELECT 
			cst_id ,
			cst_key ,
			LTRIM(RTRIM(cst_firstname)) as cst_firstname ,
			LTRIM(RTRIM(cst_lastname)) as cst_lastname ,
			CASE
				 WHEN UPPER(LTRIM(RTRIM(cst_marital_status))) = 'S' THEN 'Single'
				 WHEN UPPER(LTRIM(RTRIM(cst_marital_status))) = 'M' THEN 'Married'
				 ELSE 'N/A' -- Enhancing missing values
			END AS cst_marital_status,  -- Normalize marital status values to readable format
			CASE 
				 WHEN UPPER(LTRIM(RTRIM(cst_gndr))) = 'F' THEN 'Female'
				 WHEN UPPER(LTRIM(RTRIM(cst_gndr))) = 'M' THEN 'Male'
				 ELSE 'N/A'
			END AS cst_gndr,
			cst_create_date
		FROM (
			SELECT *,
			ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
			FROM bronze.crm_cust_info
			WHERE cst_id IS NOT NULL
			)t 
			WHERE flag_last = 1; -- select most recent record per customer
		SET @end_time = GETDATE();
		PRINT('>>LOAD DURATION: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' SECONDS ');

		SET @start_time = GETDATE()
		PRINT'>>TRUNCATE THEN INSERT TABLE: silver.prd_info ';
		TRUNCATE TABLE silver.prd_info
		INSERT INTO silver.prd_info(
		prd_id,
		cat_id,
		prd_key,
		prd_nm,
		prd_cost,
		prd_line,
		prd_start_dt,
		prd_end_dt
		)
		SELECT 
		prd_id,
		REPLACE(SUBSTRING(prd_key,1,5), '-','_') AS cat_id,
		SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key,
		prd_nm,
		ISNULL(prd_cost,0) AS prd_cost,
		CASE UPPER(LTRIM(RTRIM(prd_line)))
			 WHEN 'M' THEN 'Mountain'
			 WHEN 'R' THEN 'Road'
			 WHEN 'S' THEN 'Other Sales'
			 WHEN 'T' THEN 'Touring'
			 ELSE 'N/A'
		END AS prd_line, -- Map prd_line codes to descriptive values
		CAST(prd_start_dt AS DATE) AS prd_start_dt, --converting data types
		CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key
									  ORDER BY prd_start_dt) -1 AS DATE)
									  AS prd_end_dt -- Enrichment
		FROM bronze.prd_info
		SET @end_time = GETDATE()
		PRINT('>>LOAD DURATION: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' SECONDS ');
		

		SET @start_time = GETDATE()
		PRINT'>>TRUNCATE THEN INSERT TABLE: silver.sales_details '
		TRUNCATE TABLE silver.sales_details 
		INSERT INTO silver.sales_details (
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		sls_order_dt,
		sls_ship_dt,
		sls_due_dt,
		sls_sales,
		sls_quantity,
		sls_price
		)
		SELECT
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		CASE WHEN sls_order_dt =0 or len(sls_order_dt) <>8 then null
			 ELSE CAST(CAST(sls_order_dt AS VARCHAR)AS DATE)
			 END AS sls_order_dt,
		CASE WHEN sls_ship_dt =0 or len(sls_ship_dt) <>8 then null
			 ELSE CAST(CAST(sls_ship_dt AS VARCHAR)AS DATE)
			 END AS sls_ship_dt,
		CASE WHEN sls_due_dt =0 or len(sls_due_dt) <>8 then null
			 ELSE CAST(CAST(sls_due_dt AS VARCHAR)AS DATE)
			 END AS sls_due_dt,
		CASE WHEN sls_sales IS NULL OR sls_sales <=0 OR sls_sales <> sls_quantity * ABS(sls_price)
			   THEN sls_quantity * ABS(sls_price)
			 ELSE sls_sales
		END AS sls_sales,
		sls_quantity,
		CASE WHEN sls_price IS NULL OR sls_price <= 0 
			 THEN sls_sales / NULLIF(sls_quantity,0)
			 ELSE sls_price
		END AS sls_price
		FROM bronze.sales_details
		SET @end_time = GETDATE();
		PRINT('>>LOAD DURATION: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' SECONDS ');

		SET @start_time = GETDATE()
		PRINT'>>TRUNCATE THEN INSERT TABLE: silver.cust_az12 '
		TRUNCATE TABLE silver.cust_az12
		INSERT INTO silver.cust_az12(cid,bdate, gen )
		SELECT
		CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4, LEN(cid)) --REMOVE 'NAS' prefix if present
			 ELSE cid
		END AS cid,
		CASE WHEN bdate > GETDATE() THEN NULL -- set future bday null
			 ELSE bdate
		END AS bdate,
		CASE WHEN UPPER(LTRIM(RTRIM(gen))) IN ('F', 'Female') THEN 'Female'
			 WHEN UPPER(LTRIM(RTRIM(gen))) IN  ('M', 'Male') THEN 'Male'
			 ELSE 'N/A'
		END AS gen -- normallize 
		FROM bronze.cust_az12
		SET @end_time = GETDATE();
		PRINT('>>LOAD DURATION: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' SECONDS ');

		SET @start_time = GETDATE()
		PRINT'>>TRUNCATE THEN INSERT TABLE: silver.loc_A101 '
		TRUNCATE TABLE silver.loc_A101
		INSERT INTO silver.loc_A101(
		cid,cntry
		)
		SELECT
		REPLACE(cid, '-','') cid,
		CASE WHEN RTRIM(LTRIM(cntry)) = 'DE' THEN 'Germany'
			 WHEN RTRIM(LTRIM(cntry)) IN ('US', 'USA') THEN 'United States'
			 WHEN RTRIM(LTRIM(cntry)) = '' or cntry IS NULL THEN 'N/A'
			 ELSE RTRIM(LTRIM(cntry))
		END AS cntry
		FROM bronze.loc_A101
		SET @end_time = GETDATE();
		PRINT('>>LOAD DURATION: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' SECONDS ');

		SET @start_time = GETDATE()
		PRINT'>>TRUNCATE THEN INSERT TABLE: silver.px_cat_g1v2 '
		TRUNCATE TABLE silver.px_cat_g1v2
		INSERT INTO silver.px_cat_g1v2 (id,cat,subcat,maintenance)
		SELECT
		id,
		cat,
		subcat,
		maintenance
		FROM bronze.px_cat_g1v2
		SET @end_time = GETDATE();
		PRINT('>>LOAD DURATION: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' SECONDS ');
		SET @batch_end_time = GETDATE();
		PRINT '==========================================';
		PRINT 'Loading SILVER Layer is Completed';
		PRINT ('   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds');
		PRINT '==========================================';
	END TRY
	BEGIN CATCH
		PRINT 'ERROR OCCURED DURING LOADING SILVER LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
	END CATCH
END

