-- 1. Count total number of clients
-- Why: Understand customer base size
SELECT COUNT(*) AS total_clients FROM clients;

-- 2. Find the number of transactions per client
-- Why: See engagement frequency per user
SELECT client_id, COUNT(*) AS total_transactions
FROM transactions
GROUP BY client_id;

-- 3. List the top 5 cities with the highest number of clients
-- Why: Identify geographic customer concentration
SELECT city, COUNT(*) AS num_clients
FROM clients
GROUP BY city
ORDER BY num_clients DESC
LIMIT 5;

-- 4. Count how many clients signed up each month
-- Why: Analyze acquisition trends over time
SELECT DATE_TRUNC('month', registration_date) AS month, COUNT(*) AS signups
FROM clients
GROUP BY month
ORDER BY month;

-- 5. Find the average time gap between transactions for each client
-- Why: Estimate customer visit cycles
SELECT client_id,
       AVG(DATE_PART('day', LEAD(transaction_date) OVER (PARTITION BY client_id ORDER BY transaction_date) - transaction_date)) AS avg_gap_days
FROM transactions;

-- 6. Identify clients who haven’t purchased in the last 90 days
-- Why: Spot potential churned customers
SELECT client_id
FROM transactions
GROUP BY client_id
HAVING MAX(transaction_date) < CURRENT_DATE - INTERVAL '90 days';

-- 7. Determine average basket size (items per transaction)
-- Why: Helps understand per-visit spend and behavior
SELECT AVG(items_count) AS avg_basket_size FROM transactions;

-- 8. Compare transaction volume between weekdays and weekends
-- Why: Find optimal promotion times
SELECT 
  CASE WHEN EXTRACT(DOW FROM transaction_date) IN (0,6) THEN 'Weekend' ELSE 'Weekday' END AS day_type,
  COUNT(*) AS num_transactions
FROM transactions
GROUP BY day_type;

-- 9. Top 10 most frequently bought items
-- Why: Know popular inventory for marketing and stocking
SELECT item_id, COUNT(*) AS frequency
FROM transaction_items
GROUP BY item_id
ORDER BY frequency DESC
LIMIT 10;

-- 10. Clients who refer the most new clients
-- Why: Reward brand ambassadors
SELECT referred_by AS referrer, COUNT(*) AS referrals
FROM clients
WHERE referred_by IS NOT NULL
GROUP BY referrer
ORDER BY referrals DESC
LIMIT 10;

-- 11. Detect Repeat Buyers vs One-time Buyers
-- Why: Segment customers for retention strategies
SELECT client_id,
       COUNT(DISTINCT transaction_id) AS transaction_count,
       CASE
         WHEN COUNT(DISTINCT transaction_id) = 1 THEN 'One-time Buyer'
         ELSE 'Repeat Buyer'
       END AS buyer_type
FROM transactions
GROUP BY client_id;

-- 12. Customer churn probability (basic heuristic)
-- Why: Preemptively act on at-risk customers
SELECT client_id,
       MAX(transaction_date) AS last_purchase,
       CURRENT_DATE - MAX(transaction_date) AS days_since_last,
       CASE 
         WHEN CURRENT_DATE - MAX(transaction_date) > 180 THEN 'High Risk'
         WHEN CURRENT_DATE - MAX(transaction_date) > 90 THEN 'Moderate Risk'
         ELSE 'Low Risk'
       END AS churn_risk
FROM transactions
GROUP BY client_id;

-- 13. Segment customers by lifetime value (LTV)
-- Why: Focus marketing on high-value users
SELECT client_id, 
       SUM(total_amount) AS total_spent,
       CASE
         WHEN SUM(total_amount) > 1000 THEN 'High Value'
         WHEN SUM(total_amount) BETWEEN 500 AND 1000 THEN 'Mid Value'
         ELSE 'Low Value'
       END AS ltv_segment
FROM transactions
GROUP BY client_id;

-- 14. Monthly cohort analysis - retention
-- Why: Evaluate customer loyalty per signup month
WITH cohort AS (
  SELECT client_id, MIN(transaction_date) AS first_purchase
  FROM transactions
  GROUP BY client_id
),
activity AS (
  SELECT t.client_id, t.transaction_date, DATE_TRUNC('month', t.transaction_date) AS activity_month
  FROM transactions t
),
joined AS (
  SELECT c.client_id,
         DATE_TRUNC('month', c.first_purchase) AS cohort_month,
         a.activity_month
  FROM cohort c
  JOIN activity a ON c.client_id = a.client_id
)
SELECT cohort_month, activity_month, COUNT(DISTINCT client_id) AS active_users
FROM joined
GROUP BY cohort_month, activity_month
ORDER BY cohort_month, activity_month;

-- 15. Top 5 stores with highest client retention rate
-- Why: Benchmark store performance on customer loyalty
WITH first_last AS (
  SELECT client_id, store_id,
         MIN(transaction_date) AS first_txn,
         MAX(transaction_date) AS last_txn
  FROM transactions
  GROUP BY client_id, store_id
)
SELECT store_id,
       COUNT(*) FILTER (WHERE first_txn != last_txn) * 1.0 / COUNT(*) AS retention_rate
FROM first_last
GROUP BY store_id
ORDER BY retention_rate DESC
LIMIT 5;

-- 16. Detect dormant customers who were previously active
-- Why: Identify lost high-value customers to target re-engagement campaigns
WITH active_periods AS (
  SELECT client_id,
         DATE_TRUNC('month', transaction_date) AS txn_month,
         COUNT(*) AS txn_count
  FROM transactions
  GROUP BY client_id, txn_month
),
recent_months AS (
  SELECT generate_series(
    DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '12 months',
    DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '1 month',
    '1 month'
  )::date AS txn_month
)
SELECT a.client_id
FROM active_periods a
JOIN recent_months r ON a.txn_month = r.txn_month
GROUP BY a.client_id
HAVING COUNT(*) >= 6 -- Was active in at least 6 of last 12 months
   AND MAX(a.txn_month) < CURRENT_DATE - INTERVAL '90 days';

-- 17. Find customers who shifted loyalty (purchased in a new store after 3 months absence from previous store)
-- Why: Detect customer attrition at store level
WITH ranked_txns AS (
  SELECT client_id, store_id, transaction_date,
         LAG(store_id) OVER (PARTITION BY client_id ORDER BY transaction_date) AS prev_store,
         LAG(transaction_date) OVER (PARTITION BY client_id ORDER BY transaction_date) AS prev_date
  FROM transactions
)
SELECT *
FROM ranked_txns
WHERE store_id != prev_store AND transaction_date - prev_date > INTERVAL '90 days';

-- 18. Identify high-frequency buyers who only purchase low-ticket items
-- Why: Spot up-sell opportunities
SELECT t.client_id, COUNT(*) AS txn_count, AVG(t.total_amount) AS avg_spent
FROM transactions t
GROUP BY t.client_id
HAVING COUNT(*) > 10 AND AVG(t.total_amount) < 20;

-- 19. Calculate Customer Lifetime Value over time windows
-- Why: Evaluate how customer value grows over 6, 12, 24 months
WITH first_purchase AS (
  SELECT client_id, MIN(transaction_date) AS start_date
  FROM transactions
  GROUP BY client_id
),
ltv_windowed AS (
  SELECT t.client_id,
         CASE 
           WHEN t.transaction_date <= f.start_date + INTERVAL '6 months' THEN '0-6 months'
           WHEN t.transaction_date <= f.start_date + INTERVAL '12 months' THEN '6-12 months'
           ELSE '12+ months'
         END AS ltv_window,
         SUM(t.total_amount) AS amount
  FROM transactions t
  JOIN first_purchase f ON t.client_id = f.client_id
  GROUP BY t.client_id, ltv_window
)
SELECT ltv_window, AVG(amount) AS avg_ltv
FROM ltv_windowed
GROUP BY ltv_window;

-- 20. Basket affinity analysis - frequently bought together items
-- Why: Power cross-sell strategies and bundle offers
SELECT item_id, related_item_id, COUNT(*) AS pair_count
FROM (
  SELECT transaction_id, item_id
  FROM transaction_items
) t1
JOIN (
  SELECT transaction_id, item_id AS related_item_id
  FROM transaction_items
) t2
ON t1.transaction_id = t2.transaction_id AND t1.item_id < t2.related_item_id
GROUP BY item_id, related_item_id
ORDER BY pair_count DESC
LIMIT 20;

