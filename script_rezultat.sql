-- Generated by Oracle SQL Developer Data Modeler 22.2.0.165.1149
--   at:        2024-04-23 14:55:16 EEST
--   site:      Oracle Database 11g
--   type:      Oracle Database 11g



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE produse (
    id_p_cr                  NUMBER(2) NOT NULL,
    tip_produs_id_produs     NUMBER(2) NOT NULL,
    car_p                    VARCHAR2(20) NOT NULL,
    nume_producator_id_firma NUMBER(2) NOT NULL,
    stare_produs_id_stare    NUMBER(2) NOT NULL
)
LOGGING;

ALTER TABLE produse ADD CONSTRAINT produse_pk PRIMARY KEY ( id_p_cr );

CREATE TABLE magazie (
    produse_id_p_cr       NUMBER(2) NOT NULL,
    cantitate_disponibila NUMBER(4) NOT NULL,
    pret                  NUMBER(4) NOT NULL
)
LOGGING;

ALTER TABLE magazie ADD CONSTRAINT cant_disp_nr_pozitiv CHECK ( cantitate_disponibila > 0 );

ALTER TABLE magazie ADD CONSTRAINT pret_numar_pozitiv CHECK ( pret > 0 );

ALTER TABLE magazie ADD CONSTRAINT magazie_id_p_cr_un UNIQUE ( produse_id_p_cr );

CREATE TABLE tip_produs (
    id_produs       NUMBER(2) NOT NULL,
    nume_tip_produs VARCHAR2(20) NOT NULL
)
LOGGING;

ALTER TABLE tip_produs
    ADD CONSTRAINT nume_tip_produs_fara_cifre CHECK ( nume_tip_produs NOT LIKE '%0%'
                                                      AND nume_tip_produs NOT LIKE '%1%'
                                                      AND nume_tip_produs NOT LIKE '%2%'
                                                      AND nume_tip_produs NOT LIKE '%3%'
                                                      AND nume_tip_produs NOT LIKE '%4%'
                                                      AND nume_tip_produs NOT LIKE '%5%'
                                                      AND nume_tip_produs NOT LIKE '%6%'
                                                      AND nume_tip_produs NOT LIKE '%7%'
                                                      AND nume_tip_produs NOT LIKE '%8%'
                                                      AND nume_tip_produs NOT LIKE '%9%' );

ALTER TABLE tip_produs ADD CONSTRAINT tip_produs_pk PRIMARY KEY ( id_produs );

ALTER TABLE tip_produs ADD CONSTRAINT tip_produs_nume_tip_produs_un UNIQUE ( nume_tip_produs );

CREATE TABLE nume_producator (
    id_firma   NUMBER(2) NOT NULL,
    nume_firma VARCHAR2(20) NOT NULL
)
LOGGING;

ALTER TABLE nume_producator ADD CONSTRAINT nume_producator_pk PRIMARY KEY ( id_firma );

ALTER TABLE nume_producator ADD CONSTRAINT nume_producator_nume_firma_un UNIQUE ( nume_firma );

CREATE TABLE stare_produs (
    id_stare   NUMBER(2) NOT NULL,
    nume_stare VARCHAR2(20) NOT NULL
)
LOGGING;

ALTER TABLE stare_produs
    ADD CONSTRAINT nume_stare_nu_contine_cifre CHECK ( nume_stare NOT LIKE '%0%'
                                                       AND nume_stare NOT LIKE '%1%'
                                                       AND nume_stare NOT LIKE '%2%'
                                                       AND nume_stare NOT LIKE '%3%'
                                                       AND nume_stare NOT LIKE '%4%'
                                                       AND nume_stare NOT LIKE '%5%'
                                                       AND nume_stare NOT LIKE '%6%'
                                                       AND nume_stare NOT LIKE '%7%'
                                                       AND nume_stare NOT LIKE '%8%'
                                                       AND nume_stare NOT LIKE '%9%' );

ALTER TABLE stare_produs ADD CONSTRAINT stare_produs_pk PRIMARY KEY ( id_stare );

ALTER TABLE stare_produs ADD CONSTRAINT stare_produs_nume_stare_un UNIQUE ( nume_stare );

CREATE OR REPLACE PACKAGE magazie_pkg AS
    PROCEDURE insert_magazie(
        p_nume_tip_produs IN tip_produs.nume_tip_produs%TYPE,
        p_car_p IN produse.car_p%TYPE,
        p_nume_firma IN nume_producator.nume_firma%TYPE,
        p_nume_stare IN stare_produs.nume_stare%TYPE,
        p_cantitate_disponibila IN magazie.cantitate_disponibila%TYPE,
        p_pret                  IN magazie.pret%TYPE
    );

    PROCEDURE update_magazie(
        p_nume_tip_produs IN tip_produs.nume_tip_produs%TYPE,
        p_car_p IN produse.car_p%TYPE,
        p_nume_firma IN nume_producator.nume_firma%TYPE,
        p_nume_stare IN stare_produs.nume_stare%TYPE,
        p_cantitate_disponibila IN magazie.cantitate_disponibila%TYPE,
        p_pret                  IN magazie.pret%TYPE
    );

    PROCEDURE delete_magazie(
        p_nume_tip_produs IN tip_produs.nume_tip_produs%TYPE,
        p_car_p IN produse.car_p%TYPE,
        p_nume_firma IN nume_producator.nume_firma%TYPE,
        p_nume_stare IN stare_produs.nume_stare%TYPE
    );

    FUNCTION get_magazie(
        p_nume_tip_produs IN tip_produs.nume_tip_produs%TYPE,
        p_car_p IN produse.car_p%TYPE,
        p_nume_firma IN nume_producator.nume_firma%TYPE,
        p_nume_stare IN stare_produs.nume_stare%TYPE
    ) RETURN SYS_REFCURSOR;

    FUNCTION get_all_magazie RETURN SYS_REFCURSOR;
END magazie_pkg;
/

CREATE OR REPLACE PACKAGE BODY magazie_pkg AS
    PROCEDURE insert_magazie(
        p_nume_tip_produs IN tip_produs.nume_tip_produs%TYPE,
        p_car_p IN produse.car_p%TYPE,
        p_nume_firma IN nume_producator.nume_firma%TYPE,
        p_nume_stare IN stare_produs.nume_stare%TYPE,
        p_cantitate_disponibila IN magazie.cantitate_disponibila%TYPE,
        p_pret                  IN magazie.pret%TYPE
    ) IS
    p_tip_produs_id_produs produse.tip_produs_id_produs%TYPE;
    p_nume_producator_id_firma produse.nume_producator_id_firma%TYPE;
    p_stare_produs_id_stare produse.stare_produs_id_stare%TYPE;
    p_produse_id_p_cr magazie.produse_id_p_cr%TYPE;
    BEGIN
        SELECT id_produs INTO p_tip_produs_id_produs from tip_produs where nume_tip_produs like p_nume_tip_produs;
        SELECT id_firma INTO p_nume_producator_id_firma from nume_producator where nume_firma like p_nume_firma;
        SELECT id_stare INTO p_stare_produs_id_stare from stare_produs where nume_stare like p_nume_stare;
        SELECT id_p_cr INTO p_produse_id_p_cr FROM produse WHERE tip_produs_id_produs=p_tip_produs_id_produs and car_p=p_car_p and nume_producator_id_firma=p_nume_producator_id_firma and stare_produs_id_stare=p_stare_produs_id_stare;
        INSERT INTO magazie (produse_id_p_cr, cantitate_disponibila, pret)
        VALUES (p_produse_id_p_cr, p_cantitate_disponibila, p_pret);
        COMMIT;
    END insert_magazie;

    PROCEDURE update_magazie(
        p_nume_tip_produs IN tip_produs.nume_tip_produs%TYPE,
        p_car_p IN produse.car_p%TYPE,
        p_nume_firma IN nume_producator.nume_firma%TYPE,
        p_nume_stare IN stare_produs.nume_stare%TYPE,
        p_cantitate_disponibila IN magazie.cantitate_disponibila%TYPE,
        p_pret                  IN magazie.pret%TYPE
    ) IS
    p_produse_id_p_cr magazie.produse_id_p_cr%TYPE;
    p_tip_produs_id_produs produse.tip_produs_id_produs%TYPE;
    p_nume_producator_id_firma produse.nume_producator_id_firma%TYPE;
    p_stare_produs_id_stare produse.stare_produs_id_stare%TYPE;
    BEGIN
        SELECT id_produs INTO p_tip_produs_id_produs from tip_produs where nume_tip_produs like p_nume_tip_produs;
        SELECT id_firma INTO p_nume_producator_id_firma from nume_producator where nume_firma like p_nume_firma;
        SELECT id_stare INTO p_stare_produs_id_stare from stare_produs where nume_stare like p_nume_stare;
        SELECT id_p_cr INTO p_produse_id_p_cr FROM produse WHERE tip_produs_id_produs=p_tip_produs_id_produs and car_p=p_car_p and nume_producator_id_firma=p_nume_producator_id_firma and stare_produs_id_stare=p_stare_produs_id_stare;
        UPDATE magazie
        SET cantitate_disponibila = p_cantitate_disponibila,
            pret = p_pret
        WHERE produse_id_p_cr = p_produse_id_p_cr;
        COMMIT;
    END update_magazie;

    PROCEDURE delete_magazie(
        p_nume_tip_produs IN tip_produs.nume_tip_produs%TYPE,
        p_car_p IN produse.car_p%TYPE,
        p_nume_firma IN nume_producator.nume_firma%TYPE,
        p_nume_stare IN stare_produs.nume_stare%TYPE
    ) IS
    p_produse_id_p_cr magazie.produse_id_p_cr%TYPE;
    p_tip_produs_id_produs produse.tip_produs_id_produs%TYPE;
    p_nume_producator_id_firma produse.nume_producator_id_firma%TYPE;
    p_stare_produs_id_stare produse.stare_produs_id_stare%TYPE;
    BEGIN
        SELECT id_produs INTO p_tip_produs_id_produs from tip_produs where nume_tip_produs like p_nume_tip_produs;
        SELECT id_firma INTO p_nume_producator_id_firma from nume_producator where nume_firma like p_nume_firma;
        SELECT id_stare INTO p_stare_produs_id_stare from stare_produs where nume_stare like p_nume_stare;
        SELECT id_p_cr INTO p_produse_id_p_cr FROM produse WHERE tip_produs_id_produs=p_tip_produs_id_produs and car_p=p_car_p and nume_producator_id_firma=p_nume_producator_id_firma and stare_produs_id_stare=p_stare_produs_id_stare;
        DELETE FROM magazie
        WHERE produse_id_p_cr = p_produse_id_p_cr;
        COMMIT;
    END delete_magazie;

    FUNCTION get_magazie(
        p_nume_tip_produs IN tip_produs.nume_tip_produs%TYPE,
        p_car_p IN produse.car_p%TYPE,
        p_nume_firma IN nume_producator.nume_firma%TYPE,
        p_nume_stare IN stare_produs.nume_stare%TYPE
    ) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
        p_produse_id_p_cr magazie.produse_id_p_cr%TYPE;
        p_tip_produs_id_produs produse.tip_produs_id_produs%TYPE;
        p_nume_producator_id_firma produse.nume_producator_id_firma%TYPE;
        p_stare_produs_id_stare produse.stare_produs_id_stare%TYPE;
    BEGIN
        SELECT id_produs INTO p_tip_produs_id_produs from tip_produs where nume_tip_produs like p_nume_tip_produs;
        SELECT id_firma INTO p_nume_producator_id_firma from nume_producator where nume_firma like p_nume_firma;
        SELECT id_stare INTO p_stare_produs_id_stare from stare_produs where nume_stare like p_nume_stare;
        SELECT id_p_cr INTO p_produse_id_p_cr FROM produse WHERE tip_produs_id_produs=p_tip_produs_id_produs and car_p=p_car_p and nume_producator_id_firma=p_nume_producator_id_firma and stare_produs_id_stare=p_stare_produs_id_stare;
        OPEN v_cursor FOR
        SELECT *
        FROM magazie
        WHERE produse_id_p_cr = p_produse_id_p_cr;
        RETURN v_cursor;
    END get_magazie;

    FUNCTION get_all_magazie RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
        SELECT *
        FROM magazie;
        RETURN v_cursor;
    END get_all_magazie;
END magazie_pkg;
/

CREATE OR REPLACE PACKAGE nume_producator_pkg AS
    PROCEDURE inserare_producator(p_nume_firma IN nume_producator.nume_firma%TYPE);
    
    PROCEDURE actualizare_producator(p_nume_firma IN nume_producator.nume_firma%TYPE,p_nume_nou_firma IN nume_producator.nume_firma%TYPE);
    
    PROCEDURE stergere_producator(p_nume_firma IN nume_producator.nume_firma%TYPE);
    
    FUNCTION selectare_producator(p_nume_firma IN nume_producator.nume_firma%TYPE) RETURN nume_producator%ROWTYPE;
    
    FUNCTION selectare_toti_producatorii RETURN SYS_REFCURSOR;
END nume_producator_pkg;
/
CREATE OR REPLACE PACKAGE BODY nume_producator_pkg AS
    PROCEDURE inserare_producator(p_nume_firma IN nume_producator.nume_firma%TYPE) AS
    BEGIN
        INSERT INTO nume_producator (nume_firma) VALUES (p_nume_firma);
        COMMIT;
    END inserare_producator;
    
    PROCEDURE actualizare_producator(p_nume_firma IN nume_producator.nume_firma%TYPE,p_nume_nou_firma IN nume_producator.nume_firma%TYPE) AS
    BEGIN
        UPDATE nume_producator SET nume_firma = p_nume_nou_firma WHERE nume_firma = p_nume_firma;
        COMMIT;
    END actualizare_producator;
    
    PROCEDURE stergere_producator(p_nume_firma IN nume_producator.nume_firma%TYPE) AS
    BEGIN
        DELETE FROM nume_producator WHERE nume_firma = p_nume_firma;
        COMMIT;
    END stergere_producator;
    
    FUNCTION selectare_producator(p_nume_firma IN nume_producator.nume_firma%TYPE) RETURN nume_producator%ROWTYPE AS
        v_producator nume_producator%ROWTYPE;
    BEGIN
        SELECT * INTO v_producator FROM nume_producator WHERE nume_firma = p_nume_firma;
        RETURN v_producator;
    END selectare_producator;
    
    FUNCTION selectare_toti_producatorii RETURN SYS_REFCURSOR AS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR SELECT * FROM nume_producator;
        RETURN v_cursor;
    END selectare_toti_producatorii;
END nume_producator_pkg;
/

CREATE OR REPLACE PACKAGE produse_pkg AS
    PROCEDURE inserare_produs(
        p_nume_tip_produs IN tip_produs.nume_tip_produs%TYPE,
        p_car_p IN produse.car_p%TYPE,
        p_nume_firma IN nume_producator.nume_firma%TYPE,
        p_nume_stare IN stare_produs.nume_stare%TYPE
    );
    
    PROCEDURE actualizare_produs(
        p_nume_tip_produs IN tip_produs.nume_tip_produs%TYPE,
        p_car_p IN produse.car_p%TYPE,
        p_nume_firma IN nume_producator.nume_firma%TYPE,
        p_nume_stare IN stare_produs.nume_stare%TYPE,
        p_nume_nou_tip_produs IN tip_produs.nume_tip_produs%TYPE,
        p_car_nou_p IN produse.car_p%TYPE,
        p_nume_nou_firma IN nume_producator.nume_firma%TYPE,
        p_nume_nou_stare IN stare_produs.nume_stare%TYPE
    );
    
    PROCEDURE stergere_produs(
    p_nume_tip_produs IN tip_produs.nume_tip_produs%TYPE,
    p_car_p IN produse.car_p%TYPE,
    p_nume_firma IN nume_producator.nume_firma%TYPE,
    p_nume_stare IN stare_produs.nume_stare%TYPE
    );
    
    FUNCTION selectare_produs(
    p_nume_tip_produs IN tip_produs.nume_tip_produs%TYPE,
    p_car_p IN produse.car_p%TYPE,
    p_nume_firma IN nume_producator.nume_firma%TYPE,
    p_nume_stare IN stare_produs.nume_stare%TYPE
    ) RETURN produse%ROWTYPE;
    
    FUNCTION selectare_toate_produsele RETURN SYS_REFCURSOR;
END produse_pkg;
/
CREATE OR REPLACE PACKAGE BODY produse_pkg AS
    PROCEDURE inserare_produs(
      p_nume_tip_produs IN tip_produs.nume_tip_produs%TYPE,
      p_car_p IN produse.car_p%TYPE,
      p_nume_firma IN nume_producator.nume_firma%TYPE,
      p_nume_stare IN stare_produs.nume_stare%TYPE
    ) IS
    p_tip_produs_id_produs produse.tip_produs_id_produs%TYPE;
    p_nume_producator_id_firma produse.nume_producator_id_firma%TYPE;
    p_stare_produs_id_stare produse.stare_produs_id_stare%TYPE;
    BEGIN
        SELECT id_produs INTO p_tip_produs_id_produs from tip_produs where nume_tip_produs like p_nume_tip_produs;
        SELECT id_firma INTO p_nume_producator_id_firma from nume_producator where nume_firma like p_nume_firma;
        SELECT id_stare INTO p_stare_produs_id_stare from stare_produs where nume_stare like p_nume_stare;
        INSERT INTO produse (tip_produs_id_produs,car_p,nume_producator_id_firma,stare_produs_id_stare) 
        VALUES (p_tip_produs_id_produs, p_car_p, p_nume_producator_id_firma, p_stare_produs_id_stare);
        COMMIT;
    END inserare_produs;
    
    PROCEDURE actualizare_produs(--De verificat
        p_nume_tip_produs IN tip_produs.nume_tip_produs%TYPE,
        p_car_p IN produse.car_p%TYPE,
        p_nume_firma IN nume_producator.nume_firma%TYPE,
        p_nume_stare IN stare_produs.nume_stare%TYPE,
        p_nume_nou_tip_produs IN tip_produs.nume_tip_produs%TYPE,
        p_car_nou_p IN produse.car_p%TYPE,
        p_nume_nou_firma IN nume_producator.nume_firma%TYPE,
        p_nume_nou_stare IN stare_produs.nume_stare%TYPE
    ) IS
    p_id_p_cr produse.id_p_cr%TYPE;
    p_tip_produs_id_produs produse.tip_produs_id_produs%TYPE;
    p_nume_producator_id_firma produse.nume_producator_id_firma%TYPE;
    p_stare_produs_id_stare produse.stare_produs_id_stare%TYPE;
    p_id_nou_p_cr produse.id_p_cr%TYPE;
    p_tip_nou_produs_id_produs produse.tip_produs_id_produs%TYPE;
    p_nume_nou_producator_id_firma produse.nume_producator_id_firma%TYPE;
    p_stare_nou_produs_id_stare produse.stare_produs_id_stare%TYPE;
    BEGIN
        SELECT id_produs INTO p_tip_produs_id_produs from tip_produs where nume_tip_produs like p_nume_tip_produs;
        SELECT id_firma INTO p_nume_producator_id_firma from nume_producator where nume_firma like p_nume_firma;
        SELECT id_stare INTO p_stare_produs_id_stare from stare_produs where nume_stare like p_nume_stare;
        SELECT id_produs INTO p_tip_nou_produs_id_produs from tip_produs where nume_tip_produs like p_nume_nou_tip_produs;
        SELECT id_firma INTO p_nume_nou_producator_id_firma from nume_producator where nume_firma like p_nume_nou_firma;
        SELECT id_stare INTO p_stare_nou_produs_id_stare from stare_produs where nume_stare like p_nume_nou_stare;
        UPDATE produse 
        SET tip_produs_id_produs = p_tip_produs_id_produs,
            car_p = p_car_p,
            nume_producator_id_firma = p_nume_producator_id_firma,
            stare_produs_id_stare = p_stare_produs_id_stare
        WHERE tip_produs_id_produs=p_tip_produs_id_produs and car_p=p_car_p and nume_producator_id_firma=p_nume_producator_id_firma and stare_produs_id_stare=p_stare_produs_id_stare;
        COMMIT;
    END actualizare_produs;
    
    PROCEDURE stergere_produs(
    p_nume_tip_produs IN tip_produs.nume_tip_produs%TYPE,
    p_car_p IN produse.car_p%TYPE,
    p_nume_firma IN nume_producator.nume_firma%TYPE,
    p_nume_stare IN stare_produs.nume_stare%TYPE
    ) IS
    p_id_p_cr produse.id_p_cr%TYPE;
    p_tip_produs_id_produs produse.tip_produs_id_produs%TYPE;
    p_nume_producator_id_firma produse.nume_producator_id_firma%TYPE;
    p_stare_produs_id_stare produse.stare_produs_id_stare%TYPE;
    BEGIN
        SELECT id_produs INTO p_tip_produs_id_produs from tip_produs where nume_tip_produs like p_nume_tip_produs;
        SELECT id_firma INTO p_nume_producator_id_firma from nume_producator where nume_firma like p_nume_firma;
        SELECT id_stare INTO p_stare_produs_id_stare from stare_produs where nume_stare like p_nume_stare;
        DELETE FROM produse WHERE tip_produs_id_produs=p_tip_produs_id_produs and car_p=p_car_p and nume_producator_id_firma=p_nume_producator_id_firma and stare_produs_id_stare=p_stare_produs_id_stare;
        COMMIT;
    END stergere_produs;
    
    FUNCTION selectare_produs(p_nume_tip_produs IN tip_produs.nume_tip_produs%TYPE,
      p_car_p IN produse.car_p%TYPE,
      p_nume_firma IN nume_producator.nume_firma%TYPE,
      p_nume_stare IN stare_produs.nume_stare%TYPE) RETURN produse%ROWTYPE IS
      v_produs produse%ROWTYPE;
      p_id_p_cr produse.id_p_cr%TYPE;
      p_tip_produs_id_produs produse.tip_produs_id_produs%TYPE;
      p_nume_producator_id_firma produse.nume_producator_id_firma%TYPE;
      p_stare_produs_id_stare produse.stare_produs_id_stare%TYPE;
    BEGIN
        SELECT id_produs INTO p_tip_produs_id_produs from tip_produs where nume_tip_produs like p_nume_tip_produs;
        SELECT id_firma INTO p_nume_producator_id_firma from nume_producator where nume_firma like p_nume_firma;
        SELECT id_stare INTO p_stare_produs_id_stare from stare_produs where nume_stare like p_nume_stare;
        SELECT * INTO v_produs FROM produse WHERE WHERE tip_produs_id_produs=p_tip_produs_id_produs and car_p=p_car_p and nume_producator_id_firma=p_nume_producator_id_firma and stare_produs_id_stare=p_stare_produs_id_stare;
        RETURN v_produs;
    END selectare_produs;
    
    FUNCTION selectare_toate_produsele RETURN SYS_REFCURSOR AS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR SELECT * FROM produse;
        RETURN v_cursor;
    END selectare_toate_produsele;
END produse_pkg;
/

CREATE OR REPLACE PACKAGE stare_produs_pkg AS
    
    PROCEDURE inserare_stare(p_nume_stare IN stare_produs.nume_stare%TYPE);
    
    PROCEDURE actualizare_stare(p_nume_stare IN stare_produs.nume_stare%TYPE,p_nume_nou_stare IN stare_produs.nume_stare%TYPE);
    
    PROCEDURE stergere_stare(p_nume_stare IN stare_produs.nume_stare%TYPE);
    
    FUNCTION selectare_stare(p_nume_stare IN stare_produs.nume_stare%TYPE) RETURN stare_produs%ROWTYPE;
    
    FUNCTION selectare_toate_starile RETURN SYS_REFCURSOR;
END stare_produs_pkg;
/
CREATE OR REPLACE PACKAGE BODY stare_produs_pkg AS
    PROCEDURE inserare_stare(p_nume_stare IN stare_produs.nume_stare%TYPE) AS
    BEGIN
        INSERT INTO stare_produs (nume_stare) VALUES (p_nume_stare);
        COMMIT;
    END inserare_stare;
    
    PROCEDURE actualizare_stare(p_nume_stare IN stare_produs.nume_stare%TYPE, p_nume_nou_stare IN stare_produs.nume_stare%TYPE) AS
    BEGIN
        UPDATE stare_produs SET nume_stare = p_nume_nou_stare WHERE nume_stare = p_nume_stare;
        COMMIT;
    END actualizare_stare;
    
    PROCEDURE stergere_stare(p_nume_stare IN stare_produs.nume_stare%TYPE) AS
    BEGIN
        DELETE FROM stare_produs WHERE nume_stare = p_nume_stare;
        COMMIT;
    END stergere_stare;
    
    FUNCTION selectare_stare(p_nume_stare IN stare_produs.nume_stare%TYPE) RETURN stare_produs%ROWTYPE AS
        v_stare stare_produs%ROWTYPE;
    BEGIN
        SELECT * INTO v_stare FROM stare_produs WHERE nume_stare = p_nume_stare;
        RETURN v_stare;
    END selectare_stare;
    
    FUNCTION selectare_toate_starile RETURN SYS_REFCURSOR AS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR SELECT * FROM stare_produs;
        RETURN v_cursor;
    END selectare_toate_starile;
END stare_produs_pkg;
/

CREATE OR REPLACE PACKAGE tip_produs_pkg AS
    PROCEDURE inserare_tip_produs(p_nume_tip_produs IN tip_produs.nume_tip_produs%TYPE);
    
    PROCEDURE actualizare_tip_produs(p_nume_tip_produs IN tip_produs.nume_tip_produs%TYPE, p_nume_nou_tip_produs IN tip_produs.nume_tip_produs%TYPE);
    
    PROCEDURE stergere_tip_produs(p_nume_tip_produs IN tip_produs.nume_tip_produs%TYPE);
    
    FUNCTION selectare_tip_produs(p_nume_tip_produs IN tip_produs.nume_tip_produs%TYPE) RETURN tip_produs%ROWTYPE;
    
    FUNCTION selectare_toate_tipurile RETURN SYS_REFCURSOR;
END tip_produs_pkg;
/
CREATE OR REPLACE PACKAGE BODY tip_produs_pkg AS
    PROCEDURE inserare_tip_produs(p_nume_tip_produs IN tip_produs.nume_tip_produs%TYPE) AS
    BEGIN
        INSERT INTO tip_produs (nume_tip_produs) VALUES (p_nume_tip_produs);
        COMMIT;
    END inserare_tip_produs;
    
    PROCEDURE actualizare_tip_produs(p_nume_tip_produs IN tip_produs.nume_tip_produs%TYPE,p_nume_nou_tip_produs IN tip_produs.nume_tip_produs%TYPE) AS
    BEGIN
        UPDATE tip_produs SET nume_tip_produs = p_nume_nou_tip_produs WHERE nume_tip_produs = p_nume_tip_produs;
        COMMIT;
    END actualizare_tip_produs;
    
    PROCEDURE stergere_tip_produs(p_nume_tip_produs IN tip_produs.nume_tip_produs%TYPE) AS
    BEGIN
        DELETE FROM tip_produs WHERE nume_tip_produs = p_nume_tip_produs;
        COMMIT;
    END stergere_tip_produs;
    
    FUNCTION selectare_tip_produs(p_nume_tip_produs IN tip_produs.nume_tip_produs%TYPE) RETURN tip_produs%ROWTYPE AS
        v_tip_produs tip_produs%ROWTYPE;
    BEGIN
        SELECT * INTO v_tip_produs FROM tip_produs WHERE nume_tip_produs = p_nume_tip_produs;
        RETURN v_tip_produs;
    END selectare_tip_produs;
    
    FUNCTION selectare_toate_tipurile RETURN SYS_REFCURSOR AS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR SELECT * FROM tip_produs;
        RETURN v_cursor;
    END selectare_toate_tipurile;
END tip_produs_pkg;
/

CREATE TABLE vanzari (
    produse_id_p_cr  NUMBER(2) NOT NULL,
    cantitate_dorita NUMBER(4) NOT NULL,
    data             DATE NOT NULL
)
LOGGING;

ALTER TABLE vanzari ADD CONSTRAINT cantitate_dorita_pozitiv CHECK ( cantitate_dorita > 0 );

CREATE OR REPLACE PACKAGE vanzari_pkg AS
    PROCEDURE inserare_vanzare(
        p_nume_tip_produs IN tip_produs.nume_tip_produs%TYPE,
        p_car_p IN produse.car_p%TYPE,
        p_nume_firma IN nume_producator.nume_firma%TYPE,
        p_nume_stare IN stare_produs.nume_stare%TYPE, 
        p_cantitate_dorita IN vanzari.cantitate_dorita%TYPE,
        p_data IN vanzari.data%TYPE
    );
    
    PROCEDURE actualizare_vanzare(
        p_nume_tip_produs IN tip_produs.nume_tip_produs%TYPE,
        p_car_p IN produse.car_p%TYPE,
        p_nume_firma IN nume_producator.nume_firma%TYPE,
        p_nume_stare IN stare_produs.nume_stare%TYPE, 
        p_cantitate_dorita IN vanzari.cantitate_dorita%TYPE,
        p_data IN vanzari.data%TYPE,
        p_cantitate_dorita_noua IN vanzari.cantitate_dorita%TYPE,
        p_data_noua IN vanzari.data%TYPE
    );
    
    PROCEDURE stergere_vanzare(p_nume_tip_produs IN tip_produs.nume_tip_produs%TYPE,
        p_car_p IN produse.car_p%TYPE,
        p_nume_firma IN nume_producator.nume_firma%TYPE,
        p_nume_stare IN stare_produs.nume_stare%TYPE,
        p_cantitate_dorita IN vanzari.cantitate_dorita%TYPE,
        p_data IN vanzari.data%TYPE
        );
    
    FUNCTION selectare_vanzare(p_nume_tip_produs IN tip_produs.nume_tip_produs%TYPE,
        p_car_p IN produse.car_p%TYPE,
        p_nume_firma IN nume_producator.nume_firma%TYPE,
        p_nume_stare IN stare_produs.nume_stare%TYPE,
        p_cantitate_dorita IN vanzari.cantitate_dorita%TYPE,
        p_data IN vanzari.data%TYPE) RETURN vanzari%ROWTYPE;
    
    FUNCTION selectare_toate_vanzarile RETURN SYS_REFCURSOR;
END vanzari_pkg;
/
CREATE OR REPLACE PACKAGE BODY vanzari_pkg AS
    PROCEDURE inserare_vanzare(
        p_nume_tip_produs IN tip_produs.nume_tip_produs%TYPE,
        p_car_p IN produse.car_p%TYPE,
        p_nume_firma IN nume_producator.nume_firma%TYPE,
        p_nume_stare IN stare_produs.nume_stare%TYPE,  
        p_cantitate_dorita IN vanzari.cantitate_dorita%TYPE,
        p_data IN vanzari.data%TYPE
    ) IS
    p_tip_produs_id_produs produse.tip_produs_id_produs%TYPE;
    p_nume_producator_id_firma produse.nume_producator_id_firma%TYPE;
    p_stare_produs_id_stare produse.stare_produs_id_stare%TYPE;
    p_produse_id_p_cr magazie.produse_id_p_cr%TYPE;
    BEGIN
        SELECT id_produs INTO p_tip_produs_id_produs from tip_produs where nume_tip_produs like p_nume_tip_produs;
        SELECT id_firma INTO p_nume_producator_id_firma from nume_producator where nume_firma like p_nume_firma;
        SELECT id_stare INTO p_stare_produs_id_stare from stare_produs where nume_stare like p_nume_stare;
        SELECT id_p_cr INTO p_produse_id_p_cr FROM produse WHERE tip_produs_id_produs=p_tip_produs_id_produs and car_p=p_car_p and nume_producator_id_firma=p_nume_producator_id_firma and stare_produs_id_stare=p_stare_produs_id_stare;
        INSERT INTO vanzari (produse_id_p_cr, cantitate_dorita, data) 
        VALUES (p_produse_id_p_cr, p_cantitate_dorita, p_data);
        COMMIT;
    END inserare_vanzare;
    
    PROCEDURE actualizare_vanzare(
        p_nume_tip_produs IN tip_produs.nume_tip_produs%TYPE,
        p_car_p IN produse.car_p%TYPE,
        p_nume_firma IN nume_producator.nume_firma%TYPE,
        p_nume_stare IN stare_produs.nume_stare%TYPE,  
        p_cantitate_dorita IN vanzari.cantitate_dorita%TYPE,
        p_data IN vanzari.data%TYPE,
        p_cantitate_dorita_noua IN vanzari.cantitate_dorita%TYPE,
        p_data_noua IN vanzari.data%TYPE
    ) IS
    p_tip_produs_id_produs produse.tip_produs_id_produs%TYPE;
    p_nume_producator_id_firma produse.nume_producator_id_firma%TYPE;
    p_stare_produs_id_stare produse.stare_produs_id_stare%TYPE;
    p_produse_id_p_cr magazie.produse_id_p_cr%TYPE;
    BEGIN
        SELECT id_produs INTO p_tip_produs_id_produs from tip_produs where nume_tip_produs like p_nume_tip_produs;
        SELECT id_firma INTO p_nume_producator_id_firma from nume_producator where nume_firma like p_nume_firma;
        SELECT id_stare INTO p_stare_produs_id_stare from stare_produs where nume_stare like p_nume_stare;
        SELECT id_p_cr INTO p_produse_id_p_cr FROM produse WHERE tip_produs_id_produs=p_tip_produs_id_produs and car_p=p_car_p and nume_producator_id_firma=p_nume_producator_id_firma and stare_produs_id_stare=p_stare_produs_id_stare;
        UPDATE vanzari 
        SET cantitate_dorita = p_cantitate_dorita_noua,
            data = p_data_noua
        WHERE produse_id_p_cr = p_produse_id_p_cr and cantitate_dorita=p_cantitate_dorita and data=p_data;
        COMMIT;
    END actualizare_vanzare;
    
    PROCEDURE stergere_vanzare(p_nume_tip_produs IN tip_produs.nume_tip_produs%TYPE,
        p_car_p IN produse.car_p%TYPE,
        p_nume_firma IN nume_producator.nume_firma%TYPE,
        p_nume_stare IN stare_produs.nume_stare%TYPE,
        p_cantitate_dorita IN vanzari.cantitate_dorita%TYPE,
        p_data IN vanzari.data%TYPE
        ) IS
        p_tip_produs_id_produs produse.tip_produs_id_produs%TYPE;
        p_nume_producator_id_firma produse.nume_producator_id_firma%TYPE;
        p_stare_produs_id_stare produse.stare_produs_id_stare%TYPE;
        p_produse_id_p_cr magazie.produse_id_p_cr%TYPE;
    BEGIN
        SELECT id_produs INTO p_tip_produs_id_produs from tip_produs where nume_tip_produs like p_nume_tip_produs;
        SELECT id_firma INTO p_nume_producator_id_firma from nume_producator where nume_firma like p_nume_firma;
        SELECT id_stare INTO p_stare_produs_id_stare from stare_produs where nume_stare like p_nume_stare;
        SELECT id_p_cr INTO p_produse_id_p_cr FROM produse WHERE tip_produs_id_produs=p_tip_produs_id_produs and car_p=p_car_p and nume_producator_id_firma=p_nume_producator_id_firma and stare_produs_id_stare=p_stare_produs_id_stare;
        DELETE FROM vanzari WHERE produse_id_p_cr = p_produse_id_p_cr and cantitate_dorita=p_cantitate_dorita and data=p_data;
        COMMIT;
    END stergere_vanzare;
    
    FUNCTION selectare_vanzare(p_nume_tip_produs IN tip_produs.nume_tip_produs%TYPE,
        p_car_p IN produse.car_p%TYPE,
        p_nume_firma IN nume_producator.nume_firma%TYPE,
        p_nume_stare IN stare_produs.nume_stare%TYPE,
        p_cantitate_dorita IN vanzari.cantitate_dorita%TYPE,
        p_data IN vanzari.data%TYPE) RETURN vanzari%ROWTYPE AS
        p_tip_produs_id_produs produse.tip_produs_id_produs%TYPE;
        p_nume_producator_id_firma produse.nume_producator_id_firma%TYPE;
        p_stare_produs_id_stare produse.stare_produs_id_stare%TYPE;
        p_produse_id_p_cr magazie.produse_id_p_cr%TYPE;
        v_vanzare vanzari%ROWTYPE;
    BEGIN
        SELECT id_produs INTO p_tip_produs_id_produs from tip_produs where nume_tip_produs like p_nume_tip_produs;
        SELECT id_firma INTO p_nume_producator_id_firma from nume_producator where nume_firma like p_nume_firma;
        SELECT id_stare INTO p_stare_produs_id_stare from stare_produs where nume_stare like p_nume_stare;
        SELECT id_p_cr INTO p_produse_id_p_cr FROM produse WHERE tip_produs_id_produs=p_tip_produs_id_produs and car_p=p_car_p and nume_producator_id_firma=p_nume_producator_id_firma and stare_produs_id_stare=p_stare_produs_id_stare;
        SELECT * INTO v_vanzare FROM vanzari WHERE produse_id_p_cr = p_produse_id_p_cr and cantitate_dorita=p_cantitate_dorita and data=p_data;
        RETURN v_vanzare;
    END selectare_vanzare;
    
    FUNCTION selectare_toate_vanzarile RETURN SYS_REFCURSOR AS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR SELECT * FROM vanzari;
        RETURN v_cursor;
    END selectare_toate_vanzarile;
END vanzari_pkg;
/

ALTER TABLE magazie
    ADD CONSTRAINT magazie_produse_fk FOREIGN KEY ( produse_id_p_cr )
        REFERENCES produse ( id_p_cr )
    NOT DEFERRABLE;

ALTER TABLE produse
    ADD CONSTRAINT produse_nume_producator_fk FOREIGN KEY ( nume_producator_id_firma )
        REFERENCES nume_producator ( id_firma )
    NOT DEFERRABLE;

ALTER TABLE produse
    ADD CONSTRAINT produse_stare_produs_fk FOREIGN KEY ( stare_produs_id_stare )
        REFERENCES stare_produs ( id_stare )
    NOT DEFERRABLE;

ALTER TABLE produse
    ADD CONSTRAINT produse_tip_produs_fk FOREIGN KEY ( tip_produs_id_produs )
        REFERENCES tip_produs ( id_produs )
    NOT DEFERRABLE;

ALTER TABLE vanzari
    ADD CONSTRAINT vanzari_produse_fk FOREIGN KEY ( produse_id_p_cr )
        REFERENCES produse ( id_p_cr )
    NOT DEFERRABLE;

CREATE OR REPLACE TRIGGER trg_produse_duplicate_insert 
    BEFORE INSERT ON produse 
    FOR EACH ROW 
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM produse
    WHERE tip_produs_id_produs = :NEW.tip_produs_id_produs
    AND car_p = :NEW.car_p
    AND nume_producator_id_firma = :NEW.nume_producator_id_firma
    AND stare_produs_id_stare = :NEW.stare_produs_id_stare;
    
    IF v_count > 0 THEN
        raise_application_error(-20001, 'Produs duplicat.');
    END IF;
END; 
/

CREATE OR REPLACE TRIGGER trg_produse_duplicate_update 
    BEFORE UPDATE ON produse 
    FOR EACH ROW 
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM produse
    WHERE tip_produs_id_produs = :NEW.tip_produs_id_produs
    AND car_p = :NEW.car_p
    AND nume_producator_id_firma = :NEW.nume_producator_id_firma
    AND stare_produs_id_stare = :NEW.stare_produs_id_stare
    AND id_p_cr != :NEW.id_p_cr; 
    
    IF v_count > 0 THEN
        raise_application_error(-20001, 'Produs duplicat.');
    END IF;
END; 
/

CREATE OR REPLACE TRIGGER trg_tranzactie 
    BEFORE INSERT OR UPDATE ON Vanzari 
    FOR EACH ROW 
DECLARE
    v_stoc_magazie NUMBER;
BEGIN
    SELECT cantitate_disponibila
    INTO v_stoc_magazie
    FROM magazie
    WHERE produse_id_p_cr = :NEW.produse_id_p_cr;

    IF v_stoc_magazie < :NEW.cantitate_dorita THEN
        raise_application_error(-20001, 'Stoc insuficient produs.');
    ELSE
        UPDATE magazie
        SET cantitate_disponibila = v_stoc_magazie - :NEW.cantitate_dorita
        WHERE produse_id_p_cr = :NEW.produse_id_p_cr;
    END IF;
END ;
/

CREATE OR REPLACE TRIGGER trg_unic_vanzare_insert 
    BEFORE INSERT ON Vanzari 
    FOR EACH ROW 
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM vanzari
    WHERE produse_id_p_cr = :NEW.produse_id_p_cr
    AND data = :NEW.data
    AND cantitate_dorita = :NEW.cantitate_dorita;

    IF v_count > 0 THEN
        raise_application_error(-20001, 'Vanzare duplicata.');
    END IF;
END; 
/

CREATE OR REPLACE TRIGGER trg_unic_vanzare_update 
    BEFORE UPDATE ON Vanzari 
    FOR EACH ROW 
DECLARE
    v_count NUMBER;
BEGIN
    
    SELECT COUNT(*)
    INTO v_count
    FROM vanzari
    WHERE produse_id_p_cr = :NEW.produse_id_p_cr
    AND data = :NEW.data
    AND cantitate_dorita = :NEW.cantitate_dorita
    AND ROWNUM <= 1; 
    
    IF v_count > 0 THEN
        raise_application_error(-20001, 'Vanzare duplicata.');
    END IF;
END; 
/

CREATE SEQUENCE nume_producator_id_firma_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER nume_producator_id_firma_trg BEFORE
    INSERT ON nume_producator
    FOR EACH ROW
    WHEN ( new.id_firma IS NULL )
BEGIN
    :new.id_firma := nume_producator_id_firma_seq.nextval;
END;
/

CREATE SEQUENCE produse_id_p_cr_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER produse_id_p_cr_trg BEFORE
    INSERT ON produse
    FOR EACH ROW
    WHEN ( new.id_p_cr IS NULL )
BEGIN
    :new.id_p_cr := produse_id_p_cr_seq.nextval;
END;
/

CREATE SEQUENCE stare_produs_id_stare_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER stare_produs_id_stare_trg BEFORE
    INSERT ON stare_produs
    FOR EACH ROW
    WHEN ( new.id_stare IS NULL )
BEGIN
    :new.id_stare := stare_produs_id_stare_seq.nextval;
END;
/

CREATE SEQUENCE tip_produs_id_produs_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER tip_produs_id_produs_trg BEFORE
    INSERT ON tip_produs
    FOR EACH ROW
    WHEN ( new.id_produs IS NULL )
BEGIN
    :new.id_produs := tip_produs_id_produs_seq.nextval;
END;
/



-- Oracle SQL Developer Data Modeler Summary Report: 
-- 
-- CREATE TABLE                             6
-- CREATE INDEX                             0
-- ALTER TABLE                             18
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           6
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           9
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          4
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0

