USE master;
GO
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'DataWarehouseAnalytics')
BEGIN
    CREATE DATABASE DataWarehouseAnalytics;
END;
GO

USE DataWarehouseAnalytics;
GO
