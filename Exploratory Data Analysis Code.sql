-- Exploratory Data Analysis -- 
# Dive into it to find trends and patterns

SELECT *
FROM world_layoffs.layoffs_staging2;

# Summary Table Descriptive Metrics

SELECT COUNT(DISTINCT company) AS total_company, COUNT(DISTINCT location) AS total_location,
COUNT(DISTINCT industry) AS total_industry,
MAX(total_laid_off), MIN(total_laid_off), ROUND(AVG(total_laid_off)),
MAX(percentage_laid_off), MIN(percentage_laid_off), AVG(percentage_laid_off),
MAX(`date`), MIN(`date`), COUNT(DISTINCT country),
MAX(funds_raised_millions), AVG(funds_raised_millions)
FROM world_layoffs.layoffs_staging2;

# Check the MAX's of total laid off and percentage laid off(1 in percentage laid off means 100%, the company closed down)
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM world_layoffs.layoffs_staging2;

# Check all the companies that closed down
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off = 1;

# Check all the companies that closed down ordered by total laid off DESC
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

# Total laid off by companies
SELECT company, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

# Check the date range
SELECT MIN(`date`), MAX(`date`)
FROM world_layoffs.layoffs_staging2;

# Total laid off by industry
SELECT industry, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

# Total laid off by country TOP 20
SELECT country, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY country
ORDER BY 2 DESC
LIMIT 20;

# Total laid off by Year
SELECT YEAR(`date`) AS `year`, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY YEAR(`date`)
HAVING `year` IS NOT NULL
ORDER BY 1 DESC;

# Total laid off by stage
SELECT stage, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

# Total Funds Raised by companies
SELECT company, SUM(funds_raised_millions)
FROM world_layoffs.layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

# Total Funds Raised by industries
SELECT industry, SUM(funds_raised_millions)
FROM world_layoffs.layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

##  Rolling Total for total_laid_off
SELECT *
FROM world_layoffs.layoffs_staging2;

# Gets the SUM total laid off per month by year
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY SUBSTRING(`date`,1,7)
ORDER BY 1;

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM world_layoffs.layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH` 
ORDER BY 1
)
SELECT `MONTH`, total_off,
SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total 
FROM Rolling_Total;


# TOP 5 laid off by companies ranked per year
WITH Company_Year (company, years, total_laid_off) AS
(SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC
), Company_Year_Rank AS
(SELECT *, 
DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE `years` IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5;


## ADD TOTAL EMPLOYEE COLUMNS CREATING NEW TABLE

# Create the column TOTAL EMPLOYEE
CREATE TEMPORARY TABLE total_employee_table
SELECT *, ROUND(total_laid_off/NULLIF(percentage_laid_off,0)) AS total_employee
FROM world_layoffs.layoffs_staging2;

CREATE TABLE `layoffs_staging3` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `total_employee` INT DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM total_employee_table;

INSERT INTO layoffs_staging3
SELECT *
FROM total_employee_table;

SELECT *
FROM world_layoffs.layoffs_staging3;


# Employees per company
SELECT company, SUM(total_employee), SUM(total_laid_off), AVG(percentage_laid_off)
FROM world_layoffs.layoffs_staging3
GROUP BY company
ORDER BY 3 DESC;