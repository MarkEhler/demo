variable "project_name" {
  type        = string
  description = "Short project name used for AWS resource naming."
  default     = "bloomerang-demo"
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
  default     = ""
}

variable "aws_iam_user_arn" {
  type        = string
  description = "Current IAM user ARN used for local and GitHub-based Terraform access."
  default     = ""
}

variable "aws_session_token" {
  type        = string
  description = "Optional AWS session token for temporary credentials. Leave blank if not required."
  default     = ""
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