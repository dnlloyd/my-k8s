```
kubectl get roles -n www
```

# Show all resources (pods, nodes, etc.)
```
kubectl api-resources
```

# Show aws-auth configmap
```
kubectl describe -n kube-system configmap/aws-auth
```

```
kubectl apply -f roles.yaml

kubectl describe role read-only -n www
```
