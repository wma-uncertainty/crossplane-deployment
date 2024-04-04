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

# not needed if we deploy the lb to ephemeralDev?
aws_lb_subnet = "subnet-08f1118dd59133513"
#aws_lb_subnet = "subnet-0f29464029b7f677c" # vpc-ephemeralDev-Subnet-A

#route53_zone_id = "Z0397660PCRA6NSWUDHX"
route53_zone_id = "Z27Z5RKV3W66YR" # dev-wma.chs.usgs.gov

permissions_boundary = "arn:aws:iam::807615458658:policy/csr-Developer-Permissions-Boundary"

max_instances = 20

