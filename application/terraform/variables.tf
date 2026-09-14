variable "project_name" {
  type        = string
  description = "Short project name used for AWS resource naming."
  default     = "bloomerang-demo" #update to bloomerang
}

variable "environment" {
  type        = string
  description = "Deployment environment label."
  default     = "dev"
}

variable "aws_region" {
  type        = string
  description = "Amazon region for deployment."
  default     = "us-east-1"
}

variable "aws_account_id" {
  type        = string
  description = "AWS account id associated with the deployment."
  default     = "017011573822"
}

variable "aws_iam_user_arn" {
  type        = string
  description = "Current IAM user ARN used for local and GitHub-based Terraform access."
  default     = "arn:aws:iam::017011573822:user/github"
  sensitive   = true
}

variable "aws_access_key_id" {
  type        = string
  description = "AWS access key used for Terraform authentication. For production, prefer OIDC or IAM role assumptions."
  default     = "AKIAQH5PYAQ7JJC7SWED"
  sensitive   = true
}

variable "aws_secret_access_key" {
  type        = string
  description = "AWS secret access key used for Terraform authentication."
  default     = "rHzH7ggxzDijj/zGDU3OWke8rsFi8EKjCi5vFt1X"
  sensitive   = true
}

variable "aws_session_token" {
  type        = string
  description = "Optional AWS session token for temporary credentials. Leave blank if not required."
  default     = ""
  sensitive   = true
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  type        = string
  description = "CIDR block for the primary public subnet hosting the EC2 instance and EKS control plane connectivity."
  default     = "10.0.1.0/24"
}

variable "subnet_cidr_2" {
  type        = string
  description = "CIDR block for the secondary public subnet required by EKS in a second AZ."
  default     = "10.0.2.0/24"
}

variable "ec2_instance_type" {
  type        = string
  description = "EC2 instance type for the Datadog VM node."
  default     = "t3.small"
}

variable "eks_node_count" {
  type        = number
  description = "Desired number of EKS worker nodes."
  default     = 2
}

variable "admin_username" {
  type        = string
  description = "Admin username for the Linux EC2 instance."
  default     = "ec2-user"
}

variable "admin_password" {
  type        = string
  description = "Password for the VM image if using password authentication. Prefer SSH keys for production."
  default     = "ChangeMe123!"
  sensitive   = true

  validation {
    condition     = length(var.admin_password) >= 12
    error_message = "admin_password must be at least 12 characters long."
  }
}

variable "allowed_ssh_cidr" {
  type        = string
  description = "CIDR allowed to reach SSH on the EC2 instance."
  default     = "0.0.0.0/0"
}

variable "ssh_public_key" {
  type        = string
  description = "Public SSH key used for EC2 access. Leave blank to skip the EC2 key pair until a valid key is supplied."
  default     = ""
}