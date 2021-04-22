
# ensure some global uniqueness. Used for statefile and dynamodb statelock
resource "random_integer" "seed" {
  min = 1000
  max = 9999
}
