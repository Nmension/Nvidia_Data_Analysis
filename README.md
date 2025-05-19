# Nvidia: Economic & Financial Data Analysis
📘 Project Documentation: Financial Bubble Assessment – **Nvidia**
</br>

## 🧭 Project Objective

  This project investigates whether the elevated market valuation of _Nvidia_ constitutes a financial bubble. The workflow integrates a modular stack for data ingestion, processing, exploration, and visualization, emphasizing reproducibility, clarity, and accessibility for both analysts and non-coders.
</br>

## 🗃️ Data Architecture

#### Data Source:
  - Structured and semi-structured data is collected from:

      - SEC filings (10-K, 10-Q)

      - Public company financial statements

      - Open financial APIs and databases

####  Database Storage:
  - Data is stored in a PostgreSQL relational database, designed to allow structured queries across various tables:

    - **quarterly_financials** 

      → quarterly data for all segments as one, including: revenue, operating income, taxes and interests, COGS, OPEX, etc

    - **quarterly_revenue_per_activity** 

      → quarterly revenue by segments

    - **yearly_financials** (_filled by the bash script using quarterly financials for calculations_)

      → yearly data for all segments as one, including: revenue, operating income, taxes and interests, COGS, OPEX, etc

    - **yearly_financials_extra**

      → complementary yearly financial data, including: total assets &liabilities, net debt, average stock price, etc

    - **valuations** (_filled by the bash script_)

      → includes: equity value per share, average market cap, enterprise value

    - **shares_numbers_in_million**

      → includes: treasury stock, total outstanding, insiders, top 3 institutions & the rest of shares

    - **activities** & **quarters_per_year**

      → junction tables

## 🛠️ Bash Script: **manage_data.sh** (500+ lines)

A comprehensive CLI tool built to facilitate non-technical user interaction with the database:

#### Functionality:

  - Data Exportation Guidance

      - Prompts users to target one or more table(s) then from their selection, for partial or total data extraction 

      - Outputs clean .csv files ready for analysis

  - Database Auto-Update

      - Checks latest entry in specific tables, then 

      - Calculates missing data from pre-defined database endpoints

      - Executes SQL INSERT/UPDATE statements with conflict handling

  - Data Insertion Guidance

      - Provides step-by-step support for data entry

      - Helps to respect schema adherence and formatting

## 📊 Python Analytics Environment

#### Platform: 
  - Jupyter Lab for interactive exploration

#### Libraries Used:

  - pandas – Tabular data manipulation and transformation

  - numpy – Numerical operations and missing value handling

  - matplotlib & seaborn – Custom visualizations (line charts, bar graphs, pie charts, etc.)

#### Outputs:

  - Key time-series plots and tables (Revenue vs Net Income, FCF vs SBC, etc.)

  - Sectoral breakdowns and cost structure visualizations

  - Scenario-based valuation summaries

## 🧪 Analysis Flow

#### Data Extraction
  - csv format export from PostgreSQL via Bash or SQL queries

       Here's an example of prompt I used to generate a file called: _quarterly_financials.csv_

```bash
psql -X --csv -U postgres -d nvidia -c "SELECT quarter, year, revenue, operating_income,net_income, gross_margin_percentage, taxes_and_interests, cost_of_goods_sold, gross_profit, operating_expenses, cogs_opex_difference FROM quarters_per_year INNER JOIN quarterly_financials USING(yq_id);" > quarterly_financials.csv
```
    

#### Exploratory Data Analysis (EDA)
  - Data cleaning, derived KPIs, outlier detection, descriptive statistics in Jupyter

#### Financial Modeling & Visualization
  - Multiple perspectives consideration (business efficiency, valuation, systemic risk)

## 🔁 Reproducibility

All components are modular and script-driven for reproducibility:

  - Bash script includes different types of input-validation

  - Python script accepts standard .csv input and its code commented

  - Charts and output tables are export-ready (PNG, PDF, LaTeX-friendly)