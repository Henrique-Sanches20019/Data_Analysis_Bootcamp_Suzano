CREATE DATABASE automotive_repair_shop;
USE automotive_repair_shop;

CREATE TABLE IF NOT EXISTS person (
    cpf CHAR(11) PRIMARY KEY,
    firstName VARCHAR(50) NOT NULL,
    middleInit CHAR(3),
    lastName VARCHAR(50) NOT NULL,
    address VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS client (
    cpf CHAR(11) PRIMARY KEY,
    contact CHAR(11) NOT NULL,
    email VARCHAR(50) NOT NULL,
    CONSTRAINT fk_client_person FOREIGN KEY (cpf) REFERENCES person(cpf) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS mechanic (
    cpf CHAR(11) PRIMARY KEY,
    specialization VARCHAR(50) NOT NULL,
    CONSTRAINT fk_mechanic_person FOREIGN KEY (cpf) REFERENCES person(cpf) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS orders (
    orderNumber INT AUTO_INCREMENT PRIMARY KEY,
    issueDate DATE NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    orderStatus ENUM('Cancelled', 'Confirmed', 'In processing') DEFAULT 'In processing',
    expirationDate DATE NOT NULL,
    vehicleModel VARCHAR(50) NOT NULL,
    cpf CHAR(11),
    CONSTRAINT fk_order_person FOREIGN KEY (cpf) REFERENCES person(cpf) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS service (
    idService INT AUTO_INCREMENT PRIMARY KEY,
    serviceType VARCHAR(50) NOT NULL UNIQUE,
    price DECIMAL(10, 2) NOT NULL
);

CREATE TABLE IF NOT EXISTS part (
    idPart INT AUTO_INCREMENT PRIMARY KEY,
    partType VARCHAR(50) NOT NULL UNIQUE,
    price DECIMAL(10, 2) NOT NULL
);

CREATE TABLE IF NOT EXISTS orderService (
    orderNumber INT,
    idService INT,
    PRIMARY KEY (orderNumber, idService),
    CONSTRAINT fk_orderService_order FOREIGN KEY (orderNumber) REFERENCES orders(orderNumber) ON UPDATE CASCADE,
    CONSTRAINT fk_orderService_service FOREIGN KEY (idService) REFERENCES service(idService) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS orderPart (
    orderNumber INT,
    idPart INT,
    quantity INT NOT NULL,
    PRIMARY KEY (orderNumber, idPart),
    CONSTRAINT fk_orderPart_order FOREIGN KEY (orderNumber) REFERENCES orders(orderNumber) ON UPDATE CASCADE,
    CONSTRAINT fk_orderPart_part FOREIGN KEY (idPart) REFERENCES part(idPart) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS orderMechanic (
    orderNumber INT,
    cpf CHAR(11),
    hoursWorked DECIMAL(3, 1) NOT NULL,
    PRIMARY KEY (orderNumber, cpf),
    CONSTRAINT fk_orderMechanic_order FOREIGN KEY (orderNumber) REFERENCES orders(orderNumber) ON UPDATE CASCADE,
    CONSTRAINT fk_orderMechanic_mechanic FOREIGN KEY (cpf) REFERENCES mechanic(cpf) ON UPDATE CASCADE
);

SHOW TABLES;

INSERT INTO person (cpf, firstName, middleInit, lastName, address)
VALUES
('12345678901', 'John', 'A', 'Doe', '123 Main St'),
('23456789012', 'Jane', 'B', 'Smith', '234 Elm St'),
('34567890123', 'Peter', 'C', 'Parker', '456 Marvel Ave'),
('45678901234', 'Tony', 'S', 'Stark', '789 Stark Tower'),
('56789012345', 'Bruce', 'B', 'Wayne', '100 Wayne Manor'),
('67890123456', 'Diana', 'P', 'Prince', '101 Silver Dr');

INSERT INTO client (cpf, contact, email)
VALUES
('12345678901', '12345678901', 'john@email.com'),
('23456789012', '23456789012', 'jane@email.com'),
('34567890123', '34567890123', 'peter@email.com');

INSERT INTO mechanic (cpf, specialization)
VALUES
('45678901234', 'Engine'),
('56789012345', 'Suspension'),
('67890123456', 'Brakes');

INSERT INTO orders (issueDate, price, expirationDate, vehicleModel, cpf)
VALUES
('2021-01-01', 1000.00, '2021-01-05', 'Fiesta', '12345678901'),
('2021-01-02', 2000.00, '2021-01-07', 'Focus', '23456789012'),
('2021-01-03', 3000.00, '2021-01-12', 'Fusion', '34567890123'),
('2021-01-04', 4500.00, '2021-01-15', 'Mustang', '12345678901');

INSERT INTO service (serviceType, price)
VALUES
('Oil Change', 100.00),
('Tire Rotation', 50.00),
('Brake Inspection', 75.00);

INSERT INTO part (partType, price)
VALUES
('Oil Filter', 10.00),
('Air Filter', 15.00),
('Brake Pads', 50.00);

INSERT INTO orderService (orderNumber, idService)
VALUES
(1, 1),
(2, 2),
(3, 1),
(3, 3),
(4, 1),
(4, 2);

INSERT INTO orderPart (orderNumber, idPart, quantity)
VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 1),
(3, 1, 1),
(4, 2, 2),
(4, 3, 1);

INSERT INTO orderMechanic (orderNumber, cpf, hoursWorked)
VALUES
(1, '45678901234', 20.5),
(2, '56789012345', 30.0),
(3, '67890123456', 40.5),
(4, '56789012345', 20.0),
(4, '45678901234', 20.0);

-- Clientes com mais de duas ordens de serviço
SELECT CONCAT(person.firstName, ' ', person.lastName) AS clientName, COUNT(orders.orderNumber) AS totalOrders
FROM person
JOIN orders ON person.cpf = orders.cpf
GROUP BY person.cpf
HAVING totalOrders > 1;

-- Lista dos serviços em cada ordem de serviço ordenados por data de expiração
SELECT CONCAT(person.firstName, ' ', person.lastName) AS clientName, orders.vehicleModel, service.serviceType, orders.expirationDate
FROM person, orders, service, orderService
WHERE person.cpf = orders.cpf AND orders.orderNumber = orderService.orderNumber AND orderService.idService = service.idService
ORDER BY orders.expirationDate;
