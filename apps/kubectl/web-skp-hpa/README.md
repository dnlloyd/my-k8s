
# Web SKP

* Nginx web container
* AWS load balancer
* AWS Route53 record
* HPA (metrics via metrics server)

## Deploy Metrics Server

```
kubectl apply -f metrics-server.yaml
```

## Deploy

```
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f hpa.yaml
```

## Verify

```
kubectl -n www get hpa web-skp-hpa
kubectl -n www describe hpa web-skp-hpa
```

```
kubectl -n www exec --stdin --tty web-skp-6c77f659bb-trzv6 -- /bin/bash
```

```
while sleep 0.01; do curl http://web-skp; done
```

## Reference

https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/

https://github.com/kubernetes-sigs/metrics-server#readme

