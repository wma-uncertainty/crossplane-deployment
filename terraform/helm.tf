provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.cluster.certificate_authority[0].data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      # This requires the awscli to be installed locally where Terraform is executed
      args = ["eks", "get-token", "--cluster-name", aws_eks_cluster.cluster.name]
    }
  }
}

resource "helm_release" "autoscaler" {
  name             = "cluster-autoscaler"
  repository       = "https://kubernetes.github.io/autoscaler"
  chart            = "cluster-autoscaler"
  version          = var.cluster_autoscaler_version
  namespace        = "cluster-autoscaler"
  create_namespace = true

  set {
    name  = "autoDiscovery.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "awsRegion"
    value = var.region
  }

  set {
    # Double escaping needed as otherwise . is inteprerted as a nesting
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.cluster_autoscaler_irsa.iam_role_arn
  }

  wait = true

  depends_on = [
    aws_eks_cluster.cluster
  ]
}

#resource "helm_release" "crossplane" {
#  name             = "crossplane"
#  repository       = "https://charts.crossplane.io/stable"
#  chart            = "crossplane-stable"
#  namespace        = "crossplane"
#  create_namespace = true
#
#  set {
#    name  = "autoDiscovery.clusterName"
#    value = var.cluster_name
#  }
#
#  set {
#    name  = "awsRegion"
#    value = var.region
#  }
#
#  set {
#    # Double escaping needed as otherwise . is inteprerted as a nesting
#    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#    value = module.cluster_autoscaler_irsa.iam_role_arn
#  }
#
#  wait = true
#
#  depends_on = [
#    aws_eks_cluster.cluster
#  ]
#}
#
#resource "helm_release" "prometheus" {
#  name             = "prometheus"
#  repository       = "https://prometheus-community.github.io/helm-charts"
#  chart            = "prometheus"
#  namespace        = "support"
#  create_namespace = true
#  version          = var.prometheus_version
#
#  set {
#    # We don't use alertmanager
#    name  = "alertmanager.enabled"
#    value = false
#  }
#
#  set {
#    # We don't use pushgateway either
#    name  = "pushgateway.enabled"
#    value = false
#  }
#
#  set {
#    name  = "server.persistentVolume.size"
#    value = var.prometheus_disk_size
#  }
#
#  set {
#    name  = "server.retention"
#    value = "${var.prometheus_metrics_retention_days}d"
#  }
#
#  set {
#    name  = "server.ingress.enabled"
#    value = true
#  }
#
#  set {
#    name  = "server.ingress.hosts[0]"
#    value = var.prometheus_hostname
#  }
#
#  set {
#    # Double \\ is neded so the entire last part of the name is used as key
#    name  = "server.ingress.annotations.kubernetes\\.io/ingress\\.class"
#    value = "nginx"
#  }
#
#  set {
#    # We have a persistent disk attached, so the default (RollingUpdate)
#    # can sometimes get 'stuck' and require pods to be manually deleted.
#    name  = "strategy.type"
#    value = "Recreate"
#  }
#  # wait = true
#  depends_on = [
#    aws_eks_cluster.cluster
#  ]
#}

# install AWS Load Balancer Controller
# https://github.com/aws/eks-charts/blob/master/stable/aws-load-balancer-controller/values.yaml
# lots of good tips at 
# https://artifacthub.io/packages/helm/aws/aws-load-balancer-controller
resource "helm_release" "ingress" {
  name             = "ingress"
  repository       = "https://aws.github.io/eks-charts"
  chart            = "aws-load-balancer-controller"
  namespace        = "kube-system"
  create_namespace = true
  version          = var.aws_load_balancer_controller_version

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  #set {
  #  name  = "region"
  #  value = var.region
  #}

  #set {
  #  name  = "vpcId"
  #  value = data.aws_vpc.default.id
  #}
  set {
    name  = "autoDiscoverAwsRegion"
    value = "true"
  }

  set {
    name  = "autoDiscoverAwsVpcID"
    value = "true"
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = aws_iam_role.cluster_control_plane.name
  }

  set {
    name  = "serviceAccount.annotations.eks.amazonaws.com/role-arn"
    value = aws_iam_role.cluster_control_plane.arn
  }

  wait = true

  depends_on = [
    aws_eks_cluster.cluster
  ]
}

#resource "helm_release" "ingress" {
#  name             = "ingress"
#  repository       = "https://kubernetes.github.io/ingress-nginx"
#  chart            = "ingress-nginx"
#  namespace        = "support"
#  create_namespace = true
#  version          = var.nginx_ingress_version
#
#  wait = true
#  depends_on = [
#    aws_eks_cluster.cluster
#  ]
#}
