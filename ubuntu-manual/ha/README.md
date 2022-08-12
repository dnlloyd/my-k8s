# Install Kubernetes on Ubuntu (HA)

## IaC

[terraform/k8s-manual-ubuntu/ha](../terraform/k8s-manual-ubuntu/ha)

## Install

(All nodes)

https://phoenixnap.com/kb/install-kubernetes-on-ubuntu

https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/high-availability/


(Master 01)

```
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 \
  --control-plane-endpoint "myk8sapi.fhcdan.net:443" \
  --upload-certs
```

## Deploy pod network 

(Master 01)

```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

```
sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

Verify

```
kubectl get pods --all-namespaces
```

## Join additional masters

(All remaining masters)
```
sudo kubeadm join myk8sapi.fhcdan.net:443 --token XXXXXXXXXXXXX \
  --discovery-token-ca-cert-hash sha256:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX \
  --control-plane \
  --certificate-key XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
