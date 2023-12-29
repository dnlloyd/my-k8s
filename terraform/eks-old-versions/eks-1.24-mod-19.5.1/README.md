# kubeconfig

```
aws eks update-kubeconfig --region us-east-1 --name my-k8s --alias my-k8s
```

# VPC CNI

https://docs.aws.amazon.com/eks/latest/userguide/managing-vpc-cni.html
https://docs.aws.amazon.com/eks/latest/userguide/cni-iam-role.html

Add-on version
```
aws eks describe-addon --cluster-name my-k8s --addon-name vpc-cni --query addon.addonVersion --output text
```

Self-managed version
```
kubectl describe daemonset aws-node --namespace kube-system | grep amazon-k8s-cni: | cut -d : -f 3
```

Check for `AWS_WEB_IDENTITY_TOKEN_FILE` and `AWS_ROLE_ARN`
```
kubectl exec -n kube-system aws-node-24z6d -c aws-node -- env | grep AWS
```

# Install kubeadm on Amazon Linux 2

[https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)
