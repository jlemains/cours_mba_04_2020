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
ALTER TABLE client ADD anciennete_annee integer;
UPDATE client set anciennete_annee = DATE_PART('year', datefinadhesion) - DATE_PART('year', datedebutadhesion);

ALTER TABLE client ADD churner integer;
UPDATE client set churner = DATE_PART('year', datefinadhesion) - DATE_PART('year', datedebutadhesion);

select idclient, datefinadhesion, (case when datefinadhesion> current_date then 0 else 1 end) as CHURNER from client;
select idclient, datefinadhesion, (datefinadhesion < current_date) as CHURNER from client;

Alter table client add churner boolean;
UPDATE client set churner = (datefinadhesion < current_date);

select churner, count(distinct idclient) from client group by churner;

-- Combien de clients sont rattaché à chaque département de magasin (i.e. combien de clients dans le 74, 73, etc.)
select libelledepartement, count (distinct idclient)from client 
inner join ref_magasin 
on client.magasin = ref_magasin.codesociete 
group by libelledepartement;

-------------------
---TICKET---------- 
-------------------
-- Attention : tables volumineuses, pensez a échantilloner quand vous travaillez sur la requête

-- Combien de tickets ont été produits par mois en 2017 ?
select to_char(tic_date,'Month'), count(distinct idticket) from entete_ticket 
where extract(year from tic_date) = 2017
group by to_char(tic_date,'Month');

-- Quels sont les 10 magasins (précisez aussi la ville) où le plus de tickets ont été produits en été 2017 (juin juillet aout)
select codesociete, ville, count(distinct idticket) as nb_ticket from entete_ticket 
join ref_magasin on entete_ticket.mag_code = ref_magasin.codesociete
where extract(year from tic_date) = 2017 and extract(month from tic_date) in (6,7,8)
group by codesociete, ville
order by nb_ticket desc
limit 10;

-- En moyenne, combien de lignes a un ticket ? 
select avg(nb_ligne) from (select idticket, count(*) as nb_ligne from lignes_ticket group by idticket) as toto;

-- Quels sont les 10 articles que l'on achete en + grande quantité en moyenne ? 
select idarticle, avg(quantite) as avg_quantite from lignes_ticket group by idarticle order by avg_quantite desc limit 10;

-- Combien d'articles appartiennent à chaque univers ?
select codeunivers, count(codearticle) from ref_article
group by codeunivers;

-- Quels sont les 5 clients a avoir acheter le plus (en montant) en 2016 ? 
select client.idclient, sum(tic_totalttc) as total_montant from client join entete_ticket
on client.idclient = entete_ticket.idclient
where extract(year from tic_date)=2016
group by client.idclient
order by total_montant desc
limit 5;

-- Quels sont les 5 clients a avoir acheter le plus (en quantite d'articles) en 2016 ?
