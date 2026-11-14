/*
===============================================================================
DDL Script: Creación de Vistas Analíticas para la Capa Gold
===============================================================================
Propósito:
    - Crear las vistas del Esquema en Estrella (Star Schema):
        * gold.dim_customers (Dimensión Clientes: CRM + ERP)
        * gold.dim_products  (Dimensión Productos: CRM + ERP)
        * gold.fact_sales    (Hechos de Ventas conectado a las dimensiones)
===============================================================================
*/

USE DataWarehouse;
GO

-- ============================================================================
-- 1. DIMENSIÓN: Clientes (gold.dim_customers)
-- ============================================================================
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY crm.cst_id) AS customer_key, -- Clave subrogada
    crm.cst_id                             AS customer_id,
    crm.cst_key                            AS customer_number,
    crm.cst_firstname                      AS first_name,
    crm.cst_lastname                       AS last_name,
    ISNULL(loc.cntry, 'n/a')               AS country,
    crm.cst_marital_status                 AS marital_status,
    CASE 
        WHEN crm.cst_gndr != 'n/a' THEN crm.cst_gndr
        ELSE COALESCE(dem.gen, 'n/a')
    END                                    AS gender,
    dem.bdate                              AS birthdate,
    crm.cst_create_date                    AS create_date
FROM silver.crm_cust_info crm
LEFT JOIN silver.erp_cust_az12 dem
    ON crm.cst_key = dem.cid
LEFT JOIN silver.erp_loc_a101 loc
    ON crm.cst_key = loc.cid;
GO

-- ============================================================================
-- 2. DIMENSIÓN: Productos (gold.dim_products)
-- ============================================================================
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT
    ROW_NUMBER() OVER (ORDER BY prd.prd_start_dt, prd.prd_key) AS product_key, -- Clave subrogada
    prd.prd_id                                                AS product_id,
    prd.prd_key                                               AS product_number,
    prd.prd_nm                                                AS product_name,
    prd.cat_id                                                AS category_id,
    ISNULL(cat.cat, 'n/a')                                    AS category,
    ISNULL(cat.subcat, 'n/a')                                 AS subcategory,
    ISNULL(cat.maintenance, 'n/a')                            AS maintenance,
    prd.prd_cost                                              AS cost,
    prd.prd_line                                              AS product_line,
    prd.prd_start_dt                                          AS start_date
FROM silver.crm_prd_info prd
LEFT JOIN silver.erp_px_cat_g1v2 cat
    ON prd.cat_id = cat.id
WHERE prd.prd_end_dt IS NULL; -- Solo catálogo vigente (foto actual)
GO

-- ============================================================================
-- 3. HECHOS: Ventas (gold.fact_sales)
-- ============================================================================
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT
    sls.sls_ord_num     AS order_number,
    pr.product_key      AS product_key,     -- Llave foránea hacia dim_products
    cu.customer_key     AS customer_key,    -- Llave foránea hacia dim_customers
    sls.sls_order_dt    AS order_date,
    sls.sls_ship_dt     AS shipping_date,
    sls.sls_due_dt      AS due_date,
    sls.sls_sales       AS sales_amount,
    sls.sls_quantity    AS quantity,
    sls.sls_price       AS price
FROM silver.crm_sales_details sls
LEFT JOIN gold.dim_products pr
    ON sls.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
    ON sls.sls_cust_id = cu.customer_id;
GO

PRINT '>> Vistas de la capa Gold creadas exitosamente.';
GO