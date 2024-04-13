-- Order Activity
SELECT
o.order_id,
i.item_price,
o.quantity,
i.item_cat,
i.item_name,
o.created_dt,
a.delivery_address1,
a.delivery_address2,
a.delivery_city,
a.delivery_zipcode,
o.delivery
FROM
Orders as o
LEFT JOIN Items as i ON o.item_id = i.item_id
LEFT JOIN Address as a ON o.addr_id = a.addr_id;


-- Inventory Management
CREATE VIEW Stock1 AS 
SELECT 
s1.item_name,
s1.ing_id,
s1.ing_name,
s1.ing_weight,
s1.ing_price,
s1.order_quantity,
s1.recipe_quantity,
s1.order_quantity * s1.recipe_quantity as ordered_weight,
s1.ing_price / s1.ing_weight as unit_cost,
(s1.order_quantity * s1.recipe_quantity) * (s1.ing_price / s1.ing_weight) as ingredient_cost
FROM 
(SELECT
o.item_id,
i.sku,
i.item_name,
r.ing_id,
ing.ing_name,
r.quantity as recipe_quantity,
sum(o.quantity) as order_quantity,
ing.ing_weight,
ing.ing_price
FROM
Orders as o
LEFT JOIN Items as i ON o.item_id = i.item_id
LEFT JOIN Recipe as r ON i.sku = r.recipe_id
LEFT JOIN Ingredients as ing ON r.ing_id = ing.ing_id
GROUP BY 
o.item_id, 
i.sku, 
i.item_name,
r.ing_id,
r.quantity,
ing.ing_name,
ing.ing_weight,
ing.ing_price) s1;


SELECT
s2.ing_name,
s2.ordered_weight,
ing.ing_weight * inv.quantity as total_inv_weight,
(ing.ing_weight * inv.quantity) - s2.ordered_weight as remaining_weight
FROM
(SELECT
ing_id,
ing_name,
sum(ordered_weight) as ordered_weight
FROM
Stock1
GROUP BY ing_name, ing_id) s2
LEFT JOIN Inventory as inv ON inv.item_id = s2.ing_id
LEFT JOIN Ingredients as ing ON ing.ing_id = s2.ing_id;