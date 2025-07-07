CREATE TABLE
    ActividadesProyecto (
        id INT AUTO_INCREMENT PRIMARY KEY,
        actividad_a_realizar TEXT,
        objetivo VARCHAR(100),
        meta VARCHAR(100),
        duracion VARCHAR(50),
        id_proyecto INT
    ) ENGINE = InnoDB;

CREATE TABLE
    BitacoraItems (
        id INT AUTO_INCREMENT PRIMARY KEY,
        detalle_actividades TEXT,
        total_horas INT,
        punch_in TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        punch_out TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    ) ENGINE = InnoDB;

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

CREATE TABLE
    DetalleBitacoraPerfilUsuario (
        id INT AUTO_INCREMENT PRIMARY KEY,
        id_bitacora INT,
        id_perfil_usuario INT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    ) ENGINE = InnoDB;

CREATE TABLE
    DetalleBitacoraProyectoBitacoraItems (
        id INT AUTO_INCREMENT PRIMARY KEY,
        id_bitacora INT,
        id_bitacora_item INT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    ) ENGINE = InnoDB;

-- FK
ALTER TABLE ActividadesProyecto ADD CONSTRAINT fk_actividad_proyecto FOREIGN KEY (id_proyecto) REFERENCES ProyectosInstitucion (id) ON DELETE CASCADE;

ALTER TABLE BitacoraProyecto ADD CONSTRAINT fk_bitacora_proyecto FOREIGN KEY (id_proyecto) REFERENCES ProyectosInstitucion (id) ON DELETE CASCADE;

ALTER TABLE DetalleBitacoraPerfilUsuario ADD CONSTRAINT fk_detbit_perfil FOREIGN KEY (id_perfil_usuario) REFERENCES PerfilUsuario (id) ON DELETE CASCADE,
ADD CONSTRAINT fk_detbit_bitacora FOREIGN KEY (id_bitacora) REFERENCES BitacoraProyecto (id) ON DELETE CASCADE;

ALTER TABLE DetalleBitacoraProyectoBitacoraItems ADD CONSTRAINT fk_detbitproj_bitacora FOREIGN KEY (id_bitacora) REFERENCES BitacoraProyecto (id) ON DELETE CASCADE,
ADD CONSTRAINT fk_detbitproj_bitacora_it FOREIGN KEY (id_bitacora_item) REFERENCES BitacoraItems (id) ON DELETE CASCADE;
