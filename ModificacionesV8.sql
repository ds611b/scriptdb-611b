/* 2.1  INSTITUCIONES  --------------------------------------------------- */
ALTER TABLE Instituciones
    ADD COLUMN id_encargado INT NULL AFTER estado,
    ADD KEY idx_institucion_encargado (id_encargado),
    ADD CONSTRAINT fk_institucion_encargado
        FOREIGN KEY (id_encargado)
        REFERENCES EncargadoInstitucion(id)
        ON DELETE CASCADE;

/* 2.2  PROYECTOSINSTITUCION  ------------------------------------------- */
ALTER TABLE ProyectosInstitucion
    /* nuevas columnas de negocio */
    ADD COLUMN sitio_web           VARCHAR(100)  AFTER descripcion,
    ADD COLUMN actividad_principal TEXT          AFTER direccion,
    ADD COLUMN horario_requerido   VARCHAR(100)  AFTER actividad_principal,
    ADD COLUMN id_encargado        INT NULL      AFTER estado,
    /* soporte FK */
    ADD KEY idx_proyecto_encargado (id_encargado),
    ADD CONSTRAINT fk_proyecto_encargado
        FOREIGN KEY (id_encargado)
        REFERENCES EncargadoInstitucion(id)
        ON DELETE CASCADE;

/* 2.3  PERFILUSUARIO  --------------------------------------------------- */
ALTER TABLE PerfilUsuario
    MODIFY COLUMN anio_academico VARCHAR(25) NULL;