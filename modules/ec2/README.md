## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_iam_instance_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.ec2_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.ec2_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_amiID"></a> [amiID](#input\_amiID) | Provide the AMI ID for EC2 Instance | `string` | `""` | no |
| <a name="input_create_eip"></a> [create\_eip](#input\_create\_eip) | Whether to create Elastic IP or not | `bool` | `true` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Provide the type of the EC2 Instance | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for your Infrastructure | `string` | `""` | no |
| <a name="input_port"></a> [port](#input\_port) | Port number for the application | `number` | n/a | yes |
| <a name="input_private_key_file"></a> [private\_key\_file](#input\_private\_key\_file) | Enter the name of the Key-Pair | `string` | `null` | no |
| <a name="input_private_key_name"></a> [private\_key\_name](#input\_private\_key\_name) | Enter the name of the Key-Pair | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | Region of the Infrastructure | `string` | n/a | yes |
| <a name="input_sg_id"></a> [sg\_id](#input\_sg\_id) | ID of the Security Group | `string` | `null` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | ID of the Subnet | `string` | `null` | no |
| <a name="input_volume_encryption"></a> [volume\_encryption](#input\_volume\_encryption) | Whether to encypt you ec2 root volume | `bool` | `true` | no |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | Size of the Ec2 root volume | `number` | n/a | yes |
| <a name="input_volume_termination"></a> [volume\_termination](#input\_volume\_termination) | Select the volume of the instance should be delete or not | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | n/a |
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | n/a |
