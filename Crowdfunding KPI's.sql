SELECT * FROM crowdfunding.projects;

-- KPI's For Crwod Funding Data Validation -----------------

-- Replacing Unixtime columns in to Date column( created_at) ----------
alter table projects
add column HR_created_at date;

update projects
set HR_created_at = from_unixtime(created_at);

alter table projects
drop column created_at;


-- Unixtime Column to Date Column ( deadline)--------------
alter table projects 
add column HR_deadline date;

update projects
set HR_deadline = from_unixtime(deadline);

alter table projects
drop column deadline;

-- Unixtime column to Date Column ( updated_at) --------------
alter table projects
add column HR_updated_at date;

update projects
set HR_updated_at = from_unixtime(updated_at);

alter table projects
drop column updated_at;

-- Unixtime column to Date column ( state_change_at) ------------
alter table projects
add column HR_state_changed_at date;

update projects
set HR_state_changed_at = from_unixtime(state_changed_at);

alter table projects
drop column state_changed_at;

-- Unixtime column to Date column (successful_at)---------
alter table projects
add column HR_successful_at date;

alter table projects
drop column HR_successful_at;

update projects
set HR_successful_at = from_unixtime(successful_at);

-- Add Goal USD Column ----------
alter table projects
add column goal_usd int;

update projects
set goal_usd =  goal * static_usd_rate;

-- (1) Total number of projects based on outcome -----------
select state 'outcome', count(*)  'Total number of projects'from projects
group by state
order by count(*) desc;

-- (2) Total number of projects based on locations ------------
select country, count(*) 'Total number of projects' from projects
group by country
order by count(*) desc;

-- (3) Total number of projects based on category -------
select c.Name, count(*) 'Total number of projects'
from projects pr
join category c on c.id = pr.category_id
group by c.Name
order by count(*) desc limit 20;

-- (4.a) Total number of projects by Year ---------
select year(HR_created_at) 'Year', count(*) 'Total Applications'
from projects
group by year(HR_created_at)
order by count(*) desc;

-- (4.b) Total Projects by month ---
select monthname(HR_created_at) 'Month', count(*) 'Total Applications'
from projects
group by monthname(HR_created_at)
order by count(*) desc;

-- (4.c) Total Projects by quarter ----------
select concat('Qtr-',quarter(HR_created_at)) 'Quarters', count(*) 'Total Applications' from projects
group by concat('Qtr-',quarter(HR_created_at))
order by count(*) desc;

-- (5.a)Total successful projects based on amoutn raised ---------
select state, sum(usd_pledged) 'Total amount raised' from projects
where state = 'Successful';

-- (5.b) Total successful projects based on backers's count -------
select state, sum(backers_count) 'Total backers'  from projects
where state = 'Successful';

-- (5.c) Average number of days for successful projects -----
select state, round(avg(day(HR_created_at)),2) 'Average days' from projects
where state = 'Successful';

-- (6.a) Top Successful projects based on number of backers ----
select name, state, sum(backers_count) 'Total backers' from projects
where state = 'Successful'
group by name
order by sum(backers_count) desc limit 10;

-- (6.b) Top successful projects based on amount raised ---------
select name, state, sum(usd_pledged) 'Total amoount raised' from projects
where state = 'Successful'
group by name
order by sum(usd_pledged) desc limit 10;

-- (7.a) Percentage of successful projects based on category -----
select c.name, (sum(case when pr.state = 'Successful' then 1 else 0 end)/count(*))*100 'Success rate'
from category c join projects pr on c.id = pr.category_id
group by c.name;

-- (7.b) 