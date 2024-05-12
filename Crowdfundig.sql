create schema if not exists crowdfunding;
create table category(
ID int default null,
Name text,
Parent_id int default null,
Position int default null);

create table locations(
ID int default null,
Location_name text default null,
Type text default null,
Name text default null,
State text default null,
Short_name text default null,
Is_root text default null,
Country text default null,
Localized_name text default null);
drop table locations;

create table creators(
ID int default null,
Name text default null,
Choose_currency text default null);


