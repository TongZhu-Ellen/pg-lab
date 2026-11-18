-- ==========================================
-- PostgreSQL Backend Engineering Lab
-- init.sql
-- ==========================================

BEGIN;

-- 1. Users
CREATE TABLE users (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, -- id / BIGINT / GENERATED ALWAYS （generate规则是什么：AS IDENTITY / PRIMARY KEY
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 2. Products
CREATE TABLE products (
    id BIGINT     GENERATED ALWAYS AS IDENTITY     PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    sku VARCHAR(100) NOT NULL UNIQUE,
    price NUMERIC(10, 2) NOT NULL CHECK (price > 0),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 3. Orders
CREATE TABLE orders (
    id BIGINT      GENERATED ALWAYS AS IDENTITY      PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    status VARCHAR(20) NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending', 'paid', 'shipped', 'completed', 'cancelled')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 4. Order Items
CREATE TABLE order_items (
    id BIGINT       GENERATED ALWAYS AS IDENTITY     PRIMARY KEY,
    order_id BIGINT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id BIGINT NOT NULL REFERENCES products(id) ON DELETE RESTRICT,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10, 2) NOT NULL CHECK (unit_price > 0),
    UNIQUE (order_id, product_id)
);

-- 5. Payments
CREATE TABLE payments (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id BIGINT NOT NULL REFERENCES orders(id) ON DELETE RESTRICT,
    amount NUMERIC(10, 2) NOT NULL CHECK (amount > 0),
    status VARCHAR(20) NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending', 'succeeded', 'failed', 'refunded')),
    provider_reference VARCHAR(100) UNIQUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- ==========================================
-- Sample Data
-- ==========================================

-- Users
INSERT INTO users (name, email) VALUES
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com'),
('Charlie', 'charlie@example.com');

-- Products
INSERT INTO products (name, sku, price) VALUES
('The Legend of Zelda 20th Anniversary T-Shirt', 'ZELDA20THAN-TS-RED-L', 65.00),
('Screte to LeetCoding Ver.1', 'SC-TO-LC-V1', 20.00),
('Intro to Operating System Vol.1', 'OSPP-V1', 98.00),
('Human Biology', 'BIO-XYZ', 98.00);


-- orders
INSERT INTO orders (user_id, status) VALUES
(1, 'paid'),
(2, 'shipped'),
(3, 'pending');


-- 订单明细
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 3, 1, 98.00),
(1, 2, 2, 20.00),
(2, 1, 1, 65.00),
(2, 4, 1, 98.00),
(3, 2, 1, 20.00);




COMMIT;


