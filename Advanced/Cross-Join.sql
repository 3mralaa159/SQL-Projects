-- Write a query to get information about products that have not been sold at any stores or are out of stock (quantity = 0), results should return store name and product name.
-- CROSS JOIN: Generates all possible combinations
-- Prepare query matching your final result , cross join , filter by the join 

SELECT distinct
    p.product_name, 
    s.store_name 
FROM 
    production.products p
CROSS JOIN 
    sales.stores s
LEFT JOIN 
    production.stocks st ON p.product_id = st.product_id AND s.store_id = st.store_id
LEFT JOIN 
    sales.order_items oi ON p.product_id = oi.product_id
LEFT JOIN 
    sales.orders o ON oi.order_id = o.order_id AND o.store_id = s.store_id
WHERE 
    (st.quantity = 0 OR st.quantity IS NULL) 
    and o.order_id IS NULL;

----- or using Exists
	SELECT 
    p.product_name, 
    s.store_name 
FROM 
    production.products p
CROSS JOIN 
    sales.stores s
WHERE 
    NOT EXISTS (
        SELECT 1 
        FROM production.stocks st 
        WHERE st.product_id = p.product_id 
          AND st.store_id = s.store_id 
          AND st.quantity > 0
    )
    AND NOT EXISTS (
        SELECT 1 
        FROM sales.order_items oi
        JOIN sales.orders o ON oi.order_id = o.order_id
        WHERE oi.product_id = p.product_id 
          AND o.store_id = s.store_id
    );
