# Prometheus

https://docs.aws.amazon.com/eks/latest/userguide/prometheus.html

```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm pull prometheus-community/prometheus --untar

helm template prometheus-18 prometheus --output-dir prometheus_RENDERED
```

??
```
service:type: LoadBalancer
```


```
kubectl create namespace prometheus

helm upgrade -i prometheus18 ./prometheus \
    --namespace prometheus \
    --set alertmanager.persistentVolume.storageClass="gp2",server.persistentVolume.storageClass="gp2"
```

```
kubectl --namespace=prometheus port-forward deploy/prometheus18-server 9090
```

Uninstall

```
helm -n prometheus uninstall prometheus18
```