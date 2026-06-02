# Demo

A small repository containing infrastructure setup and CI/CD workflows.

## Repository structure

```
Demo/
├── .github/
│   └── workflows/
│       ├── deploy-datadog-k8s.yaml          # under construction
│       ├── deploy-datadog-vm.yaml           # under construction
│       ├── deploy-hello-world-k8s.yaml      # Deploy hello world pod to AKS
│       ├── deploy-hello-world-vm.yaml       # Execute hello world script on VM
│       ├── deploy-infrastructure.yaml       # Terraform infrastructure deployment
│       └── destroy-infrastructure.yaml      # Terraform infrastructure teardown
├── application/
│   ├── readme.md                            # Infrastructure module documentation
│   ├── deploy/
│   │   └── hello-world-vm.sh                # Hello world script for VM
│   └── terraform/
│       ├── main.tf                          # Azure resources (VM, AKS, networking)
│       ├── outputs.tf                       # Terraform outputs for workflows
│       └── variables.tf                     # Terraform input variables
├── .gitignore
└── readme.md                                # This file

```

## Key Components

### Infrastructure (application/terraform/)
- **Virtual Machine:** Ubuntu 20.04 LTS VM for Datadog agent deployment
- **AKS Cluster:** Azure Kubernetes Service cluster for containerized workloads
- **Networking:** Virtual network, subnets, and network security groups
- **Key Vault:** Stores sensitive identifiers

### Workflows (.github/workflows/)
- **Datadog Deployments:** Install Datadog agents on both VM and AKS
- **Hello World Deployments:** Basic validation scripts for VM and Kubernetes
- **Infrastructure Management:** Terraform apply/destroy workflows

## Notes
- Use the `application/terraform` folder for Terraform configurations.
- All workflows use OIDC for Azure authentication.
- Deployment scripts live in `application/deploy/`.
