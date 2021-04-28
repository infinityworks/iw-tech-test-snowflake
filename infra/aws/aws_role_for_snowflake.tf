# manual operation
create role "snowflake_role" for aws access from snowflake users

attach policy "snowflake_access"

create trust relationship with snowflake arn