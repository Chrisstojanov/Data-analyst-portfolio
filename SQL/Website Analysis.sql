ANALYZING WEBSITE PERFORMANCE

--Pageview counts 
select pageview_url,
count(distinct website_pageview_id) as PVS 
from website_pageviews
where website_pageview_id < 1000
group by pageview_url
order by pvs DESC 


--How are visitors landing on the website most often?

create temporary table first_pageview
select 
	website_session_id,
    min(website_pageview_id) AS min_pv_id
from website_pageviews
where website_pageview_id < 1000
group by website_session_id


SELECT 
    website_pageviews.pageview_url AS landing_page,
    COUNT(DISTINCT first_pageview.website_session_id) AS sessions_hitting_this_lander
FROM
    first_pageview
        LEFT JOIN
    website_pageviews ON first_pageview.min_pv_id = website_pageview_id
GROUP BY website_pageviews.pageview_url
--Every visitor accessing website from homepage

--Most viewed website pages by session volume
SELECT 
    pageview_url, 
	COUNT(DISTINCT website_pageview_id) AS pvs
FROM
    website_pageviews
WHERE
    created_at < '2012-06-09'
GROUP BY pageview_url
ORDER BY pvs DESC


--Top landing pages  ranked on entry volume

create temporary table first_pv_per_session
select 
	website_session_id,
    min(website_pageview_id) AS first_pv
FROM
	website_pageviews
WHERE created_at < '2012-06-12'
GROUP BY website_session_id


SELECT 
    website_pageviews.pageview_url AS landing_page_url,
    COUNT(DISTINCT first_pv_per_session.website_session_id) AS sessions_hitting_page
FROM
    first_pv_per_session
        LEFT JOIN
    website_pageviews ON first_pv_per_session.first_pv = website_pageviews.website_pageview_id
GROUP BY website_pageviews.pageview_url