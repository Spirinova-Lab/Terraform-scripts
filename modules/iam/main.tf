########################### IAM POLICY #################################

data "aws_iam_policy_document" "this" {
  count = var.create_iam_policy ? 1 : 0

  dynamic "statement" {
    for_each = var.statements

    content {
      sid       = lookup(statement.value, "sid", null)
      effect    = lookup(statement.value, "effect", null)
      actions   = lookup(statement.value, "actions", null)
      resources = lookup(statement.value, "resources", null)

      dynamic "condition" {
        for_each = statement.value.condition != null ? statement.value.condition : []

        content {
          test     = lookup(condition.value, "condition_test", null)
          variable = lookup(condition.value, "condition_variable", null)
          values   = lookup(condition.value, "condition_values", null)
        }
      }
    }
  }
}

resource "aws_iam_policy" "this" {
  count  = var.create_iam_policy ? 1 : 0
  name   = "${var.name}-policy"
  path   = var.path
  policy = data.aws_iam_policy_document.this[0].json
}

############################### IAM ROLE #####################################

data "aws_iam_policy_document" "assume_role_policy" {
  count = var.create_role ? 1 : 0

  dynamic "statement" {
    for_each = var.role_statements != null ? [var.role_statements] : []

    content {
      effect  = lookup(statement.value, "effect", null)
      actions = lookup(statement.value, "actions", null)

      principals {
        type        = lookup(statement.value, "principal_type", null)
        identifiers = lookup(statement.value, "assume_role_identities", null)
      }
    }
  }
}

resource "aws_iam_role" "this" {
  count = var.create_role ? 1 : 0

  name               = "${var.name}-role"
  path               = var.path
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy[0].json

  tags = merge(
    {
      "Name" = "${var.name}-role"
    },
    var.tags
  )
}

resource "aws_iam_role_policy" "this" {
  count = var.create_iam_policy && var.create_role ? 1 : 0

  name   = "${var.name}-role-policy"
  role   = aws_iam_role.this[0].id
  policy = data.aws_iam_policy_document.this[0].json
}

resource "aws_iam_role_policy_attachment" "this" {
  count = length(var.managed_role_policies)

  role       = aws_iam_role.this[0].id
  policy_arn = "arn:aws:iam::aws:policy/${var.managed_role_policies[count.index]}"
}

############################## IAM USER #####################################

resource "aws_iam_user" "this" {
  count = var.create_user ? 1 : 0

  name = var.user_name
  path = var.path

  tags = merge(
    {
      "Name" = var.user_name
    },
    var.tags
  )
}

resource "aws_iam_user_policy" "this" {
  count = var.create_iam_policy && var.create_user && var.add_user_to_group == false ? 1 : 0

  name = "${var.user_name}-user-policy"
  user = aws_iam_user.this[0].name

  policy = data.aws_iam_policy_document.this[0].json
}

resource "aws_iam_user_policy_attachment" "this" {
  count = length(var.managed_user_policies)

  user       = aws_iam_user.this[0].name
  policy_arn = "arn:aws:iam::aws:policy/${var.managed_user_policies[count.index]}"
}

resource "aws_iam_access_key" "this" {
  count = var.create_access_key ? 1 : 0

  user    = aws_iam_user.this[0].name
  pgp_key = var.pgp_key
}

resource "aws_iam_user_login_profile" "this" {
  count = var.user_login ? 1 : 0

  user                    = aws_iam_user.this[0].name
  pgp_key                 = var.pgp_key
  password_length         = var.password_length
  password_reset_required = var.password_reset_required
}

####################### IAM GROUP ##################

resource "aws_iam_group" "this" {
  count = var.create_iam_group ? 1 : 0

  name = var.iam_group_name
  path = var.path
}

resource "aws_iam_group_policy" "this" {
  count = var.create_iam_policy && var.create_iam_group ? 1 : 0

  name   = "${var.iam_group_name}-group-policy"
  group  = aws_iam_group.this[0].name
  policy = data.aws_iam_policy_document.this[0].json
}

resource "aws_iam_group_policy_attachment" "this" {
  count = length(var.managed_group_policies)

  group      = aws_iam_group.this[0].name
  policy_arn = "arn:aws:iam::aws:policy/${var.managed_group_policies[count.index]}"
}

resource "aws_iam_group_membership" "this" {
  count = var.add_user_to_group ? 1 : 0

  name  = "${var.iam_group_name}-group-membership"
  users = var.create_user ? concat([aws_iam_user.this[0].name], var.users_list) : var.users_list
  group = aws_iam_group.this[0].name
}