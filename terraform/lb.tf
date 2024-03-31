data "aws_route53_zone" "selected" {
  zone_id = var.route53_zone_id
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [var.aws_lb_vpc]
  }
}

data "aws_subnet" "public" {
  for_each = toset(data.aws_subnets.public.ids)
  id       = each.value
}

resource "aws_lb" "public_lb" {
  name               = "${var.cluster_name}-lb-tf"
  internal           = false
  load_balancer_type = "network"
  subnets            = [for subnet in data.aws_subnet.public : subnet.id]

  enable_deletion_protection = true

  tags = {
    Environment = "development"
  }
}
