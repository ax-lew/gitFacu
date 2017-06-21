--------------EJ 1

--cliente(clienteId, nombre, ciudad)
CREATE TABLE cliente (
	clienteid serial primary key, 
	nombre varchar(80),
	ciudad varchar(80)
);

--articulo(articuloId, nombre, precio, categorı́a)
CREATE TABLE articulo (
	articuloid serial primary key, 
	nombre	varchar(80),
	precio int,
	categoria varchar(80)
);

--orden(ordenId, clienteId,fecha)
CREATE TABLE orden (
	ordenid serial primary key, 
	clienteid int references cliente,
	fecha date
);

--ItemOrden(ordenId,articuloId,cantidad)
CREATE TABLE itemorden (
	ordenid int references orden, 
	articuloid int references articulo,
	cantidad int,
	primary key(ordenid, articuloid)
);

------ Datos

-- nombre, ciudad
delete from cliente;
INSERT INTO cliente(nombre, ciudad) VALUES ('Batman', 'Gotham');
INSERT INTO cliente(nombre, ciudad) VALUES ('Robin', 'Gotham');
INSERT INTO cliente(nombre, ciudad) VALUES ('Frodo', 'Tierra Media');
INSERT INTO cliente(nombre, ciudad) VALUES ('Gollum', 'Tierra Media');

-- nombre, precio, categoria
delete from articulo;
INSERT INTO articulo(nombre, precio, categoria) VALUES ('Batimovil', '10', 'auto');
INSERT INTO articulo(nombre, precio, categoria) VALUES ('Batiseñal', '20', 'ferreteria');
INSERT INTO articulo(nombre, precio, categoria) VALUES ('Anillo'   , '30', 'bijou');
INSERT INTO articulo(nombre, precio, categoria) VALUES ('Montura'  , '40', 'talabarteria');

-- ordenId, clienteId, fecha
delete from orden;
INSERT INTO orden(clienteid, fecha) 
	select clienteid, to_date('1963-09-01', 'YYYY-MM-DD')
	from cliente
	where nombre = 'Batman';

INSERT INTO orden(clienteid, fecha) 
	select clienteid, to_date('2017-04-07', 'YYYY-MM-DD')
	from cliente
	where nombre = 'Batman';

INSERT INTO orden(clienteid, fecha) 
	select clienteid, to_date('2017-03-04', 'YYYY-MM-DD')
	from cliente
	where nombre = 'Batman';

INSERT INTO orden(clienteid, fecha) 
	select clienteid, to_date('2016-01-03', 'YYYY-MM-DD')
	from cliente
	where nombre = 'Robin';


-- ordenid int references orden, articuloid int references articulo, cantidad,
delete from itemorden;
INSERT INTO itemorden(ordenid, articuloid, cantidad)
	select 1, articuloid, 1
	from articulo 
	where nombre = 'Batimovil';

INSERT INTO itemorden(ordenid, articuloid, cantidad)
	select 2, articuloid, 2
	from articulo 
	where nombre = 'Batimovil';

INSERT INTO itemorden(ordenid, articuloid, cantidad)
	select 3, articuloid, 3
	from articulo 
	where nombre = 'Batimovil';

INSERT INTO itemorden(ordenid, articuloid, cantidad)
	select 4, articuloid, 3
	from articulo 
	where nombre = 'Batimovil';

------ Queries

SELECT distinct c.nombre 
FROM Cliente c join Orden o on o.clienteId = c.clienteId
join ItemOrden io on io.ordenId = o.ordenId
join Articulo a on a.articuloId = io.articuloID
WHERE c.ciudad = 'Gotham'
and a.nombre = 'Batimovil'
and o.Fecha >= to_date('01/01/2017', 'DD/MM/YYYY')

SELECT DISTINCT c.nombre 
FROM Cliente c, Orden o,ItemOrden io, Articulo a
WHERE c.ciudad = 'Gotham'
and c.clienteId = o.clienteId
and o.ordenId = io.ordenId
and io.articuloId = a.articuloID
and a.nombre = 'Batimovil'
and o.Fecha >= to_date('01/01/2017', 'DD/MM/YYYY')

SELECT c.* FROM Cliente c
WHERE c.ciudad = 'Gotham'
and EXISTS (
	SELECT null From Orden o, ItemOrden io,Articulo a
		WHERE a.nombre = 'Batimovil'
		and io.articuloId = a.articuloID
		and o.ordenId = io.ordenId
		and o.clienteId =1
		and o.Fecha >= to_date('01/01/2017', 'DD/MM/YYYY')
	)

SELECT c.nombre FROM Cliente c
WHERE c.ciudad = 'Gotham'
and clienteId IN (
	SELECT clienteId
		From Orden o,ItemOrden io, Articulo a
		WHERE a.nombre = 'Batimovil'
		and io.articuloId = a.articuloID
		and o.ordenId = io.ordenId
		and o.Fecha >= to_date('01/01/2017', 'DD/MM/YYYY')
	)


SELECT c.nombre FROM Cliente c
WHERE c.ciudad = 'Gotham'
and clienteId IN (
	SELECT clienteId From Orden o
		WHERE o.Fecha >= to_date('01/01/2017', 'DD/MM/YYYY')
		and ordenId IN ( 
		SELECT io.OrdenId
			FROM ItemOrden io , Articulo a
			WHERE a.nombre = 'Batimovil'
			and io.articuloId = a.articuloID
		)
	)

drop table itemorden;
drop table articulo;
drop table orden;
drop table cliente;
	
--------------EJ 2

CREATE TABLE empleado (
	legajo int primary key, 
	nombre	varchar(80),
	legmgr	int
);



INSERT INTO empleado VALUES (1 , ' Juan ( el dueño ) ' , null );
INSERT INTO empleado VALUES (2 , ' Pedro Perez ' , 1) ;
INSERT INTO empleado VALUES (3 , ' Maria Lopez ' , 2) ;
INSERT INTO empleado VALUES (4 , ' Pepin Gonzalez ' , 2) ;

CREATE TABLE articulo (
	id int primary key, 
	nombre	varchar(80),
	precio	int
);

INSERT INTO articulo VALUES (1 , 'Articulo 1' , 100);
INSERT INTO articulo VALUES (2 , 'Articulo 2' , 200) ;
INSERT INTO articulo VALUES (3 , 'Articulo 3' , 300) ;
INSERT INTO articulo VALUES (3 , 'Articulo 3' , 6000) ;
ALTER TABLE articulo ADD CHECK ( precio < 1000) ;

INSERT INTO articulo VALUES (4 , 'Articulo 4' , 4000) ;
INSERT INTO articulo VALUES (4 , 'Articulo 4' , null) ;

select * from articulo
where precio < null
	
AND
---
select 1 
where (true and true) and not (true and false) and ((true and null) is null)

select 1 
where not (false and true) and not (false and false) and not (false and null)

OR
--
select 1 
where (true or true) and (true or false) and (true or null)

select 1 
where (false or true) and not (false or false) and ((false or null) is null)

X in (y1,...,yn)
----------------
select 1
where 100 in (select precio from articulo)

select 1
where ((10000 in (select precio from articulo)) is null)

select 1
where not (10000 in (select precio from articulo where precio is not null))

select 1
where not (10000 in (select precio from articulo where precio is not null))

EXISTS vs. IN
-------------
select e1.nombre
from empleado e1
where e1.legajo not in (select e2.legmgr from empleado e2)

select e1.*
from empleado e1
where (e1.legajo in (select e2.legmgr from empleado e2)) is null

select 1
where not(1 = null)

select 1
where ((1 = null) is null)

***

SELECT E1.nombre FROM empleado E1
WHERE NOT EXISTS ( SELECT E2.* FROM empleado E2
WHERE E2.legmgr = E1.legajo )

SELECT E2.* FROM empleado E2
WHERE E2.legmgr = 1

SELECT E2.* FROM empleado E2
WHERE E2.legmgr = 2

SELECT E2.* FROM empleado E2
WHERE E2.legmgr = 3

SELECT E2.* FROM empleado E2
WHERE E2.legmgr = 4

COALESCE
--------
select coalesce(null,1,2,null)

select coalesce(null,null)

select coalesce(null,null)

***

SELECT
COALESCE ( null , '1234567890' ) AS COALESCExy , COALESCE ( '1234567890' , null )
AS COALESCEyx , (( null , '1234567890' ) is null) AS ISNULLxy ,
(( '1234567890' , null ) is null) ISNULLyx ;

CASE
----
SELECT nombre , 
( CASE precio
	WHEN 100 THEN ' Barato '
	WHEN 200 THEN ' Maso '
	ELSE ' Caro ' END ) as tipo
FROM articulo

SELECT nombre ,
( CASE
	WHEN legmgr is null THEN ' Director '
	WHEN legajo = 2 THEN ' Gerente '
	ELSE ' Empleado ' END ) as puesto
FROM empleado


drop table empleado;
drop table articulo;

---------
-- INNER JOIN, OUTER LEFT|RIGHT|FULL JOIN
-- ref: http://stackoverflow.com/questions/38549/what-is-the-difference-between-inner-join-and-outer-join

CREATE TABLE tablaA (
	a int primary key
);

CREATE TABLE tablaB (
	b int primary key
);

insert into tablaA(a) 
SELECT a
FROM unnest(ARRAY[1,2,3,4]) a;

insert into tablaB(b) 
SELECT b
FROM unnest(ARRAY[3,4,5,6]) b;

select * from
tablaA ta inner join tablaB tb on ta.a = tb.b

select * from
tablaA ta left outer join tablaB tb on ta.a = tb.b

select * from
tablaA ta right outer join tablaB tb on ta.a = tb.b

select * from
tablaA ta full outer join tablaB tb on ta.a = tb.b

drop table tablaA;
drop table tablaB;
