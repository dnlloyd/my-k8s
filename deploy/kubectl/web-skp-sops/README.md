
# Web SKP

* Nginx web container
* AWS load balancer
* AWS Route53 record
* [Secrets](https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/)

## Secrets  with SOPS and KMS

Base64 data

```
echo -n 'foo' | base64
echo -n 'foobarzoo' | base64
```

Encrypt
```
KMS_ARN="arn:aws:kms:us-east-1:458891109543:key/ce910031-b905-4f68-aca0-b1c06c8e4189"
sops --kms=$KMS_ARN --encrypt secret.yaml > secret.sops.yaml
```

Deploy secret

```
sops --decrypt secret.sops.yaml | kubectl apply -f -
```

## Deploy with access to secrets
```
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

## Verify

```
kubectl -n www get pods 
kubectl -n www exec --stdin --tty <POD> -- /bin/bash
```

Service port

```
curl http://localhost:80
```

Secrets
```
echo "$( cat /etc/secret-volume/password )"
echo $MY_USERNAME
```


```
kubectl delete -f service.yaml
kubectl delete -f deployment.yaml
kubectl apply -f secret.yaml
```
