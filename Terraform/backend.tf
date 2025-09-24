terraform {
  backend "s3" {
    bucket         = "innovatemart-altsch"  # create this beforehand
    key            = "Altsch_Assessement_EKS_Deployment/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "innovatemart-altsch-lock"         # create for state locking
    encrypt        = true
  }
}
