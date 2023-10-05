1.WHAT IS THE TOTAL AMOUNT EACH CUSTOMER SPENT AT THE RESTAURANT?

select customer_id, Sum(price) as total_spend from dannys_diner.sales as S
inner join dannys_diner.menu as M on S.product_id = M.product_id
group by customer_id

2.HOW MANY DAYS HAS EACH CUSTOMER VISITED THE RESTAURANT?

select customer_id, count(distinct order_date) as Visits from dannys_diner.sales
group by customer_id


3.WHAT WAS THE FIRST ITEM FROM THE MENU PURCHASED BY EACH CUSTOMER?

with cte AS(
select customer_id, 
order_date, 
product_name,
rank() over(
			partition by customer_id 
			ORDER BY  order_date asc) as rnk
from dannys_diner.sales as S
inner join dannys_diner.menu as M on S.product_id =  M.product_id)

select * from CTE
where rnk = 1

4.WHAT IS THE MOST PURCHASED ITEM ON THE MENU AND HOW MANY TIMES WAS IT PURCHASED BY ALL CUSTOMERS?

select product_name, count(order_date) as orders
from dannys_diner.sales as S
inner join dannys_diner.menu as M on S.product_id = M.product_id
group by product_name
order by count(order_date) desc
limit 1

5.WHICH ITEM WAS THE MOST POPULAR FOR EACH CUSTOMER?

with cte as (
	select 
	product_name,
	customer_id,
	rank () over (partition by customer_id order by  count(order_date) desc) as rnk
	from dannys_diner.sales as S
	inner join dannys_diner.menu as M on S.product_id = M.product_id 
	group by product_name,customer_id
)
select 
customer_id,
product_name 
from cte
where rnk = 1


6.WHICH ITEM WAS PURCHASED FIRST BY THE CUSTOMER AFTER THEY BECAME A MEMBER?
7.WHICH ITEM WAS PURCHASED JUST BEFORE THE CUSTOMER BECAME A MEMBER?
8.WHAT IS THE TOTAL ITEMS AND AMOUNT SPENT FOR EACH MEMBER BEFORE THEY BECAME A MEMBER?
9.IF EACH $1 SPENT EQUATES TO 10 POINTS AND SUSHI HAS A 2X POINTS MULTIPLIER - HOW MANY POINTS WOULD EACH CUSTOMER HAVE?
10.IN THE FIRST WEEK AFTER A CUSTOMER JOINS THE PROGRAM (INCLUDING THEIR JOIN DATE) THEY EARN 2X POINTS ON ALL ITEMS, 
NOT JUST SUSHI - HOW MANY POINTS DO CUSTOMER A AND B HAVE AT THE END OF JANUARY?