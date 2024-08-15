# Companies-Layoffs-2020-2023
<img src="https://github.com/MPDEG/Companies-Layoffs-2020-2023/blob/main/Graphs/layoff%20image.jpg?raw=true" width="600" height="300">

In this project, we will clean and analyze the total layoff data from companies using SQL and Tableau to identify which companies, industries, and countries experienced the highest number of layoffs.

## Dataset Context

Large companies and organizations worldwide are grappling with the economic slowdown. Factors such as sluggish consumer spending, higher interest rates imposed by central banks, and a strong dollar abroad are signaling a potential recession, leading companies to begin laying off employees. This dataset was created to examine, analyze, and uncover valuable insights into this trend.

## About Dataset
This dataset, titled "Layoffs Dataset" is available for download from Kaggle in CSV format. [Dataset](https://www.kaggle.com/datasets/swaptr/layoffs-2022)

The data covers the period from March 11, 2020, to March 6, 2023. 
The dataset owner on Kaggle noted that some information, such as sources, the list of laid-off employees, and dates of addition, has been omitted. The complete dataset can be found on Layoffs.fyi.

The dataset consists of 9 columns and a total of 2,361 rows. The columns are as follows:

1. **Company**: Name of the company.
2. **Location**: Location of the company.
3. **Industry**: Industry in which the company operates.
4. **Total_laid_off**: Total number of employees laid off.
5. **Percentage_laid_off**: Percentage of the workforce that was laid off.
6. **Date**: Date of the layoffs.
7. **Stage**: Stage of the company (e.g., startup, established).
8. **Country**: Country where the company is based.
9. **Funds_raised**: Amount of funds raised by the company.

The dataset originates from a Kaggle user who provided information on where the data was obtained and noted that certain details, such as sources, the list of laid-off employees, and dates of addition, were omitted. Due to these factors, the originality of the data is considered low, and caution should be exercised when trusting the insights derived from it.

The dataset's accuracy is also compromised, as it contains numerous blanks, nulls, and duplicates. Additionally, the data completeness is low, as some missing information could have provided further insights.

While the dataset is updated weekly, the analysis we are conducting will focus on data up to March 2023.

**Based on these points, the analysis will be conducted solely for the purpose of practicing with tools like SQL and Tableau. However, the credibility of the insights obtained should not be considered reliable.**

## **PROCESS**

### Data Cleaning

- Created a new schema
- Import table data
- First look at the data
- Created some type of staging or raw data set (COPY)
1. Removed Duplicates
    - Identify Duplicates
    - Deleted Duplicates
2. Standardized the Data
    - Trimmmed
    - Standardized Labels
    - Corrected Misspelling
    - Format Consistent(Date)
3. Null Values or Blank Values
    - Checked for nulls and blanks
    - Set the blanks as nulls
    - filled up the nulls with populated rows
4. Remove Unnecessary Column or Row
      

## Exploratory Data Analysis
Dive into it to find trends and patterns

- Summary Table Descriptive Metrics
- Checked the MAX's of total laid off and percentage laid off
- Check all the companies that closed down
- Total laid off by companies
- Check the date range
- Total laid off by industry
- Total laid off by country
- Total laid off by year
- Total laid off by stage
- Total Funds Raised by companies
- Total Funds Raised by industries
- Rolling Total for total_laid_off
- TOP 5 laid off by companies ranked per year
- Create the column TOTAL EMPLOYEES
- New table with the column total employees
- Employees per company


## Visualization with TABLEAU
TABLEAU web version[Tableau Graphs](https://public.tableau.com/views/LaidOff2020-2023/LaidOffOverTime?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

![1](https://github.com/MPDEG/Companies-Layoffs-2020-2023/blob/main/Graphs/Dashboard%20Laid%20Off%20Over%20Time.png?raw=true)

![2](https://github.com/MPDEG/Companies-Layoffs-2020-2023/blob/main/Graphs/Dashboard%20Funds%20Raised.png?raw=true)

![3](https://github.com/MPDEG/Companies-Layoffs-2020-2023/blob/main/Graphs/Dashboard%20Industry,%20Country,%20Stage.png?raw=true)

![4](https://github.com/MPDEG/Companies-Layoffs-2020-2023/blob/main/Graphs/Summary%20Descriptive%20Metrics.png?raw=true)

## Conclusion

- We observed that in 2020, when Covid-19 emerged, layoffs surged rapidly over a three-month period before declining and remaining low for nearly two years. However, layoffs spiked again in 2022, driven by recession and inflation, with the trend continuing into the first three months of 2023.
- Regarding funds raised by industries, Media and Transportation saw significant increases compared to other sectors, indicating they were less impacted by layoffs.
- The top three companies that raised the most funds are Netflix, with nearly 500,000 million, followed by Uber with approximately 123,000 million, and WeWork with about 65,000 million.
- The three industries with the highest layoffs are Consumer, Retail, and Transportation.
 - The Transportation and Travel industries were the hardest hit in 2020.
 - In 2022, Retail and Consumer sectors were the most affected.
 - Manufacturing and Fin-Tech industries had the fewest total layoffs.
- When examining layoffs by country, the United States stands out as the country with the most layoffs, significantly outpacing all others.
