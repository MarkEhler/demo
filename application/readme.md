# Infrastructure Deployment Module

## Overview
This module provisions the foundational AWS infrastructure for the demo deployment. It creates a Linux EC2 instance and an Amazon EKS cluster, and exposes the identifiers needed for downstream application and deployment automation.

The current direction is to move from a local, ad-hoc prototype toward a more cloud-native, repeatable, and secure deployment model built around AWS-native services and GitHub Actions.

## Current environment model
The project is intentionally parameterized for multiple environments and structured so values are not implicitly hardcoded into the repo. The goal is to move from a developer-local pattern toward a production-aware workflow.

## Resources Generated

### 1. EC2 Virtual Machine
- Resource Type: `aws_instance`
- Purpose: host for VM-based workloads and bootstrap steps

### 2. EKS Cluster
- Resource Type: `aws_eks_cluster`
- Purpose: Kubernetes runtime for application workloads

### 3. Networking
- VPC and public subnets for shared connectivity
- Internet gateway and route table
- Security group for VM access controls

### 4. Secret and configuration storage
- TODO!
- AWS Secrets Manager stores deployment metadata
- Configuration is intentionally separated from infra provisioning values


## Deployment flow

1. Terraform initializes and validates the AWS configuration
2. Infrastructure is provisioned against the target environment
3. Outputs expose EC2 and EKS identifiers for automation
4. Workflow inputs or environment values drive environment-specific deployment settings
5. Application deployment steps interact with AWS-native services and cluster state

## Cloud-native gaps

### 1. Secrets
Current issue:
- application and deployment credentials are still stored as repo-facing values or workflow secret patterns that are not ideal for a cloud-native setup

Target state:
- use GitHub Environment secrets for non-sensitive workflow values
- use AWS IAM roles and OIDC from GitHub Actions instead of long-lived static AWS keys whenever possible
- store runtime secrets in AWS Secrets Manager or SSM Parameter Store
- only inject secrets at runtime, never commit them to code or source control

Recommended path:
- GitHub Actions authenticates to AWS via OIDC
- an IAM role is assumed for Terraform and deploy steps
- secrets needed by the app are pulled from AWS Secrets Manager at runtime
- the repo remains code-only and does not contain deployed secrets or sensitive values

### 2. Terraform state file
Current issue:
- `terraform.tfstate` is stored locally or in the github runner

Target state:
- move Terraform state to a remote backend in S3
- enable state locking using DynamoDB
- enable server-side encryption on the bucket
- store state by environment and keep access restricted by IAM

Recommended path:
- S3 bucket for Terraform state
- DynamoDB table for locking
- backend configuration per environment
- CI/CD pipeline applies changes against the remote state instead of local state files

## Prerequisites

- AWS account with appropriate IAM permissions
- Terraform >= 1.6
- GitHub Actions configured for AWS authentication
- A remote backend for infrastructure state
- GitHub environment secrets or AWS Secrets Manager for sensitive values