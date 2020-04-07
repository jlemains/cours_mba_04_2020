-------------------
---CLIENT----------
-------------------

drop table IF EXISTS client;
create table client 
(
	IDCLIENT_BRUT real primary key, 
	CIVILITE varchar(10),
	DATENAISSANCE timestamp,
	MAGASIN varchar(15),
	DATEDEBUTADHESION timestamp,
	DATEREADHESION timestamp,
	DATEFINADHESION timestamp,
	VIP integer,
	CODEINSEE varchar(10),
	PAYS varchar(10)
);

COPY client FROM 'C:\Users\Public\DATA_Projet_R\CLIENT.CSV' CSV HEADER delimiter '|' null '';

---TRANSFORMATION IDCLIENT_BRUT
ALTER TABLE client ADD IDCLIENT bigint;
UPDATE client SET IDCLIENT =  CAST(IDCLIENT_BRUT AS bigint);
ALTER TABLE client DROP IDCLIENT_BRUT;
ALTER TABLE client ADD PRIMARY KEY (IDCLIENT);

SELECT * FROM client;

--------------------------
---ENTETE_TICKET----------
--------------------------

drop table IF EXISTS entete_ticket;
create table entete_ticket 
(
	IDTICKET bigint primary key,
	TIC_DATE timestamp,
	MAG_CODE varchar(15),
	IDCLIENT_BRUT real,
	TIC_TOTALTTC_BRUT varchar(10) --money
	
);

COPY entete_ticket FROM 'C:\Users\Public\DATA_Projet_R\ENTETES_TICKET_V4.CSV' CSV HEADER delimiter '|' null '';

---TRANSFORMATION TIC_TOTALTTC_BRUT
ALTER TABLE entete_ticket ADD TIC_TOTALTTC float;
UPDATE entete_ticket SET TIC_TOTALTTC =  CAST(REPLACE(TIC_TOTALTTC_BRUT , ',', '.') AS float);
ALTER TABLE entete_ticket DROP TIC_TOTALTTC_BRUT;

---TRANSFORMATION IDCLIENT_BRUT
ALTER TABLE entete_ticket ADD IDCLIENT bigint;
UPDATE entete_ticket SET IDCLIENT =  CAST(IDCLIENT_BRUT AS bigint);
ALTER TABLE entete_ticket DROP IDCLIENT_BRUT;

SELECT * from entete_ticket;

-------------------
---LIGNE_TICKET----
-------------------

drop table IF EXISTS lignes_ticket;
create table lignes_ticket 
(
	IDTICKET bigint,
	NUMLIGNETICKET integer,
	IDARTICLE varchar(15), --ligne avec 'COUPON'
	QUANTITE_BRUT varchar(15),
	MONTANTREMISE_BRUT varchar(15),
	TOTAL_BRUT varchar(15),
	MARGESORTIE_BRUT varchar(15)
);


COPY lignes_ticket FROM 'C:\Users\Public\DATA_Projet_R\LIGNES_TICKET_V4.CSV' CSV HEADER delimiter '|' null '';

---TRANSFORMATION QUANTITE_BRUT
ALTER TABLE lignes_ticket ADD QUANTITE float;
UPDATE lignes_ticket SET QUANTITE =  CAST(REPLACE(QUANTITE_BRUT , ',', '.') AS float);
ALTER TABLE lignes_ticket DROP QUANTITE_BRUT;

---TRANSFORMATION MONTANTREMISE_BRUT
ALTER TABLE lignes_ticket ADD MONTANTREMISE float;
UPDATE lignes_ticket SET MONTANTREMISE =  CAST(REPLACE(MONTANTREMISE_BRUT , ',', '.') AS float);
ALTER TABLE lignes_ticket DROP MONTANTREMISE_BRUT;

---TRANSFORMATION TOTAL_BRUT
ALTER TABLE lignes_ticket ADD TOTAL float;
UPDATE lignes_ticket SET TOTAL =  CAST(REPLACE(TOTAL_BRUT , ',', '.') AS float);
ALTER TABLE lignes_ticket DROP TOTAL_BRUT;

---TRANSFORMATION MARGESORTIE_BRUT
ALTER TABLE lignes_ticket ADD MARGESORTIE float;
UPDATE lignes_ticket SET MARGESORTIE =  CAST(REPLACE(MARGESORTIE_BRUT , ',', '.') AS float);
ALTER TABLE lignes_ticket DROP MARGESORTIE_BRUT;

select * from lignes_ticket order by idticket limit 10;

-------------------
---REF_MAGASIN-----
-------------------

drop table IF EXISTS ref_magasin;
create table ref_magasin 
(
	CODESOCIETE varchar(15) primary key,
	VILLE varchar(50),
	LIBELLEDEPARTEMENT integer,
	LIBELLEREGIONCOMMERCIALE varchar(15)
);

COPY ref_magasin FROM 'C:\Users\Public\DATA_Projet_R\REF_MAGASIN.CSV' CSV HEADER delimiter '|' null '';

SELECT * from ref_magasin;

-------------------
---REF_ARTICLE-----
-------------------

drop table IF EXISTS ref_article;
create table ref_article 
(
	CODEARTICLE varchar(15) primary key,
	CODEUNIVERS varchar(15),
	CODEFAMILLE varchar(15),
	CODESOUSFAMILLE varchar(15)
);

COPY ref_article FROM 'C:\Users\Public\DATA_Projet_R\REF_ARTICLE.CSV' CSV HEADER delimiter '|' null '';

SELECT * from ref_article;