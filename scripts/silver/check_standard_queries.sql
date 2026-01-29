/* =========================================================
   QUERIES TO VALIDATE DATA AFTER TRANSFORMATION (SILVER)
   ========================================================= */

/* =======================
   1. CRM_CUSTOMER_INFO
   ======================= */

-- 1.1 Check NULL or duplicate primary key
SELECT 
    cst_id,
    COUNT(*) AS cnt
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- 1.2 Check unwanted leading/trailing spaces
SELECT 
    cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname <> LTRIM(RTRIM(cst_firstname));

-- 1.3 Check gender standardization & consistency
SELECT DISTINCT
    cst_gndr
FROM silver.crm_cust_info;


/* =======================
   2. PRODUCT_INFO
   ======================= */

-- 2.1 Check NULL or duplicate primary key
SELECT 
    prd_id,
    COUNT(*) AS cnt
FROM silver.prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- 2.2 Check NULL or negative product cost
SELECT 
    prd_id,
    prd_cost
FROM silver.prd_info
WHERE prd_cost IS NULL OR prd_cost < 0;

-- 2.3 Check product line standardization
SELECT DISTINCT
    prd_line
FROM silver.prd_info;

-- 2.4 Check date consistency (end date must be >= start date)
SELECT 
    prd_id,
    prd_start_dt,
    prd_end_dt
FROM silver.prd_info
WHERE prd_end_dt < prd_start_dt;


/* =======================
   3. SALES_DETAILS (SOURCE VALIDATION)
   ======================= */

-- 3.1 Validate raw date fields (stored as INT)
SELECT 
    sls_due_dt
FROM bronze.sales_details
WHERE sls_due_dt <= 0
   OR LEN(sls_due_dt) <> 8
   OR sls_due_dt > 20500101
   OR sls_due_dt < 19000101;

-- 3.2 Check logical order of dates
SELECT 
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt
FROM bronze.sales_details
WHERE sls_order_dt > sls_ship_dt
   OR sls_order_dt > sls_due_dt;

-- 3.3 Validate business rules for sales, quantity, price
-- Rule: Sales = Quantity * Price (no NULL, zero, or negative values)
SELECT DISTINCT
    sls_sales   AS old_sales,
    sls_quantity AS old_quantity,
    sls_price   AS old_price,

    -- Corrected sales value
    CASE 
        WHEN sls_sales IS NULL
          OR sls_sales <= 0
          OR sls_sales <> sls_quantity * ABS(sls_price)
        THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END AS corrected_sales,

    -- Corrected price value
    CASE 
        WHEN sls_price IS NULL OR sls_price <= 0
        THEN sls_sales / NULLIF(sls_quantity, 0)
        ELSE sls_price
    END AS corrected_price

FROM bronze.sales_details
WHERE sls_sales IS NULL
   OR sls_quantity IS NULL
   OR sls_price IS NULL
   OR sls_sales <= 0
   OR sls_quantity <= 0
   OR sls_price <= 0
   OR sls_sales <> sls_quantity * sls_price;
