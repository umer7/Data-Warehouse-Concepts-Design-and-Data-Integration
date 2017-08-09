-- Note that these examples use SS prefixed before table names to avoid conflicts with
-- other tables with the same Oracle schema.

-- Drop tables
-- You only need to drop the tables if you need to recreate the tables.
DROP TABLE SSSales;
DROP TABLE SSCustomer;
DROP TABLE SSItem;
DROP TABLE SSStore;
DROP TABLE SSDivision;
DROP TABLE SSTimeDim;

-- Drop sequences
-- Only necessary if you need to recreate and repopulate the tables. Otherwise ignore.
DROP SEQUENCE SSTimeNoSeq;
DROP SEQUENCE SSSalesNoSeq;

CREATE TABLE SSCustomer
( 	CustId 	        CHAR(8) NOT NULL,
  	CustName	VARCHAR2(30) NOT NULL,
        CustPhone    	VARCHAR2(15) NOT NULL,
	CustStreet	VARCHAR2(50) NOT NULL,
	CustCity	VARCHAR2(30) NOT NULL,
   	CustState	VARCHAR2(20) NOT NULL,
   	CustZip		VARCHAR2(10) NOT NULL,
	CustNation	VARCHAR2(20) NOT NULL,
 CONSTRAINT PKSSCustomer PRIMARY KEY (CustId)  );


CREATE TABLE SSDivision
( 	DivId 	 	CHAR(8) NOT NULL,
	DivName		VARCHAR2(50) NOT NULL,
  	DivManager	VARCHAR2(30) NOT NULL,
 CONSTRAINT PKSSDivision PRIMARY KEY (DivId) );


CREATE TABLE SSStore
( 	StoreId 	CHAR(8) NOT NULL,
	DivId		CHAR(8) NOT NULL,
  	StoreManager	VARCHAR2(30) NOT NULL,
	StoreStreet	VARCHAR2(50) NOT NULL,
	StoreCity	VARCHAR2(30) NOT NULL,
   	StoreState	VARCHAR2(20) NOT NULL,
   	StoreZip	VARCHAR2(10) NOT NULL,
	StoreNation	VARCHAR2(20) NOT NULL,
 CONSTRAINT PKSSStore PRIMARY KEY (StoreId),
 CONSTRAINT FKSSDivId FOREIGN KEY (DivId) REFERENCES SSDivision );


CREATE TABLE SSItem
( 	ItemId 	   	CHAR(8) NOT NULL,
  	ItemName	VARCHAR2(30) NOT NULL,
	ItemBrand	VARCHAR2(30) NOT NULL,
   	ItemCategory	VARCHAR2(30) NOT NULL,
  	ItemUnitPrice	DECIMAL(12,2) NOT NULL,
CONSTRAINT PKSSItem PRIMARY KEY (ItemId) );

-- In my experience, the setting of MIN VALUE and START VALUE is uncertain.
-- On an Oracle 11 server, I have used min value and start value set to 0 because Oracle 11 
-- generates first sequence value as one more than start value. Others have not experienced this
-- problem. On an Oracle 12 server, I have not experienced the problem. 
-- I suggest that you use 1 as the min and start value. If the first nextval usage generates 2, use 0. 

CREATE SEQUENCE SSTimeNoSeq
MINVALUE 1
START WITH 1;

-- Try using 0 if the first nextval generates 2 as the first value. Should not be necessary with Oracle 12.
-- CREATE SEQUENCE SSTimeNoSeq
-- MINVALUE 0
-- START WITH 0;

CREATE TABLE SSTimeDim
( 	TimeNo 	        INTEGER NOT NULL,
  	TimeDay		INTEGER NOT NULL,
  	TimeMonth	INTEGER NOT NULL,
  	TimeQuarter	INTEGER NOT NULL,
  	TimeYear	INTEGER NOT NULL,
  	TimeDayofWeek	INTEGER NOT NULL,
  	TimeFiscalYear	INTEGER NOT NULL,
 CONSTRAINT PKSSTime PRIMARY KEY (TimeNo),
 CONSTRAINT SSTimeDay1 CHECK (TimeDay BETWEEN 1 AND 31),
 CONSTRAINT SSTimeMonth1 CHECK (TimeMonth BETWEEN 1 AND 12),
 CONSTRAINT SSTimeQuarter1 CHECK (TimeQuarter BETWEEN 1 AND 4),
 CONSTRAINT SSTimeDayOfWeek1 CHECK (TimeDayOfWeek BETWEEN 1 AND 7) );

-- In my experience, the setting of MIN VALUE and START VALUE is uncertain.
-- On an Oracle 11 server, I have used min value and start value set to 0 because Oracle 11 
-- generates first sequence value as one more than the start value. Others have not experienced this
-- problem. On an Oracle 12 server, I have not experienced the problem. 
-- I suggest that you use 1 as the min and start value. If the first nextval usage generates 2, use 0. 

CREATE SEQUENCE SSSalesNoSeq
MINVALUE 1
START WITH 1;

-- Try using 0 if the first nextval generates 2 as the first value. Should not be necessary with Oracle 12.
-- CREATE SEQUENCE SSSalesNoSeq 
-- MINVALUE 0
-- START WITH 0;

CREATE TABLE SSSales
( 	SalesNo 	INTEGER NOT NULL,
  	SalesUnits	INTEGER NOT NULL,
        SalesDollar    	DECIMAL(12,2) NOT NULL,
	SalesCost	DECIMAL(12,2) NOT NULL,
	CustId		CHAR(8) NOT NULL,
	ItemId		CHAR(8) NOT NULL,
	StoreId		CHAR(8) NOT NULL,
	TimeNo		INTEGER NOT NULL,
 CONSTRAINT PKSSSales PRIMARY KEY (SalesNo),
 CONSTRAINT FKSSCustId FOREIGN KEY (CustId) REFERENCES SSCustomer,
 CONSTRAINT FKSSItemId FOREIGN KEY (ItemId) REFERENCES SSItem,
 CONSTRAINT FKSSStoreId FOREIGN KEY (StoreId) REFERENCES SSStore,
 CONSTRAINT FKSSTimeId FOREIGN KEY (TimeNo) REFERENCES SSTimeDim );



