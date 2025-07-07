CREATE DATABASE IF NOT EXISTS ConnectPRO_DB CHARACTER
SET
    utf8mb4 COLLATE utf8mb4_unicode_ci;

USE ConnectPRO_DB;


/* 1. ActividadesProyecto */
CREATE TABLE
    ActividadesProyecto (
        id INT AUTO_INCREMENT PRIMARY KEY,
        actividad_a_realizar TEXT,
        objetivo VARCHAR(100),
        meta VARCHAR(100),
        duracion VARCHAR(50),
        id_proyecto INT
    ) ENGINE = InnoDB;

/* 2. AplicacionesEstudiantes */
CREATE TABLE
    AplicacionesEstudiantes (
        id INT AUTO_INCREMENT PRIMARY KEY,
        estudiante_id INT,
        proyecto_id INT,
        estado ENUM ('Pendiente', 'Aprobado', 'Rechazado') DEFAULT 'Pendiente',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        UNIQUE KEY uq_aplicacion_estudiante_proyecto (estudiante_id, proyecto_id)
    ) ENGINE = InnoDB;

/* 3. BitacoraItems */
CREATE TABLE
    BitacoraItems (
        id INT AUTO_INCREMENT PRIMARY KEY,
        detalle_actividades TEXT,
        total_horas INT,
        punch_in TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        punch_out TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    ) ENGINE = InnoDB;

/* 4. BitacoraProyecto */
CREATE TABLE
    BitacoraProyecto (
        id INT AUTO_INCREMENT PRIMARY KEY,
        fecha_inicio DATE,
        fecha_fin DATE,
        estado ENUM ('En Proceso', 'Aprobado', 'Rechazado') DEFAULT 'En Proceso',
        observaciones TEXT,
        id_proyecto INT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    ) ENGINE = InnoDB;

/* 5. Carreras */
CREATE TABLE
    Carreras (
        id INT AUTO_INCREMENT PRIMARY KEY,
        nombre TEXT,
        id_escuela INT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    ) ENGINE = InnoDB;

/* 6. CoordinadoresCarrera */
CREATE TABLE
    CoordinadoresCarrera (
        id INT AUTO_INCREMENT PRIMARY KEY,
        nombres VARCHAR(100),
        apellidos VARCHAR(100),
        correo_institucional VARCHAR(100),
        telefono VARCHAR(15),
        id_carrera INT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    ) ENGINE = InnoDB;

/* 7. ContactoEmergencia */
CREATE TABLE
    ContactoEmergencia (
        id INT AUTO_INCREMENT PRIMARY KEY,
        nombres VARCHAR(200),
        apellidos VARCHAR(200),
        telefono VARCHAR(14),
        direccion TEXT,
        id_perfil_usuario INT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    ) ENGINE = InnoDB;

/* 8. DetalleBitacoraPerfilUsuario */
CREATE TABLE
    DetalleBitacoraPerfilUsuario (
        id INT AUTO_INCREMENT PRIMARY KEY,
        id_bitacora INT,
        id_perfil_usuario INT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    ) ENGINE = InnoDB;

/* 9. DetalleBitacoraProyectoBitacoraItems */
CREATE TABLE
    DetalleBitacoraProyectoBitacoraItems (
        id INT AUTO_INCREMENT PRIMARY KEY,
        id_bitacora INT,
        id_bitacora_item INT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    ) ENGINE = InnoDB;

/* 10. EncargadoInstitucion */
CREATE TABLE
    EncargadoInstitucion (
        id INT AUTO_INCREMENT PRIMARY KEY,
        nombres VARCHAR(100),
        apellidos VARCHAR(100),
        correo VARCHAR(100),
        telefono VARCHAR(15),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    ) ENGINE = InnoDB;

/* 11. Escuelas */
CREATE TABLE
    Escuelas (
        id INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(300),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    ) ENGINE = InnoDB;

/* 12. Habilidades */
CREATE TABLE
    Habilidades (
        id INT AUTO_INCREMENT PRIMARY KEY,
        descripcion VARCHAR(50) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        UNIQUE KEY uq_habilidades_descripcion (descripcion)
    ) ENGINE = InnoDB;

/* 13. Instituciones */
CREATE TABLE
    Instituciones (
        id INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(255) NOT NULL UNIQUE,
        direccion TEXT,
        telefono VARCHAR(20),
        email VARCHAR(150) UNIQUE,
        fecha_fundacion DATE,
        nit VARCHAR(25),
        estado ENUM ('Pendiente', 'Aprobado', 'Rechazado') DEFAULT 'Pendiente',
        id_encargado INT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    ) ENGINE = InnoDB;

/* 14. PerfilUsuario */
CREATE TABLE
    PerfilUsuario (
        id INT AUTO_INCREMENT PRIMARY KEY,
        usuario_id INT,
        direccion TEXT,
        telefono VARCHAR(20),
        fecha_nacimiento DATE,
        genero ENUM ('Masculino', 'Femenino', 'Otro'),
        foto_perfil VARCHAR(255),
        carnet VARCHAR(7) NOT NULL,
        anio_academico VARCHAR(25),
        id_carrera INT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        UNIQUE KEY uq_perfil_usuario (usuario_id)
    ) ENGINE = InnoDB;

/* 15. ProyectosInstitucion */
CREATE TABLE
    ProyectosInstitucion (
        id INT AUTO_INCREMENT PRIMARY KEY,
        institucion_id INT,
        nombre VARCHAR(255) NOT NULL,
        descripcion TEXT NOT NULL,
        sitio_web VARCHAR(100),
        fecha_inicio DATE,
        fecha_fin DATE,
        modalidad VARCHAR(25),
        direccion TEXT,
        actividad_principal TEXT,
        horario_requerido VARCHAR(100),
        disponibilidad BOOLEAN DEFAULT 1,
        estado ENUM ('Pendiente', 'Aprobado', 'Rechazado') DEFAULT 'Pendiente',
        id_encargado INT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    ) ENGINE = InnoDB;

/* 16. ProyectosInstitucionesHabilidades */
CREATE TABLE
    ProyectosInstitucionesHabilidades (
        id INT AUTO_INCREMENT PRIMARY KEY,
        proyecto_id INT,
        habilidad_id INT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        UNIQUE KEY uq_proyecto_habilidad (proyecto_id, habilidad_id)
    ) ENGINE = InnoDB;

/* 17. Roles */
CREATE TABLE
    Roles (
        id INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(50) NOT NULL UNIQUE,
        descripcion VARCHAR(50)
    ) ENGINE = InnoDB;

/* 18. Sesiones */
CREATE TABLE
    Sesiones (
        id INT AUTO_INCREMENT PRIMARY KEY,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        closed_at TIMESTAMP NULL DEFAULT NULL,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    ) ENGINE = InnoDB;

/* 19. Solicitudes */
CREATE TABLE
    Solicitudes (
        id INT AUTO_INCREMENT PRIMARY KEY,
        tipo_solicitud INT,
        titulo VARCHAR(100) NOT NULL,
        descripcion TEXT NOT NULL,
        id_institucion INT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    ) ENGINE = InnoDB;

/* 20. SolicitudUsuarios */
CREATE TABLE
    SolicitudUsuarios (
        id INT AUTO_INCREMENT PRIMARY KEY,
        id_solicitud INT,
        id_usuario INT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        UNIQUE KEY uq_solicitud_usuario (id_solicitud, id_usuario)
    ) ENGINE = InnoDB;

/* 21. TipoSolicitud */
CREATE TABLE
    TipoSolicitud (
        id INT AUTO_INCREMENT PRIMARY KEY,
        descripcion VARCHAR(100) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    ) ENGINE = InnoDB;

/* 22. Usuarios */
CREATE TABLE
    Usuarios (
        id INT AUTO_INCREMENT PRIMARY KEY,
        primer_nombre VARCHAR(100) NOT NULL,
        segundo_nombre VARCHAR(100),
        primer_apellido VARCHAR(100) NOT NULL,
        segundo_apellido VARCHAR(100),
        email VARCHAR(150) NOT NULL UNIQUE,
        password_hash VARCHAR(255) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        rol_id INT
    ) ENGINE = InnoDB;

/* 23. UsuariosHabilidades */
CREATE TABLE
    UsuariosHabilidades (
        id INT AUTO_INCREMENT PRIMARY KEY,
        usuario_id INT,
        habilidad_id INT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        UNIQUE KEY uq_usuario_habilidad (usuario_id, habilidad_id)
    ) ENGINE = InnoDB;

/* 24. UsuariosSesiones */
CREATE TABLE
    UsuariosSesiones (
        id INT AUTO_INCREMENT PRIMARY KEY,
        token VARCHAR(512) NOT NULL,
        usuario_id INT,
        sesion_id INT,
        token_sha256 CHAR(64) NOT NULL DEFAULT (
            SHA2 (
                CONCAT ('temp_', CONNECTION_ID (), '_', UNIX_TIMESTAMP ()),
                256
            )
        ),
        revoked_at TIMESTAMP NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        UNIQUE KEY uq_token_sha256 (token_sha256),
        UNIQUE INDEX idx_token_sha256 (token_sha256),
        INDEX idx_usuario (usuario_id),
        INDEX idx_active_sha (token_sha256, revoked_at)
    ) ENGINE = InnoDB;

ALTER TABLE AplicacionesEstudiantes ADD CONSTRAINT fk_aplicacion_estudiante FOREIGN KEY (estudiante_id) REFERENCES Usuarios (id) ON DELETE CASCADE,
ADD CONSTRAINT fk_aplicacion_proyecto FOREIGN KEY (proyecto_id) REFERENCES ProyectosInstitucion (id) ON DELETE CASCADE;

ALTER TABLE BitacoraProyecto ADD CONSTRAINT fk_bitacora_proyecto FOREIGN KEY (id_proyecto) REFERENCES ProyectosInstitucion (id) ON DELETE CASCADE;

ALTER TABLE Carreras ADD CONSTRAINT fk_carrera_escuela FOREIGN KEY (id_escuela) REFERENCES Escuelas (id) ON DELETE CASCADE;

ALTER TABLE CoordinadoresCarrera ADD CONSTRAINT fk_coord_carrera FOREIGN KEY (id_carrera) REFERENCES Carreras (id) ON DELETE CASCADE;

ALTER TABLE ContactoEmergencia ADD CONSTRAINT fk_contacto_perfil FOREIGN KEY (id_perfil_usuario) REFERENCES PerfilUsuario (id) ON DELETE CASCADE;

ALTER TABLE DetalleBitacoraPerfilUsuario ADD CONSTRAINT fk_detbit_perfil FOREIGN KEY (id_perfil_usuario) REFERENCES PerfilUsuario (id) ON DELETE CASCADE,
ADD CONSTRAINT fk_detbit_bitacora FOREIGN KEY (id_bitacora) REFERENCES BitacoraProyecto (id) ON DELETE CASCADE;

ALTER TABLE DetalleBitacoraProyectoBitacoraItems ADD CONSTRAINT fk_detbitproj_bitacora FOREIGN KEY (id_bitacora) REFERENCES BitacoraProyecto (id) ON DELETE CASCADE,
ADD CONSTRAINT fk_detbitproj_bitacora_it FOREIGN KEY (id_bitacora_item) REFERENCES BitacoraItems (id) ON DELETE CASCADE;

ALTER TABLE Instituciones ADD CONSTRAINT fk_institucion_encargado FOREIGN KEY (id_encargado) REFERENCES EncargadoInstitucion (id) ON DELETE CASCADE;

ALTER TABLE ActividadesProyecto ADD CONSTRAINT fk_actividad_proyecto FOREIGN KEY (id_proyecto) REFERENCES ProyectosInstitucion (id) ON DELETE CASCADE;

ALTER TABLE ProyectosInstitucion ADD CONSTRAINT fk_proyecto_institucion FOREIGN KEY (institucion_id) REFERENCES Instituciones (id) ON DELETE CASCADE,
ADD CONSTRAINT fk_proyecto_encargado FOREIGN KEY (id_encargado) REFERENCES EncargadoInstitucion (id) ON DELETE CASCADE;

ALTER TABLE ProyectosInstitucionesHabilidades ADD CONSTRAINT fk_projhab_proyecto FOREIGN KEY (proyecto_id) REFERENCES ProyectosInstitucion (id) ON DELETE CASCADE,
ADD CONSTRAINT fk_projhab_habilidad FOREIGN KEY (habilidad_id) REFERENCES Habilidades (id) ON DELETE CASCADE;

ALTER TABLE PerfilUsuario ADD CONSTRAINT fk_perfil_usuario FOREIGN KEY (usuario_id) REFERENCES Usuarios (id) ON DELETE CASCADE,
ADD CONSTRAINT fk_perfil_carrera FOREIGN KEY (id_carrera) REFERENCES Carreras (id) ON DELETE CASCADE;

ALTER TABLE Solicitudes ADD CONSTRAINT fk_solicitud_tipo FOREIGN KEY (tipo_solicitud) REFERENCES TipoSolicitud (id) ON DELETE CASCADE,
ADD CONSTRAINT fk_solicitud_institucion FOREIGN KEY (id_institucion) REFERENCES Instituciones (id) ON DELETE CASCADE;

ALTER TABLE SolicitudUsuarios ADD CONSTRAINT fk_solicitud_usuario_solic FOREIGN KEY (id_solicitud) REFERENCES Solicitudes (id) ON DELETE CASCADE,
ADD CONSTRAINT fk_solicitud_usuario_user FOREIGN KEY (id_usuario) REFERENCES Usuarios (id) ON DELETE CASCADE;

ALTER TABLE Usuarios ADD CONSTRAINT fk_usuario_rol FOREIGN KEY (rol_id) REFERENCES Roles (id) ON DELETE RESTRICT;

ALTER TABLE UsuariosHabilidades ADD CONSTRAINT fk_userhab_usuario FOREIGN KEY (usuario_id) REFERENCES Usuarios (id) ON DELETE CASCADE,
ADD CONSTRAINT fk_userhab_habilidad FOREIGN KEY (habilidad_id) REFERENCES Habilidades (id) ON DELETE CASCADE;

ALTER TABLE UsuariosSesiones ADD CONSTRAINT fk_usersess_usuario FOREIGN KEY (usuario_id) REFERENCES Usuarios (id) ON DELETE CASCADE,
ADD CONSTRAINT fk_usersess_sesion FOREIGN KEY (sesion_id) REFERENCES Sesiones (id) ON DELETE CASCADE;
