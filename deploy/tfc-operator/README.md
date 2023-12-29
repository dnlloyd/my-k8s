# Terraform Cloud Operator for Kubernetes

[v2.1.0](https://github.com/hashicorp/terraform-cloud-operator/releases/tag/v2.1.0)

## Requirements

**Terraform Cloud team token**

A [Team API Token](https://developer.hashicorp.com/terraform/cloud-docs/users-teams-organizations/api-tokens#team-api-tokens) is required so the operator can create the Agent pool resource in Terraform Cloud. Team tokens can be scoped to one or more workspaces. 

*Note: An organization token may be required if deploying other TDC operator features (e.g. Modules/Workspaces)*

**Secrets**

Secrets in this repository are encrypted via [SOPS](https://github.com/viaduct-ai/kustomize-sops) using an AWS KMS key. These secrets must be applied prior to applying other resources.

Decrypt secret

```
sops --decrypt secrets.sops.yaml > secrets.unencrypted.yaml
```

Apply secret

```
kubectl apply -f secrets.unencrypted.yaml
```

Re-encrypt (update) secret

```
sops --encrypt secrets.unencrypted.yaml > secrets.sops.yaml
```

## Manifests

Kubernetes manifests were derived from Helm and converted to Kustomize. 

```
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update
helm pull hashicorp/terraform-cloud-operator --version 2.1.0 --untar

helm template fhc-dan terraform-cloud-operator/ --output-dir 
terraform-cloud-operator_RENDERED --namespace tfc-operator-system
```

Note: All CRDS must be installed even if not using a feature (Workspaces/Modules/AgentPool)

[Charts](https://github.com/hashicorp/terraform-cloud-operator/tree/main/charts/terraform-cloud-operator)

## Reference

[GitHub: hashicorp/terraform-cloud-operator](https://github.com/hashicorp/terraform-cloud-operator)

[Terraform Cloud Operator for Kubernetes overview](https://developer.hashicorp.com/terraform/cloud-docs/integrations/kubernetes)

[Terraform Cloud Operator API](https://developer.hashicorp.com/terraform/cloud-docs/integrations/kubernetes/api-reference)
