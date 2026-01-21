USE master;
GO
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'DataWarehouseAnalytics')
BEGIN
    CREATE DATABASE DataWarehouseAnalytics;
END;
GO

USE DataWarehouseAnalytics;
GO
TRUNCATE TABLE gold.dim_customers;
GO

BULK INSERT gold.dim_customers
FROM '[insert path of the files here]'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO

TRUNCATE TABLE gold.dim_products;
GO

BULK INSERT gold.dim_products
FROM '[insert path of the files here]'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO

TRUNCATE TABLE gold.fact_sales;
GO

BULK INSERT gold.fact_sales
FROM '[insert path of the files here]'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO
