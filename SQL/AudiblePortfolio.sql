Data Cleaning an Audible dataset


--REMOVE "WRITTENBY:" FROM AUTHOR COLUMN; 

alter table audible add column new_author varchar(250)

UPDATE Audible
SET new_author = substring(author, 11)
where author like 'Writtenby:%'

--REMOVE "NARRATEDBY:" FROM NARRATOR COLUMN;

alter table audible add column new_narrator varchar(250)

UPDATE Audible
SET new_narrator = substring(narrator, 12)
where narrator like 'Narratedby%'


--CHANGE PRICE FROM INDIAN RUPEES TO USD

UPDATE audible
SET price = price / 82.665946;  (current exchange rate 1/5/2023)


--CHANGE TIME FROM HOURS AND MIN TO MINUTES

alter table audible
add column minutes varchar
alter table audible
add column hours VARCHAR

UPDATE audible
SET hours = split_part(time, 'and', 1)
    minutes = split_part(time, 'and', 2);
	
--REMOVE 'MIN' STRING FROM HOURS COLUMN

alter table audible
add column minutes2

UPDATE audible
SET minutes2 = hours
WHERE hours LIKE '%m%';

UPDATE audible 
SET hours = NULL 
WHERE hours LIKE '%mins%';


	
----TRUNCATE LAST 5 CHARACTERS OF MINUTES2, AND MINUTES COLUMN

UPDATE audible
SET minutes = left(minutes, length(minutes) - 5);

----TRUNCATE LAST 4 CHARACTERS OF HOURS COLUMN

UPDATE audible
SET hours = left(hours, length(hours) - 4);

----TRUNCATE LAST 4 CHARACTERS OF MINUTES2 COLUMN
UPDATE audible
SET minutes2 = left(hours, length(hours) - 4);

--CREATE NEW COLUMN "LENGTH"

Query to change hours to min (hours*min) and add to data in minutes column and put into new column called "Length"
Have to change datatypes in hours and minutes first



--CHANGE MIN DATA FROM HOURS COLUMN TO 0

UPDATE audible SET hours = replace(hours,'min','0') WHERE hours LIKE '%min%';

--CHANGING DATATYPES 

ALTER TABLE temptable ALTER COLUMN totalratings TYPE numeric using rating::numeric;

ALTER TABLE temptable ALTER COLUMN rating TYPE double precision USING rating::double precision;

ALTER TABLE temptable ALTER COLUMN hours TYPE numeric using hours::numeric;

alter table temptable alter column minutes type numeric using minutes::numeric;


--SPLITTING STARS COLUMN WITH DELIMITER 'STARS'

ALTER TABLE audible
  ADD COLUMN Rating VARCHAR(255),
ADD COLUMN TotalRatings VARCHAR(255)

UPDATE audible
SET rating = split_part(stars, 'stars', 1),
    totalratings = split_part(stars, 'stars', 2);
	
--CLEANING TOTALRATINGS TO JUST INTEGER

update audible
set totalratings = split_part(totalratings, 'rating', 1)


UPDATE audible 
SET totalratings = 0 WHERE totalratings = '';

--CLEANING RATING TO JUST INTEGER

UPDATE audible 
SET rating = '' WHERE rating = 'Not rated yet';

UPDATE audible 
SET rating = replace(rating, ' out of 5', '');


--REMOVE ALL DATA WITH NO TOTALRATINGS


DELETE FROM audible WHERE totalratings = '0';

--REMOVE ALL LANGUAGES EXCEPT ENGLISH


DELETE FROM audible WHERE language NOT LIKE 'English';


--CLEAN DATASET TO REMOVE MULTIPLE ENTRIES 
--CREATE SERIAL COLUMN


Alter table audible1 add column id serial primary key


-- CREATE A COMMON TABLE EXPRESSION (CTE) CALLED "CTE" THAT IDENTIFIES DUPLICATE ROWS IN THE "AUDIBLE1" TABLE


WITH cte AS (
  -- SELECT THE MINIMUM "ID" VALUE AND ALL OTHER COLUMNS FOR EACH SET OF DUPLICATE ROWS
  SELECT MIN(id) as id, title, time, releasedate, language, price, author, narrator, rating, totalratings, length
  FROM audible1
  -- GROUP THE ROWS BY ALL COLUMNS EXCEPT THE "ID" COLUMN
  GROUP BY title, time, releasedate, language, price, author, narrator, rating, totalratings, length
  -- ONLY INCLUDE GROUPS THAT HAVE MORE THAN ONE ROW (I.E., DUPLICATES)
  HAVING COUNT(*) > 1
)
-- DELETE ROWS FROM THE "AUDIBLE1" TABLE THAT MATCH THE COLUMNS AND VALUES IN THE "CTE" TABLE
-- BUT KEEP THE ROW WITH THE MINIMUM "ID" VALUE FOR EACH SET OF DUPLICATES


DELETE FROM audible1
WHERE (title, time, releasedate, language, price, author, narrator, rating, totalratings, length) IN (
  -- SELECT THE COLUMNS AND VALUES FROM THE "CTE" TABLE
  SELECT title, time, releasedate, language, price, author, narrator, rating, totalratings, length
  FROM cte
) 
-- EXCLUDE ROWS WITH THE MINIMUM "ID" VALUE FOR EACH SET OF DUPLICATES


AND id NOT IN (
  -- SELECT THE "ID" VALUES FROM THE "CTE" TABLE
  SELECT id
  FROM cte
);
