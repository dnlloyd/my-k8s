# Install

Cert Manager, AWS Load Balancer Controller, and Ingress Class are all currently being deployed by Terraform

# Guides

1. https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.4/deploy/installation/
2. https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.4/guide/ingress/annotations/
3. https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html
4. https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html

# Manual deployments
1. cert manager: `kubectl apply -f cert-manager-v1_5_4.yaml`
2. Comment out service account object (Terraform creates it via IRSA)
3. Add to `Deployment: aws-load-balancer-controller`
  - `spec.template.metadata.spec.containers.args` = `["--cluster-name=my-k8s"]`
4. load balancer controller: `kubectl apply -f lbc-v2_4_5-full.yaml`
5. ingress class: `kubectl apply -f ingclass-v2_4_5.yaml`

# Ref
https://kubernetes.io/docs/concepts/services-networking/ingress/

https://www.stacksimplify.com/aws-eks/aws-alb-ingress/lean-kubernetes-aws-alb-ingress-basics/

Example: 
https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.4/docs/examples/2048/2048_full.yaml

https://aws.amazon.com/premiumsupport/knowledge-center/load-balancer-troubleshoot-creating/

