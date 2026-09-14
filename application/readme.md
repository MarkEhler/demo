# Infrastructure Deployment Module

## Overview
This module provisions the foundational AWS infrastructure for the Datadog deployment proof of concept. It creates a Linux EC2 instance and an Amazon EKS cluster, capturing the identifiers needed for downstream Datadog agent deployment.

## Environment separation
The configuration is parameterized for multiple environments and structured for a launch path that is aligned to Amazon infrastructure. The goal is to keep environment-specific values out of the default configuration and instead pass them through workflow inputs or environment variables.

This makes the project easier to reuse for:
- development and staging
- production-like validation
- Amazon launch readiness

## Resources Generated

### 1. EC2 Virtual Machine
- Resource Type: `aws_instance`
- Instance Type: configurable
- Image: Ubuntu-based Amazon AMI
- Purpose: host for Datadog VM agent deployment

### 2. Amazon EKS Cluster
- Resource Type: `aws_eks_cluster`
- Node Count: configurable
- Purpose: Kubernetes environment for Datadog cluster agent deployment

### 3. Networking
- VPC and public subnet for shared connectivity
- Internet gateway and route table
- Security group for VM access controls

### 4. Secret and config storage
- AWS Secrets Manager stores deployment and configuration metadata
- Datadog configuration is intentionally separated from resource provisioning values

## Amazon launch readiness
The project is now aligned to a launch architecture built around AWS services:

- Azure VM -> Amazon EC2
- Azure AKS -> Amazon EKS
- Azure Key Vault -> AWS Secrets Manager / SSM Parameter Store
- Azure OIDC auth -> AWS OIDC / IAM role assumption
- Azure deployment pipeline -> GitHub Actions with AWS credentials

This is the right migration direction for a real Amazon capability story.

## Deployment flow

1. Terraform initializes and validates the AWS configuration
2. Infrastructure is provisioned against the target environment
3. Outputs expose EC2 and EKS identifiers for automation
4. Workflow inputs drive environment-specific Datadog values
5. Deployment scripts validate and install the Datadog agent securely

## Prerequisites

- AWS account with appropriate permissions
- Terraform >= 1.6
- GitHub secrets configured for AWS OIDC and Datadog installation:
  - `AWS_ROLE_TO_ASSUME`
  - `AWS_REGION`
  - `DATADOG_API_KEY`

## Operational notes
- Avoid hardcoded values in the repo for production or customer environments
- Keep environment names, tags, and project metadata in workflow inputs or external configuration
- Keep the cloud configuration explicit so the service can be launched in Amazon without a large refactor