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
| CRM  | sales_details |
| CRM  | crm_cust_info |
| CRM  | prd_info |
| ERP  | cust_az12 |
| ERP  | loc_A101 |
| ERP  | px_cat_g1v2 |

---

## Silver Layer (Cleansed & Standardized)

| Silver Table | Description |
|-------------|------------|
| sales_details | Cleaned and validated sales transactions |
| crm_cust_info | Standardized customer information |
| prd_info | Standardized product information |
| cust_az12 | Cleaned ERP customer master data |
| loc_A101 | Standardized location data |
| px_cat_g1v2 | Cleaned product category and pricing reference |

---

## Gold Layer (Business Model)

### Dimension Tables

| Gold Table | Source Tables |
|-----------|--------------|
| dim_customers | silver.crm_cust_info, silver.cust_az12, silver.loc_A101 |
| dim_products | silver.prd_info, silver.px_cat_g1v2 |

### Fact Table

| Gold Table | Source Table |
|-----------|--------------|
| fact_sales | silver.sales_details |

---

## Key Relationships

| Fact Table | Foreign Key | Dimension Table |
|-----------|-------------|----------------|
| fact_sales | customer_key | dim_customers |
| fact_sales | product_key | dim_products |
