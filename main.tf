##################### GitHub Connection ###############################

resource "aws_codestarconnections_connection" "this" {
  count = var.connection_arn == null && var.github_oauth_token == null ? 1 : 0

  name          = "${var.names[0]}-pipeline"
  provider_type = "GitHub"
}

data "aws_subnets" "this" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

data "aws_caller_identity" "this" {}

locals {
  account_id = data.aws_caller_identity.this.account_id
  s3_bucket  = var.create_s3_bucket ? aws_s3_bucket.this[0].id : var.s3_bucket_name
}

########################### ECS CLUSTER ##############################

module "ecs" {
  source = "./modules/ecs-cluster"
  count  = var.create_ecs_deployment ? 1 : 0

  cluster_name              = var.cluster_name
  create_cluster            = var.create_cluster
  name                      = var.names
  port                      = var.ecs_ports
  security_groups           = module.security-group-ecs[*].security_group_id
  subnet_ids                = var.ecs_subnet_ids == null ? data.aws_subnets.this.ids : var.ecs_subnet_ids
  load_balancing            = var.load_balancer_name != null ? true : false
  assign_public_ip          = var.assign_public_ip
  target_group_arns         = one(module.load-balancer[*].target_group_arn)
  cw_logs_retention_in_days = var.cw_logs_retention_in_days
  task_cpu                  = var.task_cpu
  task_memory               = var.task_memory
}


module "security-group-ecs" {
  source = "./modules/security-group"
  count  = var.create_ecs_deployment ? length(var.names) : 0

  name                                  = "${var.names[count.index]}-ECS"
  vpc_id                                = var.vpc_id
  tcp_ports                             = [var.ecs_ports[count.index]]
  ingress_tcp_source_security_group_ids = [one(module.security-group-lb[*].security_group_id)]
}

##################### EC2 INSTANCE #####################

module "ec2" {
  source = "./modules/ec2"
  count  = var.create_ec2_deployment && var.create_ec2_server ? 1 : 0

  name             = var.names[0]
  amiID            = var.ami_id
  create_eip       = var.create_eip
  instance_type    = var.instance_type
  sg_id            = one(module.security-group-ec2[*].security_group_id)
  subnet_id        = var.ec2_subnet_id
  private_key_name = var.private_key_name
  volume_size      = var.volume_size
  region           = var.region
  port             = var.ec2_port
}

module "security-group-ec2" {
  source = "./modules/security-group"
  count  = var.create_ec2_deployment && var.create_ec2_server ? 1 : 0

  name                                  = "${var.names[0]}-EC2"
  vpc_id                                = var.vpc_id
  myip_ssh                              = var.ssh_cidr_ips
  tcp_ports                             = [var.ec2_port]
  ingress_tcp_source_security_group_ids = [one(module.security-group-lb[*].security_group_id)]
}

resource "time_sleep" "ec2" {
  count      = var.create_ec2_deployment ? 1 : 0
  depends_on = [module.ec2]

  create_duration = "60s"
}

####################### CODE PIPELINE #######################################

module "ecs-pipeline" {
  source = "./modules/code-pipeline"
  count  = var.create_ecs_deployment ? length(var.names) : 0

  ecs_deployment     = var.create_ecs_deployment
  ec2_deployment     = var.create_ec2_deployment
  name               = var.names[count.index]
  github_oauth_token = var.github_oauth_token
  repo_owner         = var.repo_owner
  repo_name          = var.repo_ids[count.index]
  branch             = var.repo_branch_names[count.index]
  cluster_name       = var.cluster_name
  service_name       = one(module.ecs[*].ecs_service[count.index].name)
  s3_bucket_name     = local.s3_bucket
  create_s3_bucket   = false
  connection_arn     = var.connection_arn != null ? var.connection_arn : one(aws_codestarconnections_connection.this[*].arn)
  project_visibility = "PUBLIC_READ"

  env_vars = {
    ECSNAME        = var.names[count.index]
    REPOSITORY_URI = one(module.ecs[*].ecr_repository[count.index].repository_url)
  }

  depends_on = [module.ecs]
}

module "ec2-pipeline" {
  source = "./modules/code-pipeline"
  count  = var.create_ec2_deployment ? 1 : 0

  ecs_deployment     = var.create_ecs_deployment
  ec2_deployment     = var.create_ec2_deployment
  name               = var.names[0]
  github_oauth_token = var.github_oauth_token
  repo_owner         = var.repo_owner
  repo_name          = var.repo_ids[count.index]
  branch             = var.repo_branch_names[count.index]
  s3_bucket_name     = local.s3_bucket
  create_s3_bucket   = false
  connection_arn     = var.connection_arn != null ? var.connection_arn : one(aws_codestarconnections_connection.this[*].arn)

  ec2_tag_filters = {
    "Name" = var.names[0]
  }

  depends_on = [time_sleep.ec2]
}

########################### LOAD BALANCER #############################

module "load-balancer" {
  source = "./modules/load-balancer"
  count  = var.load_balancer_name != null ? 1 : 0

  certificate_arn       = var.certificate_arn
  host_names            = var.host_names
  host_paths            = var.host_paths
  health_check_paths    = var.health_check_paths
  names                 = var.names
  load_balancer_name    = var.load_balancer_name
  ports                 = var.ec2_port == null ? var.ecs_ports : [var.ec2_port]
  security_groups       = [module.security-group-lb[0].security_group_id]
  subnet_ids            = var.alb_subnet_ids == null ? data.aws_subnets.this.ids : var.alb_subnet_ids
  vpc_id                = var.vpc_id
  instance_id           = one(module.ec2[*].instance_id)
  target_type           = [var.create_ec2_deployment ? "instance" : "ip"]
  create_ec2_deployment = var.create_ec2_deployment
}


module "security-group-lb" {
  source = "./modules/security-group"
  count  = var.load_balancer_name != null ? 1 : 0

  name      = "${var.load_balancer_name}-LB"
  vpc_id    = var.vpc_id
  tcp_ports = [80, 443]
}

##################### S3 BUCKET ###########################

resource "aws_s3_bucket" "this" {
  count = var.create_s3_bucket ? 1 : 0

  bucket        = var.s3_bucket_name != null ? var.s3_bucket_name : "${lower(var.names[0])}-${local.account_id}-pipeline"
  force_destroy = true

  tags = merge(
    {
      "Name" = var.s3_bucket_name != null ? var.s3_bucket_name : "${lower(var.names[0])}-${local.account_id}-pipeline"
    },
  )
}

resource "aws_s3_bucket_policy" "this" {
  count = var.create_s3_bucket ? 1 : 0

  bucket = local.s3_bucket

  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action    = "s3:PutObject"
          Effect    = "Deny"
          Principal = "*"
          Resource = [
            "arn:aws:s3:::${local.s3_bucket}",
            "arn:aws:s3:::${local.s3_bucket}/*"

          ]
          Condition = {
            StringNotEquals = {
              "s3:x-amz-server-side-encryption" : "aws:kms"
            }
          }
        },
        {
          Action    = "s3:*"
          Effect    = "Deny"
          Principal = "*"
          Resource = [
            "arn:aws:s3:::${local.s3_bucket}",
            "arn:aws:s3:::${local.s3_bucket}/*"

          ]
          Condition = {
            Bool = {
              "aws:SecureTransport" : "false"
            }
          }
        }
      ]
    }
  )
}

resource "aws_route53_record" "this" {
  count = length(var.route53_record_names)

  zone_id = length(var.route53_zone_ids) > 1 ? var.route53_zone_ids[count.index] : var.route53_zone_ids[0]
  name    = var.route53_record_names[count.index]
  type    = "CNAME"
  ttl     = 300
  records = [one(module.load-balancer[*].dns_name)]
}