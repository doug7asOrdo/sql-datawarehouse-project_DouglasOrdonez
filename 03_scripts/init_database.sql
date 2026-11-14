USE master;
GO

-- 1. Crear la base de datos si no existe
IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE name = N'DataWarehouse')
BEGIN
    PRINT '>> Creando la base de datos [DataWarehouse]...';
    CREATE DATABASE DataWarehouse;
    PRINT '>> Base de datos [DataWarehouse] creada con éxito.';
END
ELSE
BEGIN
    PRINT '>> La base de datos [DataWarehouse] ya existe.';
END
GO

-- 2. Cambiar a la base de datos
USE DataWarehouse;
GO

-- 3. Crear Esquema Bronze
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'bronze')
BEGIN
    EXEC('CREATE SCHEMA bronze');
    PRINT '>> Esquema [bronze] creado con éxito.';
END
GO

-- 4. Crear Esquema Silver
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'silver')
BEGIN
    EXEC('CREATE SCHEMA silver');
    PRINT '>> Esquema [silver] creado con éxito.';
END
GO

-- 5. Crear Esquema Gold
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'gold')
BEGIN
    EXEC('CREATE SCHEMA gold');
    PRINT '>> Esquema [gold] creado con éxito.';
END
GO

PRINT '>> Inicialización completada exitosamente.';
GO