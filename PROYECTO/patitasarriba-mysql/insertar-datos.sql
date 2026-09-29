USE mydb;

-- ===== Nivel 0: sin dependencias =====
INSERT INTO cuenta (id_cuenta, activo, password, correo, fecha_creacion, nombre_usuario) VALUES
(1, 1, 'hash123', 'juan.perez@correo.com', '2025-01-10', 'juan.perez'),
(2, 1, 'hash456', 'lucia.paredes@patitas.pe', '2024-06-01', 'lucia.paredes'),
(3, 1, 'hash789', 'maria.diaz@patitas.pe', '2024-06-01', 'maria.diaz'),
(4, 1, 'hash012', 'rosa.valdez@correo.com', '2025-03-20', 'rosa.valdez');

INSERT INTO horario (id_horario, activo, dia_semana, hora_inicio, hora_fin) VALUES
(1, 1, 'LUNES', '09:00:00', '13:00:00'),
(2, 1, 'MARTES', '14:00:00', '18:00:00');

INSERT INTO categoria_articulo (id_categoria_articulo, activo, nombre, descripcion) VALUES
(1, 1, 'Farmacologia', 'Medicamentos y sustancias quimicas'),
(2, 1, 'Alimentos', 'Alimento balanceado para mascotas');

INSERT INTO servicio (id_servicio, activo, nombre, precio_base, descripcion, duracion_estimada, tipo_servicio_medico, requiere_triaje, requiere_vacuna) VALUES
(1, 1, 'Consulta General', 50.00, 'Revision general', 30, 'Consulta médica', 1, 0),
(2, 1, 'Vacuna Antirrabica', 35.00, 'Aplicacion de vacuna', 15, 'Vacunación', 0, 1);

INSERT INTO diagnostico (id_diagnostico, activo, nombre_enfermedad, descripcion) VALUES
(1, 1, 'Otitis', 'Infeccion en el oido'),
(2, 1, 'Dermatitis', 'Inflamacion de la piel');

INSERT INTO tratamiento (id_tratamiento, activo, nombre_procedimiento, descripcion) VALUES
(1, 1, 'Aplicacion de antibiotico', 'Inyeccion intramuscular'),
(2, 1, 'Limpieza de oidos', 'Procedimiento ambulatorio');

-- ===== Nivel 1: dependen de cuenta / categoria_articulo =====
INSERT INTO cliente (id_cliente, id_cuenta, activo, dni, nombres, apellido_paterno, apellido_materno, telefono) VALUES
(1, 1, 1, '45678912', 'Juan', 'Perez', 'Lopez', '987654321'),
(2, 4, 1, '50123456', 'Rosa', 'Valdez', 'Ramos', '912345678');

INSERT INTO administrador (id_administrador, id_cuenta, activo, dni, nombres, apellido_paterno, apellido_materno, telefono) VALUES
(1, 2, 1, '47890123', 'Lucia', 'Paredes', 'Rios', '911111111');

INSERT INTO veterinario (id_veterinario, id_cuenta, activo, dni, nombres, apellido_paterno, apellido_materno, telefono, numero_colegiatura) VALUES
(1, 3, 1, '87654321', 'Maria', 'Diaz', 'Torres', '988888888', 'CMVP-1234');

INSERT INTO articulo (id_articulo, id_categoria_articulo, activo, nombre, precio_base, descripcion, stock_actual, stock_minimo, marca) VALUES
(1, 1, 1, 'Amoxicilina 250mg', 25.00, 'Antibiotico', 40, 10, 'VetPharma'),
(2, 2, 1, 'Croquetas Adulto 15kg', 120.00, 'Alimento seco', 15, 5, 'PetFood');

-- ===== Nivel 2 =====
INSERT INTO mascota (id_mascota, id_cliente, activo, nombre, sexo, peso, fecha_nacimiento, tipo_mascota, raza) VALUES
(1, 1, 1, 'Firulais', 'M', 8.5, '2022-04-10', 'PERRO', 'Labrador'),
(2, 2, 1, 'Michi', 'H', 4.2, '2021-06-15', 'GATO', 'Siames');

INSERT INTO boleta (id_boleta, id_cliente, activo, fecha, total, metodo_pago) VALUES
(1, 1, 1, '2026-09-15', 85.00, 'Efectivo'),
(2, 2, 1, '2026-09-20', 120.00, 'Tarjeta de credito');

INSERT INTO horario_administrador (id_horario_admin, id_administrador, id_horario, activo) VALUES
(1, 1, 1, 1);

INSERT INTO horario_veterinario (id_horario_vet, id_veterinario, id_horario, activo) VALUES
(1, 1, 2, 1);

-- ===== Nivel 3 =====
INSERT INTO cita (id_cita, id_mascota, id_veterinario, activo, fecha_hora, estado) VALUES
(1, 1, 1, 1, '2026-10-05 10:00:00', 'AGENDADA'),
(2, 2, 1, 1, '2026-10-10 15:30:00', 'COMPLETADA');

INSERT INTO detalle_boleta_art (id_detalle_boleta_arti, id_boleta, id_articulo, activo, cantidad, subtotal) VALUES
(1, 1, 1, 1, 2, 50.00);

-- ===== Nivel 4 =====
INSERT INTO atencion_medica (id_atencion_medica, id_mascota, id_cita_medica, activo, fecha_hora, motivo_consulta, peso_fisico, observaciones) VALUES
(1, 2, 2, 1, '2026-10-10 15:45:00', 'Control post vacuna', 4.3, 'Todo normal');

INSERT INTO detalle_cita (id_detalle_cita, id_servicio, id_cita, activo, observaciones) VALUES
(1, 1, 1, 1, 'Control de rutina'),
(2, 2, 2, 1, 'Aplicacion de vacuna anual');

INSERT INTO detalle_boleta_serv (id_detalle_serv, id_boleta, id_servicio, activo, cantidad, subtotal) VALUES
(1, 1, 1, 1, 1, 35.00);

-- ===== Nivel 5 =====
INSERT INTO receta (id_receta, id_atencion_medica, activo, fecha_emision, indicaciones_generales) VALUES
(1, 1, 1, '2026-10-10', 'Administrar con alimento');

INSERT INTO atencion_diagnostico (id_atencion_diagnostico, id_atencion_medica, id_diagnostico, activo, nivel_gravedad, detalle_diagnostico) VALUES
(1, 1, 1, 1, 'LEVE', 'Otitis en oido derecho');

INSERT INTO atencion_tratamiento (id_atencion_tratamiento, id_atencion_medica, id_tratamiento, activo) VALUES
(1, 1, 1, 1);

-- ===== Nivel 6 =====
INSERT INTO detalle_receta (id_detalle_receta, id_receta, id_articulo, activo, dosis, frecuencia, duracion_dias, cantidad_total) VALUES
(1, 1, 1, 1, '1 comprimido', 'Cada 12 horas', 7, 14);

INSERT INTO insumo_utilizado (id_insumo_utilizado, id_atencion_tratamiento, id_articulo, activo, cantidad_utilizada) VALUES
(1, 1, 1, 1, 14);
