variable "name" {
  type        = string
  description = "Name for the IAM policy"
  default     = null
}

variable "user_name" {
  type        = string
  description = "Name for the IAM user"
  default     = null
}

variable "statements" {
  type = list(
    object(
      {
        sid       = optional(string)
        effect    = string
        actions   = list(string)
        resources = list(string)
        condition = optional(
          list(
            object(
              {
                condition_test     = string
                condition_variable = string
                condition_values   = list(string)
              }
            )
          )
        )
      }
    )
  )
  description = "Iam statements for policy"
  default = [
    {
      sid       = null
      effect    = ""
      actions   = []
      resources = []
      condition = [
        {
          condition_test     = null
          condition_variable = null
          condition_values   = []
        }
      ]
    }
  ]
}

variable "role_statements" {
  type = object(
    {
      effect                 = string
      actions                = list(string)
      principal_type         = string
      assume_role_identities = list(string)
    }
  )
  description = "IAM statements for iam role"
  default = {
    effect                 = ""
    actions                = []
    principal_type         = ""
    assume_role_identities = []
  }
}

variable "create_iam_policy" {
  type        = bool
  description = "Whether to create iam policy"
  default     = true
}

variable "create_role" {
  type        = bool
  description = "Whether to create iam role"
  default     = true
}

variable "create_user" {
  type        = bool
  description = "Whether to create iam user"
  default     = false
}

variable "user_login" {
  type        = bool
  description = "Whether to user need to access console login"
  default     = false
}

variable "create_iam_group" {
  type        = bool
  description = "Whether to create iam group"
  default     = false
}

variable "add_user_to_group" {
  type        = bool
  description = "Whether to add users into iam group"
  default     = false
}

variable "create_access_key" {
  type        = bool
  description = "Whether to create iam user's access key"
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags for your infrastructure"
  default     = {}
}

variable "pgp_key" {
  type        = string
  description = "Either a base-64 encoded PGP public key, or a keybase username"
  default     = null
}

variable "password_length" {
  type        = number
  description = "The length of the generated password on resource creation"
  default     = 20
}

variable "password_reset_required" {
  type        = bool
  description = "Whether the user should be forced to reset the generated password on resource creation."
  default     = true
}

variable "iam_group_name" {
  type        = string
  description = "Name of the iam group"
  default     = null
}

variable "path" {
  type        = string
  description = "path for the resource"
  default     = "/"
}

variable "users_list" {
  type        = list(string)
  description = "List of the iam users to attached with group"
  default     = []
}

variable "managed_group_policies" {
  type        = list(string)
  description = "List of AWS Managed IAM Policies for Group"
  default     = []
}

variable "managed_role_policies" {
  type        = list(string)
  description = "List of AWS Managed IAM Policies for Role"
  default     = []
}

variable "managed_user_policies" {
  type        = list(string)
  description = "List of AWS Managed IAM Policies for User"
  default     = []
}