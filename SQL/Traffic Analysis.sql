ANALYZING TRAFFIC SOURCES

---Where are bulk website sessions coming from through 04-12-2012
SELECT 
    utm_source,
    utm_campaign,
    http_referer,
    COUNT(DISTINCT website_session_id) AS sessions
FROM
    website_sessions
WHERE
    created_at < '2012-04-12'
GROUP BY utm_source , utm_campaign , http_referer
ORDER BY sessions DESC
--Most sessions, 3613, coming through from utm_source gsearch, utm_campaign nonbrand 

---Calculate conversion rate(CVR) from session to order for utm_source gsearch and utm_campaign nonbrand.
SELECT 
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS Orders,
    COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id) AS Session_to_order_CVR
FROM
    website_sessions
        LEFT JOIN
    orders ON website_sessions.website_session_id = orders.website_session_id
WHERE
    website_sessions.created_at < '2012-04-14'
    AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand'
	
---3895 sessions, 112 orders, conversion rate 2.8%
	
	
--Count of primary product ID by single and two item orders
SELECT 
    primary_product_id,
    COUNT(DISTINCT CASE
            WHEN items_purchased = 1 THEN order_id
            ELSE NULL
        END) AS count_single_item_orders,
    COUNT(DISTINCT CASE
            WHEN items_purchased = 2 THEN order_id
            ELSE NULL
        END) AS count_two_item_orders
FROM
    orders
GROUP BY primary_product_id

--Traffic source volume analysis

SELECT 
    MIN(DATE(created_at)) AS week_start,
    COUNT(DISTINCT website_session_id) AS sessions
FROM
    website_sessions
WHERE
    created_at < '2012-05-10'
        AND utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand'
GROUP BY YEAR(created_at) , WEEK(created_at)

--conversion rates from session to order by device type
SELECT 
    device_type,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS Orders,
    COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id) AS Session_to_order_CVR
FROM
    website_sessions
        LEFT JOIN
    orders ON website_sessions.website_session_id = orders.website_session_id
     WHERE
    website_sessions.created_at < '2012-05-11'
    AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand'
GROUP BY 1
---conversion rate on  mobile orders is less than 1 percent, desktop orders are 3.7%
---increase bids on desktop traffic to lead to a sales boost


--weekly trends for desktop and mobile to see impact on volume after bid changes
SELECT 
     MIN(DATE(created_at)) AS week_start,
    count(distinct case when device_type = 'desktop' then website_session_id else null end) as dtop_sessions,
    count(distinct case when device_type = 'mobile' then website_session_id else null end) as mob_sessions
FROM
    website_sessions
WHERE
	created_at < '2012-06-09'
    AND created_at > '2012-04-15'
    AND utm_source = 'gsearch'
	AND utm_campaign = 'nonbrand'
GROUP BY
	Year(created_at),
    week(created_at)
	
	
