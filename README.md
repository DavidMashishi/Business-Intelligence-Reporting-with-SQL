# Business Intelligence Reporting with SQL

## 📑 Table of Contents

- [Project Overview](#-project-overview)
- [Business Problem](#-business-problem)
- [Business Objectives](#-business-objectives)
- [Dataset](#-dataset)
- [Data Model](#-data-model)
- [Database Tables](#-database-tables)
- [Tools & Technologies](#-tools--technologies)
- [SQL Skills Demonstrated](#-sql-skills-demonstrated)
- [Detailed Analysis](#-detailed-analysis)
- [Executive Reporting](#-executive-reporting)
- [Power BI Dashboard](#-power-bi-dashboard)
- [Business Insights](#-business-insights)
- [Business Impact](#-business-impact)
- [Recommendations](#-recommendations)
- [Conclusion](#-conclusion)

---

## 📊 Project Overview

This project demonstrates how **SQL can be used to transform transactional sales data into executive-ready Business Intelligence reports**.

The analysis covers:

- Trend analysis
- Cumulative analysis
- Performance benchmarking
- Part-to-whole analysis
- Data segmentation
- Executive reporting

Rather than focusing solely on SQL syntax, the project focuses on **solving business problems through reusable analytical reporting tables** that support strategic decision-making.

![1 Business Intelligence Reporting Workflow](https://github.com/DavidMashishi/Business-Intelligence-Reporting-with-SQL/blob/cf78cae196fd92890626185c179cd61b240d237f/images/1%20Business%20Intelligence%20Reporting%20Workflow.png)

---

## 💼 Business Problem

Companies generate thousands of transactions every day. Without proper analysis, decision-makers can struggle to answer important business questions.

This project addresses questions such as:

- Are sales improving year over year?
- Which products are declining?
- Which categories drive the most revenue?
- Which customers spend the most?
- Which customers generate the most value?
- Which products should receive more investment?

---

## 🎯 Business Objectives

| Analysis | Business Purpose |
|---|---|
| **Change Over Time** | Measure long-term business growth |
| **Cumulative Analysis** | Monitor revenue accumulation |
| **Performance Analysis** | Benchmark products against historical performance |
| **Part-to-Whole Analysis** | Identify revenue-driving categories |
| **Data Segmentation** | Group customers and products into meaningful business segments |
| **Executive Reporting** | Produce reporting-ready datasets for Power BI |

---

## 🗄️ Dataset

The project uses a **Star Schema** consisting of one fact table and two dimension tables.

### Dataset Statistics

| Metric | Value |
|---|---:|
| Customers | 18,484 |
| Products | 295 |
| Transactions | 27,659 |
| Data Range | 2010–2014 |
| Average Price | 486 |

The underlying model contains transactional sales data together with customer and product dimensions.

---

## ⭐ Data Model

The database follows a **Star Schema** consisting of:

- `gold.fact_sales`
- `gold.dim_customers`
- `gold.dim_products`

This structure separates transactional measures from descriptive customer and product attributes, providing a foundation for analytical reporting.

---

## 🗃️ Database Tables

### Customers — `gold.dim_customers`

| Column | Description |
|---|---|
| `customer_key` | Unique key identifying each customer |
| `customer_id` | Original customer identifier |
| `customer_number` | Business customer reference number |
| `first_name` | Customer first name |
| `last_name` | Customer surname |
| `country` | Customer country |
| `marital_status` | Customer marital status |
| `gender` | Customer gender |
| `birthdate` | Customer date of birth |
| `create_date` | Date the customer record was created |

### Products — `gold.dim_products`

| Column | Description |
|---|---|
| `product_key` | Unique product identifier |
| `product_id` | Product ID from source system |
| `product_name` | Product name |
| `category_id` | Product category identifier |
| `category` | Main product category |
| `subcategory` | Product subgroup |
| `maintenance` | Indicates whether maintenance is required |
| `cost` | Product acquisition cost |
| `product_line` | Product family or business line |
| `start_date` | Date product became available |

### Sales — `gold.fact_sales`

| Column | Description |
|---|---|
| `order_number` | Unique sales order number |
| `product_key` | Foreign key referencing the product dimension |
| `customer_key` | Foreign key referencing the customer dimension |
| `order_date` | Date the order was placed |
| `shipping_date` | Date the order was shipped |
| `sales_amount` | Total revenue generated |
| `quantity` | Number of units sold |
| `price` | Selling price per unit |

---

## 🛠️ Tools & Technologies

- **SQL Server**
- **SQL Server Management Studio (SSMS)**
- **Power BI**
- **GitHub**

---

## 🧠 SQL Skills Demonstrated

| Category | Skills |
|---|---|
| Querying | `SELECT`, `WHERE`, `ORDER BY` |
| Aggregation | `SUM()`, `COUNT()`, `AVG()`, `MIN()`, `MAX()` |
| Window Functions | `SUM() OVER()`, `AVG() OVER()`, `LAG()`, `LEAD()` |
| Date Functions | `YEAR()`, `MONTH()`, `DATETRUNC()` |
| Conditional Logic | `CASE` |
| Ranking | `ROW_NUMBER()`, `RANK()` |
| Data Modelling | Joins, Foreign Keys |
| Reporting | KPI Development |
| SQL Architecture | CTEs, Views, `PARTITION BY`, `GROUP BY` |

---

# 🔍 Detailed Analysis

## 1. 📅 Change Over Time

### Business Question

**How has the business performed over time?**

### Purpose

Analyse sales trends across multiple years and determine whether customer and sales activity is growing or declining.

### SQL Concepts

- `GROUP BY`
- `SUM()`
- `ORDER BY`
- `YEAR()`

### Business Insight

Sales increased steadily from 2010 through a high point in 2013 before stabilising in 2014.

---

## 2. 📈 Cumulative Analysis

### Purpose

Track cumulative revenue throughout the reporting period.

### SQL Concepts

- Window Functions
- `SUM() OVER()`
- `ORDER BY`

### Business Value

Cumulative analysis supports:

- Revenue forecasting
- Growth tracking
- Financial planning

---

## 3. 📊 Performance Analysis

### Business Question

**How is each product performing compared with its historical performance?**

### Key Metrics

- Current Year Sales
- Previous Year Sales
- Average Sales
- Growth

### SQL Concepts

- `LAG()`
- `AVG() OVER()`
- `CASE`
- Window Functions

### Business Value

Performance analysis helps identify:

- Best-performing products
- Worst-performing products
- Products requiring management attention
- Products exceeding or meeting target values

---

## 4. 🥧 Part-to-Whole Analysis

### Business Question

**Which product categories generate the most revenue?**

### Business Value

The analysis helps identify underperforming areas requiring strategic review while highlighting categories that generate the largest proportion of revenue.

This supports better investment prioritisation and resource allocation.

---

## 5. 👥 Data Segmentation

### Business Purpose

The project segments:

- Products into cost ranges
- Customers into revenue-based groups

Customer segments include:

- **VIP**
- **Regular**
- **New**

This segmentation supports:

- Pricing strategies
- Inventory planning
- Personalised marketing campaigns

---

# 📋 Executive Reporting

The final objective is to convert raw transactional data into **business-ready reporting datasets** that executives can use to monitor performance.

---

## 👤 Customer Performance Report

### Purpose

Provide a complete overview of customer purchasing behaviour.

### Metrics

| Metric | Description |
|---|---|
| Total Sales | Revenue generated by each customer |
| Total Orders | Number of completed orders |
| Quantity Purchased | Total units purchased |
| Customer Lifespan | Months between first and last purchase |

### Key Performance Indicators

| KPI | Description |
|---|---|
| Recency | Measures customer activity |
| Average Order Value | Indicates customer spending |
| Average Monthly Spend | Measures long-term customer value |

### Customer Segmentation

| Segment | Meaning |
|---|---|
| **VIP** | Highest-revenue customers |
| **Regular** | Strong purchasing behaviour |
| **New** | Recently acquired / regular customers |

---

## 📦 Product Performance Report

### Metrics

- Revenue
- Orders
- Customers
- Quantity
- Product Lifespan

### Key Performance Indicators

- Recency
- Average Order Value
- Average Monthly Spend

### Business Value

The product reporting layer supports:

- Inventory Planning
- Product Lifecycle Management
- Marketing Strategy
- Pricing Decisions
- Portfolio Optimisation

---

# 📊 Power BI Dashboard

**SQL provides the analytical layer of the Business Intelligence solution, while Power BI provides the visualisation layer used to communicate findings to stakeholders and management.**

### Dashboard Pages

- **Executive Dashboard**
- **Sales Performance Dashboard**
- **Customer Dashboard**
- **Product Dashboard**
- **Category Performance**

This creates an end-to-end workflow from transactional data through SQL analysis to interactive Business Intelligence reporting.

---

# 🔑 Business Insights

The analysis produced several key findings:

- Sales increased from **2010 to a high point in 2013**, before stabilising in 2014.
- The **Bike category generated approximately 96% of revenue**, followed by Accessories at approximately 2.3% and Clothing at approximately 1%.
- Customer purchasing behaviour revealed distinct **high-value and low-value customer segments**.
- Average monthly spending varied significantly across customer groups.

---

# 💼 Business Impact

This reporting solution enables decision-makers to:

- Identify revenue trends.
- Monitor sales performance.
- Detect declining products.
- Prioritise high-performing categories.
- Improve customer retention strategies.
- Identify customer purchasing patterns and loyalty trends.
- Support inventory, pricing, and marketing decisions using segmented data.

---

# 🚀 Recommendations

Based on the analysis:

### 1. Increase Investment in High-Performing Products

Prioritise resources toward products demonstrating strong revenue and performance.

### 2. Review Underperforming Categories

Conduct further analysis of consistently underperforming categories, particularly **Clothing and Accessories**, to identify opportunities for improvement.

### 3. Personalise Customer Marketing

Use customer segmentation to develop targeted and personalised marketing strategies.

### 4. Strengthen Customer Retention

Develop retention campaigns for valuable existing customers while creating strategies to convert new customers into long-term customers.

---

# 🏁 Conclusion

This project demonstrates an **end-to-end Business Intelligence workflow**, from data preparation and SQL analytics through to reporting-ready datasets and an interactive Power BI dashboard.

The project highlights SQL proficiency while demonstrating the ability to transform transactional data into **business insights that support data-driven decision-making**.

---

## ⭐ Key Portfolio Takeaway

**SQL → Analytical Layer → Reporting Tables → Power BI → Business Insights → Strategic Recommendations**
