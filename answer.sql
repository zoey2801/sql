#create window row_number grouped by customer_name. 
WITH
c4 
AS
(SELECT *,
Row_number() OVER (PARTITION BY customer_name Order by transaction_time ASC) as rank1
FROM customer_transactions),


#Join with itself using the row_number row
c5
AS
(SELECT t1.customer_name, t1.transaction_time, t2.transaction_time, ABS(ROUND((JULIANDAY(t1.transaction_time)-JULIANDAY(t2.transaction_time))*86400))  as result
FROM c4 t1
JOIN c4 t2
ON t1.rank1 + 1 = t2.rank1 AND t1.customer_name = t2.customer_name)

#needs adjusts
SELECT customer_name
FROM c5
GROUP BY customer_name
HAVING SUM(result/10) = count(customer_name)
