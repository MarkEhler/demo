# Demo

"A mid-size financial services company has 200 microservices running on Kubernetes across three environments — dev, staging, and production. They have basic cloud monitoring but no unified observability. Their on-call team is flying blind during incidents and MTTR is running three to four hours. Our job today is to walk through how we would deploy the Datadog agent across that environment, automate it end to end, and build the foundation for full observability."

## Repository Structure

```text
Demo/
├── .github/
│   └── workflows/
│       ├── deploy-datadog-k8s.yaml          # Deploy Datadog Agent to AKS
│       ├── deploy-datadog-vm.yaml           # Deploy Datadog Agent to VM
│       ├── deploy-hello-world-k8s.yaml      # Deploy hello world pod to AKS
│       ├── deploy-hello-world-vm.yaml       # Execute hello world script on VM
│       └── deploy-infrastructure.yaml       # Terraform infrastructure deployment
│
├── application/
│   ├── readme.md                            # Infrastructure module documentation
│   │
│   ├── config/
│   │   └── datadog.yaml                     # Central Datadog configuration
│   │
│   ├── deploy/
│   │   ├── hello-world-vm.sh               # VM validation script
│   │   ├── hello-world-k8s.yaml            # Kubernetes validation workload
│   │   ├── datadog-agent-values.yaml       # Datadog Helm values
│   │   └── install-datadog-vm.sh           # Datadog VM installation script
│   │
│   └── terraform/
│      ├── main.tf                         # Azure resources (VM, AKS, networking)
│      ├── outputs.tf                      # Terraform outputs for workflows
│      └── variables.tf                    # Terraform input variables
│
├── .gitignore
└── readme.md

```

## Key Components

### Infrastructure (application/terraform/)

* Ubuntu VM for Datadog agent deployment
* Azure Kubernetes Service (AKS)
* Virtual networking and NSGs
* Azure Key Vault for secrets and identifiers

### Datadog Configuration (application/config/)

* Central location for:

  * Agent version
  * Datadog site
  * Global tags
  * Feature toggles
* Shared by both AKS and VM deployments

### Deployment Assets (application/deploy/)

* Kubernetes manifests
* Helm values
* VM installation scripts
* Validation workloads

### Workflows (.github/workflows/)

* Datadog deployment workflows
* Validation workflows
* Infrastructure lifecycle workflows

## Notes

* All Azure authentication uses GitHub OIDC.
* Terraform state should be stored remotely for production use.
* Datadog configuration should be modified in a single location and consumed by both VM and Kubernetes deployments.
* Deployment scripts live in `application/deploy/`.
* Configuration files live in `application/config/`.

```
```
## Deployment Strategy

## Phase 1 — POC (Week 1–2)
Deploy agent to dev environment — single cluster, 10 nodes
Validate: hosts appear, logs flowing, APM traces visible
Establish tagging strategy and get team sign-off
Identify any network or proxy blockers early
Success criteria: 
Dev environment fully instrumented, unified service tagging validated, no gaps in host map.

## Phase 2 — Test / Staging (Week 3–4)
Promote same Helm chart and Terraform config to staging with environment-specific values
Validate against production-like workloads
Build and validate dashboards, monitors, and SLOs against staging data
Run a simulated incident — verify the observability stack surfaces it correctly
Involve on-call team — they need to trust the tooling before prod
Success criteria: 
Staging mirrors prod architecture, on-call team has validated alert coverage, runbooks written.

## Phase 3 — Production (Week 5–8)
Canary rollout — deploy to 10% of prod nodes first
Watch host map for gaps — any node not reporting is a problem before full rollout
Validate log volume and cost — set exclusion filters before full indexing
Full rollout after 48-hour canary validation
Decommission any existing monitoring tools running in parallel
Success criteria: 
100% node coverage in host map, all services appearing in APM, SLOs defined and tracking.

## Phase 4 — Steady State (Week 8+)
Agent version management via pipeline — no manual updates
Tagging governance — quarterly audit of tag consistency
Log cost review — monthly check on indexing vs archive split
Expand coverage: Synthetics, RUM, Continuous Profiler as next phases
