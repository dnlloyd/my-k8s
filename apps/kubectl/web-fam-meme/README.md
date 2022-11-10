
# Web Family Memes

## Deploy

```
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

## Verify

```
kubectl -n www exec --stdin --tty web-skp-< POD ID > -- /bin/bash
```

```
while sleep 0.01; do curl http://memes; done
```


