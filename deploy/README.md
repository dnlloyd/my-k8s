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

## Debugging container issues

[https://kubernetes.io/docs/tasks/debug/debug-application/debug-running-pod/](https://kubernetes.io/docs/tasks/debug/debug-application/debug-running-pod/)

### Deploy an Ubuntu debug pod

Pod definitions:
[kubectl/ubuntu-debug-pod](kubectl/ubuntu-debug-pod)

```
kubectl apply -f pod.yaml
kubectl exec -it ubuntu -- /bin/bash
```

### Debugging with an ephemeral debug container

https://kubernetes.io/docs/tasks/debug/debug-application/debug-running-pod/#ephemeral-container

You have to enable the k8s EphemeralContainers feature gate in your cluster. At the moment this is still alpha and therefore not enabled by default.

https://kubernetes.io/docs/reference/command-line-tools-reference/feature-gates/

You probably also want to enable Process Namespace Sharing in your pod.

https://kubernetes.io/docs/tasks/configure-pod-container/share-process-namespace/

Note however, that all of this has repercussions in your cluster, to things like security, so make sure you understand those tradeoffs.


```
kubectl -n <namespace> debug -it <Container to debug> --image=dnlloyd/ubu-debug:latest --target=<Container to debug>
```