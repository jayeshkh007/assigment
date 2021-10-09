resource "aws_dynamodb_table" "UserCheckin" {
  name           = "UserCheckin"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "Username"
  read_capacity  = 5
  write_capacity = 5
  
  attribute {
    name = "Username"
    type = "S"
  }
}