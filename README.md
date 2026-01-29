# SQL Data Warehouse Project

## 📌 Project Overview

This project demonstrates the design and implementation of a **modern Data Warehouse** using **SQL Server**, following the **Medallion Architecture (Bronze – Silver – Gold)**.

The goal of the project is to ingest data from multiple source systems (CRM & ERP), apply data quality transformations, and deliver **business-ready analytical models** for reporting and analysis.

---

## 🏗️ Architecture Overview

The data warehouse is structured into three logical layers:

- **Bronze Layer** – Raw data ingestion
- **Silver Layer** – Data cleansing and standardization
- **Gold Layer** – Business and analytics models

---

## 📂 Source Systems

| Source | Description |
|------|------------|
| CRM | Customer, product, and sales transactional data |
| ERP | Master data, location data, and product categorization |

---

## 🥉 Bronze Layer – Raw Data Ingestion

**Purpose:**  
The Bronze layer stores raw data ingested directly from source systems.  
Tables are created with source-aligned schemas and data types.  
No business rules or transformations are applied at this stage.

**Key Characteristics:**
- Raw, append-only data
- Minimal transformations
- Schema mirrors source systems
- Used as a historical landing zone

| Source | Bronze Table |
|------|--------------|
| CRM | sales_details |
| CRM | crm_cust_info |
| CRM | prd_info |
| ERP | cust_az12 |
| ERP | loc_A101 |
| ERP | px_cat_g1v2 |

---

## 🥈 Silver Layer – Cleansing & Standardization

**Purpose:**  
The Silver layer improves data quality and consistency by applying cleansing, normalization, and validation rules.

**Key Transformations:**
- Remove duplicates and invalid records
- Handle null values
- Standardize text formats (e.g., gender, country, categories)
- Validate dates and numeric ranges
- Enforce business rules

| Silver Table | Description |
|-------------|------------|
| sales_details | Cleaned and validated sales transactions |
| crm_cust_info | Standardized customer information |
| prd_info | Standardized product information |
| cust_az12 | Cleaned ERP customer master data |
| loc_A101 | Standardized location data |
| px_cat_g1v2 | Cleaned product category and pricing reference |

---

## 🥇 Gold Layer – Business & Analytics Model

**Purpose:**  
The Gold layer provides curated, business-ready datasets optimized for analytics and reporting.  
It follows a **star schema** design using **fact and dimension tables** with surrogate keys.

### Dimension Tables

| Gold Table | Description | Source Tables |
|-----------|------------|---------------|
| dim_customers | Customer master dimension | silver.crm_cust_info, silver.cust_az12, silver.loc_A101 |
| dim_products | Product master dimension | silver.prd_info, silver.px_cat_g1v2 |

### Fact Table

| Gold Table | Description | Source Table |
|-----------|------------|--------------|
| fact_sales | Sales transactions fact table | silver.sales_details |

---

## 🔗 Key Relationships

| Fact Table | Foreign Key | Dimension Table |
|-----------|-------------|----------------|
| fact_sales | customer_key | dim_customers |
| fact_sales | product_key | dim_products |

---

## 🧩 Data Modeling Concepts Used

- Medallion Architecture (Bronze / Silver / Gold)
- Star Schema
- Surrogate Keys
- Slowly Changing Dimensions (design-ready)
- Data Quality Validation Rules
- SQL-based ETL / ELT

---

## 🛠️ Technologies Used

- **Database:** SQL Server
- **Language:** T-SQL
- **Version Control:** Git & GitHub
- **Modeling Approach:** Dimensional Modeling (Kimball-style)

---

## 🚀 How to Use This Project

1. Create schemas: `bronze`, `silver`, `gold`
2. Run table creation scripts in order:
   - Bronze layer
   - Silver layer
   - Gold layer
3. Execute data loading and transformation procedures
4. Query Gold layer tables for analytics and reporting

---

## 📈 Future Improvements

- Implement Slowly Changing Dimensions (Type 2)
- Add incremental loading logic
- Introduce data quality monitoring
- Integrate BI tools (Power BI / Tableau)
- Automate pipelines using orchestration tools

---

## 👤 Author

**Bao101033**  
Data Engineering Enthusiast  
Building scalable data platforms with SQL Server
