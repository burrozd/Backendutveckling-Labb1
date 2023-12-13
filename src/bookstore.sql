-- Skapar databasen och använder den
DROP DATABASE IF EXISTS bookstore;
CREATE DATABASE bookstore;
USE bookstore;

-- Skapar tabellen "author"
CREATE TABLE author (
                        id INT AUTO_INCREMENT PRIMARY KEY,
                        first_name VARCHAR(255),
                        last_name VARCHAR(255),
                        birth_date DATE
);

-- Skapar tabellen "language"
CREATE TABLE language (
                          id INT AUTO_INCREMENT PRIMARY KEY,
                          language_name VARCHAR(255)
);

-- Skapar tabellen "book"
CREATE TABLE book (
                      isbn VARCHAR(13) PRIMARY KEY,
                      title VARCHAR(255),
                      language_id INT,
                      price DECIMAL(10, 2),
                      publication_date DATE,
                      author_id INT,
                      FOREIGN KEY (language_id) REFERENCES language(id),
                      FOREIGN KEY (author_id) REFERENCES author(id)
);

-- Skapar tabellen "bookstore"
CREATE TABLE bookstore (
                           id INT AUTO_INCREMENT PRIMARY KEY,
                           store_name VARCHAR(255),
                           city VARCHAR(255)
);

-- Skapar tabellen "inventory"
CREATE TABLE inventory (
                           store_id INT,
                           isbn VARCHAR(13),
                           amount INT,
                           PRIMARY KEY (store_id, isbn),
                           FOREIGN KEY (store_id) REFERENCES bookstore(id),
                           FOREIGN KEY (isbn) REFERENCES book(isbn)
);

-- Lägg till författare, böcker, butiker och lagersaldon (anpassa detta efter ditt behov)
-- Exempel:
INSERT INTO author (first_name, last_name, birth_date) VALUES ('John', 'Doe', '1990-01-01');
INSERT INTO language (language_name) VALUES ('English');
INSERT INTO book (isbn, title, language_id, price, publication_date, author_id) VALUES ('1234567890123', 'Sample Book', 1, 19.99, '2022-01-01', 1);
INSERT INTO bookstore (store_name, city) VALUES ('Bookstore A', 'City A');
INSERT INTO inventory (store_id, isbn, amount) VALUES (1, '1234567890123', 50);

-- Skapar vyn "total_author_book_value"
CREATE VIEW total_author_book_value AS
SELECT
    CONCAT(a.first_name, ' ', a.last_name) AS name,
    TIMESTAMPDIFF(YEAR, a.birth_date, CURDATE()) AS age,
    COUNT(DISTINCT b.title) AS book_title_count,
    SUM(b.price * i.amount) AS inventory_value
FROM
    author a
        JOIN
    book b ON a.id = b.author_id
        JOIN
    inventory i ON b.isbn = i.isbn
GROUP BY
    a.id;

-- Skapar användare och ger rättigheter
-- Utvecklarkonto
CREATE USER 'developer'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON bookstore.* TO 'developer'@'localhost';

-- Web server konto
CREATE USER 'webserver'@'localhost' IDENTIFIED BY 'password';
GRANT SELECT, INSERT, UPDATE, DELETE ON bookstore.* TO 'webserver'@'localhost';
