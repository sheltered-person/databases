DROP TABLE application CASCADE CONSTRAINTS;

DROP TABLE diploma CASCADE CONSTRAINTS;

DROP TABLE faculty CASCADE CONSTRAINTS;

DROP TABLE graduate CASCADE CONSTRAINTS;

DROP TABLE organisation CASCADE CONSTRAINTS;

DROP TABLE speciality CASCADE CONSTRAINTS;

DROP TABLE university CASCADE CONSTRAINTS;


CREATE TABLE application (
    graduate_id         INTEGER NOT NULL,
    organisation_id     INTEGER NOT NULL,
    application_number  INTEGER NOT NULL UNIQUE
);

ALTER TABLE application ADD CONSTRAINT application_pk PRIMARY KEY ( graduate_id,
                                                                    organisation_id );

CREATE TABLE diploma (
    id                                INTEGER NOT NULL,
    diploma_number                    INTEGER NOT NULL UNIQUE,
    education_form                    VARCHAR2(20) NOT NULL CHECK(education_form IN ('budget', 'paid')),
    job                               VARCHAR2(30) NOT NULL,
    graduate_id                       INTEGER NOT NULL,
    speciality_id                     INTEGER NOT NULL,
    speciality_faculty_id             INTEGER NOT NULL, 
    spec_faculty_univer_id            INTEGER NOT NULL
);

ALTER TABLE diploma ADD CONSTRAINT diploma_pk PRIMARY KEY ( id );

CREATE TABLE faculty (
    id             INTEGER NOT NULL,
    name           VARCHAR2(60) NOT NULL,
    university_id  INTEGER NOT NULL
);

ALTER TABLE faculty ADD CONSTRAINT faculty_pk PRIMARY KEY ( id,
                                                            university_id );

CREATE TABLE graduate (
    id    INTEGER NOT NULL,
    name  VARCHAR2(20) NOT NULL
);

ALTER TABLE graduate ADD CONSTRAINT graduate_pk PRIMARY KEY ( id );

CREATE TABLE organisation (
    id             INTEGER NOT NULL,
    name           VARCHAR(60) NOT NULL,
    director_name  VARCHAR2(60) NOT NULL,
    telephone      VARCHAR2(15) NOT NULL
);

ALTER TABLE organisation ADD CONSTRAINT organisation_pk PRIMARY KEY ( id );

CREATE TABLE speciality (
    id                     INTEGER NOT NULL,
    name                   VARCHAR2(60) NOT NULL,
    faculty_id             INTEGER NOT NULL,
    faculty_university_id  INTEGER NOT NULL
);

ALTER TABLE speciality
    ADD CONSTRAINT speciality_pk PRIMARY KEY ( id,
                                               faculty_id,
                                               faculty_university_id );

CREATE TABLE university (
    id    INTEGER NOT NULL,
    name  VARCHAR2(60) NOT NULL
);

ALTER TABLE university ADD CONSTRAINT university_pk PRIMARY KEY ( id );

ALTER TABLE application
    ADD CONSTRAINT application_graduate_fk FOREIGN KEY ( graduate_id )
        REFERENCES graduate ( id ) ON DELETE CASCADE;

ALTER TABLE application
    ADD CONSTRAINT application_organisation_fk FOREIGN KEY ( organisation_id )
        REFERENCES organisation ( id ) ON DELETE CASCADE;

ALTER TABLE diploma
    ADD CONSTRAINT diploma_graduate_fk FOREIGN KEY ( graduate_id )
        REFERENCES graduate ( id ) ON DELETE CASCADE;

ALTER TABLE diploma
    ADD CONSTRAINT diploma_speciality_fk FOREIGN KEY ( speciality_id,
                                                       speciality_faculty_id,
                                                       spec_faculty_univer_id )
        REFERENCES speciality ( id,
                                faculty_id,
                                faculty_university_id ) ON DELETE CASCADE;

ALTER TABLE faculty
    ADD CONSTRAINT faculty_university_fk FOREIGN KEY ( university_id )
        REFERENCES university ( id ) ON DELETE CASCADE;

ALTER TABLE speciality
    ADD CONSTRAINT speciality_faculty_fk FOREIGN KEY ( faculty_id,
                                                       faculty_university_id )
        REFERENCES faculty ( id,
                             university_id ) ON DELETE CASCADE;

CREATE OR REPLACE TRIGGER fkntm_diploma BEFORE
    UPDATE OF graduate_id ON diploma
BEGIN
    raise_application_error(-20225, 'Non Transferable FK constraint  on table Diploma is violated');
END;
