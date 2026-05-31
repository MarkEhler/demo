Demo/
├── application/          # Infrastructure setup
│   └── .github/workflows/
│       └── deploy-infrastructure.yaml
│
└── app_deployment/       # Datadog agent deployment
    └── .github/workflows/
        ├── deploy-datadog-vm.yaml
        └── deploy-datadog-k8s.yaml