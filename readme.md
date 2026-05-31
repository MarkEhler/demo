Demo/
├── .gitignore
├── readme.md
├── .github/
│   └── workflows/
│       ├── agent_deployment/
│       │   ├── create-release-candidate.yaml
│       │   ├── deploy-datadog-k8s.yaml
│       │   ├── deploy-datadog-vm.yaml
│       │   └── deploy-prod.yaml
│       └── terraform-azure-setup/
│           ├── action.yaml
│           ├── deploy-infrastructure.yaml
│           └── terraform.yaml
│
└── application/          # Infrastructure setup
    ├── readme.md
    └── terraform/
        ├── main.tf
        ├── outputs.tf
        └── variables.tf