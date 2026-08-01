CREATE DATABASE IF NOT EXISTS tourism_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE tourism_db;

-- 1. Справочник стран
CREATE TABLE countries (
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL UNIQUE,
    region VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

-- 2. Справочник видов туров
CREATE TABLE tour_types (
    tour_type_id INT AUTO_INCREMENT PRIMARY KEY,
    tour_type_name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255)
) ENGINE=InnoDB;

-- 3. Справочник услуг
CREATE TABLE services (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    service_name VARCHAR(100) NOT NULL UNIQUE,
    price DECIMAL(10,2) NOT NULL
) ENGINE=InnoDB;

-- 4. Таблица переменной информации: заказы туров
CREATE TABLE tour_orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    client_full_name VARCHAR(150) NOT NULL,
    client_phone VARCHAR(30) NOT NULL,
    order_date DATE NOT NULL,
    departure_date DATE NOT NULL,
    tourists_count INT NOT NULL DEFAULT 1,
    country_id INT NOT NULL,
    tour_type_id INT NOT NULL,
    service_id INT NOT NULL,
    total_cost DECIMAL(10,2) NOT NULL,
    comment VARCHAR(255),

    CONSTRAINT fk_tour_orders_country
        FOREIGN KEY (country_id)
        REFERENCES countries(country_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_tour_orders_tour_type
        FOREIGN KEY (tour_type_id)
        REFERENCES tour_types(tour_type_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_tour_orders_service
        FOREIGN KEY (service_id)
        REFERENCES services(service_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;
USE tourism_db;

-- =========================================================
-- Заполнение справочника стран
-- =========================================================
INSERT INTO countries (country_name, region) VALUES
('Турция', 'Европа и Азия'),
('Египет', 'Африка'),
('Таиланд', 'Азия'),
('Франция', 'Европа'),
('ОАЭ', 'Ближний Восток');

-- =========================================================
-- Заполнение справочника видов туров
-- =========================================================
INSERT INTO tour_types (tour_type_name, description) VALUES
('Пляжный', 'Отдых на море с проживанием в отеле'),
('Экскурсионный', 'Тур с посещением достопримечательностей'),
('Горнолыжный', 'Отдых в горных и зимних курортах'),
('Оздоровительный', 'Тур с оздоровительными процедурами');

-- =========================================================
-- Заполнение справочника услуг
-- =========================================================
INSERT INTO services (service_name, price) VALUES
('Трансфер', 50.00),
('Страхование', 25.00),
('Экскурсионное сопровождение', 120.00),
('VIP-обслуживание', 300.00);

-- =========================================================
-- Заполнение таблицы заказов
-- =========================================================
INSERT INTO tour_orders
(
    client_full_name,
    client_phone,
    email,
    order_date,
    departure_date,
    tourists_count,
    country_id,
    tour_type_id,
    service_id,
    total_cost,
    comment
)
VALUES
('Иванов Иван Иванович', '+7-900-111-22-33', 'ivanov@mail.ru', '2026-07-01', '2026-08-10', 2, 1, 1, 1, 145000.00, 'Номер с видом на море'),
('Петрова Анна Сергеевна', '+7-900-222-33-44', 'petrova@mail.ru', '2026-07-03', '2026-09-05', 1, 2, 2, 3, 98000.00, 'Нужен русскоязычный гид'),
('Смирнов Алексей Петрович', '+7-900-333-44-55', 'smirnov@mail.ru', '2026-07-05', '2026-12-15', 4, 3, 1, 2, 210000.00, 'Семейный отдых'),
('Кузнецова Мария Олеговна', '+7-900-444-55-66', 'kuznetsova@mail.ru', '2026-07-08', '2026-10-20', 2, 4, 2, 3, 175000.00, 'Экскурсионная программа по музеям'),
('Васильев Дмитрий Андреевич', '+7-900-555-66-77', 'vasiliev@mail.ru', '2026-07-10', '2026-11-01', 3, 5, 4, 4, 320000.00, 'Премиум-тур с повышенным комфортом');