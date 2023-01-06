# KSOPS

https://github.com/viaduct-ai/kustomize-sops

KOPS config file `.sops.yaml` is searched for recursively

```
sops -e overlays/new-relic-secret.yaml > overlays/new-relic-secret.enc.yaml
```

Verify

```
kustomize build --enable-alpha-plugins .
```

# Deploy

```
kubectl apply -k overlays
```