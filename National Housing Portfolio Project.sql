SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [Portfolio Project 2].[dbo].[national Housing Data]

  --cleaning data in sql queries

  select * from [national Housing Data]

  select saledate
  from [national Housing Data]
  update [national Housing Data]
  set saledate= convert (date, saledate)
  alter table [national Housing Data]
  add saledateconverted date
  update [national Housing Data]
  set saledateconverted= convert (date, saledate)

   select saledateconverted
  from [national Housing Data]

  --populate property address

   select A.[UniqueID ],A.ParcelID, A.PropertyAddress,B.[UniqueID ],B.ParcelID, B.PropertyAddress
  from [national Housing Data] a join [national Housing Data] b on a. ParcelID = b. ParcelID and A.[UniqueID ]<>B.[UniqueID ]
  WHERE A.PropertyAddress IS NULL
 
  select A.[UniqueID ],A.ParcelID, A.PropertyAddress,B.[UniqueID ],B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress, B.PropertyAddress)
  from [national Housing Data] a join [national Housing Data] b on a. ParcelID = b. ParcelID and A.[UniqueID ]<>B.[UniqueID ]
  WHERE A.PropertyAddress IS NULL
 
  UPDATE A
  SET  A.PropertyAddress= ISNULL(A.PropertyAddress, B.PropertyAddress)from [national Housing Data] a join [national Housing Data] b on a. ParcelID = b. ParcelID and A.[UniqueID ]<>B.[UniqueID ]
  WHERE A.PropertyAddress IS NULL

  -- Breaking out address into colums (ADDRESS, CITY, STATE)

  SELECT PROPERTYADDRESS
   from [national Housing Data]

   
  SELECT PROPERTYADDRESS, SUBSTRING (PROPERTYADDRESS, 1, CHARINDEX (',', PROPERTYADDRESS)-1) AS ADDRESS
   from [national Housing Data]

   SELECT PROPERTYADDRESS, SUBSTRING (PROPERTYADDRESS, CHARINDEX (',', PROPERTYADDRESS)+1,LEN(PROPERTYADDRESS)) AS CITY
   from [national Housing Data]

   ALTER TABLE [national Housing Data]
   ADD PROPERTYSPLITADDRESS NVARCHAR (255)

    update [national Housing Data]
  set PROPERTYSPLITADDRESS = SUBSTRING (PROPERTYADDRESS, 1, CHARINDEX (',', PROPERTYADDRESS)-1)

   ALTER TABLE [national Housing Data]
   ADD PROPERTYSPLITCITY NVARCHAR (255)

    update [national Housing Data]
  set PROPERTYSPLITCITY = SUBSTRING (PROPERTYADDRESS, CHARINDEX (',', PROPERTYADDRESS)+1,LEN(PROPERTYADDRESS))

   SELECT PROPERTYADDRESS, PROPERTYSPLITADDRESS, PROPERTYSPLITCITY
   from [national Housing Data]

   SELECT OWNERADDRESS
   from [national Housing Data]

   SELECT PARSENAME( REPLACE(OWNERADDRESS,',','.'), 3),
   PARSENAME( REPLACE(OWNERADDRESS,',','.'), 2),
   PARSENAME( REPLACE(OWNERADDRESS,',','.'), 1)
   from [national Housing Data]



    ALTER TABLE [national Housing Data]
   ADD OWNERSPLITADDRESS NVARCHAR (255)

    update [national Housing Data]
  set OWNERSPLITADDRESS = PARSENAME( REPLACE(OWNERADDRESS,',','.'), 3)

   ALTER TABLE [national Housing Data]
   ADD OWNERSPLITCITY NVARCHAR (255)

    update [national Housing Data]
  set OWNERSPLITCITY = PARSENAME( REPLACE(OWNERADDRESS,',','.'), 2)

    ALTER TABLE [national Housing Data]
   ADD OWNERSPLITSTATE NVARCHAR (255)

    update [national Housing Data]
  set OWNERSPLITSTATE = PARSENAME( REPLACE(OWNERADDRESS,',','.'), 1)

   SELECT OWNERADDRESS, OWNERSPLITADDRESS, OWNERSPLITCITY,OWNERSPLITSTATE
   from [national Housing Data]

   -- CHANGE N AND Y TO NO AND YES ON SOLDASVACANT

   SELECT DISTINCT (SOLDASVACANT)
   from [national Housing Data]

    SELECT DISTINCT SOLDASVACANT,
	CASE WHEN  SOLDASVACANT = 'Y' THEN 'Yes' WHEN  SOLDASVACANT = 'N' THEN 'No' ELSE SoldAsVacant
	END
   from [national Housing Data]

        update [national Housing Data]
  set SOLDASVACANT = CASE WHEN  SOLDASVACANT = 'Y' THEN 'Yes' WHEN  SOLDASVACANT = 'N' THEN 'No' ELSE SoldAsVacant
	END
	 
	 SELECT DISTINCT (SOLDASVACANT),COUNT (SOLDASVACANT)
   from [national Housing Data]
   GROUP BY SoldAsVacant

   --REMOVE DUPLICATES

   select *
     from [national Housing Data]

	 select [UniqueID ], ParcelID, PropertyAddress,SaleDate,SalePrice,LegalReference, ROW_NUMBER () 
  over (partition by ParcelID, PropertyAddress,SaleDate,SalePrice,LegalReference order by uniqueid ) as rownumb
     from [national Housing Data]

  with duplicate as (select [UniqueID ], ParcelID, PropertyAddress,SaleDate,SalePrice,LegalReference, ROW_NUMBER () 
  over (partition by ParcelID, PropertyAddress,SaleDate,SalePrice,LegalReference order by uniqueid ) as rownumb
     from [national Housing Data])
	 select* from duplicate
	  
	 with duplicate as ( select [UniqueID ], ParcelID, PropertyAddress,SaleDate,SalePrice,LegalReference, ROW_NUMBER () 
  over (partition by ParcelID, PropertyAddress,SaleDate,SalePrice,LegalReference order by uniqueid ) as rownumb
     from [national Housing Data])
	 select * from duplicate
	 where rownumb > 1 
	  
	  with duplicate as ( select [UniqueID ], ParcelID, PropertyAddress,SaleDate,SalePrice,LegalReference, ROW_NUMBER () 
  over (partition by ParcelID, PropertyAddress,SaleDate,SalePrice,LegalReference order by uniqueid ) as rownumb
     from [national Housing Data])
	 delete from duplicate
	 where rownumb > 1

	 	 -- DELETE UNSUSED COLUMNS FROM TABLE

		  ALTER TABLE [national Housing Data]
	 DROP COLUMN PROPERTYADDRESS, OWNERADDRESS,TAXDISTRICT

	 select *
     from [national Housing Data]

