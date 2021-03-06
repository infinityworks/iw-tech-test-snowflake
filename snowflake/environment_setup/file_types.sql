create or replace file format staging.convex_json
type = json;

create or replace file format staging.convex_csv
type = csv
skip_header = 1;
