
select @@SERVERNAME
----------------------<<  CONSTRUCTING RELATIONAL DATABASE  >>--------------------------------
USE EnergyData

SELECT * FROM COUNTRY

--We stored the full database in table "MAIN"
/**
for consistency we changed the name of the following columns in "MAIN" table:
-hydro_energy_per_capita -> hydro_cons_per_capita
-fossil_fuel_consumption ->  fossil_consumption
**/

-------CHECKING THE COLUMNS DATA TYPES
SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'COUNTRY' AND COLUMN_NAME = 'NAME';


-------TABLE ENERGY
CREATE TABLE ENERGY(
NAME NVARCHAR(50),
RENEWABLE BIT
)

INSERT INTO ENERGY(NAME,RENEWABLE)
VALUES  ('biofuel',1),
		('hydro',1),
		('solar',1),
		('wind',1),
		('other_renewable', 1),
		('renewables', 1),
		('coal', 0),
		('fossil', 0),
		('gas', 0),
		('low_carbon', 0),
		('nuclear', 0),
		('oil', 0)



-------TABLE COUNTRY
INSERT INTO COUNTRY
SELECT DISTINCT(country) AS NAME,ISO_CODE AS ISO_CODE
FROM EnergyData..MAIN 
WHERE ISO_CODE IS NOT NULL

ALTER TABLE COUNTRY
ALTER COLUMN NAME NVARCHAR(50) NOT NULL

ALTER TABLE COUNTRY
ADD CONSTRAINT PK_COUNRTY_NAME PRIMARY KEY (NAME)


-------TABLE ENERGY_CONSUMPTION
/**
check the python script 
<Table_Energy_Generation.py> 
for how we have done insertion 
of data to the table
**/
CREATE TABLE ENERGY_CONSUMPTION(
ENERGY NVARCHAR(50),
country NVARCHAR(50) not null,
YEAR INT,
change_pct FLOAT,
change_twh FLOAT,
per_capita FLOAT,
prim FLOAT,
share FLOAT
CONSTRAINT FK_CONSUMPTION_COUNTRY FOREIGN KEY (country)
REFERENCES COUNTRY (name)
)


-------TABLE ELEC_GENERATION
/**
check the python script 
<Table_Elec_Generation.py> 
for how we have done insertion 
of data to the table
**/
CREATE TABLE ELEC_GENERATION(
ENERGY NVARCHAR(50),
COUNTRY NVARCHAR(50) NOT NULL,
YEAR INT,
per_capita FLOAT,
electricity FLOAT,
share FLOAT,
CONSTRAINT FK_ELEC_COUNTRY FOREIGN KEY (country)
REFERENCES COUNTRY (name)
)
--------------------------------------------------------------------------



