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
