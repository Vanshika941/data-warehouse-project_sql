/*
=========================================================
Create Database and Schemas
=========================================================

Script Purpose:
    This script creates a new database named 'DataWarehouse'
    after checking if it already exists.

    If the database exists, it is dropped and recreated.
    Additionally, the script sets up three schemas within
    the database: 'bronze', 'silver', and 'gold'.

WARNING:
    Running this script will drop the entire 'DataWarehouse'
    database if it exists. All data in the database will be
    permanently deleted. Proceed with caution and ensure
    you have proper backups before running this script.
*/

-- Create Database 'DataWarehouse'

use master ;
go
-- Drop and recreate the 'DataWarehouse' database
If exists (select 1 from sys.databases where name = 'DataWarehouse')
 begin 
 ALTER database DateWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
 DROP DATABASE DateWarehouse;
 END;
 

 -- Create the database DateWarehouse
 create database DateWarehouse;
 use DateWarehouse;

 -- Create the Schemas
 -- create schema bronze;
-- GO
 -- create schema gold;
 -- GO
 -- create schema silver;
 -- GO;
 IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_cust_info;
 CREATE TABLE bronze.crm_cust_info(
 cst_id INT,
 cst_key NVARCHAR (50),
 cst_firstname NVARCHAR (50),
 cst_lastname NVARCHAR (50),
 cst_material_status NVARCHAR (50),
 cst_gndr NVARCHAR(50),
 cst_create_date DATE );
GO 
USE DateWarehouse ;
GO
 IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_prd_info;
GO

CREATE TABLE bronze.crm_prd_info (
    prd_id       INT,
    prd_key      NVARCHAR(50),
    prd_nm       NVARCHAR(50),
    prd_cost     INT,
    prd_line     NVARCHAR(50),
    prd_start_dt DATETIME,
    prd_end_dt   DATETIME
);


IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE bronze.crm_sales_details;
GO

CREATE TABLE bronze.crm_sales_details (
    sls_ord_num  NVARCHAR(50),
    sls_prd_key  NVARCHAR(50),
    sls_cust_id  INT,
    sls_order_dt INT,
    sls_ship_dt  INT,
    sls_due_dt   INT,
    sls_sales    INT,
    sls_quantity INT,
    sls_price    INT
);
GO

IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE bronze.erp_loc_a101;
GO

CREATE TABLE bronze.erp_loc_a101 (
    cid    NVARCHAR(50),
    cntry  NVARCHAR(50)
);
GO

IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE bronze.erp_cust_az12;
GO

CREATE TABLE bronze.erp_cust_az12 (
    cid    NVARCHAR(50),
    bdate  DATE,
    gen    NVARCHAR(50)
);
GO

IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE bronze.erp_px_cat_g1v2;
GO

CREATE TABLE bronze.erp_px_cat_g1v2 (
    id           NVARCHAR(50),
    cat          NVARCHAR(50),
    subcat       NVARCHAR(50),
    maintenance  NVARCHAR(50)
);
GO

EXEC bronze.load_bronze ;

/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================

Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files.

    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the 'BULK INSERT' command to load data from CSV Files to bronze tables.

Parameters:
    None.

    This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;

===============================================================================
*/

        CREATE OR ALTER PROCEDURE bronze.load_bronze AS
        BEGIN
         DECLARE @start_time DATETIME, @end_time DATETIME;
        BEGIN TRY
        PRINT '======================================';
        PRINT 'LOADING BRONZE LAYER';
        PRINT '======================================';

        PRINT '======================================';
        PRINT 'LOADING CRM TABLES'
        PRINT '======================================';

        set @start_time = GETDATE();
        PRINT'>> Truncating Table: bronze.crm_cust_info';
            TRUNCATE TABLE bronze.crm_cust_info;
        PRINT'>> Insertinge Data Into : bronze.crm_cust_info';

            BULK INSERT bronze.crm_cust_info
            FROM 'C:\Users\vansh\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
            WITH
            ( 
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                ROWTERMINATOR = '\n'
            );
                set @end_time = GETDATE();
                PRINT '>> Load Duration :' + Cast(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR ) + 'Seconds';
                PRINT '========================='
        
                set @start_time = GETDATE();
            PRINT'>> Truncating Table: bronze.crm_prd_info';
            TRUNCATE TABLE bronze.crm_prd_info;
            PRINT'>> Insertinge Data Into : bronze.crm_prd_info';
            BULK INSERT bronze.crm_prd_info
            FROM 'C:\Users\vansh\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
            WITH
            (
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                ROWTERMINATOR = '\n'
            );
            PRINT '>> Load Duration :' + Cast(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR ) + 'Seconds';
            PRINT '========================='

                set @start_time = GETDATE();
            PRINT'>> Truncating Table: bronze.crm_sales_details';
            TRUNCATE TABLE bronze.crm_sales_details;
            PRINT'>> Insertinge Data Into : bronze.crm_sales_details';
            BULK INSERT bronze.crm_sales_details
            FROM 'C:\Users\vansh\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
            WITH
            (
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                ROWTERMINATOR = '\n'
            );
    PRINT'>> Load Duration :' + Cast(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR ) + 'Seconds';
                PRINT '========================='
        PRINT '======================================';
        PRINT 'LOADING ERP TABLES';
        PRINT '======================================';

            set @start_time = GETDATE();
            PRINT'>> Truncating Table: bronze.erp_cust_az12';
            TRUNCATE TABLE bronze.erp_cust_az12;
            PRINT'>> Insertinge Data Into : bronze.erp_cust_az12';
            BULK INSERT bronze.erp_cust_az12
            FROM 'C:\Users\vansh\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
            WITH
            (
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                ROWTERMINATOR = '\n'
            );
            PRINT'>> Load Duration :' + Cast(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR ) + 'Seconds';
                PRINT '========================='

                    set @start_time = GETDATE();
            PRINT'>> Truncating Table: bronze.erp_loc_a101';
            TRUNCATE TABLE bronze.erp_loc_a101;
             PRINT'>> Insertinge Data Into : bronze.erp_loc_a101';
            BULK INSERT bronze.erp_loc_a101
            FROM 'C:\Users\vansh\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
            WITH
            (
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                ROWTERMINATOR = '\n'
            );
    PRINT'>> Load Duration :' + Cast(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR ) + 'Seconds';
                PRINT '========================='

                    set @start_time = GETDATE();
            PRINT'>> Truncating Table: bronze.erp_px_cat_g1v2';
            TRUNCATE TABLE bronze.erp_px_cat_g1v2;
            PRINT'>> Insertinge Data Into : bronze.erp_px_cat_g1v2';
            BULK INSERT bronze.erp_px_cat_g1v2
            FROM 'C:\Users\vansh\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
            WITH
            (
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                ROWTERMINATOR = '\n'
            );
            PRINT'>> Load Duration :' + Cast(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR ) + 'Seconds';
                PRINT '========================='
          END TRY
          BEGIN CATCH
          PRINT '==========================='
          PRINT 'Error occured during Bronze Layer '
          PRINT '==========================='
          END CATCH
        END
        

        ----- SILVER LAYER ------
    IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_cust_info;
GO

CREATE TABLE silver.crm_cust_info (
    cst_id             INT,
    cst_key            NVARCHAR(50),
    cst_firstname      NVARCHAR(50),
    cst_lastname       NVARCHAR(50),
    cst_marital_status NVARCHAR(50),
    cst_gndr           NVARCHAR(50),
    cst_create_date    DATE,
    dwh_create_date    DATETIME2 DEFAULT GETDATE()
);
GO


IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_prd_info;
GO

CREATE TABLE silver.crm_prd_info (
    prd_id          INT,
    cat_id          NVARCHAR(50),
    prd_key         NVARCHAR(50),
    prd_nm          NVARCHAR(50),
    prd_cost        INT,
    prd_line        NVARCHAR(50),
    prd_start_dt    DATE,
    prd_end_dt      DATE,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE silver.crm_sales_details;
GO

CREATE TABLE silver.crm_sales_details (
    sls_ord_num     NVARCHAR(50),
    sls_prd_key     NVARCHAR(50),
    sls_cust_id     INT,
    sls_order_dt    DATE,
    sls_ship_dt     DATE,
    sls_due_dt      DATE,
    sls_sales       INT,
    sls_quantity    INT,
    sls_price       INT,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE silver.erp_loc_a101;
GO

CREATE TABLE silver.erp_loc_a101 (
    cid             NVARCHAR(50),
    cntry           NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE silver.erp_cust_az12;
GO

CREATE TABLE silver.erp_cust_az12 (
    cid             NVARCHAR(50),
    bdate           DATE,
    gen             NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE silver.erp_px_cat_g1v2;
GO

CREATE TABLE silver.erp_px_cat_g1v2 (
    id              NVARCHAR(50),
    cat             NVARCHAR(50),
    subcat          NVARCHAR(50),
    maintenance     NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

