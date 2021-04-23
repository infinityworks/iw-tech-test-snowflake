# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table

locals {
  statelock_table_name = "${var.aws_dynamodb_table}-${random_integer.seed.result}"
}

resource "aws_dynamodb_table" "terraform_statelock" {
    name = local.statelock_table_name
    read_capacity = 20
    write_capacity = 20
    hash_key = "LockID"

    attribute {
      name = "LockID"
      type = "S"
    }

    tags = var.default_tags
}

output "state_dynamo_table" {
  value = aws_dynamodb_table.terraform_statelock.id
}
