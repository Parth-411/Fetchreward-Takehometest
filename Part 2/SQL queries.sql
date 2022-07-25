-- #Q1 What are the top 5 brands by receipts scanned for most recent month?

with top5 as (
SELECT b.brandId as brand_id, i.receiptId as receipt_id, b.name, count(i.receiptId) as total_receipt, (strftime('%Y',i.dateScanned)) as "Year", (strftime('%m',i.dateScanned)) as "Month"  
from items as i
left join brands as b on i.brandCode = b.brandCode 
where Month = '03' and Year = '2021'
group by 1,3
order by receipt_id
Limit 5)

SELECT * from top5;

-- #Q2 How does the ranking of the top 5 brands by receipts scanned for the recent month compare to the ranking for the previous month?

with top5 as (
SELECT b.brandId as brand_id, i.receiptId as receipt_id, b.name, count(i.receiptId) as total_receipt, (strftime('%Y',i.dateScanned)) as "Year", (strftime('%m',i.dateScanned)) as "Month", RANK() OVER (ORDER BY COUNT(i.receiptId) desc) as rnk  
from items as i
left join brands as b on i.brandCode = b.brandCode
where Month = '03' and Year = '2021'
group by 1,3
order by total_receipt desc
Limit 5),

top5_prev as (
SELECT b.brandId as brand_id, i.receiptId as receipt_id, b.name, count(i.receiptId) as total_receipt, (strftime('%Y',i.dateScanned)) as "Year", (strftime('%m',i.dateScanned)) as "Month", RANK() OVER (ORDER BY COUNT(i.receiptId) desc) as rnk  
from items as i
left join brands as b on i.brandCode = b.brandCode
where Month = '02' and Year = '2021'
group by 1,3
order by total_receipt desc)


SELECT t.brand_id, t.total_receipt as total_count , t.rnk as current_rank, p.total_receipt as total_count_prev, p.rnk as previous_rank
from top5 t
left join top5_prev p on t.brand_id = p.brand_id;


-- #Q3 When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?

SELECT AVG(COALESCE(totalSpent,0)) as Average_spend, rewardsReceiptStatus
from receipts
group by rewardsReceiptStatus

-- Accepted uis greater

-- #Q4 When considering total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?

SELECT SUM(COALESCE(purchasedItemCount , 0 )) as total_items, rewardsReceiptStatus
from receipts
group by rewardsReceiptStatus

-- Accepted count of total items in higher

-- #Q5 Which brand has the most spend among users who were created within the past 6 months?

SELECT b.brandCode, b.name, SUM(r.totalSpent) as total_spend
FROM brands as b
LEFT JOIN items as i on i.brandCode = b.brandCode
LEFT JOIN receipts as r ON i.receiptId = r.receiptId
WHERE r.userId IN (SELECT userId FROM users WHERE (strftime('%Y',createdDate)) = 2021 AND (strftime('%M',createdDate)) IN (1, 2, 3)
OR (strftime('%Y',createdDate)) = 2020 AND (strftime('%M',createdDate)) IN (9, 10, 11, 12)) 
GROUP BY b.brandCode 
ORDER BY total_spend DESC;

-- #Q6 Which brand has the most transactions among users who were created within the past 6 months?

SELECT b.brandCode, b.name, b.barcode, COUNT(r.receiptId) as receipt_count
FROM brands as b
LEFT JOIN items as i on i.brandCode = b.brandCode
LEFT JOIN receipts as r ON i.receiptId = r.receiptId
WHERE r.userId IN (SELECT userId FROM users WHERE (strftime('%Y',createdDate)) = 2021 AND (strftime('%M',createdDate)) IN (1, 2, 3)
OR (strftime('%Y',createdDate)) = 2020 AND (strftime('%M',createdDate)) IN (9, 10, 11, 12)) 
GROUP BY b.brandCode 
ORDER BY receipt_count DESC;