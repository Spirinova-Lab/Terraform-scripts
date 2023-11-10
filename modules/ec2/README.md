## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.iam_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_instance.application](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_security_group.application](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ssh_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.udp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [null_resource.connect_ansible_hosts](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_amiID"></a> [amiID](#input\_amiID) | Provide the AMI ID for EC2 Instance | `string` | n/a | yes |
| <a name="input_ansible_file"></a> [ansible\_file](#input\_ansible\_file) | Provide the ansible playbook file name with its path | `string` | n/a | yes |
| <a name="input_domainname"></a> [domainname](#input\_domainname) | Enter a domain name for your application | `string` | n/a | yes |
| <a name="input_ec2_count"></a> [ec2\_count](#input\_ec2\_count) | Number of Instances. If the count is 1 let it blank in default | `string` | n/a | yes |
| <a name="input_ec2_role"></a> [ec2\_role](#input\_ec2\_role) | Arn of IAM Role for EC2 Instance | `any` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Provide the type of the EC2 Instance | `string` | n/a | yes |
| <a name="input_key_file_path"></a> [key\_file\_path](#input\_key\_file\_path) | Enter the path of the Key-Pair | `string` | n/a | yes |
| <a name="input_myip_ssh"></a> [myip\_ssh](#input\_myip\_ssh) | Provide list of IP addressess for SSH connection | `list(any)` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name for your Infrastructure | `string` | n/a | yes |
| <a name="input_password"></a> [password](#input\_password) | Enter a password for your appication | `string` | n/a | yes |
| <a name="input_ports"></a> [ports](#input\_ports) | List of the ports for the Security Group. If nothing just leave it in default | `list(number)` | n/a | yes |
| <a name="input_private_key"></a> [private\_key](#input\_private\_key) | Enter the name of the Key-Pair | `string` | n/a | yes |
| <a name="input_ssh_user"></a> [ssh\_user](#input\_ssh\_user) | Enter the name of the ssh user | `string` | n/a | yes |
| <a name="input_udp_ports"></a> [udp\_ports](#input\_udp\_ports) | List of the UDP ports. If nothing just leave it in default | `list(number)` | n/a | yes |
| <a name="input_username"></a> [username](#input\_username) | Enter the user name for your application | `string` | n/a | yes |
| <a name="input_volume_termination"></a> [volume\_termination](#input\_volume\_termination) | Select the volume of the instance should be delete or not | `bool` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_PublicIP"></a> [PublicIP](#output\_PublicIP) | n/a |
| <a name="output_aws_instance"></a> [aws\_instance](#output\_aws\_instance) | n/a |
