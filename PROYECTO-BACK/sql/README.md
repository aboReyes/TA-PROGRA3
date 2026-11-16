# Diagrama Lógico en MySQL ⚙️

## Estándares a seguir para los DATATYPES
- Los atributos booleanos son TINYINT(1)
- ENUM: ENUM('...', '...', ...)
- descripciones: VARCHAR2(200)
- nombres y apellidos: VARCHAR2(40)
- DNI: VARCHAR2(8)
- Valores double de Java: DECIMAL

- Se utiliza el concrete table inheritance para la creación de tablas

## Cómo abrir el diagrama
1. Descargar el diagrama
2. Abrir a MySQL Workbench
3. Ir a file / Open Model y abrir el archivo
 
 
## Sobre el ddl 
- Se generó el ddl en base al DER con la función Forward Engineer SQL Script de MySQL Workbench 

## Sobre los procedures
- los archivos .sql de los procedures deben llamarse procedimientos-nombre_tabla.sql 

## Cómo instalar la base de datos
1. Si ya existe, borrarla: `DROP SCHEMA patitasarriba;`
2. Ejecutar `instalar-patitasarriba.sql`: crea las 25 tablas y los 166 procedures. Es el único archivo de instalación.
3. Opcional, para probar: `datos-prueba.sql` (cuentas, mascotas, citas y boletas de ejemplo; contraseña `Patitas123`) o `datos-iniciales.sql` (solo el primer administrador).
- `instalar-patitasarriba.sql` se **genera** juntando `patitasarriba-mysql.sql` (tablas) y todos los `procedures-*.sql` (en orden alfabético). Si cambia alguno de esos archivos hay que volver a generarlo; no se edita a mano.
- Para vaciar los datos y conservar la estructura: `limpiar-tablas.sql`.

## Registro con verificación de correo y recuperación de contraseña
- Tablas: `registro_pendiente` y `token_recuperacion` (en `patitasarriba-mysql.sql`).
- Procedures: `procedures-registro_pendiente.sql` y `procedures-token_recuperacion.sql`.

## Foto de la mascota
- La tabla `mascota` tiene la columna `foto` (MEDIUMTEXT, opcional): la imagen como texto `data:image/jpeg;base64,...`.
- `insertar_mascota` y `modificar_mascota` reciben `p_foto` (después de `p_raza`).
