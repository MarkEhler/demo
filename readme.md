# Demo

A small repository containing infrastructure setup and CI/CD workflows.

## Repository structure

- .gitignore
- readme.md (this file)
- .github/
    - workflows/
        - agent_deployment/
            - create-release-candidate.yaml
            - deploy-datadog-k8s.yaml
            - deploy-datadog-vm.yaml
            - deploy-prod.yaml
        - terraform-azure-setup/
            - action.yaml
            - deploy-infrastructure.yaml
            - terraform.yaml

- application/ — Infrastructure setup
    - readme.md
    - terraform/
        - main.tf
        - outputs.tf
        - variables.tf

## Notes
- Use the `application/terraform` folder for Terraform configurations.
- CI workflows live under `.github/workflows`.
