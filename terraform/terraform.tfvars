# Default USGS pangeo-forge bakery
region = "us-west-2"

cluster_name = "uncertainty"

aws_tags = {
  "wma:project_id"     = "uncertainty_ts"
  "wma:application_id" = "crossplane"
  "wma:contact"        = "thodson@usgs.gov"
}

aws_vpc = {
  default = false
  id      = "vpc-0af42fd592a1efc5b"
}

aws_lb_vpc = "vpc-0055752230db6161d"

route53_zone_id = "Z0397660PCRA6NSWUDHX"

permissions_boundary = "arn:aws:iam::807615458658:policy/csr-Developer-Permissions-Boundary"

max_instances = 20

