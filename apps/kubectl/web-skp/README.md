
Deploy

```
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

Troubleshoot

```
kubectl -n www get pods 

kubectl -n www exec --stdin --tty <POD> -- /bin/bash
```

```
curl http://localhost:80
```


```
kubectl delete -f service.yaml
kubectl delete -f deployment.yaml
```
