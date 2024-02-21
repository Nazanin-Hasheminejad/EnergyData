import pyodbc

# print(pyodbc.drivers())


SERVER = 'DESKTOP-JPHMPI0\MSSQLSERVER01'
DATABASE = 'EnergyData'
USERNAME = 'NZ'
PASSWORD = '123456'
TRUST = 'yes'
ENCRYPT = 'no'
connectionString = f'DRIVER={{SQL Server}};SERVER={SERVER};DATABASE={DATABASE};Trusted_Conncetion={TRUST}'

# Connect to the database
conn = pyodbc.connect(connectionString)

# Create a cursor from the connection
cursor = conn.cursor()

query = "SELECT NAME FROM ENERGY;" 

# Execute the query
cursor.execute(query)

# Fetch all rows from the query result
rows = cursor.fetchall()

for row in rows:
    energy_type = row[0]
    if energy_type != 'other_renewable':
        query = (f"""
                DECLARE @ENERGY NVARCHAR(50);
                SET @ENERGY='{energy_type}';
                INSERT INTO ELEC_GENERATION
                SELECT 
                    @ENERGY, 
                    COUNTRY,
                    YEAR, 
                    {energy_type}_elec_per_capita, 
                    {energy_type}_electricity, 
                    {energy_type}_share_elec
                FROM MAIN
                WHERE ISO_CODE IS NOT NULL;
        
                """)
        cursor.execute(query)
        conn.commit()

# Close the cursor and connection
cursor.close()

# Don't forget to close the connection
print("done!!!!!!!!!!!!!!!")
conn.close()
# for i in cursor.fetchall():
#     print(i) 

