## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.20.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.20.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_codebuild_project.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_codedeploy_app.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_app) | resource |
| [aws_codedeploy_deployment_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_group) | resource |
| [aws_codepipeline.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline) | resource |
| [aws_codepipeline.this_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline) | resource |
| [aws_codepipeline.this_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline) | resource |
| [aws_iam_role.build_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.deploy_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.pipeline_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.public_build_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.backend_build_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.build_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.deploy_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.pipeline_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.public_build_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backend_deployment"></a> [backend\_deployment](#input\_backend\_deployment) | For the Backend deployment | `bool` | `false` | no |
| <a name="input_branch"></a> [branch](#input\_branch) | Branch of the GitHub repository, _e.g._ `master` | `string` | `null` | no |
| <a name="input_build_container_type"></a> [build\_container\_type](#input\_build\_container\_type) | Type of build environment to use for related builds. Valid values: LINUX\_CONTAINER, LINUX\_GPU\_CONTAINER, WINDOWS\_CONTAINER (deprecated), WINDOWS\_SERVER\_2019\_CONTAINER, ARM\_CONTAINER. | `string` | `"LINUX_CONTAINER"` | no |
| <a name="input_build_spec"></a> [build\_spec](#input\_build\_spec) | Path of the build spec file | `string` | `"buildspec-ecs.yml"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the ECS Cluster name | `string` | `null` | no |
| <a name="input_codedeploy_app"></a> [codedeploy\_app](#input\_codedeploy\_app) | Name of the code deployment app. Is needed if 'create\_deploy\_group' is set to 'false' | `string` | `null` | no |
| <a name="input_compute_type"></a> [compute\_type](#input\_compute\_type) | Type or aize of the server for code build project | `string` | `"BUILD_GENERAL1_SMALL"` | no |
| <a name="input_connection_arn"></a> [connection\_arn](#input\_connection\_arn) | ARN of the code star connection | `string` | `null` | no |
| <a name="input_create_deploy_group"></a> [create\_deploy\_group](#input\_create\_deploy\_group) | Whether the deployment group shoul be create or not | `bool` | `true` | no |
| <a name="input_create_s3_bucket"></a> [create\_s3\_bucket](#input\_create\_s3\_bucket) | Whehter the S3 bucket for codepipeline should be create | `bool` | `false` | no |
| <a name="input_deployment_group"></a> [deployment\_group](#input\_deployment\_group) | Name of the code deployment group. Is needed if 'create\_deploy\_group' is set to 'false' | `string` | `null` | no |
| <a name="input_ec2_deployment"></a> [ec2\_deployment](#input\_ec2\_deployment) | For the EC2 deployment | `bool` | `false` | no |
| <a name="input_ec2_tag_filters"></a> [ec2\_tag\_filters](#input\_ec2\_tag\_filters) | Key and value pairs of ec2 instance tags for code deployment group | `map(string)` | `null` | no |
| <a name="input_ecs_deployment"></a> [ecs\_deployment](#input\_ecs\_deployment) | For the ECS deployment | `bool` | `true` | no |
| <a name="input_env_vars"></a> [env\_vars](#input\_env\_vars) | key and value pair of environment variables for code build project | `map(string)` | `null` | no |
| <a name="input_github_oauth_token"></a> [github\_oauth\_token](#input\_github\_oauth\_token) | GitHub OAuth Token with permissions to access private repositories | `string` | `null` | no |
| <a name="input_github_webhook_events"></a> [github\_webhook\_events](#input\_github\_webhook\_events) | A list of events which should trigger the webhook. See a list of [available events](https://developer.github.com/v3/activity/events/types/) | `list(string)` | <pre>[<br>  "push"<br>]</pre> | no |
| <a name="input_image_identifier"></a> [image\_identifier](#input\_image\_identifier) | Docker image to use for this build project. | `string` | `"aws/codebuild/amazonlinux2-x86_64-standard:4.0"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for this infrastructure | `string` | n/a | yes |
| <a name="input_privileged_mode"></a> [privileged\_mode](#input\_privileged\_mode) | Whether to enable running the Docker daemon inside a Docker container. | `bool` | `true` | no |
| <a name="input_project_visibility"></a> [project\_visibility](#input\_project\_visibility) | Specifies the visibility of the project's builds. Possible values are: PUBLIC\_READ and PRIVATE. Default value is PRIVATE. | `string` | `"PRIVATE"` | no |
| <a name="input_repo_branch_name"></a> [repo\_branch\_name](#input\_repo\_branch\_name) | Name of the source code repo branch | `string` | `null` | no |
| <a name="input_repo_id"></a> [repo\_id](#input\_repo\_id) | ID of the source code repository | `string` | `null` | no |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | GitHub repository name of the application to be built and deployed to ECS | `string` | `null` | no |
| <a name="input_repo_owner"></a> [repo\_owner](#input\_repo\_owner) | GitHub Organization or Username | `string` | `null` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | Name of the pipeline s3 bucket. | `string` | `null` | no |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | Name of the ECS Service name | `string` | `null` | no |
| <a name="input_source_owner"></a> [source\_owner](#input\_source\_owner) | Owner of the source provider for the code pipeline | `string` | `"ThirdParty"` | no |
| <a name="input_source_provider"></a> [source\_provider](#input\_source\_provider) | Name of the source provider for the code pipeline | `string` | `"GitHub"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for this infrastructure | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_build_logs_public_url"></a> [build\_logs\_public\_url](#output\_build\_logs\_public\_url) | The project identifier used with the public build APIs. |
| <a name="output_build_project_arn"></a> [build\_project\_arn](#output\_build\_project\_arn) | ARN of the Code Builf Project |
| <a name="output_code_pipeline_arn"></a> [code\_pipeline\_arn](#output\_code\_pipeline\_arn) | ARN of the Code Pipeline |
| <a name="output_code_pipeline_id"></a> [code\_pipeline\_id](#output\_code\_pipeline\_id) | ID of the Code Pipeline |
| <a name="output_deploy_app_arn"></a> [deploy\_app\_arn](#output\_deploy\_app\_arn) | ARN of the Code Deploy Application |
| <a name="output_deploy_app_id"></a> [deploy\_app\_id](#output\_deploy\_app\_id) | Application ID of the Code Deploy Application |
| <a name="output_deploy_group_arn"></a> [deploy\_group\_arn](#output\_deploy\_group\_arn) | ARN of the Code Deployment Group |
| <a name="output_deploy_group_id"></a> [deploy\_group\_id](#output\_deploy\_group\_id) | Application name and deployment group name. |
| <a name="output_deployment_group_id"></a> [deployment\_group\_id](#output\_deployment\_group\_id) | The ID of the CodeDeploy deployment group. |
| <a name="output_s3_bucket_arn"></a> [s3\_bucket\_arn](#output\_s3\_bucket\_arn) | ARN of the Code Pipeline S3 bucket |
| <a name="output_s3_bucket_id"></a> [s3\_bucket\_id](#output\_s3\_bucket\_id) | ID of the COde Pipeline S3 bucket |
