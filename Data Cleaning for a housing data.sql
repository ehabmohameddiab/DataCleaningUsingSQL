--showing data
select * 
from dbo.NashvilleHousing

select saledate from NashvilleHousing


alter table NashvilleHousing
add SaleDateConverted Date

update NashvilleHousing
set SaleDateConverted = CONVERT(Date, SaleDate)

select SaleDateConverted
from NashvilleHousing

----------------------------------------------
--CHECKING NULL VALUES IN PROPERTY ADDRESS COLUMN
SELECT * FROM NashvilleHousing
WHERE PropertyAddress IS NULL


UPDATE A
SET A.PropertyAddress = B.PropertyAddress
from NashvilleHousing a,
	 NashvilleHousing b
WHERE A.ParcelID = B.ParcelID AND A.[UniqueID ] <> B.[UniqueID ] AND A.PropertyAddress IS NULL

--CHECKING FILLING NULL VALUES WITH CORRECT VALUES
SELECT * FROM NashvilleHousing
WHERE PropertyAddress IS NULL
-----------------------------------------
--CLEANING DATA IN ADDRESS OF OWNER AND ADDRESS OF PROPERTY
SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) PropertyAddressSplitted,
	   SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , Len(PropertyAddress)) PropertyCitySplitted 
FROM NashvilleHousing

ALTER TABLE NashvilleHousing 
ADD PropertyAddressSplitted VARCHAR(200),
	PropertyCitySplitted VARCHAR(200)
GO
UPDATE NashvilleHousing
SET PropertyAddressSplitted = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ),
	PropertyCitySplitted = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , Len(PropertyAddress))

SELECT * FROM NashvilleHousing
--------------------------
SELECT OwnerAddress
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerAddressSplitted VARCHAR(200),
	OwnerCittySplitted VARCHAR(200),
	OwnerStateSplitted VARCHAR(200)
GO
UPDATE NashvilleHousing
SET
OwnerAddressSplitted = PARSENAME(REPLACE(OwnerAddress,',', '.'), 3),
OwnerCittySplitted = PARSENAME(REPLACE(OwnerAddress,',', '.'), 2),
OwnerStateSplitted = PARSENAME(REPLACE(OwnerAddress,',', '.'), 1)
FROM NashvilleHousing
---------------------------------
--CLEANING DATA OF SOLDASVACANT

UPDATE NashvilleHousing
SET SoldAsVacant = 
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END

SELECT SoldAsVacant FROM NashvilleHousing
--------------------------------------
--REMOVE DUBLICATES
WITH CTE AS
(SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by uniqueid desc) ROWNUM
FROM NashvilleHousing
)

DELETE * 
FROM CTE
WHERE rownum > 1    

GO

ALTER TABLE [dbo].[NashvilleHousing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
