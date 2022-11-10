# Deploy a Linux debug container

```
kubectl apply -f pod.yaml
```

Shell

```
kubectl exec -it ubuntu -- /bin/bash
```

Curl

```
apt update && apt install curl -y
```

## ref

https://downey.io/notes/dev/ubuntu-sleep-pod-yaml/