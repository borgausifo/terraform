provider "aws" {
  region = "us-east-1"
}


resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-trial-01"

  #Prevent accidental deletion of this s3 bucket
  lifecycle {
    prevent_destroy = true
  }

  #Enable versioning so we can see the full revidion history of oour state files
  versioning {
    enabled = true
  }

  # Enable server-sdie encryption by default 
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

terraform {
  backend "s3" {
    bucket         = "terraform-state-trial-01"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}

output "s3_bucket_arn" {
  value       = aws_s3_bucket.terraform_state.arn
  description = "The ARN of the s3 bucket"
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.terraform_locks.name
  description = "The name of the DynamoDB table"
  depends_on  = []
}

