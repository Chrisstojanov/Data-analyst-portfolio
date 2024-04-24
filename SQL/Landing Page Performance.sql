LANDING PAGE PERFORMANCE & TESTING
--COMMON USE  CASES

--Identifying your top opportunities for landing pages- high volume pages with higher than 
--expected bounce rates or low conversion rates.

--Setting up A/B experiments on your live traffic to see if you can improve your bounce rates and conversion rates.

--Analyzing test results and making recommendations on which version of landing pages you should use going forward.

LANDING PAGE PERFORMANCE

-- created temporary table for  count of sessions  for each landing page(sessions_landing_page_count)
create temporary table sessions_landing_page_count
SELECT 
    website_session_id,
    pageview_url as landing_page,
    count(website_pageview_id) as Count_of_pages_viewed
FROM
    website_pageviews
WHERE
	created_at BETWEEN '2014-01-01' AND '2014-02-01'
GROUP BY
website_session_id

-- created temporary table for count of sessions = 1 for each landing page (bounced_pages)
create temporary table Bounced_pages
SELECT 
    website_session_id,
    pageview_url as landing_page,
    count(website_pageview_id) as Count_of_pages_viewed
FROM
    website_pageviews
WHERE
	created_at BETWEEN '2014-01-01' AND '2014-02-01'
GROUP BY
website_session_id
HAVING
	COUNT(website_pageview_id) = 1
	
	
-- joined together on website_session_id_column. Created Bounce_rate for each landing_page. (Bounced_sessions/Sessions)	
	select 
	sessions_landing_page_count.landing_page,
	Count(sessions_landing_page_count.website_session_id) as Sessions,
    count(bounced_pages.website_session_id) as Bounced_sessions,
    count(bounced_pages.website_session_id) / Count(sessions_landing_page_count.website_session_id) as Bounce_rate
from sessions_landing_page_count
	left join bounced_pages
    on sessions_landing_page_count.website_session_id = bounced_pages.website_session_id
group by 
	sessions_landing_page_count.landing_page
Order by
	Bounce_rate desc
	
 