# Convenciones de nomenclatura

Este documento describe las convenciones de nomenclatura utilizadas para los esquemas, las tablas, las vistas, las columnas y otros objetos del almacén de datos.

## Principios generales
- Formato: snake_case (letras minúsculas y guiones bajos).
- Idioma: Inglés para todos los nombres de objetos y columnas.
- Evitar palabras reservadas de SQL.

## Convenciones para nombrar tablas

### Reglas para Bronze
- Patrón: <sourcesystem>_<entity>
- Ejemplo: crm_cust_info, erp_loc_a101

### Reglas para Silver
- Patrón: <sourcesystem>_<entity>
- Ejemplo: crm_cust_info, erp_loc_a101

### Reglas para Gold
- Patrón: <category>_<entity>
- Categorías:
  * dim_ : Tablas de dimensión (ej. dim_customers, dim_products)
  * fact_ : Tablas de hechos (ej. fact_sales)
  * report_ : Tablas o vistas de reportes agregados

## Convenciones para nombrar columnas

### Claves subrogadas (Surrogate Keys)
- Patrón: <table_name>_key (ej. customer_key, product_key)

### Columnas técnicas
- Prefijo: dwh_<column_name> (ej. dwh_load_date, dwh_create_date)

## Convenciones para nombrar procedimientos almacenados
- Patrón: load_<layer> (ej. load_bronze, load_silver)
