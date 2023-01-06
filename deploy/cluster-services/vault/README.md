# Hashicorp Vault

https://developer.hashicorp.com/vault/tutorials/kubernetes/kubernetes-raft-deployment-guide


## Install

```
helm -n vault upgrade --install vault121 ./vault
```

## Unseal

Vault Server pod will not show as healthy until you unseal 

```
kubectl -n vault port-forward vault121-0 8200:8200
```

http://localhost:8200/ui/

Seal/Unseal doc: https://developer.hashicorp.com/vault/docs/concepts/seal

Retrieve initial root token and key(s)

# Uninstall

```
helm -n vault uninstall vault121
```
