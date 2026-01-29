# Data Flow Overview

## Source Systems

| Source | Description |
|------|------------|
| CRM  | Customer, product, and sales transactional data |
| ERP  | Master data, reference data, and product categorization |

---

## Bronze Layer (Raw Data)

| Source | Bronze Table |
|------|--------------|
| CRM  | crm_sales_details |
| CRM  | crm_cust_info |
| CRM  | crm_prd_info |
| ERP  | erp_cust_az12 |
| ERP  | erp_loc_a101 |
| ERP  | erp_px_cat_g1v2 |

---

## Silver Layer (Cleansed & Standardized)

| Silver Table | Description |
|-------------|------------|
| crm_sales_details | Cleaned and validated sales transactions |
| crm_cust_info | Standardized customer information |
| crm_prd_info | Standardized product information |
| erp_cust_az12 | Cleaned ERP customer master data |
| erp_loc_a101 | Standardized location data |
| erp_px_cat_g1v2 | Cleaned product category and pricing reference |

---

## Gold Layer (Business Model)

### Dimension Tables

| Gold Table | Source Tables |
|-----------|--------------|
| dim_customers | crm_cust_info, erp_cust_az12, erp_loc_a101 |
| dim_products | crm_prd_info, erp_px_cat_g1v2 |

### Fact Table

| Gold Table | Source Table |
|-----------|--------------|
| fact_sales | crm_sales_details |

---

## Key Relationships

| Fact Table | Foreign Key | Dimension Table |
|-----------|-------------|----------------|
| fact_sales | customer_key | dim_customers |
| fact_sales | product_key | dim_products |
