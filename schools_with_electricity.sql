-- Created a database and imported teh particular file into it

-- Creating a database named education 
create database education;

-- Using the database
use education;

-- show tables -- to see the tables 
show tables;

-- to see the structure of the table 
describe table schools_with_electricity;

ALTER TABLE schools_with_electricity RENAME COLUMN `All Schools` TO all_schools;
ALTER TABLE schools_with_electricity RENAME COLUMN  `Sec_with_HrSec.` to  Sec_with_HrSec;
alter table schools_with_electricity modify column year varchar(255);

-- to get the row count
Select count(*) as no_rows from schools_with_electricity;

-- to get the coulmn count
SELECT COUNT(*) as no_col
FROM information_schema.columns
WHERE table_schema = 'education'
AND table_name = 'schools_with_electricity';

-- to get the first 10 rows of the table 
select * from schools_with_electricity limit 10;

-- to get the last 10 rows of the table 
select * from schools_with_electricity order by state_ut desc limit 10;

-- to see the count of distinct entries of states and UT's
select count(distinct(state_ut)) as distinct_count from schools_with_electricity;

 delete from schools_with_electricity where state_ut = "all India";

-- ****************************************************************************************************
-- over all schools 
select state_ut as UT,all_schools,year,dense_rank() over(partition by year order by all_schools desc) as "rank"
from schools_with_electricity
where state_ut in("Andaman & Nicobar Islands","Dadra & Nagar Haveli",
"Daman & Diu","Delhi","Jammu And Kashmir","Lakshadweep","Puducherry");

-- states over all schools:
 -- to get top 10  state wise on over all schools:
 select state_ut as state,all_schools,year,dense_rank()over(partition by year order by all_schools desc) as "rank" 
 from schools_with_electricity
where state_ut not in("Andaman & Nicobar Islands","Dadra & Nagar Haveli",
"Daman & Diu","Delhi","Jammu And Kashmir","Lakshadweep","Puducherry") ;
 
 
 -- ****************************************************************************************************
 -- Only  Primary 
 
 -- to find the top 5 states under only_primary year wise
  
 create temporary table primary_only_top5_year_wise as( 
 (select year,state_ut,primary_only from schools_with_electricity 
 where year = '2013-14' order by 1,3 desc limit 5)
 union all
 (select year,state_ut,primary_only   from schools_with_electricity 
 where year = '2014-15' order by 1,3 desc limit 5)
 union all
 (select year,state_ut,primary_only  from schools_with_electricity 
 where year = '2015-16' order by 1,3  desc limit  5)); 
 
 select * from primary_only_top5_year_wise;
 
 -- to find the least 5  states under only_primary year wise

 create temporary table primary_only_least_5_year_wise as( 
 (select year,state_ut,primary_only from schools_with_electricity 
 where year = '2013-14' order by 1,3  limit 5)
 union all
 (select year,state_ut,primary_only   from schools_with_electricity 
 where year = '2014-15' order by 1,3  limit 5)
 union all
 (select year,state_ut,primary_only  from schools_with_electricity 
 where year = '2015-16' order by 1,3  limit  5)); 

  select * from primary_only_least_5_year_wise;
 
  -- to find the average of only primary schools are provided with electricity for all the three years:
  select round(avg(primary_only),2) as AVG_Primary_only from schools_with_electricity ;
 
--  to find how many states had provided more than teh average value:
select year,count(state_ut) as no_of_state_ut from schools_with_electricity where primary_only > 
(select round(avg(primary_only),2)  from schools_with_electricity) group by year;

-- to find the max value under primary _only category:
 select max(primary_only)as max_Primary_only from schools_with_electricity ;
 
 -- count states that has the maximum value under primary only
select year,count(state_ut) as no_of_state_ut from schools_with_electricity where primary_only = 
(select max(primary_only) from schools_with_electricity) group by year;

-- to find the min value under primary _only category:
 select min(primary_only)as min_Primary_only from schools_with_electricity ;
 
 -- count states that has the maximum value under primary only
select year,count(state_ut) as no_of_state_ut from schools_with_electricity where primary_only <=
(select min(primary_only) from schools_with_electricity) group by year;

 -- ****************************************************************************************************
 -- the same queriers can be applied for the remaining categories in order to analyse them
 -- ****************************************************************************************************
 -- year wise average for each category
 
 create view avg_year_wise as( select year,
 round(avg(primary_only),2) as avg_primary_only,
 round(avg(Primary_with_U_Primary),2) as avg_Primary_with_U_Primary,
 round(avg(Primary_with_U_Primary_Sec_HrSec),2) as avg_Primary_with_U_Primary_Sec_HrSec,
 round(avg(U_Primary_Only),2) as avg_U_Primary_Only,
 round(avg(U_Primary_With_Sec_HrSec),2) as U_Primary_With_Sec_HrSec,
 round(avg(Primary_with_U_Primary_Sec),2) as avg_Primary_with_U_Primary_Sec,
 round(avg(U_Primary_With_Sec),2) as avg_U_Primary_With_Sec,
round(avg(Sec_Only),2) as avg_Sec_Only,
round(avg(Sec_with_HrSec),2) as avg_Sec_with_HrSec,
 round(avg(HrSec_Only),2) as avg_HrSec_Only
  from schools_with_electricity group by year);
  
  select * from avg_year_wise;
 
 -- year_wise_max for each category
 
 create view max_year_wise as( select year,
 max(primary_only) as max_primary_only,
 max(Primary_with_U_Primary) as max_Primary_with_U_Primary,
 max(Primary_with_U_Primary_Sec_HrSec) as max_Primary_with_U_Primary_Sec_HrSec,
 max(U_Primary_Only) as max_U_Primary_Only,
 max(U_Primary_With_Sec_HrSec) as max_U_Primary_With_Sec_HrSec,
 max(Primary_with_U_Primary_Sec) as max_Primary_with_U_Primary_Sec,
 max(U_Primary_With_Sec) as max_U_Primary_With_Sec,
max(Sec_Only) as max_Sec_Only,
max(Sec_with_HrSec) as max_Sec_with_HrSec,
 max(HrSec_Only) as max_HrSec_Only
  from schools_with_electricity group by year);

 select * from max_year_wise;
 
  -- year_wise_min for each category
 create view min_year_wise as( select year,
 min(primary_only) as min_primary_only,
 min(Primary_with_U_Primary) as min_Primary_with_U_Primary,
 min(Primary_with_U_Primary_Sec_HrSec) as min_Primary_with_U_Primary_Sec_HrSec,
 min(U_Primary_Only) as min_U_Primary_Only,
 min(U_Primary_With_Sec_HrSec) as U_Primary_With_Sec_HrSec,
 min(Primary_with_U_Primary_Sec) as min_Primary_with_U_Primary_Sec,
 min(U_Primary_With_Sec) as min_U_Primary_With_Sec,
min(Sec_Only) as min_Sec_Only,
min(Sec_with_HrSec) as min_Sec_with_HrSec,
 min(HrSec_Only) as min_HrSec_Only
  from schools_with_electricity group by year);
  
  select * from min_year_wise;

 