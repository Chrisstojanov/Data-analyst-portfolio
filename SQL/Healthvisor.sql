1. WHat is the age distribution of our patient base?

SELECT Age, COUNT(*) AS PatientCount
FROM PatientDemographic
GROUP BY Age
ORDER BY Patientcount desc;

2. Which gender is most prevalent among our patient base?

select Gender, count(*) as GenderCount
from Patientdemographic
group by gender
order by gendercount desc

3. Which geographic locations have the most patients?
select location, count(*) as LocationCount
from patientdemographic
group by location
order by locationcount desc

4. what is the gender distribution across different locations?

SELECT Location, Gender, COUNT(*) AS PatientCount
FROM PatientDemographic
GROUP BY Location, Gender
ORDER BY Location, PatientCount DESC;

5. What is the average age of patients across different locations?

select location, avg(age) as AverageAge
from patientdemographic
group by location
order by AverageAge desc

6. which location has the oldest or youngest patients?
--Oldest
select location, max(age) as OldestPatient
from patientdemographic
group by location
order by OldestPatient

--youngest
select location, min(age) as YoungestPatient
from patientdemographic
group by location
order by YoungestPatient

7. Which age group has the highest concentration of patients?
SELECT CASE
         WHEN Age BETWEEN 18 AND 24 THEN '18-24'
         WHEN Age BETWEEN 25 AND 34 THEN '25-34'
         WHEN Age BETWEEN 35 AND 44 THEN '35-44'
         WHEN Age BETWEEN 45 AND 54 THEN '45-54'
         WHEN Age BETWEEN 55 AND 64 THEN '55-64'
         ELSE '65+'
       END AS AgeGroup, COUNT(*) AS PatientCount
FROM PatientDemographic
GROUP BY AgeGroup
ORDER BY PatientCount DESC;


8. Are certain genders more prevalent in specific age groups?
SELECT Gender, CASE
                WHEN Age BETWEEN 18 AND 24 THEN '18-24'
                WHEN Age BETWEEN 25 AND 34 THEN '25-34'
                WHEN Age BETWEEN 35 AND 44 THEN '35-44'
                WHEN Age BETWEEN 45 AND 54 THEN '45-54'
                WHEN Age BETWEEN 55 AND 64 THEN '55-64'
                ELSE '65+'
              END AS AgeGroup, COUNT(*) AS PatientCount
FROM PatientDemographic
GROUP BY Gender, AgeGroup
ORDER BY Gender, AgeGroup;

9. Which age group is the most prevalent in each location?

SELECT Location, CASE
                  WHEN Age BETWEEN 18 AND 24 THEN '18-24'
                  WHEN Age BETWEEN 25 AND 34 THEN '25-34'
                  WHEN Age BETWEEN 35 AND 44 THEN '35-44'
                  WHEN Age BETWEEN 45 AND 54 THEN '45-54'
                  WHEN Age BETWEEN 55 AND 64 THEN '55-64'
                  ELSE '65+'
                END AS AgeGroup, COUNT(*) AS PatientCount
FROM PatientDemographic
GROUP BY Location, AgeGroup
ORDER BY Location, PatientCount DESC;

