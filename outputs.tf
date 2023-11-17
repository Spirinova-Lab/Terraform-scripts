output "build_logs_public_url" {
  value = var.create_ec2_deployment ? null : zipmap(var.names, formatlist("https://${var.region}.codebuild.aws.amazon.com/project/%s", module.ecs-pipeline[*].build_logs_public_url))
}

output "dns_name" {
  value = one(module.load-balancer[*].dns_name)
}