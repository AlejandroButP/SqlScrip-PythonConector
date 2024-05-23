CREATE DATABASE canchas;
USE canchas;
create table usuarios(
usuario_id int primary key auto_increment,
nombre varchar(100),
numero_documento varchar(100),
correo_electronico varchar(100),
numero_celular varchar(100),
contraseña varchar(100)
);

create table canchas (
cancha_id int primary key auto_increment,
tipo_deporte enum('futbol','baloncesto','tennis'),
ubicacion varchar(100),
capacidad int
);


create table reservas (
reserva_id int primary key auto_increment,
usuario_id int,
cancha_id int,
fecha date,
hora_inicio time,
hora_fin time,
estado enum('Ocupada','Disponible'),
metodo_pago enum('tarjeta_debito','Tarjeta_credito','Nequi'),
foreign key (usuario_id) references usuarios(usuario_id),
foreign key (cancha_id) references canchas(cancha_id)
);

create table ComprobantePago(
 comprobante_id int primary key auto_increment,
 reserva_id int,
 fecha_pago date,
 tipo_pago enum('Tarjeta de credito','Tarjeta debito','PSE','Efectivo'),
 valor_reserva double,
 foreign key (reserva_id) references reservas(reserva_id)
);

insert into usuarios (nombre,numero_documento,correo_electronico,numero_celular,contraseña)
values
('Natalia Rodriguez','1011025718','nat4alia.rodriguesaf@ecci.edu.co','3133568776','12345'),
('Gustavo Gonzalez','1021876872','g1agb21@yahoo.es','3123986754','12345'),
('Silveria Buitrago','39751046','alajabuit3ragro@gmail.com','3212427590','12345'),
('Rafael Bobadilla','79304871','rafael-bobadil2la@hotmail.com','3142382773','2134'),
('Alejandro Bobadila','1007351890','ras213@hotmail.es','3196934719','21123');

insert into canchas (tipo_deporte,ubicacion,capacidad)
values
('futbol','cedritos','10'),
('baloncesto','San Jose','8'),
('tennis','codito','2'),
('futbol','barrancas','18'),
('baloncesto','7 agosto','14');


insert into reservas (usuario_id,cancha_id,fecha,hora_inicio,hora_fin,estado,metodo_pago)
values
(1,1,'2024-02-23','12:30','15:30','Ocupada','tarjeta_debito'),
(1,1,'2024-02-23','10:30','12:00','Ocupada','Tarjeta_credito'),
(2,2,'2024-02-23','08:30','10:00','Ocupada','Tarjeta_credito'),
(3,3,'2024-02-23','18:30','21:00','Ocupada','Tarjeta_credito');

insert into ComprobantePago(reserva_id,fecha_pago,tipo_pago,valor_reserva)
values
('1','2024-02-20','Tarjeta de credito','100000'),
('2','2024-02-18','PSE','85000'),
('3','2024-02-19','Tarjeta Debito','80000'),
('4','2024-02-19','PSE','50000');



--  CREATE

delimiter //
create procedure CrearUsuario(IN nombre varchar(100), IN numero_documento VARCHAR(100), IN
correo_electronico VARCHAR(100), IN numero_celular varchar(50), IN contraseña varchar(100))
begin
INSERT INTO
usuarios(nombre , numero_documento , correo_electronico , numero_celular , contraseña)
VALUES
(nombre, numero_documento, correo_electronico, numero_celular, contraseña);
end//
delimiter ;

-- READ

delimiter //
create procedure LeerUsuarios(in Codigo int)
begin
select * from usuarios where usuario_id=Codigo;
end//
delimiter ;

-- UPDATE

delimiter //
create procedure ActualizarUsuario(IN Codigo INT,IN nombre varchar(100), IN numero_documento VARCHAR(100), IN
correo_electronico VARCHAR(100), IN numero_celular varchar(50), IN contraseña varchar(100)
)
begin
update usuarios
set
usuario_id=Codigo, nombre =nombre,numero_documento=numero_documento,correo_electronico=
correo_electronico,numero_celular=numero_celular,contraseña=contraseña
where usuario_id=Codigo;
end//
delimiter ;

-- DELETE

delimiter //
create procedure BorrarUsuario(in Codigo int)
begin
delete from usuarios where usuario_id=Codigo;
end//
delimiter ;

-- Canchas mas usadas en un rango de tiempo

delimiter //
create procedure CanchasMasUsadas(in FechaInicio date,in FechaFin date)
begin
select count(reservas.cancha_id) as 'Cantidad de reservas',canchas.tipo_deporte as 'Tipo de camnchas'
from reservas
inner join canchas on canchas.cancha_id=reservas.cancha_id
where fecha between FechaInicio and FechaFin
group by reservas.cancha_id;
end//
delimiter ;

-- Clientes que mas alquilan canchas 

delimiter //
create procedure ClientesFrecuentes(in FechaInicio date,in FechaFin date)
begin
select usuarios.nombre,count(reservas.cancha_id) as 'Cantidad de reservas'
from reservas
inner join usuarios on usuarios.usuario_id = reservas.usuario_id
where fecha between FechaInicio and FechaFin
group by usuarios.usuario_id;
end//
delimiter ;

-- Consultar el historial de reservas de por cliente y fecha

delimiter //
create procedure ConsultaReserva(in CodigoUsuario int,in FechaReserva date)
begin
select reserva_id,usuarios.nombre,canchas.tipo_deporte,canchas.ubicacion,fecha,hora_inicio,hora_fin from reservas
inner join usuarios on usuarios.usuario_id = reservas.usuario_id
inner join canchas on canchas.cancha_id=reservas.cancha_id
where reservas.usuario_id=CodigoUsuario and reservas.fecha =FechaReserva;
end//
delimiter ;
