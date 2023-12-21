##################### GitHub Connection ###############################

resource "aws_codestarconnections_connection" "this" {
  count = var.connection_arn == null && var.github_oauth_token == null ? 1 : 0

  name          = "${var.names[0]}-pipeline"
  provider_type = "GitHub"
}

################### DATA SOURCES & LOCALS ###############################

data "aws_subnets" "this" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

data "aws_caller_identity" "this" {}

data "aws_eks_cluster_auth" "this" {
  count = var.create_eks_deployment ? 1 : 0
  name  = var.eks_cluster_name
}

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
  ignore_changes            = var.ignore_changes
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

  name               = var.names[0]
  amiID              = var.ami_id
  create_eip         = var.create_eip
  instance_type      = var.instance_type
  sg_id              = one(module.security-group-ec2[*].security_group_id)
  subnet_id          = var.ec2_subnet_id
  volume_termination = var.volume_termination
  volume_encryption  = var.volume_encryption
  private_key_name   = var.private_key_name
  volume_size        = var.volume_size
  region             = var.region
  port               = var.ec2_port
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
  count      = var.create_ec2_deployment && var.create_ec2_server ? 1 : 0
  depends_on = [module.ec2]

  create_duration = "60s"
}

######################## EKS CLUSTER #####################################

module "eks-cluster" {
  count  = var.create_eks_deployment && var.create_cluster ? 1 : 0
  source = "./modules/eks-cluster"

  name                            = var.eks_cluster_name
  instance_types                  = [var.instance_type]
  subnet_ids                      = var.ecs_subnet_ids == null ? slice(data.aws_subnets.this.ids, 0, 2) : var.ecs_subnet_ids
  node_subnet_ids                 = var.ecs_subnet_ids == null ? data.aws_subnets.this.ids : var.ecs_subnet_ids
  vpc_id                          = var.vpc_id
  myip_ssh                        = var.ssh_cidr_ips
  private_key                     = var.private_key_name
  ami_type                        = var.node_ami_type
  cluster_version                 = var.cluster_version
  min_size                        = var.node_min_size
  max_size                        = var.node_max_size
  desired_size                    = var.node_desired_size
  region                          = var.region
  account_id                      = local.account_id
  delete_on_termination           = var.volume_termination
  enabled_cluster_log_types       = var.enabled_cluster_log_types
  cluster_endpoint_private_access = var.cluster_endpoint_private_access
  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
}

###################################### CONFIG MAP ################################################

resource "kubernetes_config_map_v1_data" "aws-auth" {
  count = var.create_eks_deployment && var.create_cluster ? 1 : 0

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  force = true

  data = {
    mapRoles = yamlencode(
      [
        {
          rolearn  = module.eks-cluster[0].kubectl_role_arn
          username = "build"
          groups   = ["system:masters"]
        },
        {
          rolearn  = module.eks-cluster[0].ng_role_arn
          username = "system:node:{{EC2PrivateDNSName}}"
          groups   = ["system:bootstrappers", "system:nodes"]
        }
      ]
    )
  }

  depends_on = [
    module.eks-cluster
  ]
}

####################### CODE PIPELINE #######################################

module "ecs-pipeline" {
  source = "./modules/code-pipeline"
  count  = var.create_ecs_deployment ? length(var.names) : 0

  ecs_deployment       = var.create_ecs_deployment
  ec2_deployment       = var.create_ec2_deployment
  name                 = var.names[count.index]
  github_oauth_token   = var.github_oauth_token
  repo_owner           = var.repo_owner
  repo_name            = var.repo_owner != null ? var.repo_ids[count.index] : null
  branch               = var.repo_owner != null ? var.repo_branch_names[count.index] : null
  source_owner         = var.source_owner
  source_provider      = var.source_provider
  repo_id              = var.repo_owner == null ? var.repo_ids[count.index] : null
  repo_branch_name     = var.repo_owner == null ? var.repo_branch_names[count.index] : null
  cluster_name         = var.cluster_name
  service_name         = one(module.ecs[*].ecs_service[count.index].name)
  s3_bucket_name       = local.s3_bucket
  create_s3_bucket     = false
  connection_arn       = var.connection_arn != null ? var.connection_arn : one(aws_codestarconnections_connection.this[*].arn)
  project_visibility   = "PUBLIC_READ"
  compute_type         = var.codebuild_compute_type
  build_container_type = var.build_container_type
  image_identifier     = var.image_identifier
  deployment_timeout   = var.ecs_deployment_timeout
  secret_id            = var.secrets_manager_arn == null ? aws_secretsmanager_secret.this[0].id : var.secrets_manager_arn

  env_vars = {
    ECSNAME         = var.names[count.index]
    REPOSITORY_URI  = one(module.ecs[*].ecr_repository[count.index].repository_url)
    SECRET_USERNAME = "${var.secrets_manager_arn == null ? aws_secretsmanager_secret.this[0].id : var.secrets_manager_arn}:username"
    SECRET_PASSWORD = "${var.secrets_manager_arn == null ? aws_secretsmanager_secret.this[0].id : var.secrets_manager_arn}:password"
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
  repo_name          = var.repo_owner != null ? var.repo_ids[count.index] : null
  branch             = var.repo_owner != null ? var.repo_branch_names[count.index] : null
  source_owner       = var.source_owner
  source_provider    = var.source_provider
  repo_id            = var.repo_owner == null ? var.repo_ids[count.index] : null
  repo_branch_name   = var.repo_owner == null ? var.repo_branch_names[count.index] : null
  s3_bucket_name     = local.s3_bucket
  create_s3_bucket   = false
  connection_arn     = var.connection_arn != null ? var.connection_arn : one(aws_codestarconnections_connection.this[*].arn)

  ec2_tag_filters = {
    "Name" = var.names[0]
  }

  depends_on = [time_sleep.ec2]
}

module "eks-pipeline" {
  source = "./modules/code-pipeline"
  count  = var.create_eks_deployment ? length(var.names) : 0

  ecs_deployment       = var.create_ecs_deployment
  ec2_deployment       = var.create_ec2_deployment
  backend_deployment   = true
  name                 = var.names[count.index]
  github_oauth_token   = var.github_oauth_token
  repo_owner           = var.repo_owner
  repo_name            = var.repo_owner != null ? var.repo_ids[count.index] : null
  branch               = var.repo_owner != null ? var.repo_branch_names[count.index] : null
  source_owner         = var.source_owner
  source_provider      = var.source_provider
  repo_id              = var.repo_owner == null ? var.repo_ids[count.index] : null
  repo_branch_name     = var.repo_owner == null ? var.repo_branch_names[count.index] : null
  s3_bucket_name       = local.s3_bucket
  create_s3_bucket     = false
  connection_arn       = var.connection_arn != null ? var.connection_arn : one(aws_codestarconnections_connection.this[*].arn)
  project_visibility   = "PUBLIC_READ"
  build_spec           = "buildspec-eks.yml"
  compute_type         = var.codebuild_compute_type
  build_container_type = var.build_container_type
  image_identifier     = var.image_identifier
  secret_id            = var.secrets_manager_arn == null ? aws_secretsmanager_secret.this[0].id : var.secrets_manager_arn

  env_vars = merge(
    {
      "REPOSITORY_NAME"      = var.repo_ids[count.index],
      "REPOSITORY_BRANCH"    = var.repo_branch_names[count.index],
      "EKS_CLUSTER_NAME"     = var.eks_cluster_name
      "REPOSITORY_URI"       = aws_ecr_repository.this[count.index].repository_url
      "EKS_KUBECTL_ROLE_ARN" = module.eks-cluster[0].kubectl_role_arn
      "SECRET_USERNAME"      = "${var.secrets_manager_arn == null ? aws_secretsmanager_secret.this[0].id : var.secrets_manager_arn}:username"
      "SECRET_PASSWORD"      = "${var.secrets_manager_arn == null ? aws_secretsmanager_secret.this[0].id : var.secrets_manager_arn}:password"
    },
  var.env_vars)

  depends_on = [
    module.eks-cluster
  ]
}

resource "aws_ecr_repository" "this" {
  count = var.create_eks_deployment ? length(var.names) : 0

  name                 = lower(var.names[count.index])
  force_delete         = true
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    "Name" = var.names[count.index]
  }
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
  health_check_interval = var.health_check_interval
  health_check_timeout  = var.health_check_timeout
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

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count = var.create_s3_bucket ? 1 : 0

  bucket = local.s3_bucket

  rule {
    id = "Delete Objects after 1 day"

    expiration {
      days = 1
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 1
    }

    status = "Enabled"
  }
}

############################## ROUTE 53 ##################################

resource "aws_route53_record" "this" {
  count = length(var.route53_record_names)

  zone_id = length(var.route53_zone_ids) > 1 ? var.route53_zone_ids[count.index] : var.route53_zone_ids[0]
  name    = var.route53_record_names[count.index]
  type    = "CNAME"
  ttl     = 300
  records = [one(module.load-balancer[*].dns_name)]
}

######################### PIPELINE ALERTS ################################

resource "aws_codestarnotifications_notification_rule" "this" {
  count = length(var.names)

  detail_type = "FULL"
  name        = "${var.names[count.index]}-pipeline-notification"
  resource    = var.create_ecs_deployment ? module.ecs-pipeline[count.index].code_pipeline_arn : (var.create_ec2_deployment ? module.ec2-pipeline[0].code_pipeline_arn : module.eks-pipeline[count.index].code_pipeline_arn)

  event_type_ids = [
    "codepipeline-pipeline-pipeline-execution-failed",
    "codepipeline-pipeline-pipeline-execution-succeeded"
  ]

  target {
    address = var.sns_topic_arn == null ? one(aws_sns_topic.this[*].arn) : var.sns_topic_arn
  }
}

resource "aws_sns_topic" "this" {
  count = var.sns_topic_arn == null ? 1 : 0

  name = "${var.names[0]}-pipeline-notification"
}

resource "aws_sns_topic_policy" "this" {
  count = var.sns_topic_arn == null ? 1 : 0

  arn    = aws_sns_topic.this[0].arn
  policy = data.aws_iam_policy_document.this[0].json
}

data "aws_iam_policy_document" "this" {
  count = var.sns_topic_arn == null ? 1 : 0

  policy_id = "__default_policy_ID"

  statement {
    effect = "Allow"
    sid    = "__default_statement_ID"

    actions = [
      "SNS:GetTopicAttributes",
      "SNS:SetTopicAttributes",
      "SNS:AddPermission",
      "SNS:RemovePermission",
      "SNS:DeleteTopic",
      "SNS:Subscribe",
      "SNS:ListSubscriptionsByTopic",
      "SNS:Publish",
      "SNS:Receive"
    ]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        local.account_id,
      ]
    }
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    resources = [
      var.sns_topic_arn == null ? one(aws_sns_topic.this[*].arn) : var.sns_topic_arn
    ]
  }

  statement {
    effect = "Allow"
    sid    = "AWSCodeStarNotifications_publish"
    actions = [
      "SNS:Publish"
    ]
    principals {
      type        = "Service"
      identifiers = ["codestar-notifications.amazonaws.com"]
    }
    resources = [
      var.sns_topic_arn == null ? one(aws_sns_topic.this[*].arn) : var.sns_topic_arn
    ]
  }
}

resource "aws_sns_topic_subscription" "this" {
  count = var.sns_topic_arn == null ? length(var.email_addresses) : 0

  topic_arn = one(aws_sns_topic.this[*].arn)
  protocol  = "email"
  endpoint  = var.email_addresses[count.index]
}

################## SECRETS MANAGER ###########################

resource "aws_secretsmanager_secret" "this" {
  count = var.secrets_manager_arn == null || var.create_secrets_manager ? 1 : 0

  name                    = var.secret_name
  kms_key_id              = var.secrets_manager_kms_key_id
  recovery_window_in_days = var.kms_key_recovery_window_in_days
}

resource "aws_secretsmanager_secret_version" "this" {
  count = var.secrets_manager_arn == null || var.create_secrets_manager ? 1 : 0

  secret_id = aws_secretsmanager_secret.this[0].id
  secret_string = jsonencode(
    {
      username = var.docker_username,
      password = var.docker_password
    }
  )
}