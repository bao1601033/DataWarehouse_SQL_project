# Data Flow Overview

## Source Systems

| Source | Description |
|------|------------|
| CRM  | Customer, product, and sales transactional data |
| ERP  | Master data, reference data, and product categorization |

---

## Bronze Layer (Raw Data)
**Purpose:**  
The Bronze layer stores raw data ingested from source systems.  
At this stage, tables are created with source-aligned schemas and data types, and loading scripts are executed without applying business logic or transformations.
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
**Purpose:**  
The Silver layer applies data quality rules and transformations, including cleansing, normalization, standardization, and validation.  
This layer ensures consistent formats, corrected values, and reliable relationships across datasets.
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
**Purpose:**  
The Gold layer represents curated, business-ready data models optimized for analytics and reporting.  
It consists of dimension and fact tables with surrogate keys and well-defined relationships.
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
