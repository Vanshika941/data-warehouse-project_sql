# Data Warehouse Project — Medallion Architecture (Bronze, Silver, Gold)

A SQL Server data warehouse built using the **Medallion Architecture**, designed to consolidate ERP and CRM source data into clean, business-ready analytical views. The warehouse is organized into three progressive layers — **Bronze**, **Silver**, and **Gold** — each refining the data further until it's ready for reporting and analysis.

---

## 🏗️ Architecture Overview

```
   ┌─────────────┐        ┌─────────────┐        ┌─────────────┐
   │   BRONZE    │  --->  │   SILVER    │  --->  │    GOLD     │
   │  Raw Data   │        │  Cleaned &  │        │  Business-  │
   │  (Tables)   │        │  Standard.  │        │  Ready Views│
   └─────────────┘        └─────────────┘        └─────────────┘
        ▲                                              │
        │                                              ▼
   ERP & CRM Sources                          Analytical Reports
```

| Layer | Purpose | Object Type |
|-------|---------|--------------|
| 🥉 **Bronze** | Raw, unprocessed data ingested as-is from source systems | Tables |
| 🥈 **Silver** | Cleaned, standardized, and conformed data | Tables |
| 🥇 **Gold** | Business-ready, aggregated data modeled for reporting | Views |

---

## 📥 Bronze Layer — Raw Data

The Bronze layer holds raw data exactly as it arrives from the source systems, with no transformations applied. This preserves a historical, traceable copy of the source data.

- **Sources:** ERP and CRM systems
- **Process:** Data is extracted from source files/systems and loaded directly into SQL Server tables
- **Goal:** Maintain a single source of truth for raw, unmodified data that can be reprocessed at any time

---

## 🧹 Silver Layer — Cleaned & Standardized Data

The Silver layer takes the raw Bronze data and applies cleaning, transformation, and standardization rules to produce consistent, reliable tables.

- **Process:** Data from Bronze tables is cleaned, deduplicated, standardized (e.g., consistent naming, data types, formats), and loaded into Silver tables
- **Goal:** Provide a trusted, query-ready version of the data that's consistent across ERP and CRM sources

---

## 📊 Gold Layer — Business-Ready Views

The Gold layer is where the data is shaped into business-friendly views, optimized for reporting and analysis.

- **Process:** Views are created on top of Silver tables, applying business logic, joins, and aggregations
- **Output:** Includes analytical views built specifically to support **business reporting**
- **Goal:** Deliver data in a form that's directly consumable by BI tools, dashboards, and stakeholders

---

## 🛠️ Tech Stack

- **Database:** SQL Server (T-SQL)
- **Sources:** ERP, CRM
- **Architecture Pattern:** Medallion Architecture (Bronze → Silver → Gold)

---

## 📁 Project Structure

```
data-warehouse-project/
│
├── bronze/
│   └── scripts to create and load raw tables from ERP & CRM
│
├── silver/
│   └── scripts to clean, transform, and load standardized tables
│
├── gold/
│   └── scripts to create business-ready analytical views
│
└── README.md
```

---

## 🚀 How It Works (End-to-End Flow)

1. **Extract** raw data from ERP and CRM source systems
2. **Load** it into the **Bronze** layer as-is
3. **Transform & clean** Bronze data, then load it into the **Silver** layer
4. **Model** Silver data into business-focused **Gold** views
5. **Consume** Gold views for analytical and business reporting

---

## 📈 Use Cases

- Centralized reporting across ERP and CRM data
- Business intelligence dashboards
- Ad-hoc analytical queries on clean, standardized data

---

## 📌 Future Improvements

- Add automated ETL/ELT orchestration (e.g., scheduled jobs or a pipeline tool)
- Add data quality checks and validation between layers
- Add documentation for each table/view's schema and business logic

---

## 📂 How to Explore the Project

To understand the complete Data Warehouse pipeline:

1. Open the `source` folder.
2. Review the SQL scripts in the following order:

- `Bronze_and_silver.sql`
- `Loading_Silver_Layer.sql`
- `Data_Quality_Check.sql`
- `Gold_Layer.sql`
- `Final_datasets.sql`

Each SQL file represents a different stage of the ETL process, from loading raw data to creating the final analytical datasets.

## 📄 License

This project is open source and available for learning and reference purposes.
