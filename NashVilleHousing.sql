SELECT * FROM [portfolio project].dbo.NashvilleHousing

SELECT SaleDateConverted, CONVERT(Date,SaleDate)
FROM [portfolio project].dbo.NashvilleHousing

UPDATE [portfolio project].dbo.NashvilleHousing
SET SaleDateConverted = Convert(Date, SaleDate)

ALTER Table [portfolio project].dbo.NashvilleHousing
ADD SaleDateConverted Date;

SELECT *
FROM [portfolio project].dbo.NashvilleHousing
--WHERE PropertyAddress is null
ORDER BY ParcelID


SELECT a.ParcelID,a.PropertyAddress, b.ParcelID,b.PropertyAddress 
FROM [portfolio project].dbo.NashvilleHousing a
JOIN [portfolio project].dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<> b.[UniqueID ]
WHERE a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [portfolio project].dbo.NashvilleHousing a
Join [portfolio project].dbo.NashvilleHousing b
  on a.ParcelID = b.ParcelID
  AND a.[UniqueID ]<> b.[UniqueID]
Where a.PropertyAddress is null



SELECT PropertyAddress
From [portfolio project].dbo.NashvilleHousing


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)) as Address,CHARINDEX(',', PropertyAddress)
From [portfolio project].dbo.NashvilleHousing



SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address
From [portfolio project].dbo.NashvilleHousing

ALTER Table [portfolio project].dbo.NashvilleHousing
ADD PropertySplitAddress nvarchar(255);


UPDATE  [portfolio project].dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)



ALTER Table  [portfolio project].dbo.NashvilleHousing
ADD PropertySplitCity nvarchar(255);


UPDATE  [portfolio project].dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))



SELECT * FROM [portfolio project].dbo.NashvilleHousing


SELECT OwnerAddress 
FROM [portfolio project].dbo.NashvilleHousing


SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'), 3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM [portfolio project].dbo.NashvilleHousing 

ALTER Table [portfolio project].dbo.NashvilleHousing
ADD OwnerSplitAddress nvarchar(255);


UPDATE  [portfolio project].dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)


ALTER Table  [portfolio project].dbo.NashvilleHousing
ADD OwnerSplitCity nvarchar(255);


UPDATE  [portfolio project].dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER Table  [portfolio project].dbo.NashvilleHousing
ADD OwnerSplitState nvarchar(255);


UPDATE  [portfolio project].dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

SELECT * FROM [portfolio project].dbo.NashvilleHousing

SELECT DISTINCT(SoldAsVacant)
FROM [portfolio project].dbo.NashvilleHousing


SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM [portfolio project].dbo.NashvilleHousing
GROUP BY SoldAsVacant
Order by 2

SELECT SoldAsVacant
,CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
      WHEN SoldAsVacant = 'N' THEN 'NO'
	  ELSE SoldAsVacant
	  END
FROM [portfolio project].dbo.NashvilleHousing


UPDATE [portfolio project].dbo.NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
      WHEN SoldAsVacant = 'N' THEN 'NO'
	  ELSE SoldAsVacant
	  END

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM [portfolio project].dbo.NashvilleHousing
GROUP BY SoldAsVacant
order by 2


With RowNumCTE AS(
SELECT *,
    ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	ORDER BY 
	   UniqueId
	    ) row_num

FROM [portfolio project].dbo.NashvilleHousing
--order by ParcelID
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress





SELECT * FROM [portfolio project].dbo.NashvilleHousing


ALTER Table [portfolio project].dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
 
