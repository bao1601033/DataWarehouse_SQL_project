DROP PROCEDURE bronze.load_bronze
EXEC bronze.load_bronze

  
CREATE PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT 'Loading Bronze Layer';
		PRINT '====================================';
		PRINT 'Loading CRM Table';

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_cust_info;
		BULK INSERT bronze.crm_cust_info
		FROM 'D:\dataset_sql_de_project\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION:' + CAST(DATEDIFF(SECOND, @start_time, @end_time) As VARCHAR) + 'SECONDS';

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.prd_info;
		BULK INSERT bronze.prd_info
		FROM 'D:\dataset_sql_de_project\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION:' + CAST(DATEDIFF(SECOND, @start_time, @end_time) As VARCHAR) + 'SECONDS';

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.sales_details;
		BULK INSERT bronze.sales_details
		FROM 'D:\dataset_sql_de_project\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION:' + CAST(DATEDIFF(SECOND, @start_time, @end_time) As VARCHAR) + 'SECONDS';

		PRINT 'Loading ERP Table'
		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.cust_az12;
		BULK INSERT bronze.cust_az12
		FROM 'D:\dataset_sql_de_project\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION:' + CAST(DATEDIFF(SECOND, @start_time, @end_time) As VARCHAR) + 'SECONDS';

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.loc_A101;
		BULK INSERT bronze.loc_A101
		FROM 'D:\dataset_sql_de_project\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION:' + CAST(DATEDIFF(SECOND, @start_time, @end_time) As VARCHAR) + 'SECONDS';

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.px_cat_g1v2;
		BULK INSERT bronze.px_cat_g1v2
		FROM 'D:\dataset_sql_de_project\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION:' + CAST(DATEDIFF(SECOND, @start_time, @end_time) As VARCHAR) + 'SECONDS';
		SET @batch_end_time = GETDATE();
		PRINT '==========================================';
		PRINT 'Loading Bronze Layer is Completed';
		PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '==========================================';
	END TRY
	BEGIN CATCH
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
	END CATCH
END