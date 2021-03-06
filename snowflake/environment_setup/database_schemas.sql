
-- using the sysadmin role for creating database, schemas
-- and objects.
-- This is mainly for test purposes. For production specific and limited
-- roles have to be defined to provide for separation of concerns
-- and reduce the possibility of unwanted incidents happening.
use role sysadmin;

-- creating a transient database mainly for test purposes 
-- so that no that it doesn't incur any aditional costs
-- for time travel.create transient database if not exists convext_test;
create transient database convext_test;

use database convext_test;

create schema staging;
create schema dimensions;
create schema facts;

-- objects in each schema are defined in their
-- associated folder inside "snowflake" folder
-- however the file types can be created after 
-- this script has executed.
