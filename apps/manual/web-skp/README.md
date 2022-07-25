
Deploy

```
kubectl apply -f deployment.yml
```

Troubleshoot

```
kubectl -n www get pods 

kubectl -n www exec --stdin --tty <POD> -- /bin/bash
```

```
curl http://localhost:80
```
