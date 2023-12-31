## GitHub OAuth Token Create

Go to your github account and click on your **profile** followed by **Settings** --> **Developer settings**.

![alt text](https://github.com/jerinrathnam/earlystack-terraform-script/blob/main/images/Screenshot_2.png?raw=true)

**Personal access tokens --> Tokens --> Generate new token**

![alt text](https://github.com/jerinrathnam/earlystack-terraform-script/blob/main/images/Screenshot_1.png?raw=true)

Click on **Generate new token (classic)**

![alt text](https://github.com/jerinrathnam/earlystack-terraform-script/blob/main/images/Screenshot_3.png?raw=true)

Enter a name for this token inside **Note**.
Select **Expiration** date for this token. If you need this token premanently select **No expiration**.

![alt text](https://github.com/jerinrathnam/earlystack-terraform-script/blob/main/images/Screenshot_4.png?raw=true)

Select **repos** and **admin:repo_hook** permissions.

![alt text](https://github.com/jerinrathnam/earlystack-terraform-script/blob/main/images/Screenshot_5.png?raw=true)

Click **Generate token** button.

![alt text](https://github.com/jerinrathnam/earlystack-terraform-script/blob/main/images/Screenshot_6.png?raw=true)

Now it will show the OAuth token. Copy the token and save it somewhere else.

![alt text](https://github.com/jerinrathnam/earlystack-terraform-script/blob/main/images/Screenshot_7.png?raw=true)

## Github1 to Github2 migration

Open the **variables.tf** file and the below screenshot is the example for **Github version 1**

The values for the below mentioned variables should be the same exactly like the below screenshot

1. source_provideer = "GitHub"
2. source_owner     = "ThirdParty"

![alt text](https://github.com/jerinrathnam/earlystack-terraform-script/blob/main/images/Screenshot_8.png?raw=true)

The below picture is the example for **GitHub version 2** type.

The values for the below mentioned variables should be the same exactly like the below screenshot

1. source_provider = "CodeStarSourceConnection"
2. source_owner = "AWS"

![alt text](https://github.com/jerinrathnam/earlystack-terraform-script/blob/main/images/Screenshot_9.png?raw=true)

Then execute terraform script. While the resources creation happens go to your AWS account and in follow the below steps with the reference of this image.

**Developer Tools --> Settings --> Connections --> Connection name**

![alt text](https://github.com/jerinrathnam/earlystack-terraform-script/blob/main/images/Screenshot_10.png?raw=true)

Then click on **Update pending connection**.

![alt text](https://github.com/jerinrathnam/earlystack-terraform-script/blob/main/images/Screenshot_11.png?raw=true)

It will open a new browser window. Click on the **Install a new app**.

![alt text](https://github.com/jerinrathnam/earlystack-terraform-script/blob/main/images/Screenshot_12.png?raw=true)

Select the GitHub account that you have your source code.

![alt text](https://github.com/jerinrathnam/earlystack-terraform-script/blob/main/images/Screenshot_13.png?raw=true)

If you want to give access to All repositories click on ** All repositories**.
But you can also mention for some particular one or more repos.

**Only select repositories --> Select repositories**

you can select one or multiple repositories.

![alt text](https://github.com/jerinrathnam/earlystack-terraform-script/blob/main/images/Screenshot_14.png?raw=true)

You can able to see the selected repos to give access to aws code pipeline. Click on **Install** button.

![alt text](https://github.com/jerinrathnam/earlystack-terraform-script/blob/main/images/Screenshot_15.png?raw=true)

Now you will see an ID of your GitHub connection. Click on **Connect**.

![alt text](https://github.com/jerinrathnam/earlystack-terraform-script/blob/main/images/Screenshot_16.png?raw=true)

You will redirected to your AWS codestar connection page and you can see the **status** of your connection will be **Availabe**.

![alt text](https://github.com/jerinrathnam/earlystack-terraform-script/blob/main/images/Screenshot_17.png?raw=true)


## Enter values for Terraform  Variables 

1. For **access_key** and **secret_key**, provide the AWS credentials with their respective values.
2. For **ECS Deployment**, set **create_ecs_deployment** to **true** and set **create_ec2_deployment** and **create_eks_deployment** to **false**.
3. For **EC2 Deployment**, set **create_ec2_deployment** to **true** and set **create_ecs_deployment** and **create_eks_deployment** to **false**.
3. For **EKS Deployment**, set **create_eks_deployment** to **true** and set **create_ecs_deployment** and **create_ec2_deployment** to **false**.

## Run Terraform script

1. ```terraform init``` This command need to run once you have cloned this code in your system to initialize the terraform depencies.

2. ```terraform plan``` This command will shows the details of creation or changes of the resources.

3. ```terraform apply``` This command will deploy the resources. 

4. ```terraform destroy``` To delete all the resources

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.24.0 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.9.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ec2"></a> [ec2](#module\_ec2) | ./modules/ec2 | n/a |
| <a name="module_ec2-pipeline"></a> [ec2-pipeline](#module\_ec2-pipeline) | ./modules/code-pipeline | n/a |
| <a name="module_ecs"></a> [ecs](#module\_ecs) | ./modules/ecs-cluster | n/a |
| <a name="module_ecs-pipeline"></a> [ecs-pipeline](#module\_ecs-pipeline) | ./modules/code-pipeline | n/a |
| <a name="module_eks-cluster"></a> [eks-cluster](#module\_eks-cluster) | ./modules/eks-cluster | n/a |
| <a name="module_eks-pipeline"></a> [eks-pipeline](#module\_eks-pipeline) | ./modules/code-pipeline | n/a |
| <a name="module_load-balancer"></a> [load-balancer](#module\_load-balancer) | ./modules/load-balancer | n/a |
| <a name="module_security-group-ec2"></a> [security-group-ec2](#module\_security-group-ec2) | ./modules/security-group | n/a |
| <a name="module_security-group-ecs"></a> [security-group-ecs](#module\_security-group-ecs) | ./modules/security-group | n/a |
| <a name="module_security-group-lb"></a> [security-group-lb](#module\_security-group-lb) | ./modules/security-group | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_codestarconnections_connection.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codestarconnections_connection) | resource |
| [aws_codestarnotifications_notification_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codestarnotifications_notification_rule) | resource |
| [aws_ecr_repository.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_route53_record.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_secretsmanager_secret.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_sns_topic.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_sns_topic_subscription.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [time_sleep.ec2](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_subnets.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_key"></a> [access\_key](#input\_access\_key) | Enter the AWS Access Key ID | `string` | `null` | no |
| <a name="input_alb_subnet_ids"></a> [alb\_subnet\_ids](#input\_alb\_subnet\_ids) | list of subnet ids for Load Balancer | `list(string)` | `null` | no |
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | Provide the AMI ID for EC2 Instance | `string` | `null` | no |
| <a name="input_assign_public_ip"></a> [assign\_public\_ip](#input\_assign\_public\_ip) | Whether the public ip for ECS service should be created | `bool` | `true` | no |
| <a name="input_build_container_type"></a> [build\_container\_type](#input\_build\_container\_type) | Type of build environment to use for related builds. Valid values: LINUX\_CONTAINER, LINUX\_GPU\_CONTAINER, WINDOWS\_CONTAINER (deprecated), WINDOWS\_SERVER\_2019\_CONTAINER, ARM\_CONTAINER. | `string` | `"LINUX_CONTAINER"` | no |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | Certificate arn of the domain for load balancer | `string` | `""` | no |
| <a name="input_cluster_endpoint_private_access"></a> [cluster\_endpoint\_private\_access](#input\_cluster\_endpoint\_private\_access) | Whether the Amazon EKS private API server endpoint is enabled. | `string` | `false` | no |
| <a name="input_cluster_endpoint_public_access"></a> [cluster\_endpoint\_public\_access](#input\_cluster\_endpoint\_public\_access) | Whether the Amazon EKS public API server endpoint is enabled. | `string` | `true` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the ECS cluster | `string` | `"cluster-name"` | no |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | Version of the EKS cluster | `string` | `"1.26"` | no |
| <a name="input_codebuild_compute_type"></a> [codebuild\_compute\_type](#input\_codebuild\_compute\_type) | Type or aize of the server for code build project. Valid values: BUILD\_GENERAL1\_SMALL, BUILD\_GENERAL1\_MEDIUM, BUILD\_GENERAL1\_LARGE, BUILD\_GENERAL1\_2XLARGE | `string` | `"BUILD_GENERAL1_SMALL"` | no |
| <a name="input_connection_arn"></a> [connection\_arn](#input\_connection\_arn) | ARN of the code star connection, Not needed | `string` | `null` | no |
| <a name="input_create_cluster"></a> [create\_cluster](#input\_create\_cluster) | Whether the ECS or EKS cluster needs to be create or not. If 'false' It will use existing ECS cluster | `bool` | `true` | no |
| <a name="input_create_ec2_deployment"></a> [create\_ec2\_deployment](#input\_create\_ec2\_deployment) | For EC2 deployment | `bool` | `false` | no |
| <a name="input_create_ec2_server"></a> [create\_ec2\_server](#input\_create\_ec2\_server) | whether to create EC2 instance | `bool` | `true` | no |
| <a name="input_create_ecs_deployment"></a> [create\_ecs\_deployment](#input\_create\_ecs\_deployment) | For ECS deployment | `bool` | `true` | no |
| <a name="input_create_eip"></a> [create\_eip](#input\_create\_eip) | Whether to create Elastic IP or not | `bool` | `true` | no |
| <a name="input_create_eks_deployment"></a> [create\_eks\_deployment](#input\_create\_eks\_deployment) | For EKS deployment | `bool` | `false` | no |
| <a name="input_create_s3_bucket"></a> [create\_s3\_bucket](#input\_create\_s3\_bucket) | Whether to create s3 bucket for pipeline | `bool` | `true` | no |
| <a name="input_create_secrets_manager"></a> [create\_secrets\_manager](#input\_create\_secrets\_manager) | whether to create secrets manager or not | `bool` | `true` | no |
| <a name="input_cw_logs_retention_in_days"></a> [cw\_logs\_retention\_in\_days](#input\_cw\_logs\_retention\_in\_days) | Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653, and 0 | `number` | `60` | no |
| <a name="input_docker_password"></a> [docker\_password](#input\_docker\_password) | Username of docker hub password | `string` | n/a | yes |
| <a name="input_docker_username"></a> [docker\_username](#input\_docker\_username) | Username of the Docker hub registry | `string` | n/a | yes |
| <a name="input_ec2_port"></a> [ec2\_port](#input\_ec2\_port) | Port number for the application in EC2 | `number` | `300` | no |
| <a name="input_ec2_subnet_id"></a> [ec2\_subnet\_id](#input\_ec2\_subnet\_id) | ID of the subnet for ec2 | `string` | `null` | no |
| <a name="input_ecs_ports"></a> [ecs\_ports](#input\_ecs\_ports) | List of Port numbers for the application in ECS | `list(number)` | <pre>[<br>  3000<br>]</pre> | no |
| <a name="input_ecs_subnet_ids"></a> [ecs\_subnet\_ids](#input\_ecs\_subnet\_ids) | list of subnet ids for ECS service | `list(string)` | `null` | no |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | Name for EKS cluster | `string` | `"eks-cluster-name"` | no |
| <a name="input_email_addresses"></a> [email\_addresses](#input\_email\_addresses) | List of Email address for code commit notification | `list(string)` | <pre>[<br>  "example@gmail.com"<br>]</pre> | no |
| <a name="input_enabled_cluster_log_types"></a> [enabled\_cluster\_log\_types](#input\_enabled\_cluster\_log\_types) | List of EKS Cluster log types. Enter 'null' for disable logs | `list(string)` | <pre>[<br>  "api",<br>  "audit",<br>  "authenticator"<br>]</pre> | no |
| <a name="input_env_vars"></a> [env\_vars](#input\_env\_vars) | Map of environment variables for code build project | `map(any)` | `{}` | no |
| <a name="input_github_oauth_token"></a> [github\_oauth\_token](#input\_github\_oauth\_token) | GitHub OAuth Token with permissions to access private repositories | `string` | `"ouath-token"` | no |
| <a name="input_health_check_paths"></a> [health\_check\_paths](#input\_health\_check\_paths) | List of health check paths | `list(string)` | <pre>[<br>  "/"<br>]</pre> | no |
| <a name="input_host_names"></a> [host\_names](#input\_host\_names) | List of names of domains. If you need to setup multiple domains, enter the domain names from the second applciations | `list(string)` | `[]` | no |
| <a name="input_host_paths"></a> [host\_paths](#input\_host\_paths) | List of paths of hosts. If ypu jave setup multiple paths, enter paths from the second applications | `list(string)` | `[]` | no |
| <a name="input_ignore_changes"></a> [ignore\_changes](#input\_ignore\_changes) | Whehter to ignore changes configuration should be apply | `bool` | `true` | no |
| <a name="input_image_identifier"></a> [image\_identifier](#input\_image\_identifier) | Docker image to use for this build project. | `string` | `"aws/codebuild/amazonlinux2-x86_64-standard:4.0"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Provide the type of the EC2 Instance and EKS cluster nodes | `string` | `"t3.medium"` | no |
| <a name="input_kms_key_recovery_window_in_days"></a> [kms\_key\_recovery\_window\_in\_days](#input\_kms\_key\_recovery\_window\_in\_days) | Number of days that AWS Secrets Manager waits before it can delete the secret. This value can be 0 to force deletion without recovery or range from 7 to 30 days. | `number` | `30` | no |
| <a name="input_load_balancer_name"></a> [load\_balancer\_name](#input\_load\_balancer\_name) | Name for load balancer. if this value is 'null' Load Balancer won't be created. | `string` | `null` | no |
| <a name="input_names"></a> [names](#input\_names) | List of Names for ECS services and Code Pipelines. For EC2 instance provide a single name only | `list(string)` | <pre>[<br>  "Node-App-1"<br>]</pre> | no |
| <a name="input_node_ami_type"></a> [node\_ami\_type](#input\_node\_ami\_type) | Type of Amazon Machine Image (AMI) associated with the EKS Node Group. Valid Values: AL2\_x86\_64 \| AL2\_x86\_64\_GPU \| AL2\_ARM\_64 \| CUSTOM \| BOTTLEROCKET\_ARM\_64 \| BOTTLEROCKET\_x86\_64 \| BOTTLEROCKET\_ARM\_64\_NVIDIA \| BOTTLEROCKET\_x86\_64\_NVIDIA \| WINDOWS\_CORE\_2019\_x86\_64 \| WINDOWS\_FULL\_2019\_x86\_64 \| WINDOWS\_CORE\_2022\_x86\_64 \| WINDOWS\_FULL\_2022\_x86\_64 | `string` | `"AL2_x86_64"` | no |
| <a name="input_node_desired_size"></a> [node\_desired\_size](#input\_node\_desired\_size) | desired size of the nodes for autoscaling group | `number` | `2` | no |
| <a name="input_node_max_size"></a> [node\_max\_size](#input\_node\_max\_size) | maximun size of the nodes for autoscaling group | `number` | `5` | no |
| <a name="input_node_min_size"></a> [node\_min\_size](#input\_node\_min\_size) | minimum size of the nodes for autoscaling group | `number` | `2` | no |
| <a name="input_private_key_name"></a> [private\_key\_name](#input\_private\_key\_name) | Enter the name of the Key-Pair | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | Enter the region for your infrastructure | `string` | `"us-east-1"` | no |
| <a name="input_repo_branch_names"></a> [repo\_branch\_names](#input\_repo\_branch\_names) | List of Names of the source code repo branch | `list(string)` | <pre>[<br>  "main"<br>]</pre> | no |
| <a name="input_repo_ids"></a> [repo\_ids](#input\_repo\_ids) | List of IDs of the source code repository | `list(string)` | <pre>[<br>  "repo-id"<br>]</pre> | no |
| <a name="input_repo_owner"></a> [repo\_owner](#input\_repo\_owner) | GitHub Organization or Username | `string` | `"github-username"` | no |
| <a name="input_route53_record_names"></a> [route53\_record\_names](#input\_route53\_record\_names) | List of subdomains for your applications | `list(string)` | `[]` | no |
| <a name="input_route53_zone_ids"></a> [route53\_zone\_ids](#input\_route53\_zone\_ids) | List of IDs of Route 53 Hosted zones. if same hosted zone for all sub domains single value is enough | `list(string)` | `[]` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | Name of the S3 bucket for codepipeline | `string` | `null` | no |
| <a name="input_secret_key"></a> [secret\_key](#input\_secret\_key) | Enter the AWS Secret Access Key | `string` | `null` | no |
| <a name="input_secret_name"></a> [secret\_name](#input\_secret\_name) | Name for the secrets manager | `string` | `"secret-name"` | no |
| <a name="input_secrets_manager_arn"></a> [secrets\_manager\_arn](#input\_secrets\_manager\_arn) | ARN of the secrets manager. If you have existing Secrets Manager, Provide the ARN here | `string` | `null` | no |
| <a name="input_secrets_manager_kms_key_id"></a> [secrets\_manager\_kms\_key\_id](#input\_secrets\_manager\_kms\_key\_id) | ARN or Id of the AWS KMS key to be used to encrypt the secret values in the versions stored in this secret | `string` | `null` | no |
| <a name="input_sns_topic_arn"></a> [sns\_topic\_arn](#input\_sns\_topic\_arn) | Only need to Provide SNS ARN, if there is existing SNS topic | `string` | `null` | no |
| <a name="input_source_owner"></a> [source\_owner](#input\_source\_owner) | Owner of the source provider for the code pipeline | `string` | `"ThirdParty"` | no |
| <a name="input_source_provider"></a> [source\_provider](#input\_source\_provider) | Name of the source provider for the code pipeline | `string` | `"GitHub"` | no |
| <a name="input_ssh_cidr_ips"></a> [ssh\_cidr\_ips](#input\_ssh\_cidr\_ips) | list of ssh Ips for ec2 instance | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_task_cpu"></a> [task\_cpu](#input\_task\_cpu) | List of CPU for task definition. If a single value is same for all services, then provide one value is enough | `list(number)` | <pre>[<br>  256<br>]</pre> | no |
| <a name="input_task_memory"></a> [task\_memory](#input\_task\_memory) | List of Memory for task definition. If a single value is same for all services, then provide one value is enough | `list(number)` | <pre>[<br>  512<br>]</pre> | no |
| <a name="input_volume_encryption"></a> [volume\_encryption](#input\_volume\_encryption) | Whether to encypt you ec2 root volume | `bool` | `true` | no |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | Size of the EC2 root volume and EKS cluster nodes | `number` | `50` | no |
| <a name="input_volume_termination"></a> [volume\_termination](#input\_volume\_termination) | Select the volume of the instance and EKS cluster nodes should be delete or not | `bool` | `false` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the vpc | `string` | `"vpc-id"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_build_logs_public_url"></a> [build\_logs\_public\_url](#output\_build\_logs\_public\_url) | List of Public Build URLs of Code Build projects |
| <a name="output_dns_name"></a> [dns\_name](#output\_dns\_name) | Domain Name of the Load Balancer |
