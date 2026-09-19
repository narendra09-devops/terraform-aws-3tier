data "aws_caller_identity" "deployment" {}
data "aws_partition" "deployment" {}

locals {
  deployment_name = "three-tier-dev"
  deployment_bucket_arns = [
    "arn:${data.aws_partition.deployment.partition}:s3:::${local.deployment_name}-${data.aws_caller_identity.deployment.account_id}-${var.aws_region}-data",
    "arn:${data.aws_partition.deployment.partition}:s3:::${local.deployment_name}-${data.aws_caller_identity.deployment.account_id}-${var.aws_region}-alb-logs"
  ]
  deployment_role_arns = [
    "arn:${data.aws_partition.deployment.partition}:iam::${data.aws_caller_identity.deployment.account_id}:role/${local.deployment_name}-*"
  ]
  deployment_instance_profile_arns = [
    "arn:${data.aws_partition.deployment.partition}:iam::${data.aws_caller_identity.deployment.account_id}:instance-profile/${local.deployment_name}-*"
  ]
  autoscaling_service_linked_role_arn = "arn:${data.aws_partition.deployment.partition}:iam::${data.aws_caller_identity.deployment.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
}

data "aws_iam_policy_document" "github_apply_network_compute" {
  statement {
    sid = "ManageRegionalNetworkAndCompute"
    actions = [
      "ec2:AllocateAddress",
      "ec2:AssociateAddress",
      "ec2:AssociateRouteTable",
      "ec2:AttachInternetGateway",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CreateFlowLogs",
      "ec2:CreateInternetGateway",
      "ec2:CreateLaunchTemplate",
      "ec2:CreateLaunchTemplateVersion",
      "ec2:CreateNatGateway",
      "ec2:CreateRoute",
      "ec2:CreateRouteTable",
      "ec2:CreateSecurityGroup",
      "ec2:CreateSubnet",
      "ec2:CreateTags",
      "ec2:CreateVpc",
      "ec2:DeleteFlowLogs",
      "ec2:DeleteInternetGateway",
      "ec2:DeleteLaunchTemplate",
      "ec2:DeleteLaunchTemplateVersions",
      "ec2:DeleteNatGateway",
      "ec2:DeleteRoute",
      "ec2:DeleteRouteTable",
      "ec2:DeleteSecurityGroup",
      "ec2:DeleteSubnet",
      "ec2:DeleteTags",
      "ec2:DeleteVpc",
      "ec2:DetachInternetGateway",
      "ec2:DisassociateAddress",
      "ec2:DisassociateRouteTable",
      "ec2:ModifyLaunchTemplate",
      "ec2:ModifySecurityGroupRules",
      "ec2:ModifySubnetAttribute",
      "ec2:ModifyVpcAttribute",
      "ec2:ReleaseAddress",
      "ec2:ReplaceRoute",
      "ec2:ReplaceRouteTableAssociation",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:UpdateSecurityGroupRuleDescriptionsEgress",
      "ec2:UpdateSecurityGroupRuleDescriptionsIngress",
      "elasticloadbalancing:AddListenerCertificates",
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:ModifyLoadBalancerAttributes",
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:ModifyTargetGroupAttributes",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:RemoveListenerCertificates",
      "elasticloadbalancing:RemoveTags",
      "elasticloadbalancing:SetIpAddressType",
      "elasticloadbalancing:SetSecurityGroups",
      "elasticloadbalancing:SetSubnets",
      "autoscaling:AttachLoadBalancerTargetGroups",
      "autoscaling:CancelInstanceRefresh",
      "autoscaling:CreateAutoScalingGroup",
      "autoscaling:CreateOrUpdateTags",
      "autoscaling:DeleteAutoScalingGroup",
      "autoscaling:DeletePolicy",
      "autoscaling:DeleteTags",
      "autoscaling:DetachLoadBalancerTargetGroups",
      "autoscaling:DisableMetricsCollection",
      "autoscaling:EnableMetricsCollection",
      "autoscaling:PutScalingPolicy",
      "autoscaling:ResumeProcesses",
      "autoscaling:RollbackInstanceRefresh",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:StartInstanceRefresh",
      "autoscaling:SuspendProcesses",
      "autoscaling:UpdateAutoScalingGroup"
    ]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestedRegion"
      values   = [var.aws_region]
    }
  }
}

resource "aws_iam_policy" "github_apply_network_compute" {
  name        = "${local.deployment_name}-network-compute-deploy"
  description = "Deploy the dev VPC, ALB, launch template, and Auto Scaling resources."
  policy      = data.aws_iam_policy_document.github_apply_network_compute.json
  tags        = var.tags
}

data "aws_iam_policy_document" "github_apply_data_operations" {
  statement {
    sid = "ManageRegionalDataAndOperations"
    actions = [
      "cloudwatch:DeleteAlarms",
      "cloudwatch:DeleteDashboards",
      "cloudwatch:PutDashboard",
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:TagResource",
      "cloudwatch:UntagResource",
      "kms:CancelKeyDeletion",
      "kms:CreateGrant",
      "kms:CreateKey",
      "kms:CreateAlias",
      "kms:DeleteAlias",
      "kms:DisableKeyRotation",
      "kms:EnableKeyRotation",
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:GenerateDataKey",
      "kms:GenerateDataKeyWithoutPlaintext",
      "kms:PutKeyPolicy",
      "kms:RevokeGrant",
      "kms:ScheduleKeyDeletion",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:UpdateAlias",
      "kms:UpdateKeyDescription",
      "logs:AssociateKmsKey",
      "logs:CreateLogGroup",
      "logs:DeleteLogGroup",
      "logs:DeleteRetentionPolicy",
      "logs:DisassociateKmsKey",
      "logs:PutRetentionPolicy",
      "logs:TagLogGroup",
      "logs:TagResource",
      "logs:UntagLogGroup",
      "logs:UntagResource",
      "rds:AddTagsToResource",
      "rds:CreateDBInstance",
      "rds:CreateDBSnapshot",
      "rds:CreateDBSubnetGroup",
      "rds:DeleteDBInstance",
      "rds:DeleteDBSnapshot",
      "rds:DeleteDBSubnetGroup",
      "rds:ModifyDBInstance",
      "rds:ModifyDBSubnetGroup",
      "rds:RebootDBInstance",
      "rds:RemoveTagsFromResource",
      "rds:StartDBInstance",
      "rds:StopDBInstance",
      "secretsmanager:CreateSecret",
      "secretsmanager:DeleteSecret",
      "secretsmanager:GetRandomPassword",
      "secretsmanager:PutResourcePolicy",
      "secretsmanager:DeleteResourcePolicy",
      "secretsmanager:TagResource",
      "secretsmanager:UntagResource",
      "secretsmanager:UpdateSecret",
      "sns:CreateTopic",
      "sns:DeleteTopic",
      "sns:SetSubscriptionAttributes",
      "sns:SetTopicAttributes",
      "sns:Subscribe",
      "sns:TagResource",
      "sns:Unsubscribe",
      "sns:UntagResource"
    ]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestedRegion"
      values   = [var.aws_region]
    }
  }

  statement {
    sid       = "ManageProjectBuckets"
    actions   = ["s3:*"]
    resources = concat(local.deployment_bucket_arns, [for arn in local.deployment_bucket_arns : "${arn}/*"])
  }
}

resource "aws_iam_policy" "github_apply_data_operations" {
  name        = "${local.deployment_name}-data-operations-deploy"
  description = "Deploy the dev RDS, KMS, S3, logging, monitoring, and alerting resources."
  policy      = data.aws_iam_policy_document.github_apply_data_operations.json
  tags        = var.tags
}

data "aws_iam_policy_document" "github_apply_identity" {
  statement {
    sid = "ManageProjectRoles"
    actions = [
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:DeleteRolePolicy",
      "iam:PutRolePolicy",
      "iam:TagRole",
      "iam:UntagRole",
      "iam:UpdateAssumeRolePolicy"
    ]
    resources = local.deployment_role_arns
  }

  statement {
    sid = "AttachApprovedAWSManagedPolicies"
    actions = [
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy"
    ]
    resources = local.deployment_role_arns

    condition {
      test     = "ArnEquals"
      variable = "iam:PolicyARN"
      values = [
        "arn:${data.aws_partition.deployment.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore",
        "arn:${data.aws_partition.deployment.partition}:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
      ]
    }
  }

  statement {
    sid = "ManageProjectInstanceProfiles"
    actions = [
      "iam:AddRoleToInstanceProfile",
      "iam:CreateInstanceProfile",
      "iam:DeleteInstanceProfile",
      "iam:RemoveRoleFromInstanceProfile",
      "iam:TagInstanceProfile",
      "iam:UntagInstanceProfile"
    ]
    resources = local.deployment_instance_profile_arns
  }

  statement {
    sid       = "PassProjectRolesToAWSResources"
    actions   = ["iam:PassRole"]
    resources = local.deployment_role_arns

    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values = [
        "ec2.amazonaws.com",
        "monitoring.rds.amazonaws.com",
        "rds.amazonaws.com",
        "vpc-flow-logs.amazonaws.com"
      ]
    }
  }

  statement {
    sid       = "PassAutoScalingServiceLinkedRole"
    actions   = ["iam:PassRole"]
    resources = [local.autoscaling_service_linked_role_arn]

    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["autoscaling.amazonaws.com"]
    }
  }

  statement {
    sid       = "CreateRequiredServiceLinkedRoles"
    actions   = ["iam:CreateServiceLinkedRole"]
    resources = ["arn:${data.aws_partition.deployment.partition}:iam::${data.aws_caller_identity.deployment.account_id}:role/aws-service-role/*"]

    condition {
      test     = "StringEquals"
      variable = "iam:AWSServiceName"
      values = [
        "autoscaling.amazonaws.com",
        "elasticloadbalancing.amazonaws.com",
        "rds.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_policy" "github_apply_identity" {
  name        = "${local.deployment_name}-identity-deploy"
  description = "Manage and pass only IAM roles and instance profiles created by the dev stack."
  policy      = data.aws_iam_policy_document.github_apply_identity.json
  tags        = var.tags
}

resource "aws_iam_role_policy_attachment" "github_apply_deployment" {
  for_each = {
    network_compute = aws_iam_policy.github_apply_network_compute.arn
    data_operations = aws_iam_policy.github_apply_data_operations.arn
    identity        = aws_iam_policy.github_apply_identity.arn
  }

  role       = aws_iam_role.github_apply.name
  policy_arn = each.value
}
