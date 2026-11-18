import pandas as pd
import sqlite3
import matplotlib.pyplot as plt
import seaborn as sns
import os

# ==========================================
# 1. СОЗДАНИЕ БАЗЫ ДАННЫХ (если ее еще нет)
# ==========================================
db_name = 'olist.db'

if not os.path.exists(db_name):
    print("Создаем базу данных olist.db...")
    conn = sqlite3.connect(db_name)
    
    # Загружаем CSV-файлы (убедитесь, что они лежат в папке с проектом)
    orders = pd.read_csv('olist_orders_dataset.csv')
    items = pd.read_csv('olist_order_items_dataset.csv')
    products = pd.read_csv('olist_products_dataset.csv')
    
    # Записываем в базу
    orders.to_sql('orders', conn, if_exists='replace', index=False)
    items.to_sql('order_items', conn, if_exists='replace', index=False)
    products.to_sql('products', conn, if_exists='replace', index=False)
    
    conn.close()
    print("База данных успешно создана!")
else:
    print("База данных olist.db уже существует. Пропускаем создание.")

# ==========================================
# 2. ВЫПОЛНЕНИЕ SQL-ЗАПРОСА ИЗ PYTHON
# ==========================================
print("\nВыполняем SQL-запрос...")
conn = sqlite3.connect(db_name)

# Добавлен фильтр WHERE p.product_category_name IS NOT NULL,
# чтобы пустые категории не попадали в топ и не искажали выручку.
query = """
SELECT
    p.product_category_name AS category,
    SUM(oi.price) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
WHERE p.product_category_name IS NOT NULL
GROUP BY p.product_category_name
ORDER BY revenue DESC
LIMIT 10;
"""

# Загружаем результат в DataFrame
df_top_categories = pd.read_sql_query(query, conn)
conn.close()

# Делаем названия категорий читаемыми (заменяем подчеркивания на пробелы)
df_top_categories['category'] = df_top_categories['category'].str.replace('_', ' ')

print("Топ-10 категорий по выручке:")
print(df_top_categories)

# Сохраняем для DataLens
df_top_categories.to_csv('top_categories.csv', index=False)
print("\nДанные для DataLens сохранены в top_categories.csv")

# ==========================================
# 3. ВИЗУАЛИЗАЦИЯ (matplotlib/seaborn)
# ==========================================
print("\nСтроим график...")
plt.figure(figsize=(10, 6))

# Убран FutureWarning: добавлены hue='category' и legend=False
sns.barplot(
    x='revenue', 
    y='category', 
    data=df_top_categories, 
    hue='category',
    palette='viridis',
    legend=False
)

plt.title('Топ-10 категорий по выручке (SQL + Python)')
plt.xlabel('Выручка (BRL)')
plt.ylabel('Категория')
plt.tight_layout()

# Сохраняем график как картинку для README
plt.savefig('top_categories_plot.png', dpi=100)
plt.show()
print("График сохранен в top_categories_plot.png")
