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
LIMIT 10

Результат:

Категория                 Выручка (BRL)
beleza_saude                1 258 681
relogios_presentes.         1 205 006
cama_mesa_banho.            1 036 989
esporte_lazer                 988 049
informatica_acessorios.       911 954
moveis_decoracao              729 762
cool_stuff                    635 291
utilidades_domesticas         632 249
automotivo      т.            592 720
ferramentas_jardim.           485 256

Вывод: Категории «Красота и здоровье» и «Часы и подарки» —
лидеры по выручке. Это ключевые направления для инвестиций в маркетинг.

### Задача 2. Динамика выручки по месяцам

**SQL-запрос:**
```sql

SELECT
    STRFTIME('%Y-%m', o.order_purchase_timestamp) AS month,
    SUM(oi.price) AS product_revenue,
    SUM(oi.freight_value) AS freight_revenue,
    SUM(oi.price + oi.freight_value) AS total_revenue
FROM olist_orders_dataset o
JOIN olist_order_items_dataset oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
  AND o.order_purchase_timestamp >= '2017-01-01'
  AND o.order_purchase_timestamp < '2018-09-01'
GROUP BY month
ORDER BY month

Результат:

month   product_revenue	 freight_revenue  	total_revenue
2017-01	      111798.36	        15684.01      	127482.37
2017-02	       234223.4       	37015.92	      271239.32
2017-03	359198.85	55132.1	414330.95
2017-04	340669.68	50142.72	390812.4
2017-05	489338.25	77513.15	566851.4
2017-06	421923.37	68127.0	490050.37
2017-07	481604.52	84694.56	566299.08
2017-08	554699.7	91132.66	645832.36
2017-09	607399.67	93677.82	701077.49
2017-10	648247.65	102869.36	751117.01
2017-11	987765.37	165598.83	1153364.2
2017-12	726033.19	117045.1	843078.29
2018-01	924645.0	153242.46	1077887.46
2018-02	826437.13	139731.28	966168.41
2018-03	953356.25	167241.99	1120598.24
2018-04	973534.09	159344.84	1132878.93
2018-05	977544.69	151229.83	1128774.52
2018-06	856077.86	155900.43	1011978.29
2018-07	867953.46	159853.82	1027807.28
2018-08	838576.64	146915.0	985491.64



