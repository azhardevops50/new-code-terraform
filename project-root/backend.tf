terraform {
  backend "s3" {
    bucket         = "terraform-state-s3-backend-bucket"
    key            = "state/dev/infra.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}

