# Data-Cleaning_Housing
### The exercise uses SQL to clean housing data.
Since the data was obtained from an open source database, there were no licensing issues to contend with. 
It might not make sense as is since the read_me highlights all the steps that were taken to clean the data. Looking at it from the sql document at the repository will make more sense.

- The first activity is changing the SaleDate column by removing the timepart and an alternative B if the first option doesnt work.
- Next we populate the property address column where null values exist. 
- The IS NULL below populates what is missing in a with b.
- The code chunks separate the Address column into Individual Columns (Address, City, State) using substring and character index.
- The comma in the column leads to the script structure.
- The CHARINDEX searches for a specific value. CHARINDEX('opi') or  (',')/ here it looks for where a 'opi' or 'comma,' is.
- The 1 is the 1st value part of the address column, -1 means we're going back one value from the CHARINDEX (,) in this case.
- The +1 means we want to start at the CHARINDEX(,) going forward & since the LEN of the addressses are different, 
- We use LEN(PropertyAddress) to our advantage so that the query each values length individully and ends where appropriate.

- Since we're altering the address column we need to update the table for the two new separated values, now the table propertyaddress column has been altered and the two new columns appear at the far end.
- On this section, we'll do the same thing with separating the owner address using a PARSENAME.
- PARSENAMEs are useful when there are delimeters such as a period or comma but it goes backwards. 1 becomes one from the end,so go opposite

- Change Y and N to Yes and No in "Sold as Vacant" field
- The distinct reveals that the column has Yes, No, Y and N. Now to change the Y & N.
- Removing Duplicates (using CTE and windows function to find duplicates)
- We can now see the duplicates as 2,then we delete by using the same whole CTE query and replacing the last select statement with delete.
- The last order by after where row_num >1 is also omitted
- Deleting unused columns. Since we split columns ealier we can then delete the ones that are no longer useful


