output "configure_kubectl" {
  description = "Configure kubectl: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig"
  value       = "aws eks --region ${var.region} update-kubeconfig --name ${var.cluster_name}"
}

## Display load balancer hostname (typically present in AWS)
#output "load_balancer_hostname" {
#  value = kubernetes_ingress.ingress.status.0.load_balancer.0.ingress.0.hostname
#}
#
## Display load balancer IP (typically present in GCP, or using Nginx ingress controller)
#output "load_balancer_ip" {
#  value = kubernetes_ingress.ingress.status.0.load_balancer.0.ingress.0.ip
#}
#
