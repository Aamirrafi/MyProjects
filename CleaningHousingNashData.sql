---Standardize date format
SELECT * FROM MyportfolioProjects..HousingNash$
SELECT SaleDate FROM MyportfolioProjects..HousingNash$

SELECT SaleDate, CONVERT(Date, SaleDate) FROM MyportfolioProjects..HousingNash$


UPDATE HousingNash$ 
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE HousingNash$
ADD SaleDateConverted Date;

UPDATE HousingNash$ 
SET SaleDateConverted = CONVERT(Date, SaleDate)


SELECT SaleDateConverted, CONVERT(Date, SaleDate) FROM MyportfolioProjects..HousingNash$

SELECT * FROM MyportfolioProjects..HousingNash$


-- IN this section I will fill the property Address data In case of NULL

SELECT PropertyAddress FROM MyportfolioProjects..HousingNash$ WHERE PropertyAddress IS NULL
SELECT * FROM MyportfolioProjects..HousingNash$ WHERE PropertyAddress IS NULL

--Count the number of fields with NULL values for property address
SELECT COUNT(*) FROM MyportfolioProjects..HousingNash$ WHERE PropertyAddress IS  NULL
 
SELECT * FROM MyportfolioProjects..HousingNash$ WHERE PropertyAddress IS NULL
SELECT * FROM MyportfolioProjects..HousingNash$  ORDER BY ParcelID

--After exploring the data it appears there are rows with same ParcelID. For a row with NULL value for propertyAddress we can populate it with the address corresponding to the same parcelID 

SELECT * FROM MyportfolioProjects..HousingNash$ x 
JOIN MyportfolioProjects..HousingNash$ y 
ON x.ParcelID = y.ParcelID
AND x.[UniqueID ]<>y.[UniqueID ]

SELECT x.ParcelID, x.PropertyAddress,y.ParcelID,y.PropertyAddress FROM MyportfolioProjects..HousingNash$ x 
JOIN MyportfolioProjects..HousingNash$ y 
ON x.ParcelID = y.ParcelID
AND x.[UniqueID ]<>y.[UniqueID ]

-- SELECT THE ONES WHERE PROPERTY ADDRESS IS NULL 
SELECT x.ParcelID, x.PropertyAddress,y.ParcelID,y.PropertyAddress FROM MyportfolioProjects..HousingNash$ x 
JOIN MyportfolioProjects..HousingNash$ y 
ON x.ParcelID = y.ParcelID
AND x.[UniqueID ]<>y.[UniqueID ]
WHERE x.PropertyAddress IS NULL

--Replace the NULL values of PropertyAddress
SELECT x.ParcelID, x.PropertyAddress,y.ParcelID,y.PropertyAddress, ISNULL(x.PropertyAddress,y.PropertyAddress) as UpdatedAddress FROM MyportfolioProjects..HousingNash$ x 
JOIN MyportfolioProjects..HousingNash$ y 
ON x.ParcelID = y.ParcelID
AND x.[UniqueID ]<>y.[UniqueID ]
WHERE x.PropertyAddress IS NULL

-- Update the database by replacing the null values of the propertyaddress with the propertyadress

UPDATE x
SET PropertyAddress = ISNULL(x.PropertyAddress,y.PropertyAddress)
FROM MyportfolioProjects..HousingNash$ x
JOIN MyportfolioProjects..HousingNash$ y 
ON x.ParcelID = y.ParcelID
AND x.[UniqueID ]<>y.[UniqueID ]
WHERE x.PropertyAddress IS NULL

-- TEST IF THE UPDATE HAS BEEN MADE SUCCESSFULLY

SELECT COUNT(*) FROM MyportfolioProjects..HousingNash$ WHERE PropertyAddress IS NULL
SELECT * FROM  MyportfolioProjects..HousingNash$ WHERE PropertyAddress IS NULL

--- Now I would divide the address into distinct columns of ADDRESS, CITY, STATE
SELECT PropertyAddress
FROM MyportfolioProjects..HousingNash$

SELECT 
SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress)) as Address

FROM MyportfolioProjects..HousingNash$

-- Remove the comma ',' from the address

SELECT 
SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress) -1) as Address

FROM MyportfolioProjects..HousingNash$

--Get the city and address parts of the address


SELECT 
SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress) -1) as Address ,
SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as city
FROM MyportfolioProjects..HousingNash$

ALTER TABLE MyportfolioProjects..HousingNash$
ADD NewAddress Nvarchar(255)
SELECT * FROM MyportfolioProjects..HousingNash$
UPDATE MyportfolioProjects..HousingNash$
SET NewAddress = SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress) -1) 
FROM MyportfolioProjects..HousingNash$

--Add the city column
ALTER TABLE MyportfolioProjects..HousingNash$
ADD Citypart Nvarchar(255)

SELECT * FROM MyportfolioProjects..HousingNash$
UPDATE MyportfolioProjects..HousingNash$
SET Citypart = SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))
FROM MyportfolioProjects..HousingNash$

--Divide the owner addres

SELECT  OwnerAddress
FROM MyportfolioProjects..HousingNash$

--using parsename function
SELECT 
PARSENAME(OwnerAddress,1)
FROM MyportfolioProjects..HousingNash$

--parsename only looks for periods. Therefore we replace ',' with '.'
--Get the state part of the address
SELECT
PARSENAME(REPLACE(OwnerAddress, ',','.'),1)
FROM MyportfolioProjects..HousingNash$

--Get the city part of the address
SELECT
PARSENAME(REPLACE(OwnerAddress, ',','.'),2)
FROM MyportfolioProjects..HousingNash$
--Get the remaining part of the addresse
SELECT
PARSENAME(REPLACE(OwnerAddress, ',','.'),3)
FROM MyportfolioProjects..HousingNash$

--Update the table with the individual parts of the address
ALTER TABLE MyportfolioProjects..HousingNash$
ADD OwnerNewAdd Nvarchar(255)

SELECT * FROM MyportfolioProjects..HousingNash$
UPDATE MyportfolioProjects..HousingNash$
SET OwnerNewAdd = PARSENAME(REPLACE(OwnerAddress, ',','.'),3)
FROM MyportfolioProjects..HousingNash$

ALTER TABLE MyportfolioProjects..HousingNash$
ADD OwnerCity Nvarchar(255)
SELECT * FROM MyportfolioProjects..HousingNash$
UPDATE MyportfolioProjects..HousingNash$
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',','.'),2)
FROM MyportfolioProjects..HousingNash$


ALTER TABLE MyportfolioProjects..HousingNash$
ADD OwnerState Nvarchar(255)
SELECT * FROM MyportfolioProjects..HousingNash$
UPDATE MyportfolioProjects..HousingNash$
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',','.'),1)
FROM MyportfolioProjects..HousingNash$

-- Change Y to Yes and N to No

SELECT SoldAsVacant,  COUNT(SoldAsVacant)
FROM MyportfolioProjects..HousingNash$
GROUP BY SoldAsVacant
ORDER BY 2 DESC

--Replace

SELECT 
REPLACE (SoldAsVacant, 'N0','N'),
REPLACE (SoldAsVacant, 'YES','Y')
FROM  MyportfolioProjects..HousingNash$


--Use CASE METHODS TO REPLACE

SELECT SoldAsVacant,
	CASE WHEN SoldAsVacant = 'y' THEN 'YES'
	WHEN SoldAsVacant = 'N' THEN 'NO'
	ELSE SoldAsVacant
	END
FROM  MyportfolioProjects..HousingNash$

UPDATE MyportfolioProjects..HousingNash$
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'y' THEN 'YES'
	WHEN SoldAsVacant = 'N' THEN 'NO'
	ELSE SoldAsVacant
	END



--REMPVE DUPLICATES
--WRITE CTE and USE WINDOW FUNCTION TO FIND IF WE HAVE DUPLICATES IN OUR DATA
WITH NewRowCte AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From MyportfolioProjects..HousingNash$
--order by ParcelID
)
Select *
From NewRowCte
Where row_num > 1
Order by PropertyAddress


-- DROPPING UNUSED COLUMNS
Select *
From MyportfolioProjects..HousingNash$


ALTER TABLE MyportfolioProjects..HousingNash$
DROP COLUMN OwnerAddress, PropertyAddress, SaleDate