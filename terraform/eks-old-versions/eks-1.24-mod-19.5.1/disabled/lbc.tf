# resource "kubernetes_manifest" "customresourcedefinition_ingressclassparams_elbv2_k8s_aws" {
#   depends_on = [kubernetes_manifest.validatingwebhookconfiguration_cert_manager_webhook]
#
#   manifest = {
#     "apiVersion" = "apiextensions.k8s.io/v1"
#     "kind" = "CustomResourceDefinition"
#     "metadata" = {
#       "annotations" = {
#         "controller-gen.kubebuilder.io/version" = "v0.5.0"
#       }
#       "creationTimestamp" = null
#       "labels" = {
#         "app.kubernetes.io/name" = "aws-load-balancer-controller"
#       }
#       "name" = "ingressclassparams.elbv2.k8s.aws"
#     }
#     "spec" = {
#       "group" = "elbv2.k8s.aws"
#       "names" = {
#         "kind" = "IngressClassParams"
#         "listKind" = "IngressClassParamsList"
#         "plural" = "ingressclassparams"
#         "singular" = "ingressclassparams"
#       }
#       "scope" = "Cluster"
#       "versions" = [
#         {
#           "additionalPrinterColumns" = [
#             {
#               "description" = "The Ingress Group name"
#               "jsonPath" = ".spec.group.name"
#               "name" = "GROUP-NAME"
#               "type" = "string"
#             },
#             {
#               "description" = "The AWS Load Balancer scheme"
#               "jsonPath" = ".spec.scheme"
#               "name" = "SCHEME"
#               "type" = "string"
#             },
#             {
#               "description" = "The AWS Load Balancer ipAddressType"
#               "jsonPath" = ".spec.ipAddressType"
#               "name" = "IP-ADDRESS-TYPE"
#               "type" = "string"
#             },
#             {
#               "jsonPath" = ".metadata.creationTimestamp"
#               "name" = "AGE"
#               "type" = "date"
#             },
#           ]
#           "name" = "v1beta1"
#           "schema" = {
#             "openAPIV3Schema" = {
#               "description" = "IngressClassParams is the Schema for the IngressClassParams API"
#               "properties" = {
#                 "apiVersion" = {
#                   "description" = "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"
#                   "type" = "string"
#                 }
#                 "kind" = {
#                   "description" = "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"
#                   "type" = "string"
#                 }
#                 "metadata" = {
#                   "type" = "object"
#                 }
#                 "spec" = {
#                   "description" = "IngressClassParamsSpec defines the desired state of IngressClassParams"
#                   "properties" = {
#                     "group" = {
#                       "description" = "Group defines the IngressGroup for all Ingresses that belong to IngressClass with this IngressClassParams."
#                       "properties" = {
#                         "name" = {
#                           "description" = "Name is the name of IngressGroup."
#                           "type" = "string"
#                         }
#                       }
#                       "required" = [
#                         "name",
#                       ]
#                       "type" = "object"
#                     }
#                     "ipAddressType" = {
#                       "description" = "IPAddressType defines the ip address type for all Ingresses that belong to IngressClass with this IngressClassParams."
#                       "enum" = [
#                         "ipv4",
#                         "dualstack",
#                       ]
#                       "type" = "string"
#                     }
#                     "loadBalancerAttributes" = {
#                       "description" = "LoadBalancerAttributes define the custom attributes to LoadBalancers for all Ingress that that belong to IngressClass with this IngressClassParams."
#                       "items" = {
#                         "description" = "Attributes defines custom attributes on resources."
#                         "properties" = {
#                           "key" = {
#                             "description" = "The key of the attribute."
#                             "type" = "string"
#                           }
#                           "value" = {
#                             "description" = "The value of the attribute."
#                             "type" = "string"
#                           }
#                         }
#                         "required" = [
#                           "key",
#                           "value",
#                         ]
#                         "type" = "object"
#                       }
#                       "type" = "array"
#                     }
#                     "namespaceSelector" = {
#                       "description" = "NamespaceSelector restrict the namespaces of Ingresses that are allowed to specify the IngressClass with this IngressClassParams. * if absent or present but empty, it selects all namespaces."
#                       "properties" = {
#                         "matchExpressions" = {
#                           "description" = "matchExpressions is a list of label selector requirements. The requirements are ANDed."
#                           "items" = {
#                             "description" = "A label selector requirement is a selector that contains values, a key, and an operator that relates the key and values."
#                             "properties" = {
#                               "key" = {
#                                 "description" = "key is the label key that the selector applies to."
#                                 "type" = "string"
#                               }
#                               "operator" = {
#                                 "description" = "operator represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists and DoesNotExist."
#                                 "type" = "string"
#                               }
#                               "values" = {
#                                 "description" = "values is an array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. This array is replaced during a strategic merge patch."
#                                 "items" = {
#                                   "type" = "string"
#                                 }
#                                 "type" = "array"
#                               }
#                             }
#                             "required" = [
#                               "key",
#                               "operator",
#                             ]
#                             "type" = "object"
#                           }
#                           "type" = "array"
#                         }
#                         "matchLabels" = {
#                           "additionalProperties" = {
#                             "type" = "string"
#                           }
#                           "description" = "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is \"key\", the operator is \"In\", and the values array contains only \"value\". The requirements are ANDed."
#                           "type" = "object"
#                         }
#                       }
#                       "type" = "object"
#                     }
#                     "scheme" = {
#                       "description" = "Scheme defines the scheme for all Ingresses that belong to IngressClass with this IngressClassParams."
#                       "enum" = [
#                         "internal",
#                         "internet-facing",
#                       ]
#                       "type" = "string"
#                     }
#                     "tags" = {
#                       "description" = "Tags defines list of Tags on AWS resources provisioned for Ingresses that belong to IngressClass with this IngressClassParams."
#                       "items" = {
#                         "description" = "Tag defines a AWS Tag on resources."
#                         "properties" = {
#                           "key" = {
#                             "description" = "The key of the tag."
#                             "type" = "string"
#                           }
#                           "value" = {
#                             "description" = "The value of the tag."
#                             "type" = "string"
#                           }
#                         }
#                         "required" = [
#                           "key",
#                           "value",
#                         ]
#                         "type" = "object"
#                       }
#                       "type" = "array"
#                     }
#                   }
#                   "type" = "object"
#                 }
#               }
#               "type" = "object"
#             }
#           }
#           "served" = true
#           "storage" = true
#           "subresources" = {}
#         },
#       ]
#     }
#   }
# }

# resource "kubernetes_manifest" "customresourcedefinition_targetgroupbindings_elbv2_k8s_aws" {
#   depends_on = [kubernetes_manifest.customresourcedefinition_ingressclassparams_elbv2_k8s_aws]

#   manifest = {
#     "apiVersion" = "apiextensions.k8s.io/v1"
#     "kind" = "CustomResourceDefinition"
#     "metadata" = {
#       "annotations" = {
#         "controller-gen.kubebuilder.io/version" = "v0.5.0"
#       }
#       "creationTimestamp" = null
#       "labels" = {
#         "app.kubernetes.io/name" = "aws-load-balancer-controller"
#       }
#       "name" = "targetgroupbindings.elbv2.k8s.aws"
#     }
#     "spec" = {
#       "group" = "elbv2.k8s.aws"
#       "names" = {
#         "kind" = "TargetGroupBinding"
#         "listKind" = "TargetGroupBindingList"
#         "plural" = "targetgroupbindings"
#         "singular" = "targetgroupbinding"
#       }
#       "scope" = "Namespaced"
#       "versions" = [
#         {
#           "additionalPrinterColumns" = [
#             {
#               "description" = "The Kubernetes Service's name"
#               "jsonPath" = ".spec.serviceRef.name"
#               "name" = "SERVICE-NAME"
#               "type" = "string"
#             },
#             {
#               "description" = "The Kubernetes Service's port"
#               "jsonPath" = ".spec.serviceRef.port"
#               "name" = "SERVICE-PORT"
#               "type" = "string"
#             },
#             {
#               "description" = "The AWS TargetGroup's TargetType"
#               "jsonPath" = ".spec.targetType"
#               "name" = "TARGET-TYPE"
#               "type" = "string"
#             },
#             {
#               "description" = "The AWS TargetGroup's Amazon Resource Name"
#               "jsonPath" = ".spec.targetGroupARN"
#               "name" = "ARN"
#               "priority" = 1
#               "type" = "string"
#             },
#             {
#               "jsonPath" = ".metadata.creationTimestamp"
#               "name" = "AGE"
#               "type" = "date"
#             },
#           ]
#           "name" = "v1alpha1"
#           "schema" = {
#             "openAPIV3Schema" = {
#               "description" = "TargetGroupBinding is the Schema for the TargetGroupBinding API"
#               "properties" = {
#                 "apiVersion" = {
#                   "description" = "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"
#                   "type" = "string"
#                 }
#                 "kind" = {
#                   "description" = "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"
#                   "type" = "string"
#                 }
#                 "metadata" = {
#                   "type" = "object"
#                 }
#                 "spec" = {
#                   "description" = "TargetGroupBindingSpec defines the desired state of TargetGroupBinding"
#                   "properties" = {
#                     "networking" = {
#                       "description" = "networking provides the networking setup for ELBV2 LoadBalancer to access targets in TargetGroup."
#                       "properties" = {
#                         "ingress" = {
#                           "description" = "List of ingress rules to allow ELBV2 LoadBalancer to access targets in TargetGroup."
#                           "items" = {
#                             "properties" = {
#                               "from" = {
#                                 "description" = "List of peers which should be able to access the targets in TargetGroup. At least one NetworkingPeer should be specified."
#                                 "items" = {
#                                   "description" = "NetworkingPeer defines the source/destination peer for networking rules."
#                                   "properties" = {
#                                     "ipBlock" = {
#                                       "description" = "IPBlock defines an IPBlock peer. If specified, none of the other fields can be set."
#                                       "properties" = {
#                                         "cidr" = {
#                                           "description" = "CIDR is the network CIDR. Both IPV4 or IPV6 CIDR are accepted."
#                                           "type" = "string"
#                                         }
#                                       }
#                                       "required" = [
#                                         "cidr",
#                                       ]
#                                       "type" = "object"
#                                     }
#                                     "securityGroup" = {
#                                       "description" = "SecurityGroup defines a SecurityGroup peer. If specified, none of the other fields can be set."
#                                       "properties" = {
#                                         "groupID" = {
#                                           "description" = "GroupID is the EC2 SecurityGroupID."
#                                           "type" = "string"
#                                         }
#                                       }
#                                       "required" = [
#                                         "groupID",
#                                       ]
#                                       "type" = "object"
#                                     }
#                                   }
#                                   "type" = "object"
#                                 }
#                                 "type" = "array"
#                               }
#                               "ports" = {
#                                 "description" = "List of ports which should be made accessible on the targets in TargetGroup. If ports is empty or unspecified, it defaults to all ports with TCP."
#                                 "items" = {
#                                   "properties" = {
#                                     "port" = {
#                                       "anyOf" = [
#                                         {
#                                           "type" = "integer"
#                                         },
#                                         {
#                                           "type" = "string"
#                                         },
#                                       ]
#                                       "description" = "The port which traffic must match. When NodePort endpoints(instance TargetType) is used, this must be a numerical port. When Port endpoints(ip TargetType) is used, this can be either numerical or named port on pods. if port is unspecified, it defaults to all ports."
#                                       "x-kubernetes-int-or-string" = true
#                                     }
#                                     "protocol" = {
#                                       "description" = "The protocol which traffic must match. If protocol is unspecified, it defaults to TCP."
#                                       "enum" = [
#                                         "TCP",
#                                         "UDP",
#                                       ]
#                                       "type" = "string"
#                                     }
#                                   }
#                                   "type" = "object"
#                                 }
#                                 "type" = "array"
#                               }
#                             }
#                             "required" = [
#                               "from",
#                               "ports",
#                             ]
#                             "type" = "object"
#                           }
#                           "type" = "array"
#                         }
#                       }
#                       "type" = "object"
#                     }
#                     "serviceRef" = {
#                       "description" = "serviceRef is a reference to a Kubernetes Service and ServicePort."
#                       "properties" = {
#                         "name" = {
#                           "description" = "Name is the name of the Service."
#                           "type" = "string"
#                         }
#                         "port" = {
#                           "anyOf" = [
#                             {
#                               "type" = "integer"
#                             },
#                             {
#                               "type" = "string"
#                             },
#                           ]
#                           "description" = "Port is the port of the ServicePort."
#                           "x-kubernetes-int-or-string" = true
#                         }
#                       }
#                       "required" = [
#                         "name",
#                         "port",
#                       ]
#                       "type" = "object"
#                     }
#                     "targetGroupARN" = {
#                       "description" = "targetGroupARN is the Amazon Resource Name (ARN) for the TargetGroup."
#                       "type" = "string"
#                     }
#                     "targetType" = {
#                       "description" = "targetType is the TargetType of TargetGroup. If unspecified, it will be automatically inferred."
#                       "enum" = [
#                         "instance",
#                         "ip",
#                       ]
#                       "type" = "string"
#                     }
#                   }
#                   "required" = [
#                     "serviceRef",
#                     "targetGroupARN",
#                   ]
#                   "type" = "object"
#                 }
#                 "status" = {
#                   "description" = "TargetGroupBindingStatus defines the observed state of TargetGroupBinding"
#                   "properties" = {
#                     "observedGeneration" = {
#                       "description" = "The generation observed by the TargetGroupBinding controller."
#                       "format" = "int64"
#                       "type" = "integer"
#                     }
#                   }
#                   "type" = "object"
#                 }
#               }
#               "type" = "object"
#             }
#           }
#           "served" = true
#           "storage" = false
#           "subresources" = {
#             "status" = {}
#           }
#         },
#         {
#           "additionalPrinterColumns" = [
#             {
#               "description" = "The Kubernetes Service's name"
#               "jsonPath" = ".spec.serviceRef.name"
#               "name" = "SERVICE-NAME"
#               "type" = "string"
#             },
#             {
#               "description" = "The Kubernetes Service's port"
#               "jsonPath" = ".spec.serviceRef.port"
#               "name" = "SERVICE-PORT"
#               "type" = "string"
#             },
#             {
#               "description" = "The AWS TargetGroup's TargetType"
#               "jsonPath" = ".spec.targetType"
#               "name" = "TARGET-TYPE"
#               "type" = "string"
#             },
#             {
#               "description" = "The AWS TargetGroup's Amazon Resource Name"
#               "jsonPath" = ".spec.targetGroupARN"
#               "name" = "ARN"
#               "priority" = 1
#               "type" = "string"
#             },
#             {
#               "jsonPath" = ".metadata.creationTimestamp"
#               "name" = "AGE"
#               "type" = "date"
#             },
#           ]
#           "name" = "v1beta1"
#           "schema" = {
#             "openAPIV3Schema" = {
#               "description" = "TargetGroupBinding is the Schema for the TargetGroupBinding API"
#               "properties" = {
#                 "apiVersion" = {
#                   "description" = "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"
#                   "type" = "string"
#                 }
#                 "kind" = {
#                   "description" = "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"
#                   "type" = "string"
#                 }
#                 "metadata" = {
#                   "type" = "object"
#                 }
#                 "spec" = {
#                   "description" = "TargetGroupBindingSpec defines the desired state of TargetGroupBinding"
#                   "properties" = {
#                     "ipAddressType" = {
#                       "description" = "ipAddressType specifies whether the target group is of type IPv4 or IPv6. If unspecified, it will be automatically inferred."
#                       "enum" = [
#                         "ipv4",
#                         "ipv6",
#                       ]
#                       "type" = "string"
#                     }
#                     "networking" = {
#                       "description" = "networking defines the networking rules to allow ELBV2 LoadBalancer to access targets in TargetGroup."
#                       "properties" = {
#                         "ingress" = {
#                           "description" = "List of ingress rules to allow ELBV2 LoadBalancer to access targets in TargetGroup."
#                           "items" = {
#                             "description" = "NetworkingIngressRule defines a particular set of traffic that is allowed to access TargetGroup's targets."
#                             "properties" = {
#                               "from" = {
#                                 "description" = "List of peers which should be able to access the targets in TargetGroup. At least one NetworkingPeer should be specified."
#                                 "items" = {
#                                   "description" = "NetworkingPeer defines the source/destination peer for networking rules."
#                                   "properties" = {
#                                     "ipBlock" = {
#                                       "description" = "IPBlock defines an IPBlock peer. If specified, none of the other fields can be set."
#                                       "properties" = {
#                                         "cidr" = {
#                                           "description" = "CIDR is the network CIDR. Both IPV4 or IPV6 CIDR are accepted."
#                                           "type" = "string"
#                                         }
#                                       }
#                                       "required" = [
#                                         "cidr",
#                                       ]
#                                       "type" = "object"
#                                     }
#                                     "securityGroup" = {
#                                       "description" = "SecurityGroup defines a SecurityGroup peer. If specified, none of the other fields can be set."
#                                       "properties" = {
#                                         "groupID" = {
#                                           "description" = "GroupID is the EC2 SecurityGroupID."
#                                           "type" = "string"
#                                         }
#                                       }
#                                       "required" = [
#                                         "groupID",
#                                       ]
#                                       "type" = "object"
#                                     }
#                                   }
#                                   "type" = "object"
#                                 }
#                                 "type" = "array"
#                               }
#                               "ports" = {
#                                 "description" = "List of ports which should be made accessible on the targets in TargetGroup. If ports is empty or unspecified, it defaults to all ports with TCP."
#                                 "items" = {
#                                   "description" = "NetworkingPort defines the port and protocol for networking rules."
#                                   "properties" = {
#                                     "port" = {
#                                       "anyOf" = [
#                                         {
#                                           "type" = "integer"
#                                         },
#                                         {
#                                           "type" = "string"
#                                         },
#                                       ]
#                                       "description" = "The port which traffic must match. When NodePort endpoints(instance TargetType) is used, this must be a numerical port. When Port endpoints(ip TargetType) is used, this can be either numerical or named port on pods. if port is unspecified, it defaults to all ports."
#                                       "x-kubernetes-int-or-string" = true
#                                     }
#                                     "protocol" = {
#                                       "description" = "The protocol which traffic must match. If protocol is unspecified, it defaults to TCP."
#                                       "enum" = [
#                                         "TCP",
#                                         "UDP",
#                                       ]
#                                       "type" = "string"
#                                     }
#                                   }
#                                   "type" = "object"
#                                 }
#                                 "type" = "array"
#                               }
#                             }
#                             "required" = [
#                               "from",
#                               "ports",
#                             ]
#                             "type" = "object"
#                           }
#                           "type" = "array"
#                         }
#                       }
#                       "type" = "object"
#                     }
#                     "nodeSelector" = {
#                       "description" = "node selector for instance type target groups to only register certain nodes"
#                       "properties" = {
#                         "matchExpressions" = {
#                           "description" = "matchExpressions is a list of label selector requirements. The requirements are ANDed."
#                           "items" = {
#                             "description" = "A label selector requirement is a selector that contains values, a key, and an operator that relates the key and values."
#                             "properties" = {
#                               "key" = {
#                                 "description" = "key is the label key that the selector applies to."
#                                 "type" = "string"
#                               }
#                               "operator" = {
#                                 "description" = "operator represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists and DoesNotExist."
#                                 "type" = "string"
#                               }
#                               "values" = {
#                                 "description" = "values is an array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. This array is replaced during a strategic merge patch."
#                                 "items" = {
#                                   "type" = "string"
#                                 }
#                                 "type" = "array"
#                               }
#                             }
#                             "required" = [
#                               "key",
#                               "operator",
#                             ]
#                             "type" = "object"
#                           }
#                           "type" = "array"
#                         }
#                         "matchLabels" = {
#                           "additionalProperties" = {
#                             "type" = "string"
#                           }
#                           "description" = "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is \"key\", the operator is \"In\", and the values array contains only \"value\". The requirements are ANDed."
#                           "type" = "object"
#                         }
#                       }
#                       "type" = "object"
#                     }
#                     "serviceRef" = {
#                       "description" = "serviceRef is a reference to a Kubernetes Service and ServicePort."
#                       "properties" = {
#                         "name" = {
#                           "description" = "Name is the name of the Service."
#                           "type" = "string"
#                         }
#                         "port" = {
#                           "anyOf" = [
#                             {
#                               "type" = "integer"
#                             },
#                             {
#                               "type" = "string"
#                             },
#                           ]
#                           "description" = "Port is the port of the ServicePort."
#                           "x-kubernetes-int-or-string" = true
#                         }
#                       }
#                       "required" = [
#                         "name",
#                         "port",
#                       ]
#                       "type" = "object"
#                     }
#                     "targetGroupARN" = {
#                       "description" = "targetGroupARN is the Amazon Resource Name (ARN) for the TargetGroup."
#                       "minLength" = 1
#                       "type" = "string"
#                     }
#                     "targetType" = {
#                       "description" = "targetType is the TargetType of TargetGroup. If unspecified, it will be automatically inferred."
#                       "enum" = [
#                         "instance",
#                         "ip",
#                       ]
#                       "type" = "string"
#                     }
#                   }
#                   "required" = [
#                     "serviceRef",
#                     "targetGroupARN",
#                   ]
#                   "type" = "object"
#                 }
#                 "status" = {
#                   "description" = "TargetGroupBindingStatus defines the observed state of TargetGroupBinding"
#                   "properties" = {
#                     "observedGeneration" = {
#                       "description" = "The generation observed by the TargetGroupBinding controller."
#                       "format" = "int64"
#                       "type" = "integer"
#                     }
#                   }
#                   "type" = "object"
#                 }
#               }
#               "type" = "object"
#             }
#           }
#           "served" = true
#           "storage" = true
#           "subresources" = {
#             "status" = {}
#           }
#         },
#       ]
#     }
#   }
# }

# resource "kubernetes_role" "aws_load_balancer_controller_leader_election_role" {
#   depends_on = [kubernetes_manifest.customresourcedefinition_targetgroupbindings_elbv2_k8s_aws]

#   metadata {
#     name      = "aws-load-balancer-controller-leader-election-role"
#     namespace = "kube-system"

#     labels = {
#       "app.kubernetes.io/name" = "aws-load-balancer-controller"
#     }
#   }

#   rule {
#     verbs      = ["create"]
#     api_groups = [""]
#     resources  = ["configmaps"]
#   }

#   rule {
#     verbs          = ["get", "update", "patch"]
#     api_groups     = [""]
#     resources      = ["configmaps"]
#     resource_names = ["aws-load-balancer-controller-leader"]
#   }
# }

# resource "kubernetes_cluster_role" "aws_load_balancer_controller_role" {
#   depends_on = [kubernetes_manifest.customresourcedefinition_targetgroupbindings_elbv2_k8s_aws]

#   metadata {
#     name = "aws-load-balancer-controller-role"

#     labels = {
#       "app.kubernetes.io/name" = "aws-load-balancer-controller"
#     }
#   }

#   rule {
#     verbs      = ["get", "list", "watch"]
#     api_groups = [""]
#     resources  = ["endpoints"]
#   }

#   rule {
#     verbs      = ["create", "patch"]
#     api_groups = [""]
#     resources  = ["events"]
#   }

#   rule {
#     verbs      = ["get", "list", "watch"]
#     api_groups = [""]
#     resources  = ["namespaces"]
#   }

#   rule {
#     verbs      = ["get", "list", "watch"]
#     api_groups = [""]
#     resources  = ["nodes"]
#   }

#   rule {
#     verbs      = ["get", "list", "watch"]
#     api_groups = [""]
#     resources  = ["pods"]
#   }

#   rule {
#     verbs      = ["patch", "update"]
#     api_groups = [""]
#     resources  = ["pods/status"]
#   }

#   rule {
#     verbs      = ["get", "list", "patch", "update", "watch"]
#     api_groups = [""]
#     resources  = ["services"]
#   }

#   rule {
#     verbs      = ["patch", "update"]
#     api_groups = [""]
#     resources  = ["services/status"]
#   }

#   rule {
#     verbs      = ["get", "list", "watch"]
#     api_groups = ["discovery.k8s.io"]
#     resources  = ["endpointslices"]
#   }

#   rule {
#     verbs      = ["get", "list", "watch"]
#     api_groups = ["elbv2.k8s.aws"]
#     resources  = ["ingressclassparams"]
#   }

#   rule {
#     verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
#     api_groups = ["elbv2.k8s.aws"]
#     resources  = ["targetgroupbindings"]
#   }

#   rule {
#     verbs      = ["patch", "update"]
#     api_groups = ["elbv2.k8s.aws"]
#     resources  = ["targetgroupbindings/status"]
#   }

#   rule {
#     verbs      = ["get", "list", "patch", "update", "watch"]
#     api_groups = ["extensions"]
#     resources  = ["ingresses"]
#   }

#   rule {
#     verbs      = ["patch", "update"]
#     api_groups = ["extensions"]
#     resources  = ["ingresses/status"]
#   }

#   rule {
#     verbs      = ["get", "list", "watch"]
#     api_groups = ["networking.k8s.io"]
#     resources  = ["ingressclasses"]
#   }

#   rule {
#     verbs      = ["get", "list", "patch", "update", "watch"]
#     api_groups = ["networking.k8s.io"]
#     resources  = ["ingresses"]
#   }

#   rule {
#     verbs      = ["patch", "update"]
#     api_groups = ["networking.k8s.io"]
#     resources  = ["ingresses/status"]
#   }
# }

# resource "kubernetes_role_binding" "aws_load_balancer_controller_leader_election_rolebinding" {
#   depends_on = [kubernetes_role.aws_load_balancer_controller_leader_election_role]

#   metadata {
#     name      = "aws-load-balancer-controller-leader-election-rolebinding"
#     namespace = "kube-system"

#     labels = {
#       "app.kubernetes.io/name" = "aws-load-balancer-controller"
#     }
#   }

#   subject {
#     kind      = "ServiceAccount"
#     name      = "aws-load-balancer-controller"
#     namespace = "kube-system"
#   }

#   role_ref {
#     api_group = "rbac.authorization.k8s.io"
#     kind      = "Role"
#     name      = "aws-load-balancer-controller-leader-election-role"
#   }
# }

# resource "kubernetes_cluster_role_binding" "aws_load_balancer_controller_rolebinding" {
#   depends_on = [kubernetes_cluster_role.aws_load_balancer_controller_role]

#   metadata {
#     name = "aws-load-balancer-controller-rolebinding"

#     labels = {
#       "app.kubernetes.io/name" = "aws-load-balancer-controller"
#     }
#   }

#   subject {
#     kind      = "ServiceAccount"
#     name      = "aws-load-balancer-controller"
#     namespace = "kube-system"
#   }

#   role_ref {
#     api_group = "rbac.authorization.k8s.io"
#     kind      = "ClusterRole"
#     name      = "aws-load-balancer-controller-role"
#   }
# }

# resource "kubernetes_service" "aws_load_balancer_webhook_service" {
#   depends_on = [kubernetes_cluster_role_binding.aws_load_balancer_controller_rolebinding]

#   metadata {
#     name      = "aws-load-balancer-webhook-service"
#     namespace = "kube-system"

#     labels = {
#       "app.kubernetes.io/name" = "aws-load-balancer-controller"
#     }
#   }

#   spec {
#     port {
#       port        = 443
#       target_port = "9443"
#     }

#     selector = {
#       "app.kubernetes.io/component" = "controller"

#       "app.kubernetes.io/name" = "aws-load-balancer-controller"
#     }
#   }
# }

# resource "kubernetes_deployment" "aws_load_balancer_controller" {
#   depends_on = [kubernetes_service.aws_load_balancer_webhook_service]

#   metadata {
#     name      = "aws-load-balancer-controller"
#     namespace = "kube-system"

#     labels = {
#       "app.kubernetes.io/component" = "controller"

#       "app.kubernetes.io/name" = "aws-load-balancer-controller"
#     }
#   }

#   spec {
#     replicas = 1

#     selector {
#       match_labels = {
#         "app.kubernetes.io/component" = "controller"

#         "app.kubernetes.io/name" = "aws-load-balancer-controller"
#       }
#     }

#     template {
#       metadata {
#         labels = {
#           "app.kubernetes.io/component" = "controller"

#           "app.kubernetes.io/name" = "aws-load-balancer-controller"
#         }
#       }

#       spec {
#         volume {
#           name = "cert"

#           secret {
#             secret_name  = "aws-load-balancer-webhook-tls"
#             default_mode = "0644"
#           }
#         }

#         container {
#           name  = "controller"
#           image = "amazon/aws-alb-ingress-controller:v2.4.5"
#           args  = ["--cluster-name=my-k8s", "--ingress-class=alb"]

#           port {
#             name           = "webhook-server"
#             container_port = 9443
#             protocol       = "TCP"
#           }

#           resources {
#             limits = {
#               cpu = "200m"

#               memory = "500Mi"
#             }

#             requests = {
#               cpu = "100m"

#               memory = "200Mi"
#             }
#           }

#           volume_mount {
#             name       = "cert"
#             read_only  = true
#             mount_path = "/tmp/k8s-webhook-server/serving-certs"
#           }

#           liveness_probe {
#             http_get {
#               path   = "/healthz"
#               port   = "61779"
#               scheme = "HTTP"
#             }

#             initial_delay_seconds = 30
#             timeout_seconds       = 10
#             failure_threshold     = 2
#           }

#           security_context {
#             run_as_non_root           = true
#             read_only_root_filesystem = true
#           }
#         }

#         termination_grace_period_seconds = 10
#         service_account_name             = "aws-load-balancer-controller"

#         security_context {
#           fs_group = 1337
#         }

#         priority_class_name = "system-cluster-critical"
#       }
#     }
#   }
# }

# resource "kubernetes_manifest" "certificate_kube_system_aws_load_balancer_serving_cert" {
#   depends_on = [kubernetes_deployment.aws_load_balancer_controller]

#   manifest = {
#     "apiVersion" = "cert-manager.io/v1"
#     "kind" = "Certificate"
#     "metadata" = {
#       "labels" = {
#         "app.kubernetes.io/name" = "aws-load-balancer-controller"
#       }
#       "name" = "aws-load-balancer-serving-cert"
#       "namespace" = "kube-system"
#     }
#     "spec" = {
#       "dnsNames" = [
#         "aws-load-balancer-webhook-service.kube-system.svc",
#         "aws-load-balancer-webhook-service.kube-system.svc.cluster.local",
#       ]
#       "issuerRef" = {
#         "kind" = "Issuer"
#         "name" = "aws-load-balancer-selfsigned-issuer"
#       }
#       "secretName" = "aws-load-balancer-webhook-tls"
#     }
#   }
# }

# resource "kubernetes_manifest" "issuer_kube_system_aws_load_balancer_selfsigned_issuer" {
#   depends_on = [kubernetes_manifest.certificate_kube_system_aws_load_balancer_serving_cert]

#   manifest = {
#     "apiVersion" = "cert-manager.io/v1"
#     "kind" = "Issuer"
#     "metadata" = {
#       "labels" = {
#         "app.kubernetes.io/name" = "aws-load-balancer-controller"
#       }
#       "name" = "aws-load-balancer-selfsigned-issuer"
#       "namespace" = "kube-system"
#     }
#     "spec" = {
#       "selfSigned" = {}
#     }
#   }
# }

# resource "kubernetes_manifest" "mutatingwebhookconfiguration_aws_load_balancer_webhook" {
#   depends_on = [kubernetes_manifest.issuer_kube_system_aws_load_balancer_selfsigned_issuer]

#   manifest = {
#     "apiVersion" = "admissionregistration.k8s.io/v1"
#     "kind" = "MutatingWebhookConfiguration"
#     "metadata" = {
#       "annotations" = {
#         "cert-manager.io/inject-ca-from" = "kube-system/aws-load-balancer-serving-cert"
#       }
#       "labels" = {
#         "app.kubernetes.io/name" = "aws-load-balancer-controller"
#       }
#       "name" = "aws-load-balancer-webhook"
#     }
#     "webhooks" = [
#       {
#         "admissionReviewVersions" = [
#           "v1beta1",
#         ]
#         "clientConfig" = {
#           "service" = {
#             "name" = "aws-load-balancer-webhook-service"
#             "namespace" = "kube-system"
#             "path" = "/mutate-v1-pod"
#           }
#         }
#         "failurePolicy" = "Fail"
#         "name" = "mpod.elbv2.k8s.aws"
#         "namespaceSelector" = {
#           "matchExpressions" = [
#             {
#               "key" = "elbv2.k8s.aws/pod-readiness-gate-inject"
#               "operator" = "In"
#               "values" = [
#                 "enabled",
#               ]
#             },
#           ]
#         }
#         "objectSelector" = {
#           "matchExpressions" = [
#             {
#               "key" = "app.kubernetes.io/name"
#               "operator" = "NotIn"
#               "values" = [
#                 "aws-load-balancer-controller",
#               ]
#             },
#           ]
#         }
#         "rules" = [
#           {
#             "apiGroups" = [
#               "",
#             ]
#             "apiVersions" = [
#               "v1",
#             ]
#             "operations" = [
#               "CREATE",
#             ]
#             "resources" = [
#               "pods",
#             ]
#           },
#         ]
#         "sideEffects" = "None"
#       },
#       {
#         "admissionReviewVersions" = [
#           "v1beta1",
#         ]
#         "clientConfig" = {
#           "service" = {
#             "name" = "aws-load-balancer-webhook-service"
#             "namespace" = "kube-system"
#             "path" = "/mutate-elbv2-k8s-aws-v1beta1-targetgroupbinding"
#           }
#         }
#         "failurePolicy" = "Fail"
#         "name" = "mtargetgroupbinding.elbv2.k8s.aws"
#         "rules" = [
#           {
#             "apiGroups" = [
#               "elbv2.k8s.aws",
#             ]
#             "apiVersions" = [
#               "v1beta1",
#             ]
#             "operations" = [
#               "CREATE",
#               "UPDATE",
#             ]
#             "resources" = [
#               "targetgroupbindings",
#             ]
#           },
#         ]
#         "sideEffects" = "None"
#       },
#     ]
#   }
# }

# resource "kubernetes_manifest" "validatingwebhookconfiguration_aws_load_balancer_webhook" {
#   depends_on = [kubernetes_manifest.mutatingwebhookconfiguration_aws_load_balancer_webhook]

#   manifest = {
#     "apiVersion" = "admissionregistration.k8s.io/v1"
#     "kind" = "ValidatingWebhookConfiguration"
#     "metadata" = {
#       "annotations" = {
#         "cert-manager.io/inject-ca-from" = "kube-system/aws-load-balancer-serving-cert"
#       }
#       "labels" = {
#         "app.kubernetes.io/name" = "aws-load-balancer-controller"
#       }
#       "name" = "aws-load-balancer-webhook"
#     }
#     "webhooks" = [
#       {
#         "admissionReviewVersions" = [
#           "v1beta1",
#         ]
#         "clientConfig" = {
#           "service" = {
#             "name" = "aws-load-balancer-webhook-service"
#             "namespace" = "kube-system"
#             "path" = "/validate-elbv2-k8s-aws-v1beta1-targetgroupbinding"
#           }
#         }
#         "failurePolicy" = "Fail"
#         "name" = "vtargetgroupbinding.elbv2.k8s.aws"
#         "rules" = [
#           {
#             "apiGroups" = [
#               "elbv2.k8s.aws",
#             ]
#             "apiVersions" = [
#               "v1beta1",
#             ]
#             "operations" = [
#               "CREATE",
#               "UPDATE",
#             ]
#             "resources" = [
#               "targetgroupbindings",
#             ]
#           },
#         ]
#         "sideEffects" = "None"
#       },
#       {
#         "admissionReviewVersions" = [
#           "v1beta1",
#         ]
#         "clientConfig" = {
#           "service" = {
#             "name" = "aws-load-balancer-webhook-service"
#             "namespace" = "kube-system"
#             "path" = "/validate-networking-v1-ingress"
#           }
#         }
#         "failurePolicy" = "Fail"
#         "matchPolicy" = "Equivalent"
#         "name" = "vingress.elbv2.k8s.aws"
#         "rules" = [
#           {
#             "apiGroups" = [
#               "networking.k8s.io",
#             ]
#             "apiVersions" = [
#               "v1",
#             ]
#             "operations" = [
#               "CREATE",
#               "UPDATE",
#             ]
#             "resources" = [
#               "ingresses",
#             ]
#           },
#         ]
#         "sideEffects" = "None"
#       },
#     ]
#   }
# }

# resource "kubernetes_ingress_class" "alb" {
#   depends_on = [kubernetes_manifest.validatingwebhookconfiguration_aws_load_balancer_webhook]

#   metadata {
#     name = "alb"

#     labels = {
#       "app.kubernetes.io/name" = "aws-load-balancer-controller"
#     }
#   }

#   spec {
#     controller = "ingress.k8s.aws/alb"
#   }
# }
