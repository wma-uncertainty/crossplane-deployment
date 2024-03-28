data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [var.aws_lb_vpc]
  }
}

resource "aws_lb" "test" {
  name               = "${var.cluster_name}-lb-tf"
  internal           = false
  load_balancer_type = "network"
  subnets            = [for subnet in data.aws_subnets.public : subnet.id]

  enable_deletion_protection = true

  tags = {
    Environment = "development"
  }
}
