# Анализ данных интернет-магазина Olist (SQL)

Проект по анализу реальных данных бразильского маркетплейса Olist.
С помощью SQL-запросов исследованы продажи, категории товаров,
география клиентов и динамика выручки.

## 🎯 Задачи проекта

1. Топ-10 категорий товаров по выручке.
2. Динамика выручки по месяцам.
3. Средний чек по штатам.
4. Топ-5 продавцов по количеству заказов.
5. Время доставки по штатам.
6. Доля заказов с оценкой 5 и 1 звезда.

## 🛠️ Инструменты

- SQL (SQLite)
- DB Browser for SQLite
- Данные: Brazilian E-Commerce Public Dataset by Olist (Kaggle)

## 📊 Результаты

### Задача 1. Топ-10 категорий по выручке

**SQL-запрос:**
```sql
SELECT
    p.product_category_name,
    SUM(oi.price) AS total_revenue
FROM olist_order_items_dataset oi
JOIN olist_products_dataset p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC
LIMIT 10;
