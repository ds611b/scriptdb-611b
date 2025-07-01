CREATE DATABASE IF NOT EXISTS ConnectPRO_DB2 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ConnectPRO_DB2;

-- Tabla de Roles
CREATE TABLE Roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(50)
) ENGINE = InnoDB;

-- Tabla de Usuarios
CREATE TABLE Usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    telefono VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    rol_id INT NOT NULL,
    FOREIGN KEY (rol_id) REFERENCES Roles(id) ON DELETE RESTRICT
) ENGINE = InnoDB;

-- Tabla de Perfiles de Usuario  (índice UNIQUE sobre usuario_id)
CREATE TABLE PerfilUsuario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    direccion TEXT,
    fecha_nacimiento DATE,
    genero ENUM('Masculino','Femenino','Otro'),
    foto_perfil VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    UNIQUE KEY uq_perfil_usuario (usuario_id),
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id) ON DELETE CASCADE
) ENGINE = InnoDB;

-- Tabla de Instituciones
CREATE TABLE Instituciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL UNIQUE,
    direccion TEXT,
    telefono VARCHAR(20),
    email VARCHAR(150) UNIQUE,
    fecha_fundacion DATE,
    nit VARCHAR(25),
    estado ENUM('Pendiente','Aprobado','Rechazado') DEFAULT 'Pendiente',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
) ENGINE = InnoDB;

-- Tabla de Proyectos de Institución
CREATE TABLE ProyectosInstitucion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    institucion_id INT NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT NOT NULL,
    fecha_inicio DATE,
    fecha_fin DATE,
    modalidad VARCHAR(25),
    direccion TEXT,
    disponibilidad BOOLEAN DEFAULT 1,
    estado ENUM('Pendiente','Aprobado','Rechazado') DEFAULT 'Pendiente',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    FOREIGN KEY (institucion_id) REFERENCES Instituciones(id) ON DELETE CASCADE
) ENGINE = InnoDB;

-- Tabla de Aplicaciones de Estudiantes (índice UNIQUE estudiante-proyecto)
CREATE TABLE AplicacionesEstudiantes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    estudiante_id INT NOT NULL,
    proyecto_id INT NOT NULL,
    estado ENUM('Pendiente','Aprobado','Rechazado') DEFAULT 'Pendiente',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    UNIQUE KEY uq_aplicacion_estudiante_proyecto (estudiante_id, proyecto_id),
    FOREIGN KEY (estudiante_id) REFERENCES Usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (proyecto_id) REFERENCES ProyectosInstitucion(id) ON DELETE CASCADE
) ENGINE = InnoDB;

-- Tabla de Habilidades  (índice UNIQUE en descripción)
CREATE TABLE Habilidades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    UNIQUE KEY uq_habilidades_descripcion (descripcion)
) ENGINE = InnoDB;

-- Tabla de Usuarios-Habilidades (índice UNIQUE usuario-habilidad)
CREATE TABLE UsuariosHabilidades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    habilidad_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    UNIQUE KEY uq_usuario_habilidad (usuario_id, habilidad_id),
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (habilidad_id) REFERENCES Habilidades(id) ON DELETE CASCADE
) ENGINE = InnoDB;

-- Tabla de Proyectos-Habilidades (índice UNIQUE proyecto-habilidad)
CREATE TABLE ProyectosInstitucionesHabilidades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    proyecto_id INT NOT NULL,
    habilidad_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    UNIQUE KEY uq_proyecto_habilidad (proyecto_id, habilidad_id),
    FOREIGN KEY (proyecto_id) REFERENCES ProyectosInstitucion(id) ON DELETE CASCADE,
    FOREIGN KEY (habilidad_id) REFERENCES Habilidades(id) ON DELETE CASCADE
) ENGINE = InnoDB;

-- Tabla de Sesiones
CREATE TABLE Sesiones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    closed_at TIMESTAMP NULL DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
) ENGINE = InnoDB;

-- Tabla de Sesiones de Usuarios (índice SHA-256 para búsquedas rápidas)
CREATE TABLE UsuariosSesiones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    token VARCHAR(512) NOT NULL,
    usuario_id INT NOT NULL,
    sesion_id INT NOT NULL,
    token_sha256 CHAR(64) NOT NULL DEFAULT (SHA2(CONCAT('temp_', CONNECTION_ID(), '_', UNIX_TIMESTAMP()), 256)),
    revoked_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    UNIQUE KEY uq_token_sha256 (token_sha256),
    UNIQUE INDEX idx_token_sha256 (token_sha256),
    INDEX idx_usuario (usuario_id),
    INDEX idx_active_sha (token_sha256, revoked_at),
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (sesion_id) REFERENCES Sesiones(id) ON DELETE CASCADE
) ENGINE = InnoDB;

-- Tipos de Solicitud
CREATE TABLE TipoSolicitud (
    id INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
) ENGINE = InnoDB;

-- Solicitudes
CREATE TABLE Solicitudes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo_solicitud INT NOT NULL,
    titulo VARCHAR(100) NOT NULL,
    descripcion TEXT NOT NULL,
    id_institucion INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    FOREIGN KEY (tipo_solicitud) REFERENCES TipoSolicitud(id) ON DELETE CASCADE,
    FOREIGN KEY (id_institucion) REFERENCES Instituciones(id) ON DELETE CASCADE
) ENGINE = InnoDB;

-- Relación Solicitud-Usuarios (evita duplicados con índice UNIQUE)
CREATE TABLE SolicitudUsuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_solicitud INT NOT NULL,
    id_usuario INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_solicitud_usuario (id_solicitud, id_usuario),
    FOREIGN KEY (id_solicitud) REFERENCES Solicitudes(id) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id) ON DELETE CASCADE
) ENGINE = InnoDB;

## Vista de Usuarios
CREATE VIEW VistaUsuarios AS
SELECT 
    u.id AS usuario_id,
    u.nombre,
    u.apellido,
    u.email,
    u.telefono,
    u.created_at AS fecha_registro,
    u.updated_at AS fecha_actualizacion,
    r.nombre AS rol,
    p.direccion,
    p.fecha_nacimiento,
    p.genero,
    p.foto_perfil
FROM Usuarios u
LEFT JOIN PerfilUsuario p ON u.id = p.usuario_id
LEFT JOIN Roles r ON u.rol_id = r.id;

## Vista de Proyectos
CREATE VIEW VistaProyectos AS
SELECT 
    pi.id AS proyecto_id,
    pi.nombre AS proyecto_nombre,
    pi.descripcion,
    pi.fecha_inicio,
    pi.fecha_fin,
    pi.modalidad,
    i.id AS institucion_id,
    i.nombre AS institucion_nombre,
    i.direccion AS institucion_direccion,
    i.telefono AS institucion_telefono,
    ae.estudiante_id,
    u.nombre AS estudiante_nombre,
    u.apellido AS estudiante_apellido,
    ae.estado AS estado_aplicacion,
    ae.created_at AS fecha_aplicacion
FROM ProyectosInstitucion pi
LEFT JOIN Instituciones i ON pi.institucion_id = i.id
LEFT JOIN AplicacionesEstudiantes ae ON pi.id = ae.proyecto_id
LEFT JOIN Usuarios u ON ae.estudiante_id = u.id;

DELIMITER $$

## Vista de Sesiones de Usuarios
CREATE VIEW VistaSesiones AS
SELECT 
    s.id AS sesion_id,
    us.token,
    u.id AS usuario_id,
    CONCAT(u.nombre, ' ', u.apellido) AS usuario_nombre,
    s.created_at AS sesion_creada,
    s.closed_at AS sesion_cerrada
FROM UsuariosSesiones us
JOIN Sesiones s ON us.sesion_id = s.id
JOIN Usuarios u ON us.usuario_id = u.id;

## Vista de Habilidades de Usuarios
CREATE VIEW VistaHabilidadesUsuarios AS
SELECT 
    uh.usuario_id,
    CONCAT(u.nombre, ' ', u.apellido) AS usuario_nombre,
    h.id AS habilidad_id,
    h.descripcion AS habilidad_nombre
FROM UsuariosHabilidades uh
JOIN Usuarios u ON uh.usuario_id = u.id
JOIN Habilidades h ON uh.habilidad_id = h.id;

### Vista de Habilidades requeridas en Proyectos
CREATE VIEW VistaHabilidadesProyectos AS
SELECT 
    ph.proyecto_id,
    p.nombre AS proyecto_nombre,
    h.id AS habilidad_id,
    h.descripcion AS habilidad_nombre
FROM ProyectosInstitucionesHabilidades ph
JOIN ProyectosInstitucion p ON ph.proyecto_id = p.id
JOIN Habilidades h ON ph.habilidad_id = h.id;


### Procedimiento para el registro de Usuarios
CREATE PROCEDURE RegistrarUsuario(
    IN p_nombre VARCHAR(100),
    IN p_apellido VARCHAR(100),
    IN p_email VARCHAR(150),
    IN p_password_hash VARCHAR(255),
    IN p_telefono VARCHAR(20),
    IN p_rol_id INT
)
BEGIN
    INSERT INTO Usuarios (nombre, apellido, email, password_hash, telefono, created_at, updated_at, rol_id)
    VALUES (p_nombre, p_apellido, p_email, p_password_hash, p_telefono, NOW(), NOW(), p_rol_id);
END $$

DELIMITER ;

DELIMITER $$

### Procedimiento para el registro de Perfiles de usuario
CREATE PROCEDURE RegistrarPerfilUsuario(
    IN p_usuario_id INT,
    IN p_direccion TEXT,
    IN p_fecha_nacimiento DATE,
    IN p_genero ENUM('Masculino', 'Femenino', 'Otro'),
    IN p_foto_perfil VARCHAR(255)
)
BEGIN
    INSERT INTO PerfilUsuario (usuario_id, direccion, fecha_nacimiento, genero, foto_perfil, created_at, updated_at)
    VALUES (p_usuario_id, p_direccion, p_fecha_nacimiento, p_genero, p_foto_perfil, NOW(), NOW());
END $$

DELIMITER ;

DELIMITER $$

### Procedimiento para el registro de Proyectos de Instituciones
CREATE PROCEDURE RegistrarInstitucionYProyecto(
    IN p_nombre_institucion VARCHAR(255),
    IN p_direccion TEXT,
    IN p_telefono VARCHAR(20),
    IN p_email VARCHAR(150),
    IN p_fecha_fundacion DATE,
    IN p_nit VARCHAR(25),
    IN p_nombre_proyecto VARCHAR(255),
    IN p_descripcion TEXT,
    IN p_fecha_inicio DATE,
    IN p_fecha_fin DATE,
    IN p_modalidad VARCHAR(25),
    IN p_direccion_proyecto TEXT
)
BEGIN
    DECLARE v_institucion_id INT;

    INSERT INTO Instituciones (nombre, direccion, telefono, email, fecha_fundacion, nit, created_at, updated_at)
    VALUES (p_nombre_institucion, p_direccion, p_telefono, p_email, p_fecha_fundacion, p_nit, NOW(), NOW());

    SET v_institucion_id = LAST_INSERT_ID();

    INSERT INTO ProyectosInstitucion (institucion_id, nombre, descripcion, fecha_inicio, fecha_fin, modalidad, direccion, created_at, updated_at)
    VALUES (v_institucion_id, p_nombre_proyecto, p_descripcion, p_fecha_inicio, p_fecha_fin, p_modalidad, p_direccion_proyecto, NOW(), NOW());
END $$

DELIMITER ;

DELIMITER $$

### Procedimiento para la Creación de Sesiones
DELIMITER $$
CREATE PROCEDURE CrearSesion()
BEGIN
    INSERT INTO Sesiones (created_at, updated_at) VALUES (NOW(), NOW());
END $$
DELIMITER ;

## Procedimiento para la Actualización de Sesiones
DELIMITER $$
CREATE PROCEDURE ActualizarSesion(IN sesion_id INT)
BEGIN
    UPDATE Sesiones
    SET updated_at = NOW()
    WHERE id = sesion_id;
END $$
DELIMITER ;

## Procedimiento para la Actualización de Usuarios
DELIMITER $$
CREATE PROCEDURE ActualizarUsuario(
    IN p_usuario_id INT,
    IN p_nombre VARCHAR(100),
    IN p_apellido VARCHAR(100),
    IN p_email VARCHAR(150),
    IN p_telefono VARCHAR(20)
)
BEGIN
    UPDATE Usuarios
    SET nombre = p_nombre,
        apellido = p_apellido,
        email = p_email,
        telefono = p_telefono,
        updated_at = NOW()
    WHERE id = p_usuario_id;
END $$
DELIMITER ;

### Procedimiento para la Actualización de Perfil de Usuario
DELIMITER $$
CREATE PROCEDURE ActualizarPerfilUsuario(
    IN p_usuario_id INT,
    IN p_direccion TEXT,
    IN p_fecha_nacimiento DATE,
    IN p_genero ENUM('Masculino', 'Femenino', 'Otro'),
    IN p_foto_perfil VARCHAR(255)
)
BEGIN
    UPDATE PerfilUsuario
    SET direccion = p_direccion,
        fecha_nacimiento = p_fecha_nacimiento,
        genero = p_genero,
        foto_perfil = p_foto_perfil,
        updated_at = NOW()
    WHERE usuario_id = p_usuario_id;
END $$
DELIMITER ;

### Procedimiento para la Actualización de Proyectos de Instituciones
DELIMITER $$
CREATE PROCEDURE ActualizarProyectoInstitucion(
    IN p_proyecto_id INT,
    IN p_nombre VARCHAR(255),
    IN p_descripcion TEXT,
    IN p_fecha_inicio DATE,
    IN p_fecha_fin DATE,
    IN p_modalidad VARCHAR(25),
    IN p_direccion TEXT,
    IN p_disponibilidad BOOLEAN
)
BEGIN
    UPDATE ProyectosInstitucion
    SET nombre = p_nombre,
        descripcion = p_descripcion,
        fecha_inicio = p_fecha_inicio,
        fecha_fin = p_fecha_fin,
        modalidad = p_modalidad,
        direccion = p_direccion,
        disponibilidad = p_disponibilidad,
        updated_at = NOW()
    WHERE id = p_proyecto_id;
END $$
DELIMITER ;