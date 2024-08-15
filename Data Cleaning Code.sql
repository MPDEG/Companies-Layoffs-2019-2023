-- DATA CLEANING --

SELECT *
FROM world_layoffs.layoffs;
---
---
# Create a table for a COPY
CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM world_layoffs.layoffs_staging;

# Pasted table in the copy
INSERT layoffs_staging
SELECT *
FROM world_layoffs.layoffs;
---
---
## Remove Duplicates ##
---
## Identify Duplicates
WITH duplicate_cte AS (
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, 
industry, total_laid_off, percentage_laid_off, `date`,
stage, country, funds_raised_millions) AS row_num
FROM world_layoffs.layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

# Checked some duplicates for confirmation
SELECT *
FROM world_layoffs.layoffs_staging
WHERE company = 'Cazoo';

## Delete duplicates creating another table
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM world_layoffs.layoffs_staging2;
 
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, 
industry, total_laid_off, percentage_laid_off, `date`,
stage, country, funds_raised_millions) AS row_num
FROM world_layoffs.layoffs_staging;

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE row_num > 1;
 
DELETE
FROM world_layoffs.layoffs_staging2
WHERE row_num > 1;
---
---
## Standardizing Data ##
---
## TRIMMED the company column
SELECT *
FROM world_layoffs.layoffs_staging2;

SELECT DISTINCT (company)
FROM world_layoffs.layoffs_staging2;

SELECT company, TRIM(company)
FROM world_layoffs.layoffs_staging2;

UPDATE world_layoffs.layoffs_staging2
SET company = TRIM(company);


## Standardize industry column 'labels'
SELECT DISTINCT industry
FROM world_layoffs.layoffs_staging2
ORDER BY 1;

SELECT DISTINCT industry
FROM world_layoffs.layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE world_layoffs.layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT industry
FROM world_layoffs.layoffs_staging2;


## Checked Location Column
SELECT DISTINCT location
FROM world_layoffs.layoffs_staging2
ORDER BY 1;

## Checked Country Column
SELECT DISTINCT country
FROM world_layoffs.layoffs_staging2
ORDER BY 1;


## Correct 'United States.' Misspelling
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE country LIKE 'United States%'
ORDER BY 1;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM world_layoffs.layoffs_staging2
ORDER BY 1;

UPDATE world_layoffs.layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

# checking the trimmed result
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM world_layoffs.layoffs_staging2
ORDER BY 1;


## date FORMAT
SELECT `date`
FROM world_layoffs.layoffs_staging2;

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM world_layoffs.layoffs_staging2;

UPDATE world_layoffs.layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

SELECT `date`
FROM world_layoffs.layoffs_staging2;

ALTER TABLE world_layoffs.layoffs_staging2
MODIFY COLUMN `date` DATE;
---
---
# NULLS
---- 

# Check for nulls and blanks in industry
# (Few industry rows are blanks and one null)
SELECT DISTINCT *
FROM world_layoffs.layoffs_staging2
WHERE industry IS NULL
OR industry = '';

# SET all blanks to Null(it can populate the industry later) 
UPDATE world_layoffs.layoffs_staging2
SET industry = NULL
WHERE industry = '';

# Check if any other company industry is populated to use it to fill up the blanks.
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE company = 'Airbnb';

# doing a Join in Select statement to see if it works
# If it's blank it's going to be populated into t1 if there's one that is not blank.  
SELECT *
FROM world_layoffs.layoffs_staging2 AS t1
JOIN world_layoffs.layoffs_staging2 AS t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

# Translated to an UPDATE statement (SET blanks to NULLS for it to work)
UPDATE world_layoffs.layoffs_staging2 AS t1
JOIN world_layoffs.layoffs_staging2 AS t2
	ON t1.company = t2.company
    AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

# Run the previous SELECT statement to see that no rows are affected
# Run this query to check the results
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE company = 'Airbnb';

# The only one that hasn't populated similar row for industry.
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE company LIKE 'Bally%';

---
---
## DELETE ROW or COLUMNS
---

# Check the nulls that we'll delete.
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

# Delete rows with NULLS on total_laid_off and percentage_laid_off 
DELETE
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

# Delete null rows
DELETE
FROM world_layoffs.layoffs_staging2
WHERE company IS NULL
AND location IS NULL
AND industry IS NULL
AND total_laid_off IS NULL
AND percentage_laid_off IS NULL;

# DROP row_num COLUMN
SELECT *
FROM world_layoffs.layoffs_staging2;

ALTER TABLE world_layoffs.layoffs_staging2
DROP COLUMN row_num;
