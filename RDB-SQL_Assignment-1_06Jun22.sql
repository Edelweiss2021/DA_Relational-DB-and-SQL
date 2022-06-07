/*
===== RDB&SQL Assignment-1 (06 Jun 22) =============

Charlie's Chocolate Factory company produces chocolates. The following product information is stored: product name, product ID, and quantity on hand. 
These chocolates are made up of many components. Each component can be supplied by one or more suppliers. 
The following component information is kept: component ID, name, description, quantity on hand, suppliers who supply them, when and how much they supplied, and products in which they are used. 
On the other hand following supplier information is stored: supplier ID, name, and activation status.

Assumptions:

    - A supplier can exist without providing components.
    - A component does not have to be associated with a supplier. It may already have been in the inventory.
    - A component does not have to be associated with a product. Not all components are used in products.
    - A product cannot exist without components. 


Do the following exercises, using the data model.

     a) Create a database named "Manufacturer"

     b) Create the tables in the database.

     c) Define table constraints.

*/

USE Manufacturer;

-- create schemas
CREATE SCHEMA product;
go

CREATE SCHEMA component;
go

CREATE SCHEMA supplier;
go

-- create tables

CREATE TABLE product.product (
	prod_id INT IDENTITY (1, 1) PRIMARY KEY,
	prod_name VARCHAR (50) NOT NULL,
	quantity INT NOT NULL
	);

CREATE TABLE component.component (
	comp_id INT IDENTITY (1, 1) PRIMARY KEY,
	comp_name VARCHAR (50) NOT NULL,
	description VARCHAR (50) NOT NULL,
	quantity_comp INT NOT NULL
	);
	   
CREATE TABLE supplier.supplier (
	supp_id INT IDENTITY (1, 1) PRIMARY KEY,
	supp_name VARCHAR (50) NOT NULL,
	supp_location VARCHAR (50) NOT NULL,
	supp_country VARCHAR (50) NOT NULL,
	is_active BIT NOT NULL
	);

CREATE TABLE product.component (
	prod_id INT NOT NULL,
	comp_id INT NOT NULL,
	quantity_comp INT NOT NULL,
	FOREIGN KEY (prod_id) REFERENCES product.product (prod_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (comp_id) REFERENCES component.component (comp_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE component.supplier (
	supp_id INT NOT NULL,
	comp_id INT NOT NULL,
	order_date DATE NOT NULL,
	quantity INT NOT NULL,
	FOREIGN KEY (supp_id) REFERENCES supplier.supplier (supp_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (comp_id) REFERENCES component.component (comp_id) ON DELETE CASCADE ON UPDATE CASCADE
);