
# Create a DynamoDB for use of storing visitor counter for the website
resource "aws_dynamodb_table" "cw_resume_dynamodb" {
  name         = var.cw_resume_dynamodb
  billing_mode = var.billing_mode
  hash_key     = var.visit_counter_name

  # This is for my partition key(hash_key)
  attribute {
    name = var.visit_counter_name
    type = var.visit_counter_type
  }

  # Creates an event source mapping for Lambda trigger. I chose new image since I am only updating my counter
  # The choices for stream_view_type were NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES, or KEYS_ONLY
  stream_enabled   = true
  stream_view_type = "NEW_IMAGE"


  tags = {
    Name = var.cw_resume_dynamodb
  }
}

#Creates the initial visit counter item in the DynamoDB
resource "aws_dynamodb_table_item" "Initial_visit_counter" {
  table_name = aws_dynamodb_table.cw_resume_dynamodb.name
  hash_key   = var.visit_counter_name
  item       = <<ITEM
  {
    "VisitCounter": {"S": "VisitCounter"},  
    "TotalVisits": {"N": "1"}             
  }
  ITEM
}


# Output the variable for the dynamodb name so other resources can reference it
output "dynamodb_table_name" {
  value = aws_dynamodb_table.cw_resume_dynamodb
}


