```
Adam Hendel
SQL Query to identify days with unusually large sales quantities

Assumptions:
1) We are ignoring any seasonality, trend, and cyclical trends in the data
2) Large outliers in 'Quantity', defined as 2 x standard deviation,
   are considered "unusually large"-thus assuming a normal distribution
3) Entries with negative quantity values are assumed to be product returns or error-these
      sales are calculated net of their returns.
4) Not correcting for duplicate entries
```

SELECT to_char(t1.InvoiceDate,'YYYY-MM-DD') AS dt1, sum(t1.Quantity) AS daily_qty_sold
FROM purchases t1,
	(SELECT avg(t2.daily_sum) AS xbar, STDDEV_POP(t2.daily_sum) AS sigma
	 FROM (
     SELECT to_char(InvoiceDate,'YYYY-MM-DD') AS dt, sum(Quantity) AS daily_sum
		 FROM purchases
		 WHERE Quantity > 0
		 GROUP BY dt
		 ORDER BY dt
   ) t2
 ) t3
WHERE Quantity > 0
GROUP BY dt1, t3.xbar, t3.sigma
HAVING (sum(t1.Quantity)-t3.xbar)/nullif(t3.sigma,0) > 2

```
Results:
1) 2011-01-18 and 2011-12-09 had 83k and 94k sales
1a) majority of these sales were 'returned'
2) 2011-10-05 and 2011-11-15 each had approx 46k-47k of sales quantities
```
