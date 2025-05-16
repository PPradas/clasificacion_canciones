############################################Defición de la base de datos############################################
CREATE DATABASE canciones_SQL;

############################################Creación de las tablas de la base de datos############################################
CREATE TABLE canciones_SQL.Codigos(
codigo INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
id_cancion CHAR(20)
);

CREATE TABLE canciones_SQL.Canciones(
codigo INT AUTO_INCREMENT,
autor CHAR(25),
discografica CHAR(25),
coste DECIMAL(10,2) DEFAULT 0,
duracion INT DEFAULT 0,
genero CHAR(10),
disco CHAR(12),
año CHAR(4) DEFAULT "X",
mes CHAR(2) DEFAULT "X",
dia CHAR(2) DEFAULT "X",
FOREIGN KEY (codigo) REFERENCES Codigos(codigo)
);

CREATE TABLE canciones_SQL.Colaboradores(
codigo INT AUTO_INCREMENT,
colaboradores CHAR(25), 
FOREIGN KEY (codigo) REFERENCES Codigos(codigo)
);

CREATE TABLE canciones_SQL.Listas(
codigo INT,
lista CHAR(20),
usuario CHAR(10),
FOREIGN KEY (codigo) REFERENCES Codigos(codigo)
);

CREATE TABLE canciones_SQL.Favoritos(
codigo INT,
usuario CHAR(10),
FOREIGN KEY (codigo) REFERENCES Codigos(codigo)
);

CREATE TABLE canciones_SQL.Popularidad_dia(
codigo INT,
dia CHAR(2),
reproducciones INT DEFAULT 0,
FOREIGN KEY (codigo) REFERENCES Codigos(codigo)
);

CREATE TABLE canciones_SQL.Popularidad_mes(
codigo INT AUTO_INCREMENT,
total_reproducciones INT DEFAULT 0,
FOREIGN KEY (codigo) REFERENCES Codigos(codigo)
);

Select * from canciones;
Select * from colaboradores;
Select * from codigos;
Select * from favoritos;
Select * from listas;
Select * from popularidad_mes;
Select * from popularidad_dia;


############################################Consultas KPIs############################################
-- 1 Calcular la media diaria de reproducciones durante el mes de septiembre.
SELECT ROUND(AVG(reproducciones),0) AS Media_diaria_reproducciones FROM popularidad_dia;

-- 2 Calcular el número total de reproducciones  
SELECT SUM(total_reproducciones)/1000000 AS millones_reproducciones FROM popularidad_mes;

-- 3 ¿Qué días del mes se han reproducido más canciones y cuántas?
SELECT dia,ROUND(SUM(reproducciones)/1000,3) AS miles_reproducciones FROM popularidad_dia
GROUP BY dia ORDER BY miles_reproducciones DESC;

-- 4 ¿Qué día del mes suelen publicarse más canciones y cuántas?
SELECT dia,COUNT(*) AS numero_publicaciones FROM canciones
WHERE dia!="X"
GROUP BY dia ORDER BY numero_publicaciones DESC;

-- 5 ¿Cuáles son los 5 usuarios que más canciones han añadido a favoritos y cuántas?
SELECT usuario,COUNT(*) AS canciones_favoritos FROM favoritos
GROUP BY usuario ORDER BY canciones_favoritos DESC LIMIT 5;

-- 6 ¿Cuáles son los 5 usuarios que menos canciones han añadido a favoritos y cuántas?
SELECT usuario,COUNT(*) AS canciones_favoritos FROM favoritos
GROUP BY usuario ORDER BY canciones_favoritos LIMIT 5;

-- 7 ¿Cuáles son las 10 discográficas que han recibido más dinero y cuánto?
SELECT discografica, SUM(coste) AS Ventas_derechos_euros FROM canciones
GROUP BY discografica ORDER BY Ventas_derechos_euros DESC LIMIT 10;

-- 8 ¿Cuáles son los 3 artistas que más colaboraciones con otros artistas han hecho?
WITH aux AS (
SELECT DISTINCT c.codigo,ca.autor FROM canciones c
RIGHT JOIN colaboradores co
ON co.codigo=c.codigo
LEFT JOIN canciones ca
ON ca.codigo=c.codigo)

SELECT autor, COUNT(*) AS numero_colaboraciones FROM aux
GROUP BY autor ORDER BY numero_colaboraciones DESC LIMIT 3;

-- 9 ¿Cuáles son los 3 artistas que han interpretado menos canciones de otros compositores?
SELECT colaboradores AS artista, COUNT(*) AS numero_colaboraciones FROM colaboradores
GROUP BY colaboradores ORDER BY numero_colaboraciones ASC LIMIT 3;
#En este caso, existen multitud de artistas con solo una colaboración

-- 10 ¿Cuántas canciones de cada género hay?
SELECT genero,COUNT(*) AS numero_canciones FROM canciones
GROUP BY genero;

-- 11 ¿Cuáles son los discos más escuchados?
SELECT c.disco,SUM(p.total_reproducciones)/1000000 AS Millones_reproducciones FROM canciones c
LEFT JOIN popularidad_mes p
ON c.codigo=p.codigo
GROUP BY disco ORDER BY Millones_reproducciones DESC;

-- 12 ¿Cuál es la media de canciones que tiene un disco?
WITH aux AS(
SELECT disco,COUNT(*) AS numero_canciones FROM canciones
GROUP BY disco
)
SELECT ROUND(AVG(numero_canciones),0) as media_canciones FROM aux;

-- 13 ¿Cuál es la cuantía total de cada tipo de canción que cobran las 5 discográficas que han recibido más dinero?
SELECT discografica,SUM(coste) as Ingresos_discografica_euros FROM canciones
GROUP BY discografica ORDER BY Ingresos_discografica_euros DESC LIMIT 5;
SELECT genero,SUM(coste) AS Cuantía_euros FROM canciones
WHERE discografica="Merge Records" OR discografica="4AD" OR discografica="Interscope Records" OR discografica="RCA Records" OR discografica="Sun Records"
GROUP BY genero ORDER BY Cuantía_euros DESC;

#SELECT discografica,genero,SUM(coste) AS cuantía_euros FROM canciones
#GROUP BY genero,discografica ORDER BY cuantía_euros DESC LIMIT 5;

-- 14 Para cada disco calcular la duración total
SELECT disco, SUM(duracion) AS duracion_total_segundos FROM canciones
GROUP BY disco ORDER BY duracion_total_segundos DESC;

-- 15 Calcular la media de duración de los discos. 
WITH aux AS(
SELECT disco, SUM(duracion) AS duracion_total_segundos FROM canciones
GROUP BY disco
)
SELECT ROUND(AVG(duracion_total_segundos),0) as media_duracion FROM aux;

############################################ KPIs EXTRAS############################################

-- 16 ¿Cuáles son las 10 canciones más veces incluidas en listas de reproducción?
SELECT co.id_cancion,COUNT(*) AS numero_listas FROM canciones c
LEFT JOIN listas l
ON c.codigo=l.codigo
LEFT JOIN codigos co
ON co.codigo=c.codigo
GROUP BY co.id_cancion ORDER BY numero_listas DESC LIMIT 10;

-- 17 ¿Cuáles son las 5 canciones más veces marcadas como favoritas?
SELECT co.id_cancion,COUNT(*) AS numero_favoritos FROM canciones c
LEFT JOIN favoritos f
ON c.codigo=f.codigo
LEFT JOIN codigos co
ON co.codigo=c.codigo
GROUP BY co.id_cancion ORDER BY numero_favoritos DESC LIMIT 5;

-- 18 Listado de canciones tanto marcadas como favoritas como incluidas en listas
SELECT co.id_cancion,f.usuario AS usuario_favorito,l.lista,l.usuario AS usuario_lista FROM favoritos f
INNER JOIN listas l
ON f.codigo=l.codigo
LEFT JOIN codigos co
ON f.codigo=co.codigo;

############################################ KPIs EXTRAS############################################