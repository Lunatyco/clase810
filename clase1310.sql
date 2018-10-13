--en system
create profile dba_prueba2 limit idle_time 2;
alter profile dba_prueba2 limit sessions_per_user 1;
alter profile dba_prueba2 limit connect_time 1;
--pantallazo un usuario
create role rol_dba;
grant create session, create table, create user to rol_dba;


create user Inacap_prueba2
identified by prueba2
default tablespace users
temporary tablespace temp
quota 1000k on users;

grant rol_dba to Inacap_prueba2;

-- en Inacap_prueba2

create table tipo_auto(
codigo number(4),
nombre varchar2(100)
);
create table auto(
codigo number(4),
patente varchar2(6),
dueno varchar2(100),
tipo_auto_codigo number(4)
);


alter table tipo_auto
add constraint PK_tipo_auto
primary key (codigo);

alter table auto
add constraint FK_auto
foreign key (tipo_auto_codigo)
references tipo_auto(codigo);

create role cotizador;

-- en system
grant create session to cotizador;
grant select on Inacap_prueba2.tipo_auto to cotizador;
grant insert on Inacap_prueba2.auto to cotizador;

-- en Inacap_prueba
create user pedro
identified by ora1
default tablespace users
temporary tablespace temp
quota 500k on users;

-- en system 

grant cotizador to pedro;

-- en pedro 
insert into Inacap_prueba2.tipo_auto values (1,'sedan');

insert into Inacap_prueba2.auto values (1,'JPSS18','Juan',1);
insert into Inacap_prueba2.auto values (2,'JPFF18','Juano',1);
insert into Inacap_prueba2.auto values (3,'JPLL18','Juane',1);
insert into Inacap_prueba2.auto values (4,'JPPP18','Juani',1);
insert into Inacap_prueba2.auto values (5,'JPOO18','Juanu',1);

select Inacap_prueba2.auto.patente, Inacap_prueba2.tipo_auto.nombre, Inacap_prueba2.auto.dueno 
from Inacap_prueba2.auto inner join Inacap_prueba2.tipo_auto
on Inacap_prueba2.auto.tipo_auto_codigo = Inacap_prueba2.tipo_auto.codigo;