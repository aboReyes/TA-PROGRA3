# Patitas Arriba · Estado del proyecto

_Equipo Los Huérfanos · PROG3 · Corte: 11/11/2026 (main = PR #25)_

## 1. Resumen en 30 segundos

- **Todo está en `main`** (PR #22 a #25). Una sola rama; el trabajo nuevo va en ramas que parten de `main` y entran con Pull Request.
- **Base de datos:** `instalar-patitasarriba.sql` crea las **25 tablas y los 166 procedures**; `datos-prueba.sql` carga los datos de ejemplo. Está instalada en AWS y en un MySQL local (`patitasarriba_local`).
- **Backend (Java):** código para **19 de los 20 RF** (falta RF12, recordatorios). Compila. El `Tester` no se ha corrido contra la base.
- **Front (Blazor):** **47 páginas conectadas al REST** con servicios y DTOs (PR #23 de Fernando); el login valida contra la base; `DatosEjemplo` ya no se usa. Rediseño de pantallas en `main` (PR #25).
- **Servicios C#:** 15 de 15 (se creó el de Acceso: registro y recuperación de contraseña).
- **Probado:** compila (Java y .NET), pasan los **16 tests** de servicios y se verificó la **lectura de 12 pantallas** en el navegador con datos reales. **Falta probar** alta, edición y baja desde cada formulario.
- **Rendimiento:** contra la base de AWS el sistema es muy lento (una conexión nueva por consulta). Para probar se usa MySQL local. Falta un pool de conexiones.

## 2. Cómo leer las tablas

| Término | Qué significa aquí |
|---|---|
| Backend ✔ | Existe el código (BL, DAO y REST) y compila. **No** significa que esté probado contra la base. |
| Pantalla ✔ | Existe la página en el front y está conectada al REST. |
| Servicio C# | Clase del front que llama al REST (servicios de Naim y Fernando). |
| Lectura ✔ | La pantalla se abrió en el navegador y mostró datos reales de la base. Alta, edición y baja siguen **por probar**. |
| Sin probar ◐ | Está conectada, pero no se ha abierto con datos reales. |

## 3. Mapa por requerimiento funcional (RF)

| RF | Nombre | Backend | Pantalla | Servicio C# | Conectado y probado |
|---|---|---|---|---|---|
| RF01 | Autenticación y control de acceso | ✔ Sí | ✔ Login | Cuenta (Login) | ✔ Login por REST |
| RF02 | Gestión de clientes | ✔ Sí | ✔ Tarjetas y tabla | Cliente | ✔ Lectura |
| RF03 | Gestión de mascotas (foto y peso opcional) | ✔ Sí | ✔ Sí + portal del cliente | Mascota | ✔ Lectura |
| RF04 | Gestión de personal | ✔ Sí | ✔ Tarjetas y tabla | Veterinario, Administrador | ✔ Lectura |
| RF05 | Gestión de cuentas de usuario | ✔ Sí | ✔ Por rol | Cuenta | ✔ Lectura |
| RF06 | Catálogo de diagnósticos | ✔ Sí | ✔ Lista por letra | Diagnostico | ✔ Lectura |
| RF07 | Catálogo de servicios | ✔ Sí | ✔ Tarjetas por tipo | Servicio | ✔ Lectura |
| RF08 | Inventario de artículos y categorías | ✔ Sí | ✔ Sí | Articulo, Categoria | ✔ Lectura |
| RF09 | Horarios de atención | ✔ Sí | ✔ Semana y lista | Horario | ✔ Lectura |
| RF10 | Reserva de citas por el cliente | ✔ Sí | ✔ Reserva en 3 pasos | Cita | ◐ Sin probar |
| RF11 | Gestión administrativa de citas | ✔ Sí | ✔ Sí | Cita | ◐ Sin probar |
| RF12 | Envío de recordatorios (prioridad Baja) | ✘ No implementado | No aplica (es un proceso) | — | ✘ No |
| RF13 | Reporte de agenda diaria | ✔ Sí | ✔ Imprimible | Cita (por fecha) | ◐ Sin probar |
| RF14 | Atenciones e historias clínicas | ✔ Sí | ✔ Sí | Atencion | ◐ Sin probar |
| RF15 | Recetas médicas | ✔ Sí | ✔ Sí | Receta | ◐ Sin probar |
| RF16 | Reporte de historial clínico | ✔ Sí | ✔ Tarjetas y línea de tiempo | Atencion (por mascota) | ✔ Lectura |
| RF17 | Reporte de receta médica | ✔ Sí | ✔ Sí | Receta | ◐ Sin probar |
| RF18 | Facturación consolidada (boletas) | ✔ Sí | ✔ Ticket y boletas | Boleta | ✔ Lectura |
| RF19 | Registro con verificación de correo (nuevo) | ✔ Sí | ✔ Registro y verificar | Acceso | ◐ Sin probar |
| RF20 | Recuperación de contraseña (nuevo) | ✔ Sí | ✔ Olvidé y restablecer | Acceso | ◐ Sin probar |

> RF19 y RF20 son requerimientos nuevos que aún necesitan la aprobación del JP. RF12 puede reutilizar el envío de correo (SMTP) de RF19 y RF20, pero falta programar el aviso 24 horas antes de la cita. Los RF con «Sin probar» están conectados, pero nadie los ha recorrido todavía con datos reales.

## 4. Servicios: 15 de 15

El REST tiene un recurso por entidad y el front un servicio por cada uno, registrados con `AddPatitasRestServices()`. Lo que el REST no ofrece se calcula en el front.

| Recurso del REST | Servicio en C# | Observaciones |
|---|---|---|
| /clientes | ClienteService | El alta usa `POST /clientes/con-cuenta` y solo envía el correo (la persona elige su contraseña por enlace). |
| /veterinarios, /administradores | VeterinarioService, AdministradorService | Mismo alta con `/con-cuenta`. Asignar un horario a una persona requiere un `PUT` por cada persona. |
| /mascotas | MascotaService | Filtro `?cliente=`. La foto viaja como texto (data URL) dentro del `MascotaDTO`. |
| /cuentas y /login | CuentaService | El login se hace por **correo y contraseña**. |
| /citas | CitaService | Filtros `cliente`, `fecha` y `veterinario`. La reserva automática de veterinario se calcula en el front. |
| /atenciones, /recetas | AtencionService, RecetaService | Filtros `?mascota=` y `?atencion=`. |
| /boletas | BoletaService | Sin filtros: se filtran en el front. El número de boleta lo asigna Java (RN-BO-03). Lo "pendiente por cobrar" se calcula en el front. |
| /articulos, /categorias | ArticuloService, CategoriaService | Sin filtros. |
| /servicios, /diagnosticos, /horarios | ServicioService, DiagnosticoService, HorarioService | La duración del servicio es opcional (puede ser `null`). |
| /acceso (registro y recuperación) | AccesoService | Registro, confirmar correo, pedir recuperación y restablecer. Creado por Fernando (PR #23). |

## 5. Cuentas de prueba

Salen de `datos-prueba.sql` y existen solo si se cargó ese script. **La contraseña de todas es `Patitas123`** (con la P mayúscula). Ya no aparecen en la pantalla de login.

| Rol | Correo | Nombre | Para probar |
|---|---|---|---|
| Administrador | `rosa.admin@patitas.pe` | Rosa Elena Gutierrez | Todas las pantallas del administrador |
| Administrador | `jorge.admin@patitas.pe` | Jorge Luis Paredes |  |
| Veterinario | `dra.lucia@patitas.pe` | Lucia Fernandez | Agenda, atenciones y recetas |
| Veterinario | `dr.martin@patitas.pe` | Martin Castillo |  |
| Veterinario | `dra.carmen@patitas.pe` | Carmen Rosa Delgado |  |
| Cliente | `ana.torres@gmail.com` | Ana Maria Torres | Portal del cliente (Firulais y Nala) |
| Cliente | `luis.quispe@gmail.com` | Luis Alberto Quispe | Michi y Rocky |
| Cliente | `maria.flores@hotmail.com` | Maria Jose Flores | Luna |
| Cliente | `pedro.ramos@outlook.com` | Pedro Pablo Ramos | Toby y Pelusa |
| Cliente | `sofia.mendoza@gmail.com` | Sofia Mendoza | Sin mascotas |

## 6. Cómo levantar todo

- **Base de datos:** `DROP SCHEMA patitasarriba;`, luego `instalar-patitasarriba.sql` y `datos-prueba.sql`. Para probar sin la lentitud de AWS se puede instalar en un MySQL local con otro nombre de esquema (por ejemplo `patitasarriba_local`).
- **Conexión a la base:** copiar `db.properties.example` como `db.properties` en `patitasarriba-app/src/main/resources/` y en `patitasarriba-rest/src/main/resources/`. Los datos del servidor se piden a Diego por mensaje privado. **No subir `db.properties`** al repositorio (está en `.gitignore`).
- **REST:** abrir `Avances` en IntelliJ y ejecutar con GlassFish 8 (artifact `patitasarriba-rest:war`, contexto `/patitasarriba-rest-1.0-SNAPSHOT`). Debe responder en `http://localhost:8080/patitasarriba-rest-1.0-SNAPSHOT/api/v1/clientes`.
- **Front:** `dotnet run` en `Avances-dotnet/PatitasArriba.Web` (puerto 5118) y entrar con una de las cuentas de la sección 5.
- **Pruebas:** `dotnet test` en `PatitasArriba.Tests` (los 16 tests de servicios usan un servidor simulado) y `ejecucion.Tester` en `patitasarriba-app`.

## 7. Qué cambió y dónde está documentado

Todo está en el **registro de cambios** (entradas 1 a 25), con el detalle de cada entrada: qué se hizo, en qué capa, qué archivos tocó, qué RF y reglas afecta y qué falta probar.

| Entradas | Tema | Capa |
|---|---|---|
| 1 a 8 | Login por correo, registro con verificación, recuperación de contraseña, pantallas de acceso | SQL, Java y front |
| 9 a 14 | Pantallas del administrador; formularios y botones estandarizados | Front |
| 15 a 18 | Banner de inicio, portal del cliente, foto opcional de la mascota y peso opcional | SQL, Java y front |
| 19 y 20 | Pantallas de Personal: veterinarios, administradores y horarios | Front |
| 21 | Instalador SQL único (25 tablas y 166 procedures) | SQL |
| 22 | Integración en `main` con Pull Requests (#22 a #25) y arreglos de compilación | Git, front y Java |
| 23 | Prueba de punta a punta y rendimiento contra AWS | Back y front |
| 24 | Rediseño de pantallas (PR #25) | Front |
| 25 | Cuentas de prueba | Documentación |

| Documento | Contenido | Dónde está |
|---|---|---|
| `DOCUMENTACION/registro-de-cambios.html` y `.pdf` | Registro de cambios 1 a 25 y la tabla de ajustes al informe | Repo personal de Diego |
| `DOCUMENTACION/Estado-del-proyecto.pdf` y `.md` | Este documento | Repo personal de Diego |
| `DOCUMENTACION/Exposicion-RF-y-pantallas.pdf` | Hoja de 2 páginas: RF nuevos y modificados y sus pantallas | Repo personal de Diego |
| `PROPUESTA-PANTALLAS/propuesta-pantallas.html` | Prototipo del rediseño (antes y ahora) | Repo personal de Diego |
| `REGLAS-DE-NEGOCIO.md`, `Avances/sql/README.md` | Reglas de negocio e instalación de la base | Repo compartido, `Avances/` |

## 8. Qué hay que cambiar en el informe

**Ya listado en el registro de cambios (parte del login):**

| Sección | Ajuste |
|---|---|
| §3 Planificación | Revisar los porcentajes de los Lab 11 y 12: el informe dice 80 % y 100 %, el correo del coordinador pide 60 % y 90 %. |
| §5 Producto | Agregar que los clientes se registran solos con verificación de correo y todos pueden recuperar su contraseña. |
| §6 Tabla 1 (RF existentes) | RF01 (iniciar sesión con correo y recuperar contraseña), RF02 (autorregistro del cliente), RF04 (la persona elige su contraseña con un enlace) y RF05 (las cuentas del personal se crean junto con la persona). |
| §6 Tabla 1 (RF nuevos) | RF19 Registro con verificación de correo y RF20 Recuperación de contraseña (prioridad Alta). |
| §6 Tabla 2 (RNF) | RNF05 ampliado (enlaces guardados como hash, contraseña de mínimo 8 caracteres) y RNF08 nuevo (credenciales del correo por variables de entorno). |
| §6 Estado | Hoy todo dice "Propuesto": actualizar según el avance real (sección 3) e indicar la aprobación del JP. |
| §7 Diagrama de clases | Agregar `RegistroPendiente` y `TokenRecuperacion`. |
| §8 Diagrama físico | Agregar `registro_pendiente` y `token_recuperacion`: pasan a ser 25 tablas. |
| §9 IA generativa | Registrar el uso de IA en esta etapa. |
| §12 Anexos | Adjuntar `instalar-patitasarriba.sql`, el diagrama físico nuevo y las cuentas de prueba (sección 5). |

**Falta agregarlo (cambios 15 a 25 y estado real):**

| Sección | Ajuste |
|---|---|
| RF03 Mascotas | Agregar la **foto** (opcional) y el **peso opcional** cuando lo registra el cliente; el cliente registra y modifica sus propias mascotas. |
| RF10 Reserva de citas | Reserva en 3 pasos con veterinario asignado automáticamente; el cliente **no registra emergencias** (solo en la clínica). |
| RF09 Horarios | Asignar personal desde el propio horario; regla nueva: una persona no puede tener dos turnos que se crucen el mismo día. |
| RF18 Facturación | Nueva boleta en 3 pasos, modificar boleta, anular con confirmación e indicadores de cobro. |
| RF12 Recordatorios | Indicar su estado real: **no implementado** (se puede reutilizar el envío SMTP). |
| Reglas de negocio | RN-MA-02, RN-MA-06, RN-MA-07, RN-CL-03 y RN-CI-15: **necesitan aprobación del JP**. |
| §7 y §8 Diagramas | Agregar el atributo `foto` en Mascota y la columna `mascota.foto`. |
| Limitaciones | El REST **no autentica** las peticiones ("solo sus mascotas", "el cliente no registra emergencias" se aplican en el front). Contra la base de AWS el sistema es lento por abrir una conexión por consulta. Contraseñas con SHA-256 sin sal (BCrypt sería lo recomendable). |

## 9. Pendientes y riesgos

- **Pool de conexiones** en `DBManager` (por ejemplo HikariCP), en un Pull Request aparte: es lo que haría usable el sistema contra AWS. Si la entrega usa la base de AWS, es el riesgo principal.
- **Probar alta, edición y baja** desde cada pantalla, y las pantallas sin recorrer (citas, atenciones, recetas, portal del cliente, registro y recuperación).
- **Correr el `Tester`** contra la base y levantar el REST en el equipo de cada integrante.
- **Subir `instalar-patitasarriba.sql`** a `Avances/sql/`, quitar los `actualizacion-*.sql` y actualizar el `README.md` de `main`.
- **Rama `version-entrega`** de Leonardo (seguridad por rol, limpieza y README): pendiente de juntar con `main`; no tiene conflictos con el rediseño, pero hay que volver a compilar y recorrer las pantallas.
- **Aprobaciones del JP** pendientes: login (RF19, RF20, RNF08), RF03 (foto y peso), reglas RN-MA, RN-CL y RN-CI, cruces de horarios.
- **Fuera del rediseño:** emergencia con datos mínimos y foto del personal (cambian la base y las reglas), pantallas del veterinario (Mauricio) y RF12.
- **Sin probar:** envío real de correos (SMTP) y la impresión desde el celular.

## 10. Flujo de trabajo

- `main` es la única rama estable. Todo cambio va en una **rama nueva que parte de `main`** y se junta con un Pull Request.
- Antes de empezar: `git pull`. Si un `push` se rechaza, **no usar `--force`**: traer los cambios primero.
- Cada Pull Request lleva una descripción de qué cambia, cómo se verificó y qué no incluye.
- Las ramas de trabajo se borran al integrarse. Los `db.properties` nunca se suben.
