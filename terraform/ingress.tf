# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress
# https://github.com/aws-ia/terraform-aws-eks-blueprints/tree/main/patterns/private-public-ingress
# TODO wait for cluster
resource "aws_security_group" "ingress_nginx_external" {
  name        = "${var.cluster_name}-ingress-nginx-external"
  description = "Allow public HTTP and HTTPS traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # modify to your requirements
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # modify to your requirements
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

#resource "kubernetes_service" "ingress" {
#  metadata {
#    name = "ingress-service"
#  }
#  spec {
#    port {
#      port        = 80
#      target_port = 80
#      protocol    = "TCP"
#    }
#    type = "NodePort"
#  }
#
#  # Might also want this
#  depends_on = [
#    aws_eks_cluster.cluster
#  ]
#}
#
#resource "kubernetes_ingress" "ingress" {
#  wait_for_load_balancer = true
#  metadata {
#    name = "ingress"
#    annotations = {
#      "kubernetes.io/ingress.class" = "nginx"
#    }
#  }
#  spec {
#    rule {
#      http {
#        path {
#          path = "/*"
#          backend {
#            service_name = kubernetes_service.ingress.metadata.0.name
#            service_port = 80
#          }
#        }
#      }
#    }
#  }
#}
#
data "aws_route53_zone" "selected" {
  zone_id = var.route53_zone_id
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.cluster_name
  #name    = "www.${data.aws_route53_zone.selected.name}"
  type = "A"
  alias {
    name                   = aws_lb.public_lb.dns_name
    zone_id                = aws_lb.public_lb.zone_id
    evaluate_target_health = true
  }
}


data "aws_subnet" "public" {
  id = var.aws_lb_subnet
}

#resource "aws_lb" "public_lb" {
#  name               = "${var.cluster_name}-lb-tf"
#  internal           = true # maybe set to false if VPC has an internet gateway
#  load_balancer_type = "network"
#  ip_address_type    = "ipv4" # set to "dualstack" if subnets are IPv6 enabled
#  #subnets            = [for subnet in data.aws_subnet.public : subnet.id]
#  subnets = [data.aws_subnet.public.id]
#
#  enable_deletion_protection = false
#
#  tags = {
#    Environment = "development"
#  }
#}

# TODO delete one of these
resource "aws_lb" "public_lb" {
  name               = "${var.cluster_name}-lb-tf"
  internal           = true # maybe set to false if VPC has an internet gateway
  load_balancer_type = "network"
  ip_address_type    = "ipv4" # set to "dualstack" if subnets are IPv6 enabled
  #subnets            = [for subnet in data.aws_subnets.default.ids : subnet.id]
  subnets = data.aws_subnets.default.ids # InvalidConfigurationRequest: All subnets must belong to the same VPC: 'vpc-0055752230db6161d'
  #subnets = [data.aws_subnet.public.id]

  enable_deletion_protection = false

  tags = {
    Environment = "development"
  }
}
