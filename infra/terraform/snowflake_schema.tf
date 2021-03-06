resource "snowflake_schema" "schemas" {
  for_each = toset( ["STAGING", "DIMENSIONS", "FACTS", "CUBES"] )
  name     = each.key
  database = snowflake_database.convex_db.name
  depends_on = [
    snowflake_database.convex_db,
  ]  
}