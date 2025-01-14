CREATE DATABASE ecommerce;
USE ecommerce;

CREATE TABLE IF NOT EXISTS client (
    idClient INT AUTO_INCREMENT PRIMARY KEY,
    firstName VARCHAR(10),
    middleInit CHAR(3),
    lastName VARCHAR(20),
    address VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS pjClient (
    idClient INT PRIMARY KEY,
    cnpj CHAR(14) NOT NULL UNIQUE,
    CONSTRAINT fk_pjClient FOREIGN KEY (idClient) REFERENCES client(idClient) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS pfClient (
    idClient INT PRIMARY KEY,
    cpf CHAR(11) NOT NULL UNIQUE,
    birthDate DATE,
    CONSTRAINT fk_pfClient FOREIGN KEY (idClient) REFERENCES client(idClient) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS product (
    idProduct INT AUTO_INCREMENT PRIMARY KEY,
    pName VARCHAR(50),
    price DECIMAL(10, 2),
    classificationKids BOOL DEFAULT FALSE,
    category ENUM('Electronic', 'Clothing', 'Toy', 'Food', 'Furniture') NOT NULL,
    usersRating FLOAT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS payment (
    idClient INT,
    idPayment INT AUTO_INCREMENT PRIMARY KEY,
    typePayment ENUM('Receipt', 'Card', 'Two cards'),
    limitAvailable FLOAT,
    CONSTRAINT fk_payment_client FOREIGN KEY (idClient) REFERENCES client(idClient) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS orders (
    idOrder INT AUTO_INCREMENT PRIMARY KEY,
    idOrderClient INT,
    orderStatus ENUM('Cancelled', 'Confirmed', 'In processing') DEFAULT 'In processing',
    orderDescription VARCHAR(255),
    sendValue FLOAT DEFAULT 10,
    idPayment INT,
    CONSTRAINT fk_orders_client FOREIGN KEY (idOrderClient) REFERENCES client(idClient) ON UPDATE CASCADE,
    CONSTRAINT fk_order_payment FOREIGN KEY (idPayment) REFERENCES payment(idPayment) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS productStorage (
    idProdStorage INT AUTO_INCREMENT PRIMARY KEY,
    storageLocation VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS supplier (
    idSupplier INT AUTO_INCREMENT PRIMARY KEY,
    socialName VARCHAR(255) NOT NULL,
    cnpj CHAR(15) NOT NULL UNIQUE,
    contact CHAR(11) NOT NULL,
    CONSTRAINT unique_supplier UNIQUE (cnpj)
);

CREATE TABLE IF NOT EXISTS seller (
    idSeller INT AUTO_INCREMENT PRIMARY KEY,
    socialName VARCHAR(255) NOT NULL,
    abstName VARCHAR(255),
    location VARCHAR(255),
    contact CHAR(11) NOT NULL
);

CREATE TABLE IF NOT EXISTS productSeller (
    idPSeller INT,
    idProduct INT,
    prodQuantity INT DEFAULT 1,
    PRIMARY KEY (idPSeller, idProduct),
    CONSTRAINT fk_product_seller_seller FOREIGN KEY (idPSeller) REFERENCES seller(idSeller) ON UPDATE CASCADE,
    CONSTRAINT fk_product_seller_product FOREIGN KEY (idProduct) REFERENCES product(idProduct) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS productOrder (
    idPOproduct INT,
    idPOorder INT,
    poQuantity INT DEFAULT 1,
    poStatus ENUM('Available', 'Unavailable') DEFAULT 'Available',
    PRIMARY KEY (idPOproduct, idPOorder),
    CONSTRAINT fk_product_order_product FOREIGN KEY (idPOproduct) REFERENCES product(idProduct) ON UPDATE CASCADE,
    CONSTRAINT fk_product_order_orders FOREIGN KEY (idPOorder) REFERENCES orders(idOrder) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS storageLocation (
    idLproduct INT,
    idLstorage INT,
    quantity INT DEFAULT 0,
    PRIMARY KEY (idLproduct, idLstorage),
    CONSTRAINT fk_storage_location_product FOREIGN KEY (idLproduct) REFERENCES product(idProduct) ON UPDATE CASCADE,
    CONSTRAINT fk_storage_location_storage FOREIGN KEY (idLstorage) REFERENCES productStorage(idProdStorage) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS productSupplier (
    idPsSupplier INT,
    idPsProduct INT,
    quantity INT NOT NULL,
    PRIMARY KEY (idPsSupplier, idPsProduct),
    CONSTRAINT fk_product_supplier_supplier FOREIGN KEY (idPsSupplier) REFERENCES supplier(idSupplier) ON UPDATE CASCADE,
    CONSTRAINT fk_product_supplier_product FOREIGN KEY (idPsProduct) REFERENCES product(idProduct) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS delivery (
    idDelivery INT AUTO_INCREMENT PRIMARY KEY,
    idOrder INT,
    deliveryStatus ENUM('Delivered', 'In transit', 'Cancelled') DEFAULT 'In transit',
    trackingCode CHAR(10) UNIQUE,
    CONSTRAINT fk_delivery_order FOREIGN KEY (idOrder) REFERENCES orders(idOrder) ON UPDATE CASCADE
);

SHOW TABLES;

INSERT INTO client (firstName, middleInit, lastName, address) 
VALUES
('John','A','Smith','123 Main St'),        -- idClient = 1
('Jane','B','Doe','234 Elm St'),           -- idClient = 2
('Peter','C','Parker','456 Marvel Ave'),   -- idClient = 3
('Tony','S','Stark','789 Stark Tower'),    -- idClient = 4
('Bruce','B','Wayne','100 Wayne Manor'),   -- idClient = 5
('Diana','P','Prince','101 Silver Dr'),    -- idClient = 6
('Clark','J','Kent','102 Smallville Ln'),  -- idClient = 7
('Barry','A','Allen','103 Central City'),  -- idClient = 8
('Hal','J','Jordan','104 Coast City'),     -- idClient = 9
('Arthur','C','Curry','105 Atlantis'),     -- idClient = 10
('Steve','R','Rogers','106 Brooklyn'),     -- idClient = 11
('Natasha','A','Romanoff','107 Red Room'), -- idClient = 12
('Wade','W','Wilson','108 Deadpool Dr'),   -- idClient = 13
('Selina','K','Kyle','109 Gotham'),        -- idClient = 14
('Harleen','F','Quinzel','110 Arkham'),    -- idClient = 15
('Pamela','L','Isley','111 Botanical');    -- idClient = 16

INSERT INTO pjClient (idClient, cnpj) 
VALUES
(1, '11111111111111'),
(2, '22222222222222'),
(3, '33333333333333'),
(4, '44444444444444'),
(5, '55555555555555'),
(6, '66666666666666'),
(7, '77777777777777'),
(8, '88888888888888');

INSERT INTO pfClient (idClient, cpf, birthDate) 
VALUES
(9,  '99999999999',  '1990-01-01'),
(10, '10101010101', '1991-02-02'),
(11, '11111111111', '1992-03-03'),
(12, '12121212121', '1993-04-04'),
(13, '13131313131', '1994-05-05'),
(14, '14141414141', '1995-06-06'),
(15, '15151515151', '1996-07-07'),
(16, '16161616161', '1997-08-08');

INSERT INTO product (pName, price, classificationKids, category, usersRating)
VALUES
('Laptop', 999.99, FALSE, 'Electronic', 4.5),
('T-Shirt', 19.99, FALSE, 'Clothing', 3.8),
('Toy Car', 9.99, TRUE, 'Toy', 4.0),
('Sofa', 499.99, FALSE, 'Furniture', 4.2);

INSERT INTO seller (socialName, abstName, location, contact)
VALUES
('TechCorp', 'TC', 'New York', '12345678901'),
('Vendor Inc.', 'VI', 'Los Angeles', '98765432101');

INSERT INTO productStorage (storageLocation)
VALUES
('Warehouse A'),
('Warehouse B');

INSERT INTO supplier (socialName, cnpj, contact)
VALUES
('AlphaSupplies', '123456789012345', '12345678901'),
('BetaSupplies', '987654321098765', '98765432101');

INSERT INTO payment (idClient, typePayment, limitAvailable)
VALUES
(1, 'Card', 1000.00),
(1, 'Two cards', 2000.00),
(2, 'Receipt', 500.00),
(2, 'Card', 750.00),
(3, 'Receipt', 250.00),
(3, 'Two cards', 1500.00),
(4, 'Card', 1000.00),
(4, 'Receipt', 300.00),
(5, 'Card', 900.00),
(5, 'Two cards', 1800.00),
(6, 'Receipt', 500.00),
(6, 'Card', 1100.00),
(7, 'Card', 700.00),
(7, 'Two cards', 1400.00),
(8, 'Receipt', 600.00),
(8, 'Card', 1200.00),
(9, 'Card', 800.00),
(10, 'Two cards', 1500.00),
(11, 'Card', 1000.00),
(12, 'Receipt', 300.00);

INSERT INTO orders (idOrderClient, orderStatus, orderDescription, sendValue, idPayment)
VALUES
(5, 'In processing', 'Mixed items', 10.00, 9),
(5, 'In processing', 'Mixed items', 10.00, 9),
(5, 'In processing', 'Mixed items', 10.00, 9),
(9, 'Cancelled', 'Collectibles', 10.00, 17),
(1, 'Confirmed', 'Laptop order', 15.00, 1),
(4, 'Confirmed', 'Furniture order', 20.00, 7),
(5, 'In processing', 'Mixed items', 10.00, 9),
(8, 'In processing', 'Misc items', 10.00, 15),
(9, 'Cancelled', 'Collectibles', 10.00, 17),
(1, 'Confirmed', 'Laptop order', 15.0, 1),
(2, 'In processing', 'Clothing order', 10.0, 4),
(3, 'Cancelled', 'Toy order', 8.5, 5),
(4, 'Confirmed', 'Furniture order', 20.0, 7),
(5, 'In processing', 'Mixed items', 10.0, 9),
(6, 'Cancelled', 'Gift order', 12.5, 11),
(7, 'Confirmed', 'Electronics', 15.0, 14),
(8, 'In processing', 'Misc items', 10.0, 15),
(9, 'Cancelled', 'Collectibles', 10.0, 17);

INSERT INTO productOrder (idPOproduct, idPOorder, poQuantity, poStatus)
VALUES
(1, 1, 1, 'Available'),
(2, 2, 1, 'Available'),
(3, 3, 1, 'Unavailable'),
(4, 4, 1, 'Available'),
(1, 5, 1, 'Available'),
(2, 6, 1, 'Unavailable'),
(3, 7, 1, 'Available'),
(4, 8, 1, 'Available'),
(1, 9, 1, 'Unavailable');

INSERT INTO delivery (idOrder, deliveryStatus, trackingCode)
VALUES
(5, 'Delivered', 'TRACK0015'),
(5, 'Delivered', 'TRACK0016'),
(5, 'Delivered', 'TRACK0017'),
(9, 'Cancelled', 'TRACK0018'),
(1, 'Delivered', 'TRACK0010'),
(4, 'In transit', 'TRACK0011'),
(5, 'Delivered', 'TRACK0012'),
(8, 'In transit', 'TRACK0013'),
(9, 'Cancelled', 'TRACK0014'),
(1, 'Delivered', 'TRACK0001'),
(2, 'In transit', 'TRACK0002'),
(3, 'Cancelled', 'TRACK0003'),
(4, 'In transit', 'TRACK0004'),
(5, 'Delivered', 'TRACK0005'),
(6, 'Cancelled', 'TRACK0006'),
(7, 'Delivered', 'TRACK0007'),
(8, 'In transit', 'TRACK0008'),
(9, 'Cancelled', 'TRACK0009');

INSERT INTO productSeller (idPSeller, idProduct, prodQuantity)
VALUES
(1, 1, 10),
(1, 3, 50),
(2, 2, 200),
(2, 4, 10);

INSERT INTO storageLocation (idLproduct, idLstorage, quantity)
VALUES
(1, 1, 50),
(1, 2, 25),
(2, 1, 30),
(2, 2, 10),
(3, 1, 100),
(3, 2, 50),
(4, 1, 75),
(4, 2, 20);

INSERT INTO productSupplier (idPsSupplier, idPsProduct, quantity)
VALUES
(1, 1, 60),
(1, 3, 40),
(2, 2, 100),
(2, 4, 25);

SELECT CONCAT(client.firstName, ' ', client.lastName) AS clientName, COUNT(orders.idOrder) AS totalOrders
FROM client
JOIN orders ON client.idClient = orders.idOrderClient
GROUP BY client.idClient
HAVING totalOrders > 1;

SELECT CONCAT(client.firstName, ' ', client.lastName) AS clientName, birthDate
FROM client, pfClient
WHERE client.idClient = pfClient.idClient
ORDER BY birthDate;
