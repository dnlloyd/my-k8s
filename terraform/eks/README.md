# Kubernetes config (auth)

```
aws eks update-kubeconfig --region us-east-1 --name my-k8s --alias my-k8s
```

## Other config commands

```
kubectl config current-context
```

```
kubectl config get-clusters
kubectl config get-contexts
kubectl config get-users
```

```
kubectl config delete-cluster xxx
kubectl config delete-context xxx
kubectl config delete-user xxx
```

# Install kubeadm on Amazon Linux 2

[https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)
