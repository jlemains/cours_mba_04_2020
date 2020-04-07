-------------------
---CLIENT----------
-------------------
-- Combien de clients sont VIP ? 
select count(distinct idclient) from client where vip = 1;

-- En moyenne, quelle est la durée d'adhésion des clients VIP ? 
select avg(datefinadhesion - datedebutadhesion) as avg_duration from client where vip = 1;
select AVG (DATE_PART('day',datefinadhesion-datedebutadhesion)) AS duree_de_adhesion_moyenne from client where vip = 1;

-- Selectionnez toutes les différentes civilité de la table client
select distinct(civilite) from client;

-- Vous remarquez que plusieurs label designe la meme civilite, créez une nouvelle variable correctement codée (un label = une civilité unique)
ALTER TABLE client ADD civilite_new varchar(10);
UPDATE client set civilite_new = (case 
					when civilite in ('Mr','monsieur','MONSIEUR') then 'Monsieur'
					when civilite in ('Mme','madame','MADAME') then 'Madame'
					else null
	end);
select distinct(civilite_new) from client;
alter table client drop column civilite;
alter table client RENAME COLUMN civilite_new TO civilite;
select * from client;

-- Créez une nouvelle colonne qui définit l'age du client
ALTER TABLE client ADD AGE integer;
update client set age = DATE_PART('year',current_date) - DATE_PART('year', datenaissance);

-- Créez une nouvelle colonne qui définit la durée d'adhésion du client, et une colonne qui permet de savoir si il est CHURNER

-- Combien de clients sont rattaché à chaque département de magasin (i.e. combien de clients dans le 74, 73, etc.)


-------------------
---TICKET---------- 
-------------------
-- Attention : tables volumineuses, pensez a échantilloner quand vous travaillez sur la requête

-- Combien de tickets ont été produits par mois en 2017 ?

-- Quels sont les 10 magasins (précisez aussi la ville) où le plus de tickets ont été produits en été 2017 (juin juillet aout)

-- En moyenne, combien de lignes a un ticket ? 

-- Quels sont les 10 articles que l'on achete en + grande quantité en moyenne ? 

-- Combien d'articles appartiennent à chaque univers ? 

-- Quels sont les 5 clients a avoir acheter le plus (en montant) en 2016 ? 

-- Quels sont les 5 clients a avoir acheter le plus (en quantite d'articles) en 2016 ?
