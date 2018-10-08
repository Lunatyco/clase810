
/*select * from all_users;

show parameter resource_limit;

alter system set resource_limit = true;

--para acceder a todos los privilegios se debe modificar el resource limit
--connect_time = tiempo permitido que puede estar conectado un usuario. Todo con segundos 11g... 12g o superior trabaja con minutos
--sessions_per_user = Cuantas conexiones puede tener un usuario. Número entero.--idle_time = Tiempo que el usuario puede permanecer inactivo, minutos
--password_lifetime = Cantidad de tiempo que dura una contraseña en el usuario. Dias
create profile perfil_1 limit idle_time 2;
alter profile perfil_1 limit connect_time 2;
alter profile perfil_1 limit sessions_per_user 2;
alter profile perfil_1 limit password_life_time 1;

create user inacap
identified by inacap
default tablespace users
temporary tablespace temp;

grant create session to inacap;

alter user inacap profile PERFIL_1;
*/

create user octubre
identified by inacap
default tablespace users
temporary tablespace temp
quota 2000k on users;

create role administrador;
grant create session, create table, create user to administrador;



create profile tienda limit sessions_per_user 1;
alter profile tienda limit idle_time 10;
--dar nivel de acceso a los usuarios
grant  administrador to octubre;
alter user octubre profile tienda;

--en octubre

create table productos(
codigo number (5),
nombre varchar(50),
precio number(8)
);

alter table productos
add constraint PK_productos
primary key (codigo);

create table tipo_producto(
codigo number(5),
nombre varchar(50)
);

alter table tipo_producto
add constraint FK_tipo_producto
foreign key (codigo)
references productos(codigo);


insert into productos values (1,'duracel',1000);

insert into productos values (2,'hitachi',800);

insert into productos values (3,'eveready',400);

insert into tipo_producto values(1,'pila cara');

insert into tipo_producto values(2,'pila media');

insert into tipo_producto values(3,'pila barata');


create user vendedor
identified by inacap
default tablespace users
temporary tablespace temp
quota 2000k on users;

commit;
--en system de nuevo

create role ventas;
grant create session to ventas;

grant select on octubre.tipo_producto to ventas;

grant select on octubre.productos to ventas;

grant ventas to vendedor;



-- mostrar consulta de producto, precio, tipo_producto inner join
-- en vendedor 

select productos.nombre, productos.precio, tipo_producto.nombre 
from octubre.tipo_producto 
inner join octubre.productos 
on octubre.tipo_producto.codigo = octubre.productos.codigo;
