output "policy_arn" {
  value       = one(aws_iam_policy.this[*].arn)
  description = "ARN of the Iam policy"
}

output "role_arn" {
  value       = one(aws_iam_role.this[*].arn)
  description = "ARN of the Iam role"
}

output "access_key" {
  value       = one(aws_iam_access_key.this[*].id)
  description = "Access key of the user"
}

output "secret_key" {
  value       = one(aws_iam_access_key.this[*].secret)
  description = "Secret key of the user"
}

output "group_arn" {
  value       = one(aws_iam_group.this[*].arn)
  description = "ARN of the Iam Grou[]"
}

output "user_login_key_fingerprint" {
  value       = one(aws_iam_user_login_profile.this[*].key_fingerprint)
  description = "Key fingerprint of the user for console login"
}

output "user_login_encrypted_password" {
  value       = one(aws_iam_user_login_profile.this[*].encrypted_password)
  description = "Encrypted Password of the user for console login"
}