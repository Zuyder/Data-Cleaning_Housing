--This exercise involves cleaning housing data.

Select*
From PortfolioProjects.dbo.HousingData

--The first activity is changing the SaleDate column by removing the timepart.

Select SaleDate,CONVERT(Date,SaleDate)
From PortfolioProjects.dbo.HousingData

Update HousingData
Set SaleDate = CONVERT(Date,SaleDate)


--obtion B if it doesnt work

Alter Table HousingData
Add SaleDateConverted Date;

Update HousingData
Set SaleDateConverted = CONVERT(Date,SaleDate)

Select SaleDateConverted,CONVERT(Date,SaleDate)
From PortfolioProjects.dbo.HousingData

--Next we populate the property address column where null values exist. The IS NULL below populates what is missing in a with b.

Select *
From HousingData
Where PropertyAddress is null
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From HousingData a
JOIN HousingData b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From HousingData a
JOIN HousingData b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

--This section separates the Address column into Individual Columns (Address, City, State) using substring and character index.
--The comma in the column leads to the script structure.
--The CHARINDEX searches for a specific value. CHARINDEX('opi') or  (',')/ here it looks for where a 'opi' or 'comma,' is.
--The 1 is the 1st value part of the address column, -1 means we're going back one value from the CHARINDEX (,) in this case.
--The +1 means we want to start at the CHARINDEX(,) going forward & since the LEN of the addressses are different, 
--we use LEN(PropertyAddress) to our advantage so that the query each values length individully and ends where appropriate.

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
From HousingData

--because we're altering the address column we need to update the table for the two new separated values

ALTER TABLE HousingData
Add PropertySplitAddress Nvarchar(255);

Update HousingData
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE HousingData
Add PropertySplitCity Nvarchar(255);

Update HousingData
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

--now the table propertyaddress column has been altered and the two new columns appear at the far end.
Select*
FROM HousingData

--On this section, we'll do the same thing with separating the owner address using a PARSENAME.
--PARSENAMEs are useful when there are delimeters such as a period or comma but it goes backwards. 1 becomes one from the end,so go opposite


Select owneraddress
FROM HousingData


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From HousingData

Alter Table HousingData
Add OwnerSplitAddress Nvarchar(255);

Update HousingData
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE HousingData
Add OwnerSplitCity Nvarchar(255);

Update HousingData
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE HousingData
Add OwnerSplitState Nvarchar(255);

Update HousingData
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

Select*
From HousingData

---- Change Y and N to Yes and No in "Sold as Vacant" field

select Distinct SoldAsVacant, COUNT(SoldAsVacant)
From HousingData
Group by SoldAsVacant
Order by 2

--The distinct reveals that the column has Yes, No, Y and N. Now to change the Y & N.

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From HousingData

--then we update the table

Update HousingData
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
--to check
Select Distinct SoldAsVacant
From HousingData

--Removing Duplicates (using CTE and windows function to find duplicates)

WITH RowNumCTE AS(
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
From HousingData
)

Select* 
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

--we can now see the duplicates as 2,then we delete by using the same whole CTE query and replacing the last select statement with delete.
--the last order by after where row_num >1 is also omitted

Delete 
From RowNumCTE
Where row_num > 1

--Deleting unused columns. Since we split columns ealier we can then delete the ones that are no longer useful

Select*
From HousingData

ALTER TABLE HousingData
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate




Select *
From HousingData


