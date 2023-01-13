# Install

Note: Cert Manager, AWS Load Balancer Controller, and Ingress Class are all currently being deployed by Terraform

# Guides

1. https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.4/deploy/installation/
2. https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html
3. https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html

# Manual deployments
1. cert manager: `kubectl apply -f cert-manager-v1_5_4.yaml`
2. load balancer controller: `kubectl apply -f lbc-v2_4_5-full.yaml`
3. ingress class: `kubectl apply -f ingclass-v2_4_5.yaml`

# Ref
https://kubernetes.io/docs/concepts/services-networking/ingress/

Example: 
https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.4/docs/examples/2048/2048_full.yaml

https://aws.amazon.com/premiumsupport/knowledge-center/load-balancer-troubleshoot-creating/