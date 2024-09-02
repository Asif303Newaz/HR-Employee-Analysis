-- 1. What is the gender breakdown of employees in the company?
select gender, count(*) as count
from hr
where age >= 18 and termdate is null
group by gender;

-- 2. What is the race/ethnicity breakdown of employees in the company?
select race, count(*) as count
from hr
where age >= 18 and termdate is null
group by race 
order by count desc;

-- 3. What is the age distribution of employees in the company?
select min(age) as youngest,
max(age) as oldest
from hr
where age >= 18 and termdate is null;

select case 
when age >= 18 and age <= 24  then '18-24'
when age >= 25 and age <= 34  then '25-34'
when age >= 35 and age <= 44  then '35-44'
when age >= 45 and age <= 54  then '45-54'
else '65+'
end as age_group,
count(*) as count
from hr
where age >= 18 and termdate is null
group by age_group
order by age_group;

select case 
when age >= 18 and age <= 24  then '18-24'
when age >= 25 and age <= 34  then '25-34'
when age >= 35 and age <= 44  then '35-44'
when age >= 45 and age <= 54  then '45-54'
else '65+'
end as age_group,gender,
count(*) as count
from hr
where age >= 18 and termdate is null
group by age_group,gender
order by age_group, gender;

-- 4. How many employees work at headquarters versus remote locations?
select location, count(*) as count
from hr
where age >= 18 and termdate is null
group by location;


-- 5. What is the average length of employment for employees who have been terminated?
SELECT round(AVG(DATEDIFF(termdate, hire_date))/365,0) AS avg_length_of_employment
FROM hr
WHERE termdate <= CURDATE() 
  AND termdate IS NOT NULL 
  AND age >= 18;
  
  
-- 6. How does the gender distribution vary across departments and job titles?

select department, gender, count(*) as count
from hr
where age >= 18 and termdate is null
group by department, gender
order by department;

-- 7. What is the distribution of job titles across the company?
select jobtitle, count(*) as count 
from hr
where age >= 18 and termdate is null
group by jobtitle
order by jobtitle desc;

-- 8. Which department has the highest turnover rate?

SELECT department, total_count, terminated_count, terminated_count/total_count AS termination_rate
FROM (
    SELECT department,
           COUNT(*) AS total_count,
           SUM(CASE WHEN termdate IS NOT NULL AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminated_count
    FROM hr
    WHERE age >= 18
    GROUP BY department
) AS subquery
ORDER BY termination_rate DESC;


-- 9. What is the distribution of employees across locations by city and state?
select location_state, count(*) as count
from hr
where age >= 18 and termdate is null
group by location_state
order by count desc;

-- 10. How has the company's employee count changed over time based on hire and term dates?

SELECT year,
       hires,
       terminations,
       hires - terminations AS net_change,
       ROUND((hires - terminations) / hires * 100, 2) AS net_change_percentage
FROM (
    SELECT YEAR(hire_date) AS year,
           COUNT(*) AS hires,
           SUM(CASE WHEN termdate IS NOT NULL AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminations
    FROM hr
    WHERE age >= 18
    GROUP BY YEAR(hire_date)
) AS subquery
ORDER BY year ASC;

-- 11. What is the tenure distribution for each department?
 select department, round(avg(datediff(termdate, hire_date)/365),0) as avg_tenure
 from hr
 where termdate <=curdate() and termdate is not null and age >= 18
 group by department;