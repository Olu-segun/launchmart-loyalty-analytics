# LaunchMart Loyalty Analytics 🛍️

A SQL-based data analysis project for **LaunchMart**, a fictional retail loyalty platform, focusing on customer behavior, purchase patterns, and reward analytics. This project aims to provide actionable insights to improve the loyalty program's effectiveness and drive revenue growth.

## ✨ Key Features & Benefits

*   **Customer Segmentation:** Identify valuable customer segments based on purchase behavior.
*   **Purchase Pattern Analysis:** Understand product preferences and buying trends.
*   **Loyalty Program Effectiveness:** Measure the impact of loyalty programs on customer retention and spending.
*   **Revenue Forecasting:** Project future revenue based on historical trends.
*   **Actionable Insights:** Provide recommendations to improve the loyalty program and increase customer engagement.

## ⚙️ Prerequisites & Dependencies

*   **SQL Database:** A relational database management system (RDBMS) such as MySQL, PostgreSQL, or SQLite.
*   **SQL Client:** A tool for executing SQL queries, like Dbeaver, SQL Developer, or pgAdmin.

## 🚀 Installation & Setup Instructions

1.  **Clone the Repository:**

    ```bash
    git clone https://github.com/Olu-segun/launchmart-loyalty-analytics.git
    cd launchmart-loyalty-analytics
    ```

2.  **Database Setup:**

    *   Create a new database named `launchmart_loyalty`.
    *   Execute the schema script (`01_schema.sql`) to create the required tables:

        ```bash
        # Example using MySQL
        mysql -u <username> -p launchmart_loyalty < 01_schema.sql
        ```

3.  **Seed Data:**

    *   Populate the database with initial data using the seed data script (`02_seed_data.sql`):

        ```bash
        # Example using MySQL
        mysql -u <username> -p launchmart_loyalty < 02_seed_data.sql
        ```

## 💡 Usage Examples

1.  **Execute SQL Queries:**

    *   Use your preferred SQL client to connect to the `launchmart_loyalty` database.
    *   Open the `Solution.sql` file to find pre-written queries for analyzing the data.
    *   Execute the queries to gain insights into customer behavior, purchase patterns, and loyalty program effectiveness.

    ```sql
    -- Example Query from Solution.sql
    SELECT
        DATE_TRUNC('month', transaction_date) AS transaction_month,
        SUM(transaction_amount) AS monthly_revenue
    FROM
        transactions
    GROUP BY
        transaction_month
    ORDER BY
        transaction_month;
    ```

## 🛠️ Configuration Options

This project does not require extensive configuration. However, you can:

*   **Modify the Seed Data:** Customize the data in `02_seed_data.sql` to represent different customer segments, product categories, or loyalty program rules.
*   **Adjust SQL Queries:** Adapt the queries in `Solution.sql` to explore specific business questions or KPIs.

## 🤝 Contributing Guidelines

We welcome contributions to this project! To contribute:

1.  Fork the repository.
2.  Create a new branch for your feature or bug fix.
3.  Implement your changes.
4.  Write clear and concise commit messages.
5.  Submit a pull request.


## 🧭 Database Schema (ERD)

Below is the database schema showing relationships among customers, orders, order items, products, and loyalty points.
<img width="826" height="840" alt="image" src="https://github.com/user-attachments/assets/732d67ba-68ac-4eb4-b9d7-6ddbbc03bca0" />
