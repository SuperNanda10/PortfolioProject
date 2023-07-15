

--Cleaning Data in SQL Queries

select *
from NashvilleHousing




--Standardize Date Format

select SaleDateConverted,CONVERT(Date,SaleDate)
from NashvilleHousing

Update NashvilleHousing
set SaleDate=CONVERT(Date,SaleDate)

Alter Table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
set SaleDateConverted = CONVERT(Date,SaleDate);

----------------------------------------------------------------------------------------------------------------------------------------------------------------
--Populate Property Address data


select *
from NashvilleHousing
--where PropertyAddress is null
order by 2

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>B.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>B.[UniqueID ]

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Breaking Out Address into Individual Columns (Address,City,State)

select PropertyAddress
from NashvilleHousing
--where PropertyAddress is null

select
SUBSTRING (PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING (PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address

from NashvilleHousing


Alter Table NashvilleHousing
Add PropertySplitAddress nvarchar(225);

Update NashvilleHousing
set PropertySplitAddress = SUBSTRING (PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1);

Alter Table NashvilleHousing
Add PropertySplitCity nvarchar(225);

Update NashvilleHousing
set PropertySplitCity = SUBSTRING (PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress));

select *
from NashvilleHousing


select PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
from NashvilleHousing


Alter Table NashvilleHousing
Add OwnerSplitAddress nvarchar(225);

Update NashvilleHousing
set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'),3);

Alter Table NashvilleHousing
Add OwnerSplitCity nvarchar(225);

Update NashvilleHousing
set OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2);


Alter Table NashvilleHousing
Add OwnerSplitState nvarchar(225);

Update NashvilleHousing
set OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'),1);

select *
from NashvilleHousing

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Change Y and N to Yes and No in 'Sold as Vacant' Field

select distinct(SoldAsVacant),count(SoldAsVacant)
from NashvilleHousing
group by SoldAsVacant
order by Count(SoldAsVacant)


select SoldAsVacant,
case when 
SoldAsVacant = 'Y' Then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end
from NashvilleHousing

Update NashvilleHousing
set SoldAsVacant = case when 
SoldAsVacant = 'Y' Then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end



----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Remove Duplicates


With #Row_NumCTE as(
select *,
ROW_NUMBER() OVER (
PARTITION BY ParcelID,
PropertyAddress,
SaleDate,
SalePrice,
LegalReference
order by 
UniqueID)row_num

from NashvilleHousing

--order by ParcelID
)

select *
from #Row_NumCTE
order by PropertyAddress



----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Delete Unused Columns

select *
from NashvilleHousing

Alter Table NashvilleHousing
Drop Column OwnerAddress,TaxDistrict,PropertyAddress,SaleDate

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------