# ECR

## Credentials

```
kubectl create secret docker-registry regcred \
  --docker-server=458891109543.dkr.ecr.us-east-1.amazonaws.com \
  --docker-username=AWS \
  --docker-password=$(aws ecr get-login-password) \
  --namespace=www
```
