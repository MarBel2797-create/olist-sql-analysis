```sql
-- ============================================
-- Проект: Анализ данных интернет-магазина Olist
-- Автор: Марина Белова
-- ============================================

-- Задача 1. Топ-10 категорий товаров по выручке
SELECT
    p.product_category_name,
    SUM(oi.price) AS total_revenue
FROM olist_order_items_dataset oi
JOIN olist_products_dataset p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC
LIMIT 10;

-- Задача 2. Динамика выручки по месяцам
SELECT
    STRFTIME('%Y-%m', o.order_purchase_timestamp) AS month,
    SUM(oi.price) AS revenue
FROM olist_orders_dataset o
JOIN olist_order_items_dataset oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
  AND o.order_purchase_timestamp >= '2017-01-01'
  AND o.order_purchase_timestamp < '2018-09-01'
GROUP BY month
ORDER BY month;

-- Задача 3. Средний чек по штатам
SELECT
    c.customer_state AS state,
    SUM(oi.price) AS total_revenue,
    COUNT(DISTINCT o.order_id) AS orders_count,
    ROUND(SUM(oi.price) / COUNT(DISTINCT o.order_id), 2) AS avg_check
FROM olist_orders_dataset o
JOIN olist_customers_dataset c
    ON o.customer_id = c.customer_id
JOIN olist_order_items_dataset oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY avg_check DESC;

-- Задача 4. Топ-5 продавцов по количеству заказов
SELECT
    s.seller_id,
    s.seller_city,
    s.seller_state,
    COUNT(DISTINCT oi.order_id) AS orders_count
FROM olist_order_items_dataset oi
JOIN olist_sellers_dataset s
    ON oi.seller_id = s.seller_id
GROUP BY s.seller_id, s.seller_city, s.seller_state
ORDER BY orders_count DESC
LIMIT 5;

-- Задача 5. Время доставки по штатам
SELECT
    c.customer_state AS state,
    ROUND(AVG(
        JULIANDAY(o.order_delivered_customer_date) -
        JULIANDAY(o.order_purchase_timestamp)
    ), 1) AS avg_delivery_days
FROM olist_orders_dataset o
JOIN olist_customers_dataset c
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY avg_delivery_days DESC;

-- Задача 6. Доля заказов с оценкой 5 и 1 звезда
SELECT
    ROUND(100.0 * SUM(CASE WHEN review_score = 5 THEN 1 ELSE 0 END) / COUNT(*), 2) AS percent_5_stars,
    ROUND(100.0 * SUM(CASE WHEN review_score = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS percent_1_star,
    COUNT(*) AS total_reviews
FROM olist_order_reviews_dataset;
```
