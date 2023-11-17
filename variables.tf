######################################### MAIN ##############################################

variable "access_key" {
  type        = string
  sensitive   = true
  description = "Enter the AWS Access Key ID"
  default     = null
}

variable "secret_key" {
  type        = string
  sensitive   = true
  description = "Enter the AWS Secret Access Key"
  default     = null
}

variable "region" {
  type        = string
  description = "Enter the region for your infrastructure"
  default     = "us-east-1"
}

variable "create_ecs_deployment" {
  type        = bool
  description = "For ECS deployment"
  default     = true
}

variable "create_ec2_deployment" {
  type        = bool
  description = "For EC2 deployment"
  default     = false
}

######################### VPC #######################################

variable "vpc_id" {
  type        = string
  description = "ID of the vpc"
  default     = "vpc-id"
}

variable "ec2_subnet_id" {
  type        = string
  description = "ID of the subnet for ec2"
  default     = null
}

variable "ecs_subnet_ids" {
  type        = list(string)
  description = "list of subnet ids for ECS service"
  default     = null
}

variable "alb_subnet_ids" {
  type        = list(string)
  description = "list of subnet ids for Load Balancer"
  default     = null
}

########################## ECS and EC2 ###############################

variable "names" {
  type        = list(string)
  description = "List of Names for ECS services and Code Pipelines. For EC2 instance provide a single name only"
  default     = ["Node-App-1"]
}

variable "ecs_ports" {
  type        = list(number)
  description = "List of Port numbers for the application in ECS"
  default     = [3000]
}

variable "create_cluster" {
  type        = bool
  description = "Whether ecs cluster needs to be create or not. If false It will use existing ECS cluster"
  default     = true
}

variable "cluster_name" {
  type        = string
  description = "Name of the ECS cluster"
  default     = "cluster-name"
}

variable "assign_public_ip" {
  type        = bool
  description = "Whether the public ip for ECS service should be created"
  default     = true
}

variable "cw_logs_retention_in_days" {
  type        = number
  description = "Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653, and 0"
  default     = 30
}

variable "task_cpu" {
  type        = list(number)
  description = "List of CPU for task definition. If a single value is same for all services, then provide one value is enough"
  default     = [256]
}

variable "task_memory" {
  type        = list(number)
  description = "List of Memory for task definition. If a single value is same for all services, then provide one value is enough"
  default     = [512]
}

variable "create_ec2_server" {
  type        = bool
  description = "whether to create EC2 instance"
  default     = true
}

variable "ami_id" {
  type        = string
  description = "Provide the AMI ID for EC2 Instance"
  default     = null
}

variable "create_eip" {
  type        = bool
  description = "Whether to create Elastic IP or not"
  default     = true
}

variable "ec2_port" {
  type        = number
  description = "Port number for the application in EC2"
  default     = null
}

variable "private_key_name" {
  type        = string
  description = "Enter the name of the Key-Pair"
  default     = null
}

variable "instance_type" {
  type        = string
  description = "Provide the type of the EC2 Instance"
  default     = null
}

variable "volume_termination" {
  type        = bool
  description = "Select the volume of the instance should be delete or not"
  default     = false
}

variable "volume_size" {
  type        = number
  description = "Size of the EC2 root volume"
  default     = 50
}

variable "volume_encryption" {
  type        = bool
  description = "Whether to encypt you ec2 root volume"
  default     = true
}

variable "ssh_cidr_ips" {
  type        = list(string)
  description = "list of ssh Ips for ec2 instance"
  default     = ["0.0.0.0/0"]
}

################################## CODE PIPELINE #############################################

variable "repo_ids" {
  type        = list(string)
  description = "List of IDs of the source code repository"
  default     = ["nodejs-app"]
}

variable "repo_branch_names" {
  type        = list(string)
  description = "List of Names of the source code repo branch"
  default     = ["main"]
}

variable "github_oauth_token" {
  type        = string
  description = "GitHub OAuth Token with permissions to access private repositories"
  default     = "ouath-token"
}

variable "repo_owner" {
  type        = string
  description = "GitHub Organization or Username"
  default     = "github-username"
}

######################## LOAD BALANCER ################################

variable "load_balancer_name" {
  type        = string
  description = "Name for load balancer"
  default     = "lb-name"
}

variable "certificate_arn" {
  type        = string
  description = "Certificate arn of the domain for load balancer"
  default     = ""
}

variable "host_names" {
  type        = list(string)
  description = "List of names of domains. If you need to setup multiple domains, enter the domain names from the second applciations"
  default     = []
}

variable "host_paths" {
  type        = list(string)
  description = "List of paths of hosts. If ypu jave setup multiple paths, enter paths from the second applications"
  default     = []
}

variable "host_names_and_paths" {
  type        = list(map(string))
  description = "List of key value pairs of Host names and host paths. For example [ {'host_head_1'='host_path_1'}, {'host_head_2'='host_path_2'} ]"
  default     = []
}

variable "health_check_paths" {
  type        = list(string)
  description = "List of health check paths"
  default     = ["/"]
}


################## EXTRA Values ######################

variable "connection_arn" {
  type        = string
  description = "ARN of the code star connection, Not needed"
  default     = null
}

variable "s3_bucket_name" {
  type        = string
  description = "Name of the S3 bucket for codepipeline"
  default     = null
}

variable "create_s3_bucket" {
  type        = bool
  description = "Whether to create s3 bucket for pipeline"
  default     = true
}

#################### ROUTE 53 #######################

variable "route53_zone_ids" {
  type = list(string)
  description = "List of IDs of Route 53 Hosted zones. if same hosted zone for all sub domains single value is enough"
  default = []
}

variable "route53_record_names" {
  type = list(string)
  description = "List of subdomains for your applications"
  default = []
}