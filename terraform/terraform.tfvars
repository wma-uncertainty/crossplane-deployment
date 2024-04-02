# Default USGS pangeo-forge bakery
region = "us-west-2"

cluster_name = "uncertainty"

aws_tags = {
  "wma:project_id"     = "uncertainty_ts"
  "wma:application_id" = "crossplane-platform"
  "wma:contact"        = "thodson@usgs.gov"
}

aws_vpc = {
  default = false
  id      = "vpc-0af42fd592a1efc5b"
}

#aws_lb_subnet = "subnet-08f1118dd59133513"
aws_lb_subnet = "subnet-06cf6942c47c4958d"

route53_zone_id = "Z0397660PCRA6NSWUDHX"

permissions_boundary = "arn:aws:iam::807615458658:policy/csr-Developer-Permissions-Boundary"

max_instances = 20

