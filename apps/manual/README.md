Create secret for ECR

```
kubectl create secret docker-registry regcred \
  --docker-server=458891109543.dkr.ecr.us-east-1.amazonaws.com \
  --docker-username=AWS \
  --docker-password=$(aws ecr get-login-password) \
  --namespace=www
```

Deploy

```
kubectl namespace create www
kubectl apply -f deployment.yml
```

Troubleshoot

```
kubectl -n www get pods 

kubectl -n www exec --stdin --tty <POD> -- /bin/bash
```

```
curl http://localhost:80
```
