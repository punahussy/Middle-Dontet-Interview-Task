create database TicketService;
go;

use TicketService;


create table Passenger
(
    id        int not null
        constraint Passenger_pk
            primary key,
    FirstName nvarchar(max),
    LastName  nvarchar(max),
    Email     nvarchar(max)
)
go;

create table Station
(
    id   int not null
        primary key,
    Name nvarchar(100)
)
go;

create table Ticket
(
    id          int not null
        primary key,
    Origin      int
        constraint OriginFK
            references Station,
    Destination int
        constraint Destination
            references Station,
    Price       int,
    FirstClass  bit
)
go;

create table Trip
(
    id                  int not null primary key,
    Origin              int
        constraint TripOriginFK
            references Station,
    Date                date,
    Time                time,
    FirstClassAvailable bit,
    Delay               time,
    IsCancelled         bit,
    Destination         int
        constraint TripDestinationFK
            references Station
)
go

create table TicketToTrip
(
    Ticket int not null
        constraint TicketToTripFK
            references Ticket,
    Trip   int not null
        constraint TripToTicketFK
            references Trip
)
go;

create table PassengerToTicket
(
    passenger int not null
        constraint PassengerFK
            references Passenger,
    ticket    int not null
        constraint TicketFK
            references Ticket
)
go

create table TripIntermediateStations
(
    Trip    int not null
        references Trip,
    Station int not null
        references Station,
    primary key (Trip, Station)
)
go;

INSERT INTO TicketService.dbo.Station (id, Name) VALUES (1, N'Veselograd');
INSERT INTO TicketService.dbo.Station (id, Name) VALUES (2, N'Smeholino');
INSERT INTO TicketService.dbo.Station (id, Name) VALUES (3, N'Zigzagovo');
INSERT INTO TicketService.dbo.Station (id, Name) VALUES (4, N'Hohotpol');
INSERT INTO TicketService.dbo.Station (id, Name) VALUES (5, N'Zacharovino');
INSERT INTO TicketService.dbo.Station (id, Name) VALUES (6, N'Fantazijisk');
INSERT INTO TicketService.dbo.Station (id, Name) VALUES (7, N'Radostov');
INSERT INTO TicketService.dbo.Station (id, Name) VALUES (8, N'Shutovo');
INSERT INTO TicketService.dbo.Station (id, Name) VALUES (9, N'Ulybkin');
INSERT INTO TicketService.dbo.Station (id, Name) VALUES (10, N'Dobrokray');

INSERT INTO TicketService.dbo.Trip (id, Origin, Date, Time, FirstClassAvailable, Delay, IsCancelled, Destination) VALUES (1, 1, N'2023-08-14', N'10:00:00', 0, N'00:00:00', 0, 5);
INSERT INTO TicketService.dbo.Trip (id, Origin, Date, Time, FirstClassAvailable, Delay, IsCancelled, Destination) VALUES (2, 1, N'2023-08-14', N'12:00:00', 1, N'00:00:00', 0, 10);

INSERT INTO TicketService.dbo.Passenger (id, FirstName, LastName, Email) VALUES (1, N'Jimmy', N'Beast', N'mrBeast@kremlin.ru');
INSERT INTO TicketService.dbo.Passenger (id, FirstName, LastName, Email) VALUES (2, N'Michael', N'Jackson', N'michaelSinger@rambler.ru');

INSERT INTO TicketService.dbo.TripIntermediateStations (Trip, Station) VALUES (1, 2);
INSERT INTO TicketService.dbo.TripIntermediateStations (Trip, Station) VALUES (1, 3);
INSERT INTO TicketService.dbo.TripIntermediateStations (Trip, Station) VALUES (1, 4);
INSERT INTO TicketService.dbo.TripIntermediateStations (Trip, Station) VALUES (2, 2);
INSERT INTO TicketService.dbo.TripIntermediateStations (Trip, Station) VALUES (2, 3);
INSERT INTO TicketService.dbo.TripIntermediateStations (Trip, Station) VALUES (2, 4);
INSERT INTO TicketService.dbo.TripIntermediateStations (Trip, Station) VALUES (2, 5);
INSERT INTO TicketService.dbo.TripIntermediateStations (Trip, Station) VALUES (2, 6);
INSERT INTO TicketService.dbo.TripIntermediateStations (Trip, Station) VALUES (2, 7);
INSERT INTO TicketService.dbo.TripIntermediateStations (Trip, Station) VALUES (2, 8);
INSERT INTO TicketService.dbo.TripIntermediateStations (Trip, Station) VALUES (2, 9);

INSERT INTO TicketService.dbo.Ticket (id, Origin, Destination, Price, FirstClass) VALUES (1, 1, 5, 3000, 0);
INSERT INTO TicketService.dbo.Ticket (id, Origin, Destination, Price, FirstClass) VALUES (2, 1, 8, 3500, 0);

INSERT INTO TicketService.dbo.TicketToTrip (Ticket, Trip) VALUES (1, 1);
INSERT INTO TicketService.dbo.TicketToTrip (Ticket, Trip) VALUES (2, 2);

INSERT INTO TicketService.dbo.PassengerToTicket (passenger, ticket) VALUES (1, 1);
INSERT INTO TicketService.dbo.PassengerToTicket (passenger, ticket) VALUES (1, 2);
