# End-to-End Data Flow (Single Table View)

| Source System | Bronze Layer Table | Silver Layer Table | Gold Layer Table |
|--------------|-------------------|-------------------|-----------------|
| CRM | crm_sales_details | crm_sales_details | fact_sales |
| CRM | crm_cust_info | crm_cust_info | dim_customers |
| CRM | crm_prd_info | crm_prd_info | dim_products |
| ERP | erp_cust_az12 | erp_cust_az12 | dim_customers |
| ERP | erp_loc_a101 | erp_loc_a101 | dim_customers |
| ERP | erp_px_cat_g1v2 | erp_px_cat_g1v2 | dim_products |
