drop table if exists zepto

CREATE TABLE zepto(
sku_id Serial PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(120) NOT NULL,
mrp NUMERIC(8,2),
discountPercentage NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGrams INTEGER,
outOFStock BOOLEAN,
quantity INTEGER
);

--Data exporation / EDA Exploratory Data analysis

--count rows
SELECT COUNT(*)
FROM zepto;

--Data 
SELECT *
FROM zepto
LIMIT 5;

--Check for NULL
SELECT * 
FROM zepto
WHERE name IS NULL 
OR
category IS NULL
OR
mrp IS NULL
OR
discountpercentage IS NULL
OR
availablequantity IS NULL
OR
discountedsellingprice IS NULL
OR
weightingrams IS NULL
OR
outofstock IS NULL
OR
quantity IS NULL

--different product category
SELECT DISTINCT category
FROM zepto
ORDER BY category;

-- products in stock / out of stocks
SELECT outofstock, count(sku_id)
FROM zepto
GROUP BY outofstock;

--products name presentmultiple times
SELECT name, count(sku_id) as "Number of SKUs "
FROM zepto
GROUP BY name
HAVING COUNT(sku_id)>1
ORDER BY count(sku_id) DESC;

--DATA CLEANING

-- product price is 0
SELECT *
FROM zepto
WHERE mrp=0 or discountedsellingprice=0;

--removing product which has mrp = 0
DELETE FROM zepto
WHERE mrp = 0;

--convert paise to rupees
UPDATE zepto
SET mrp = mrp/100.0, discountedsellingprice=discountedsellingprice/100.0;

--Top 10 best-value products  based  on the dicounted percentage.
SELECT DISTINCT name,mrp, discountPercentage
FROM zepto
ORDER BY discountPercentage DESC
LIMIT 10;

--products with High MRP but Out Of Stock
SELECT DISTINCT name, mrp
FROM zepto
WHERE outOFStock = TRUE and mrp>300
ORDER BY mrp DESC;

--Estimated Revenue for each category
SELECT category, SUM(discountedSellingPrice * availableQuantity) AS totalrevenue
FROM zepto
GROUP BY category
ORDER BY totalrevenue;

--mrp > 500 and discount less than 10
SELECT DISTINCT name, mrp, discountPercentage
FROM zepto
WHERE mrp>500 and discountPercentage <10
ORDER BY mrp DESC, discountPercentage DESC;

--top 5 categories offering highest average discount percentage
SELECT category, ROUND(avg(discountPercentage),2) AS AvgdiscountPercentage
FROM zepto
GROUP BY category
ORDER BY AVG(discountPercentage) DESC
LIMIT 5;

--price per gram for products above 100 gram and sort best value
SELECT DISTINCT name, weightInGrams, discountedSellingPrice, ROUND(discountedSellingPrice/weightInGrams,2) AS pricepergram
FROM zepto
WHERE weightInGrams > 100
ORDER BY pricepergram DESC;

--Grouping products into categories like loww medium high
SELECT weightInGrams,
CASE 
	WHEN weightInGrams <1000 THEN 'LOW'
	WHEN weightInGrams < 5000 THEN 'MEDIUM'
	ELSE 'BULK'
	END AS weightcategory
FROM zepto;

--Total inventory weight based on category
SELECT category, SUM(weightingrams * availableQuantity) AS totalweight
FROM zepto
GROUP BY category
ORDER BY totalweight;
