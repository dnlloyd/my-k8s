# Deploy a Linux debug container

```
kubectl apply -f pod.yaml
```

Shell

```
kubectl exec -it ubuntu -- /bin/bash
```

Install additional tools

```
apt update && apt install curl netcat traceroute dnsutils -y
```

## ref

https://downey.io/notes/dev/ubuntu-sleep-pod-yaml/
