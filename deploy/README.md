# Notes

## kubectl

```
kubectl -n www get nodes
kubectl -n www get pods
kubectl -n www get svc
kubectl -n www get serviceaccounts
```

### Create secret for ECR

```
kubectl create secret docker-registry regcred \
  --docker-server=458891109543.dkr.ecr.us-east-1.amazonaws.com \
  --docker-username=AWS \
  --docker-password=$(aws ecr get-login-password) \
  --namespace=dev
```

### Deploy with kubectl

```
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

```
kubectl delete -f service.yaml
kubectl delete -f deployment.yaml
```

## Helm

```
helm create web-j4
```

### Deploy with Helm

```
helm -n www install web-j4 ./web-j4
helm -n www upgrade web-j4  ./web-j4
helm -n www uninstall web-j4
```

### Render Helm
```
helm template web-j4 web-j4/ --output-dir web-j4_RENDERED
```

## Kustomize

https://www.densify.com/kubernetes-tools/kustomize

```
brew install kustomize
```

```
kustomize build overlays/fhcdan.net
kubectl apply -k overlays/fhcdan.net
kubectl delete -k overlays/fhcdan.net
```

```
kustomize build overlays/daniel.fogops.io
kubectl apply -k overlays/daniel.fogops.io
kubectl delete -k overlays/daniel.fogops.io
```

## Troubleshooting

### Create shell in container (pod)

```
kubectl -n www exec --stdin --tty <POD-ID> -- /bin/bash

# Verify pod DNS
curl http://<Deployment-Name>
```

### Debugging container issues

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

