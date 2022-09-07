# external role (to be assumed by New Relic One)

data "aws_iam_policy_document" "newrelic-one-external-role-trust-policy" {
  statement {
    sid     = "AllowRoleAssumptionByNewRelicOne"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["754728514883"] # New Relic One account
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [var.newrelic_trusted_account_id]
    }
  }
}

data "aws_iam_policy_document" "newrelic-one-external-role-budget-policy" {
  statement {
    sid     = "AllowViewBudget"
    effect  = "Allow"
    actions = ["budgets:ViewBudget"]

    resources = ["*"]
  }
}

# Kinesis Firehose Delivery Stream

data "aws_iam_policy_document" "kinesis-firehose-stream-role-trust-policy" {
  statement {
    sid     = "AllowRoleAssumptionByKinesisFirehose"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "kinesis-firehose-stream-role-s3-policy" {
  statement {
    sid    = "AllowFirehoseS3Access"
    effect = "Allow"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject"
    ]

    resources = [
      aws_s3_bucket.kinesis-firehose-stream-failed-data.arn,
      "${aws_s3_bucket.kinesis-firehose-stream-failed-data.arn}/*"
    ]
  }
}

# CloudWatch Metric Stream

data "aws_iam_policy_document" "cloudwatch-metric-stream-role-trust-policy" {
  statement {
    sid     = "AllowRoleAssumptionByloudWatchMetricStream"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["streams.metrics.cloudwatch.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "cloudwatch-metric-stream-role-firehose-policy" {
  statement {
    sid    = "AllowCloudWatchFirehoseAccess"
    effect = "Allow"
    actions = [
      "firehose:PutRecord",
      "firehose:PutRecordBatch"
    ]

    resources = [
      aws_kinesis_firehose_delivery_stream.kinesis-firehose-stream.arn
    ]
  }
}
