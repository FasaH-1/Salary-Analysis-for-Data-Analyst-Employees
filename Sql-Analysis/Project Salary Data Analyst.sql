create database salaries_employee;

select * from ds_salaries limit 10;

-- check null 
select * from ds_salaries 
where work_year is null
or experience_level is null
or employment_type is null
or job_title is null
or salary is null
or salary_currency is null
or salary_in_usd is null
or employee_residence is null
or remote_ratio is null
or company_location is null
or company_size is null;

-- Melihat job tittle ada apa aja
select 
	distinct(job_title)
from 
	ds_salaries 
order by 
	job_title;

-- job title yang berkaitan dengan data analis
select 
	distinct(job_title) 
from 
	ds_salaries 
where 
	job_title like '%data analyst%' 
order by job_title;

--  avg gaji data analyst
select 
	avg(salary_in_usd) as avg_data_analyst 
from 
	ds_salaries 
where job_title like '%data analyst%';

--  avg gaji data analyst berdasarkan level experience
select 
	experience_level, avg(salary_in_usd) as avg_data_analyst 
from 
	ds_salaries 
where job_title like '%data analyst%' 
group by experience_level 
order by avg_data_analyst DESC;

-- avg gaji data analyust berdasarkan level experience dan employement 

select 
	experience_level, employment_type, avg(salary_in_usd) as avg_data_analyst 
from 
	ds_salaries 
where job_title like'%data analyst%'
group by 
	experience_level, employment_type 
order by avg_data_analyst desc;

-- Negara yang gajinya menarik untuk data analyst untuk exp mid

select 
	company_location, 
    avg(salary_in_usd) as avg_salary
from 
	ds_salaries 
where  
	job_title like '%data analyst%' 
    and employment_type = 'FT' 
    and experience_level in ('MI','EN') 
group by 
	company_location 
having 
	avg_salary >= 20000
order by avg_salary DESC;


-- di tahun berapa kenaikan gaji mid ke senior itu memiliki kenaikan tertinggi
-- (untuk pekerjaan yang berkaitan dengan data analyst penuh waktu)

with data_1 as (
	select work_year, avg(salary_in_usd) as salary_Executive
    from ds_salaries
    where
		employment_type = 'FT'
        and experience_level = 'EX'
        and job_title like '%data analyst%'
	group by work_year
),

data_2 as (
	select work_year, avg(salary_in_usd) as salary_Mid
    from ds_salaries
    where
		employment_type = 'FT'
        and experience_level = 'MI'
        and job_title like '%data analyst%'
	group by work_year
)
select 
data_1.work_year,
data_1.salary_Executive,
data_2.salary_Mid,
data_1.salary_Executive- data_2.salary_Mid differences
 
from data_1
left outer join data_2 on data_1.work_year = data_2.work_year

order by differences DESC;

