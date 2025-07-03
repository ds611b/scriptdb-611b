CREATE DATABASE IF NOT EXISTS ConnectPRO_DB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ConnectPRO_DB;

-- Tabla de Roles
CREATE TABLE Roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(50)
) ENGINE = InnoDB;

-- Tabla de Usuarios
CREATE TABLE Usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    primer_nombre VARCHAR(100) NOT NULL,
    segundo_nombre VARCHAR(100),
    primer_apellido VARCHAR(100) NOT NULL,
    segundo_apellido VARCHAR(100),
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
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
    telefono VARCHAR(20),
    fecha_nacimiento DATE,
    genero ENUM('Masculino','Femenino','Otro'),
    foto_perfil VARCHAR(255),
    anio_académico VARCHAR(4),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    UNIQUE KEY uq_perfil_usuario (usuario_id),
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id) ON DELETE CASCADE
) ENGINE = InnoDB;

-- Tabla de Contactos de Emergencia 
CREATE TABLE ContactoEmergencia(
	id INT AUTO_INCREMENT PRIMARY KEY, 
    nombres VARCHAR(200),
    apellidos VARCHAR(200),
    telefono VARCHAR(14),
    direccion TEXT,
    id_perfil_usuario INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_perfil_usuario) REFERENCES PerfilUsuario(id) ON DELETE CASCADE
);

-- Tabla de Escuelas Academicas
CREATE TABLE Escuelas (
	id INT AUTO_INCREMENT PRIMARY KEY, 
    nombre VARCHAR(300),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Carreras por Escuela
CREATE TABLE Carreras (
	id INT AUTO_INCREMENT PRIMARY KEY,
    nombre TEXT,
    id_escuela INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_escuela) REFERENCES Escuelas(id) ON DELETE CASCADE
);

-- Tabla de Coordinadores de Servicio Social por Carreras
CREATE TABLE CoordinadoresCarrera(
	id INT AUTO_INCREMENT PRIMARY KEY, 
    nombres VARCHAR(100),
    apellidos VARCHAR(100),
    correo_institucional VARCHAR(100),
    telefono VARCHAR(15),
    id_carrera INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_carrera) REFERENCES Carreras(id) ON DELETE CASCADE
);

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