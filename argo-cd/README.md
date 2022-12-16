# Argo CD

## Install

### Install recent

- external DNS: https://argo.fhcdan.net
- namespace created by Terraform
- argocd service set to `type: LoadBalancer`

```
kubectl -n argocd apply -f install-argocd.yaml
```

### Install latest

```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Access via LB

```
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```

## Access

### Get default admin pass

```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```

### login and update password

recent

```
argocd login argo.fhcdan.net

```

latest
```
kubectl get svc -n argocd

argocd login xxx.us-east-1.elb.amazonaws.com
```

update password (keepassxc)

```
argocd account update-password
```

## Deploy web skp

```
kubectl config set-context --current --namespace=argocd

kubectl apply -f web-skp-app.yaml
```

## Reference

https://argo-cd.readthedocs.io/en/stable/getting_started/

https://redhat-scholars.github.io/argocd-tutorial/argocd-tutorial/03-kustomize.html

https://argocd-image-updater.readthedocs.io/en/stable/

https://www.linkedin.com/pulse/automatic-image-update-using-argocd-satyam-kumar?trk=articles_directory
