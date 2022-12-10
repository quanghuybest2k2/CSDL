CREATE DATABASE Learn_Trigger
go
use Learn_Trigger
GO
-- create table
CREATE TABLE sales(
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    product_name VARCHAR(50),
    price money,
    quantity INT
);
-- insert sample data
INSERT INTO sales(product_name, price, quantity)
VALUES ('iPhone Charger', $9.99, 10),
       ('Google Chromecast', $59.25, 5),
       ('Playstation DualSense Wireless Controller', $69.00, 100),
       ('Xbox Series S', $322.00, 3),
       ('Oculus QUest 2', $299.50, 7),
       ('Netgear Nighthawk', $236.30, 40),
       ('Redragon S101', $35.98, 100),
       ('Star Wars Action Figure', $17.50, 10),
       ('Mario Kart 8 Deluxe', $57.00, 5);
GO
-- create table to store update history
CREATE TABLE ModifiedDate (id INT, date_ datetime)
GO
-- create trigger
CREATE TRIGGER dbo.update_trigger
ON sales
after UPDATE
NOT FOR replication
AS
    BEGIN
        INSERT INTO ModifiedDate
        SELECT id, getdate()
        FROM inserted
    END
GO
-- update table
UPDATE sales SET price = $10.10
WHERE id = 1;
GO
-- check ModifiedDate table
SELECT * FROM ModifiedDate;
GO
-- create instead of trigger
CREATE TRIGGER instead_insert
ON sales
instead OF INSERT
AS
    BEGIN
        SELECT 'You cannot insert in this table' AS Error
    END

-- run instead_insert trigger
INSERT INTO sales(product_name, price, quantity)
VALUES ('iPhone Charger', $9.99, 10);
GO
 -- create ddl trigger
CREATE TRIGGER drop_ddl_trigger
ON DATABASE
FOR drop_table
AS
    BEGIN
        SELECT eventdata();
    END
GO
