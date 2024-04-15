CREATE DATABASE IF NOT EXISTS crud;
USE crud;

CREATE TABLE IF NOT EXISTS student (
	ID int NOT NULL,
	Name varchar(20) NOT NULL,
	Email varchar(50),
	PRIMARY KEY (ID)
);

INSERT IGNORE INTO student (ID, Name, Email) VALUES (1, 'Tom Erichsen', 'tom_erichsen@gmail.com'), 
	(2, 'Vin Diesel', 'vin_diesel@gmail.com'), 
	(3, 'Dwayne Johnson', 'dwayne_rock@gmail.com');