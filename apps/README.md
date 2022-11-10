# Notes

## Basic kubectl

```
kubectl -n www get nodes
kubectl -n www get pods
kubectl -n www get svc
kubectl -n www get serviceaccounts
```

## Deploy with kubectl

```
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

```
kubectl delete -f service.yaml
kubectl delete -f deployment.yaml
```

## Create shell in container (pod)

```
kubectl -n www exec --stdin --tty <POD-ID> -- /bin/bash

# Verify pod DNS
curl http://<Deployment-Name>
```

## Helm

```
helm create web-j4
```

## Deploy with Helm

```
helm -n www install web-j4 ./web-j4
helm -n www upgrade web-j4  ./web-j4
helm -n www uninstall web-j4
```

## Render Helm
```
helm template web-j4 web-j4/ --output-dir web-j4_RENDERED
```

## Deploy a Linux debug container

Try this first:
https://kubernetes.io/docs/tasks/debug/debug-application/debug-running-pod/#ephemeral-container

Pod definitions:
[kubectl/ubuntu-debug-pod](kubectl/ubuntu-debug-pod)

Shell

```
kubectl exec -it ubuntu -- /bin/bash
```

curl

```
apt update && apt install curl -y
```
