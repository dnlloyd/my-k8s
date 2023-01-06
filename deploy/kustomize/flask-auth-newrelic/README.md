# KSOPS

https://github.com/viaduct-ai/kustomize-sops

KOPS config file `.sops.yaml` is searched for recursively

```
sops -e new-relic-secret.yaml > new-relic-secret.enc.yaml
```

Verify

```
kustomize build --enable-alpha-plugins .
```