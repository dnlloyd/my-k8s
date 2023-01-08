# 1. Install

## Prereqs

- external DNS: https://argo.fhcdan.net (currently created by Terraform)
- namespace (currently created by Terraform)

*argocd service set to `type: LoadBalancer`*

```
kubectl -n argocd apply -f install-argocd.yaml
```

# 2. Access

## 2.1 Get default admin pass

```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```

## 2.2 login and update password

**Login**

```
argocd login argo.fhcdan.net

```

```
Username: admin
Password: <above>
```

**Update password** (keepassxc)

```
argocd account update-password
```

# Deploy web skp

```
kubectl config set-context --current --namespace=argocd

kubectl apply -f web-skp-app.yaml
```

# Install latest (from official)

```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Access via LB

```
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```

# Reference

https://argo-cd.readthedocs.io/en/stable/getting_started/

https://redhat-scholars.github.io/argocd-tutorial/argocd-tutorial/03-kustomize.html

https://argocd-image-updater.readthedocs.io/en/stable/

https://www.linkedin.com/pulse/automatic-image-update-using-argocd-satyam-kumar?trk=articles_directory
