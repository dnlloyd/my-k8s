# Install Kubernetes on Ubuntu (Single control plane node)

## IaC
[terraform/k8s-manual-ubuntu/single-master](../terraform/k8s-manual-ubuntu/single-master)

## Install

### Short version

[https://phoenixnap.com/kb/install-kubernetes-on-ubuntu](https://phoenixnap.com/kb/install-kubernetes-on-ubuntu)

[All]
```
sudo apt-get update
sudo apt-get install docker.io
docker --version
sudo systemctl enable docker
sudo systemctl status docker
```

[All]
```
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
sudo apt-get install kubeadm kubelet kubectl
sudo apt-mark hold kubeadm kubelet kubectl
kubeadm version
sudo swapoff -a
```

[Master]
```
sudo hostnamectl set-hostname master
exit

sudo kubeadm init \
  --pod-network-cidr=10.244.0.0/16 \
  --control-plane-endpoint "myk8s.fhcdan.net:6443"

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl get pods --all-namespaces
```

[Workers]
```
sudo hostnamectl set-hostname worker-<XX>
exit

sudo kubeadm join 172.31.0.88:6443 --token XXXXXXXXXXX \
--discovery-token-ca-cert-hash sha256:XXXXXXXXXXXXXXX
```

[Master]
```
kubectl get nodes
```

### Supplemental

https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/

## Admin API connectivity

[optional-controlling-your-cluster-from-machines-other-than-the-control-plane-node](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#optional-controlling-your-cluster-from-machines-other-than-the-control-plane-node)

Add config from `<control-plane-host>:/etc/kubernetes/admin.conf` to `~/.kube/config`

Or add a user via:

[rbac/README.md](../../rbac/README.md)

## Issues

### CGroups driver mismatch issue in kubectl init

https://github.com/kubernetes/kubernetes/issues/43805#issuecomment-907734385

```
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 #This is required for the flannel network
```

Immediately after (as) this starts, edit: `/var/lib/kubelet/config.yaml` and change the following
`cgroupDriver: cgroupfs`

The initialization should complete successfully 

Need to do the same thing on the worker node when joining
```
kubeadm join 10.0.0.81:6443 --token XXXXXXXXXXX \
--discovery-token-ca-cert-hash sha256:XXXXXXXXXXXXXXXXXXX
```

Immediately after (as) this starts, edit: `/var/lib/kubelet/config.yaml` and change the following
`cgroupDriver: cgroupfs`

## Misc
