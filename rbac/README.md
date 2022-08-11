# Create normal user (Self managed k8s)

https://kubernetes.io/docs/reference/access-authn-authz/certificate-signing-requests/#normal-user

## Create client certificate for user

Create a private key
```
openssl genrsa -out dan.key 2048
```

Create a CertificateSigningRequest and submit it to a Kubernetes Cluster via kubectl
```
openssl req -new -key dan.key -out dan.csr -subj "/CN=dan"
openssl base64 -e -A -in dan.csr

kubectl apply -f csr-dan.yaml
```

Approve csr
```
kubectl get csr
kubectl certificate approve dan
```

Show certificate
```
kubectl get csr/dan -o yaml
```

Export certificate to file
```
kubectl get csr dan -o jsonpath='{.status.certificate}'| base64 -d > dan.crt
```

```
kubectl config set-credentials dan --client-certificate=/Users/dan/pki/dan.crt --client-key=/Users/dan/pki/dan.key
kubectl config set-context dan-context --cluster=kubernetes --user=dan
kubectl config use-context dan-context
```

# Create role and bind to user

https://kubernetes.io/docs/reference/access-authn-authz/rbac/

```
kubectl apply -f roles-ubu.yaml

kubectl apply -f rolebindings-ubu.yaml
```

## Verify

```
kubectl --context=dan-context get svc
```

# AWS Authentication (EKS)

## Show aws-auth configmap

```
kubectl describe -n kube-system configmap/aws-auth
```

# Misc

## Show all resources (pods, nodes, etc.)
```
kubectl api-resources
```
