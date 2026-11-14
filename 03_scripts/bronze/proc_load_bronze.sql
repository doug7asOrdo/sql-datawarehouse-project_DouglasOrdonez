/*
===============================================================================
Stored Procedure: Cargar Capa Bronze (Source -> Bronze)
===============================================================================
Propósito:
    - Trunca e inserta los datos de los 6 archivos CSV en las tablas del esquema 'bronze'.
    - Registra tiempos de ejecución y maneja errores con bloque TRY...CATCH.

Parámetros:
    Ninguno.
Uso:
    EXEC bronze.load_bronze;
===============================================================================
*/

USE DataWarehouse;
GO

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;

    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '=======================================================================';
        PRINT 'Iniciando Proceso de Carga para la Capa Bronze';
        PRINT '=======================================================================';

        -- --------------------------------------------------------------------
        -- CARGA DE TABLAS: CRM
        -- --------------------------------------------------------------------
        PRINT '-----------------------------------------------------------------------';
        PRINT 'Cargando Tablas de CRM...';
        PRINT '-----------------------------------------------------------------------';

        -- 1. bronze.crm_cust_info
        SET @start_time = GETDATE();
        PRINT '>> Truncando tabla: bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;

        PRINT '>> Insertando datos en: bronze.crm_cust_info';
        BULK INSERT bronze.crm_cust_info
        FROM 'C:\Users\dougl\Downloads\sql-datawarehouse-project_DouglasOrdoñez\01_datasets\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Duración de carga: ' + CAST(DATEDIFF(millisecond, @start_time, @end_time) AS NVARCHAR) + ' ms';
        PRINT '>> --------------------------------------------------';

        -- 2. bronze.crm_prd_info
        SET @start_time = GETDATE();
        PRINT '>> Truncando tabla: bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;

        PRINT '>> Insertando datos en: bronze.crm_prd_info';
        BULK INSERT bronze.crm_prd_info
        FROM 'C:\Users\dougl\Downloads\sql-datawarehouse-project_DouglasOrdoñez\01_datasets\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Duración de carga: ' + CAST(DATEDIFF(millisecond, @start_time, @end_time) AS NVARCHAR) + ' ms';
        PRINT '>> --------------------------------------------------';

        -- 3. bronze.crm_sales_details
        SET @start_time = GETDATE();
        PRINT '>> Truncando tabla: bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;

        PRINT '>> Insertando datos en: bronze.crm_sales_details';
        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Users\dougl\Downloads\sql-datawarehouse-project_DouglasOrdoñez\01_datasets\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Duración de carga: ' + CAST(DATEDIFF(millisecond, @start_time, @end_time) AS NVARCHAR) + ' ms';
        PRINT '>> --------------------------------------------------';

        -- --------------------------------------------------------------------
        -- CARGA DE TABLAS: ERP
        -- --------------------------------------------------------------------
        PRINT '-----------------------------------------------------------------------';
        PRINT 'Cargando Tablas de ERP...';
        PRINT '-----------------------------------------------------------------------';

        -- 4. bronze.erp_cust_az12
        SET @start_time = GETDATE();
        PRINT '>> Truncando tabla: bronze.erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12;

        PRINT '>> Insertando datos en: bronze.erp_cust_az12';
        BULK INSERT bronze.erp_cust_az12
        FROM 'C:\Users\dougl\Downloads\sql-datawarehouse-project_DouglasOrdoñez\01_datasets\source_erp\CUST_AZ12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Duración de carga: ' + CAST(DATEDIFF(millisecond, @start_time, @end_time) AS NVARCHAR) + ' ms';
        PRINT '>> --------------------------------------------------';

        -- 5. bronze.erp_loc_a101
        SET @start_time = GETDATE();
        PRINT '>> Truncando tabla: bronze.erp_loc_a101';
        TRUNCATE TABLE bronze.erp_loc_a101;

        PRINT '>> Insertando datos en: bronze.erp_loc_a101';
        BULK INSERT bronze.erp_loc_a101
        FROM 'C:\Users\dougl\Downloads\sql-datawarehouse-project_DouglasOrdoñez\01_datasets\source_erp\LOC_A101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Duración de carga: ' + CAST(DATEDIFF(millisecond, @start_time, @end_time) AS NVARCHAR) + ' ms';
        PRINT '>> --------------------------------------------------';

        -- 6. bronze.erp_px_cat_g1v2
        SET @start_time = GETDATE();
        PRINT '>> Truncando tabla: bronze.erp_px_cat_g1v2';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        PRINT '>> Insertando datos en: bronze.erp_px_cat_g1v2';
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'C:\Users\dougl\Downloads\sql-datawarehouse-project_DouglasOrdoñez\01_datasets\source_erp\PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Duración de carga: ' + CAST(DATEDIFF(millisecond, @start_time, @end_time) AS NVARCHAR) + ' ms';
        PRINT '>> --------------------------------------------------';

        SET @batch_end_time = GETDATE();
        PRINT '=======================================================================';
        PRINT 'Carga de la Capa Bronze Finalizada con Éxito';
        PRINT 'Tiempo Total de Proceso: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' segundos';
        PRINT '=======================================================================';

    END TRY
    BEGIN CATCH
        PRINT '=======================================================================';
        PRINT 'ERROR OCURRIDO DURANTE LA CARGA DE LA CAPA BRONZE';
        PRINT 'Mensaje de Error: ' + ERROR_MESSAGE();
        PRINT 'Código de Error: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Línea de Error: ' + CAST(ERROR_LINE() AS NVARCHAR);
        PRINT '=======================================================================';
    END CATCH
END;
GO