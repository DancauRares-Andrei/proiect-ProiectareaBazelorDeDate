CREATE OR REPLACE PROCEDURE tranzactie(
    p_nume_tip_produs IN tip_produs.nume_tip_produs%TYPE,
    p_nume_firma IN nume_producator.nume_firma%TYPE,
    p_car_p IN produse.car_p%TYPE,
    p_cantitate_disponibila IN magazie.cantitate_disponibila%TYPE,
    p_pret IN magazie.pret%TYPE
) AS
p_tip_produs_id_produs produse.tip_produs_id_produs%TYPE;
p_nume_producator_id_firma produse.nume_producator_id_firma%TYPE;
p_stare_produs_id_stare produse.stare_produs_id_stare%TYPE;
p_produse_id_p_cr magazie.produse_id_p_cr%TYPE;
BEGIN
    BEGIN
        INSERT INTO tip_produs (nume_tip_produs) VALUES (p_nume_tip_produs);
        
        INSERT INTO nume_producator (nume_firma) VALUES (p_nume_firma);
        
        SELECT id_produs INTO p_tip_produs_id_produs from tip_produs where nume_tip_produs like p_nume_tip_produs;
        SELECT id_firma INTO p_nume_producator_id_firma from nume_producator where nume_firma like p_nume_firma;
        SELECT id_stare INTO p_stare_produs_id_stare from stare_produs where nume_stare like 'Nou';
        
        INSERT INTO produse (tip_produs_id_produs,car_p,nume_producator_id_firma,stare_produs_id_stare)
        VALUES (p_tip_produs_id_produs, p_car_p, p_nume_producator_id_firma, p_stare_produs_id_stare);

        SELECT id_p_cr INTO p_produse_id_p_cr FROM produse WHERE tip_produs_id_produs=p_tip_produs_id_produs and car_p=p_car_p and nume_producator_id_firma=p_nume_producator_id_firma and stare_produs_id_stare=p_stare_produs_id_stare;
        INSERT INTO magazie (produse_id_p_cr, cantitate_disponibila, pret)
        VALUES (p_produse_id_p_cr, p_cantitate_disponibila, p_pret);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            raise_application_error(-20001, 'A aparut o eroare. Tranzactia a fost anulata. '||SQLERRM);
    END;
END;
/
--Executare tranzactie normala
EXECUTE tranzactie('GPU','AMD','Placa video',300,1000);
--Executare inca o data va da exceptie de la tip de produs duplicat, deci nu se va continua
EXECUTE tranzactie('GPU','AMD','Placa video',300,1000);
--Daca se schimba tipul de produs, se va trece de inserarea in tip_produs, dar va da fail la nume_producator
EXECUTE tranzactie('GPUA','AMD','Placa video',300,1000);
--Daca se schimba primele doua, atunci se va putea insera cu succes un nou produs
EXECUTE tranzactie('GPUA','AMDA','Placa video',300,1000);
--Dar daca se incearca inserarea unor elemente deja existente, atunci nu se va face nicio modificare
EXECUTE tip_produs_pkg.actualizare_tip_produs('GPUA','GPUB');
EXECUTE nume_producator_pkg.actualizare_producator('AMDA','AMDB');
EXECUTE tranzactie('GPUB','AMDB','Placa video',300,1000);
--Pentru a executa tranzactia, trebuie eliminate elementele deja existente
EXECUTE magazie_pkg.delete_magazie('GPUB','Placa video','AMDB','Nou');
EXECUTE produse_pkg.stergere_produs('GPUB','Placa video','AMDB','Nou');
EXECUTE tip_produs_pkg.stergere_tip_produs('GPUB');
EXECUTE nume_producator_pkg.stergere_producator('AMDB');
EXECUTE tranzactie('GPUB','AMDB','Placa video',300,1000);


--SQL Injection
CREATE OR REPLACE PROCEDURE selectare_tip_produs_vulnerabil(p_nume_tip_produs VARCHAR2) AS
v_select VARCHAR2(256) := 'SELECT id_produs,nume_tip_produs FROM tip_produs WHERE nume_tip_produs = ''' || p_nume_tip_produs || '''';
v_nume_tip_produs tip_produs.nume_tip_produs%TYPE;
v_id_produs tip_produs.id_produs%TYPE;
emp_cursor SYS_REFCURSOR;
    BEGIN
        OPEN emp_cursor FOR v_select;
        FETCH emp_cursor INTO v_id_produs, v_nume_tip_produs;
        CLOSE emp_cursor;
        dbms_output.put_line(v_id_produs||' '||v_nume_tip_produs);
END selectare_tip_produs_vulnerabil;
/
SET SERVEROUTPUT ON SIZE UNLIMITED
--Caz obisnuit
EXECUTE selectare_tip_produs_vulnerabil('Condensator');
--Cu aceasta comanda afisez prima inregistrare din tabela stare, desi nu as fi avut acces la tabela stare din interiorul procedurii
EXECUTE selectare_tip_produs_vulnerabil(q'[' UNION SELECT id_stare as id_produs,nume_stare AS nume_tip_produs FROM stare_produs OFFSET 0 ROWS FETCH FIRST 1 ROWS ONLY --]'); 

--Securizare folosind Bind variables
CREATE OR REPLACE PROCEDURE selectare_tip_produs_securizat(p_nume_tip_produs VARCHAR2) AS
v_select VARCHAR2(256) := 'SELECT id_produs,nume_tip_produs FROM tip_produs WHERE nume_tip_produs = :p_nume_tip_produs';
v_nume_tip_produs tip_produs.nume_tip_produs%TYPE;
v_id_produs tip_produs.id_produs%TYPE;
emp_cursor SYS_REFCURSOR;
    BEGIN
        OPEN emp_cursor FOR v_select using p_nume_tip_produs;
        FETCH emp_cursor INTO v_id_produs, v_nume_tip_produs;
        CLOSE emp_cursor;
        dbms_output.put_line(v_id_produs||' '||v_nume_tip_produs);
END selectare_tip_produs_securizat;
--Caz obisnuit
EXECUTE selectare_tip_produs_securizat('Condensator');
--Testare caz anterior vulnerabil
EXECUTE selectare_tip_produs_securizat(q'[' UNION SELECT id_stare as id_produs,nume_stare AS nume_tip_produs FROM stare_produs OFFSET 0 ROWS FETCH FIRST 1 ROWS ONLY --]');
