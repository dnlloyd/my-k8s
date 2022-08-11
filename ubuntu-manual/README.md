# Install Kubernetes on Ubuntu

## Terraform EC2 IaC
[Terraform EC2](../terraform/k8s-manual-ubuntu)

## Install

### Short version

[https://phoenixnap.com/kb/install-kubernetes-on-ubuntu](https://phoenixnap.com/kb/install-kubernetes-on-ubuntu)

```
sudo kubeadm join 172.31.0.88:6443 --token XXXXXXXXXXX \
--discovery-token-ca-cert-hash sha256:XXXXXXXXXXXXXXX
```

### Supplemental

https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/

## Public endpoint connectivity

Add config from `<control-plane-host>:/etc/kubernetes/admin.conf` to `~/.kube/config` but change server to `server: https://kubernetes:6443`

```
vi /etc/hosts

18.207.106.154  kubernetes # Public IP address of master node that matches admin certificate
```

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
