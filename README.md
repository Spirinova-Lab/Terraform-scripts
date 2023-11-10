## GitHub OAuth Token Create

Go to your github account and click on your **profile** followed by **Settings** --> **Developer settings**.

![plot](./images/screenshot_2.png)

**Personal access tokens --> Tokens --> Generate new token**

![plot](./images/screenshot_1.png)

Click on **Generate new token (classic)**

![plot](./images/screenshot_3.png)

Enter a name for this token inside **Note**.
Select **Expiration** date for this token. If you need this token premanently select **No expiration**.

![plot](./images/screenshot_4.png)

Select **repos** and **admin:repo_hook** permissions.

![plot](./images/screenshot_5.png)

Click **Generate token** button.

![plot](./images/screenshot_6.png)

Now it will show the OAuth token. Copy the token and save it somewhere else.

![plot](./images/screenshot_7.png)

## Enter values for Terraform  Variables 

1. For **access_key** and **secret_key**, provide the AWS credentials with their respective values.
2. For **ECS Deployment**, set **create_ecs_deployment** to **true** and set **create_ec2_deployment** to **false**.
3. For **EC2 Deployment**, set **create_ec2_deployment** to **true** and set **create_ecs_deployment** to **false**.
4. If you have run EC2 deployment you should have a private PEM file for the server and give the file path in **private_key_file** variable.

## Run Terraform script

1. ```terraform init``` This command need to run once you have cloned this code in your system to initialize the terraform depencies.

2. ```terraform plan``` This command will shows the details of creation or changes fo the resources.

3. ```terraform apply``` This command will deploy the resources. 

4. ```terraform destroy``` To delete all the resources

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.24.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ec2"></a> [ec2](#module\_ec2) | ./modules/ec2 | n/a |
| <a name="module_ec2-pipeline"></a> [ec2-pipeline](#module\_ec2-pipeline) | ./modules/code-pipeline | n/a |
| <a name="module_ecs"></a> [ecs](#module\_ecs) | ./modules/ecs-cluster | n/a |
| <a name="module_ecs-pipeline"></a> [ecs-pipeline](#module\_ecs-pipeline) | ./modules/code-pipeline | n/a |
| <a name="module_load-balancer"></a> [load-balancer](#module\_load-balancer) | ./modules/load-balancer | n/a |
| <a name="module_security-group-ec2"></a> [security-group-ec2](#module\_security-group-ec2) | ./modules/security-group | n/a |
| <a name="module_security-group-ecs"></a> [security-group-ecs](#module\_security-group-ecs) | ./modules/security-group | n/a |
| <a name="module_security-group-lb"></a> [security-group-lb](#module\_security-group-lb) | ./modules/security-group | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_codestarconnections_connection.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codestarconnections_connection) | resource |
| [aws_subnets.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_key"></a> [access\_key](#input\_access\_key) | Enter the AWS Access Key ID | `string` | `null` | no |
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | Provide the AMI ID for EC2 Instance | `string` | `null` | no |
| <a name="input_assign_public_ip"></a> [assign\_public\_ip](#input\_assign\_public\_ip) | Whether the public ip for ECS service should be created | `bool` | `true` | no |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | Certificate arn of the domain for load balancer | `string` | `""` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the ECS cluster | `string` | `null` | no |
| <a name="input_connection_arn"></a> [connection\_arn](#input\_connection\_arn) | ARN of the code star connection | `string` | `null` | no |
| <a name="input_create_cluster"></a> [create\_cluster](#input\_create\_cluster) | Whether ecs cluster needs to be create or not | `bool` | `true` | no |
| <a name="input_create_ec2_deployment"></a> [create\_ec2\_deployment](#input\_create\_ec2\_deployment) | For EC2 deployment | `bool` | `false` | no |
| <a name="input_create_ecs_deployment"></a> [create\_ecs\_deployment](#input\_create\_ecs\_deployment) | For ECS deployment | `bool` | `true` | no |
| <a name="input_create_eip"></a> [create\_eip](#input\_create\_eip) | Whether to create Elastic IP or not | `bool` | `true` | no |
| <a name="input_create_s3_bucket"></a> [create\_s3\_bucket](#input\_create\_s3\_bucket) | Whether to create s3 bucket for pipeline | `bool` | `false` | no |
| <a name="input_cw_logs_retention_in_days"></a> [cw\_logs\_retention\_in\_days](#input\_cw\_logs\_retention\_in\_days) | Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653, and 0 | `number` | `30` | no |
| <a name="input_ec2_port"></a> [ec2\_port](#input\_ec2\_port) | Port number for the application in EC2 | `number` | `null` | no |
| <a name="input_ec2_subnet_id"></a> [ec2\_subnet\_id](#input\_ec2\_subnet\_id) | ID of the subnet for ec2 | `string` | `null` | no |
| <a name="input_ecs_ports"></a> [ecs\_ports](#input\_ecs\_ports) | List of Port numbers for the application in ECS | `list(number)` | <pre>[<br>  3000<br>]</pre> | no |
| <a name="input_health_check_paths"></a> [health\_check\_paths](#input\_health\_check\_paths) | List of health check paths | `list(string)` | <pre>[<br>  "/"<br>]</pre> | no |
| <a name="input_host_names"></a> [host\_names](#input\_host\_names) | List of names of domains | `list(string)` | `[]` | no |
| <a name="input_host_names_and_paths"></a> [host\_names\_and\_paths](#input\_host\_names\_and\_paths) | List of key value pairs of Host names and host paths. For example [ {'host\_head\_1'='host\_path\_1'}, {'host\_head\_2'='host\_path\_2'} ] | `list(map(string))` | `[]` | no |
| <a name="input_host_paths"></a> [host\_paths](#input\_host\_paths) | List of paths of hosts | `list(string)` | `[]` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Provide the type of the EC2 Instance | `string` | `null` | no |
| <a name="input_load_balancer_name"></a> [load\_balancer\_name](#input\_load\_balancer\_name) | Name for load balancer | `string` | `null` | no |
| <a name="input_names"></a> [names](#input\_names) | List of Names for ECS services and Code Pipelines. For EC2 instance provide a single name only | `list(string)` | `[]` | no |
| <a name="input_private_key_file"></a> [private\_key\_file](#input\_private\_key\_file) | file path of the private key | `string` | `"./key.pem"` | no |
| <a name="input_private_key_name"></a> [private\_key\_name](#input\_private\_key\_name) | Enter the name of the Key-Pair | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | Enter the region for your infrastructure | `string` | `"us-east-1"` | no |
| <a name="input_repo_branch_names"></a> [repo\_branch\_names](#input\_repo\_branch\_names) | List of Names of the source code repo branch | `list(string)` | `null` | no |
| <a name="input_repo_ids"></a> [repo\_ids](#input\_repo\_ids) | List of IDs of the source code repository | `list(string)` | `null` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | Name of the S3 bucket for codepipeline | `string` | `null` | no |
| <a name="input_secret_key"></a> [secret\_key](#input\_secret\_key) | Enter the AWS Secret Access Key | `string` | `null` | no |
| <a name="input_ssh_cidr_ips"></a> [ssh\_cidr\_ips](#input\_ssh\_cidr\_ips) | list of ssh Ips for ec2 instance | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | list of subnet ids for ecs | `list(string)` | `null` | no |
| <a name="input_task_cpu"></a> [task\_cpu](#input\_task\_cpu) | List of CPU for task definition. If a single value is same for all services, then provide one value is enough | `list(number)` | <pre>[<br>  256<br>]</pre> | no |
| <a name="input_task_memory"></a> [task\_memory](#input\_task\_memory) | List of Memory for task definition. If a single value is same for all services, then provide one value is enough | `list(number)` | <pre>[<br>  512<br>]</pre> | no |
| <a name="input_volume_encryption"></a> [volume\_encryption](#input\_volume\_encryption) | Whether to encypt you ec2 root volume | `bool` | `true` | no |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | Size of the EC2 root volume | `number` | `50` | no |
| <a name="input_volume_termination"></a> [volume\_termination](#input\_volume\_termination) | Select the volume of the instance should be delete or not | `bool` | `false` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the vpc | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_build_logs_public_url"></a> [build\_logs\_public\_url](#output\_build\_logs\_public\_url) | n/a |
| <a name="output_dns_name"></a> [dns\_name](#output\_dns\_name) | n/a |
