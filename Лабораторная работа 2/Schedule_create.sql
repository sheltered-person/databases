CREATE TABLE classroom (
    classroomid       INTEGER NOT NULL,
    building          INTEGER NOT NULL,
    roomnumber        INTEGER NOT NULL,
    capacity          INTEGER NOT NULL,
    classtype         CHAR(1) NOT NULL,
    hasmultimedia     CHAR(1),
    numberofmachines  INTEGER,
    UNIQUE (building, roomnumber)
);

ALTER TABLE classroom ADD CONSTRAINT classroom_pk PRIMARY KEY ( classroomid );

CREATE TABLE studygroup (
    groupid           INTEGER NOT NULL,
    numberofstudents  INTEGER NOT NULL
);

ALTER TABLE studygroup ADD CONSTRAINT group_pk PRIMARY KEY ( groupid );

CREATE TABLE student (
    studentid       INTEGER NOT NULL,
    name            VARCHAR(20) NOT NULL,
    lastname        VARCHAR(20) NOT NULL,
    patronymic      VARCHAR(20) NOT NULL
);

ALTER TABLE student ADD CONSTRAINT student_pk PRIMARY KEY ( studentid );

CREATE TABLE studentgroup (
    student_studentid   INTEGER NOT NULL,
    group_groupid       INTEGER NOT NULL
);

ALTER TABLE studentgroup ADD CONSTRAINT studentgroup_pk PRIMARY KEY ( student_studentid,
                                                                      group_groupid );

CREATE TABLE lesson (
    lessonid               INTEGER NOT NULL,
    datetime               DATE NOT NULL,
    lessonlenght           INTEGER NOT NULL,
    teacher_teacherid      INTEGER NOT NULL,
    classroom_classroomid  INTEGER NOT NULL,
    subject_subjectid      INTEGER NOT NULL,
    UNIQUE (datetime, classroom_classroomid)
);

ALTER TABLE lesson ADD CONSTRAINT lesson_pk PRIMARY KEY ( lessonid );

CREATE TABLE lessongroup (
    lesson_lessonid  INTEGER NOT NULL,
    group_groupid    INTEGER NOT NULL
);

ALTER TABLE lessongroup ADD CONSTRAINT lessongroup_pk PRIMARY KEY ( lesson_lessonid,
                                                                    group_groupid );

CREATE TABLE subject (
    subjectid      INTEGER NOT NULL,
    name           VARCHAR2(80) NOT NULL UNIQUE,
    classroomtype  CHAR(1) NOT NULL
);

ALTER TABLE subject ADD CONSTRAINT subject_pk PRIMARY KEY ( subjectid );

CREATE TABLE subjectteacher (
    subject_subjectid  INTEGER NOT NULL,
    teacher_teacherid  INTEGER NOT NULL,
    hoursperweek       INTEGER NOT NULL
);

ALTER TABLE subjectteacher ADD CONSTRAINT subjectteacher_pk PRIMARY KEY ( subject_subjectid,
                                                                          teacher_teacherid );

CREATE TABLE teacher (
    teacherid   INTEGER NOT NULL,
    firstname   VARCHAR2(20) NOT NULL,
    lastname    VARCHAR2(20) NOT NULL,
    patronymic  VARCHAR2(20) NOT NULL
);

ALTER TABLE teacher ADD CONSTRAINT teacher_pk PRIMARY KEY ( teacherid );


ALTER TABLE lesson
    ADD CONSTRAINT lesson_classroom_fk FOREIGN KEY ( classroom_classroomid )
        REFERENCES classroom ( classroomid ) ON DELETE CASCADE;

ALTER TABLE lesson
    ADD CONSTRAINT lesson_subject_fk FOREIGN KEY ( subject_subjectid )
        REFERENCES subject ( subjectid ) ON DELETE CASCADE;

ALTER TABLE lesson
    ADD CONSTRAINT lesson_teacher_fk FOREIGN KEY ( teacher_teacherid )
        REFERENCES teacher ( teacherid ) ON DELETE CASCADE;

ALTER TABLE lessongroup
    ADD CONSTRAINT lessongroup_group_fk FOREIGN KEY ( group_groupid )
        REFERENCES studygroup ( groupid ) ON DELETE CASCADE;

ALTER TABLE lessongroup
    ADD CONSTRAINT lessongroup_lesson_fk FOREIGN KEY ( lesson_lessonid )
        REFERENCES lesson ( lessonid ) ON DELETE CASCADE;

ALTER TABLE subjectteacher
    ADD CONSTRAINT subjectteacher_subject_fk FOREIGN KEY ( subject_subjectid )
        REFERENCES subject ( subjectid ) ON DELETE CASCADE;

ALTER TABLE subjectteacher
    ADD CONSTRAINT subjectteacher_teacher_fk FOREIGN KEY ( teacher_teacherid )
        REFERENCES teacher ( teacherid ) ON DELETE CASCADE;
