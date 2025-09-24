variable "dev_user_name" {
  type        = string
  default     = "innovatemart-dev-readonly"
  description = "IAM username for developer with read-only access"
}

# Create IAM user
resource "aws_iam_user" "dev_user" {
  name = var.dev_user_name
}

# Create access key for CLI access
resource "aws_iam_access_key" "dev_user_key" {
  user = aws_iam_user.dev_user.name
}

# Policy doc for read-only access
data "aws_iam_policy_document" "eks_readonly" {
  statement {
    effect = "Allow"
    actions = [
      "eks:DescribeCluster",
      "eks:ListClusters",
      "eks:ListUpdates",
      "eks:DescribeUpdate",
      "eks:ListNodegroups",
      "eks:DescribeNodegroup",
      "eks:ListFargateProfiles",
      "eks:DescribeFargateProfile",
      "ec2:Describe*",
      "autoscaling:Describe*",
      "elasticloadbalancing:Describe*",
      "cloudwatch:Describe*",
      "logs:Describe*",
      "logs:GetLogEvents",
      "s3:ListBucket",
      "s3:GetObject"
    ]
    resources = ["*"]
  }
}

# Attach policy to user
resource "aws_iam_policy" "eks_readonly_policy" {
  name   = "${var.dev_user_name}-policy"
  policy = data.aws_iam_policy_document.eks_readonly.json
}

resource "aws_iam_user_policy_attachment" "attach" {
  user       = aws_iam_user.dev_user.name
  policy_arn = aws_iam_policy.eks_readonly_policy.arn
}

# Outputs
output "dev_iam_user_name" {
  value       = aws_iam_user.dev_user.name
  description = "IAM user name for developer read-only access"
}

output "dev_iam_access_key_id" {
  value     = aws_iam_access_key.dev_user_key.id
  sensitive = true
}

output "dev_iam_secret_access_key" {
  value     = aws_iam_access_key.dev_user_key.secret
  sensitive = true
}
