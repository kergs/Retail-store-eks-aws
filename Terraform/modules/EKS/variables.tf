variable "dev_user_name" {
  description = "The IAM username for the dev user to be mapped in aws_auth"
  type        = string
}

variable "project_name" {
  type    = string
  default = "Altsch_Assessement_EKS_Deployment"
}