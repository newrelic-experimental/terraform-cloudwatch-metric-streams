# External role for linking your AWS account to New Relic

resource "aws_iam_role" "newrelic-one-external-role" {
  name               = "${var.name_prefix}newrelic-one-external-role${var.name_suffix}"
  assume_role_policy = data.aws_iam_policy_document.newrelic-one-external-role-trust-policy.json

  tags = {
    Name = "${var.name_prefix}newrelic-one-external-role${var.name_suffix}"
  }
}

resource "aws_iam_role_policy_attachment" "newrelic-one-external-role-ReadOnlyAccess-attachment" {
  role       = aws_iam_role.newrelic-one-external-role.id
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role_policy" "newrelic-one-external-role-budget-policy" {
  name   = "${var.name_prefix}NewRelicBudget${var.name_suffix}"
  role   = aws_iam_role.newrelic-one-external-role.id
  policy = data.aws_iam_policy_document.newrelic-one-external-role-budget-policy.json
}

# Kinesis Firehose Delivery Stream

resource "aws_iam_role" "kinesis-firehose-stream-role" {
  name               = "${var.name_prefix}cloudwatch-firehose-stream-role${var.name_suffix}"
  assume_role_policy = data.aws_iam_policy_document.kinesis-firehose-stream-role-trust-policy.json

  tags = {
    Name = "${var.name_prefix}cloudwatch-firehose-stream-role${var.name_suffix}"
  }
}

resource "aws_s3_bucket" "kinesis-firehose-stream-failed-data" {
  bucket = "${var.name_prefix}cloudwatch-metric-stream-failed-data${var.name_suffix}"
  acl    = "private"
}

resource "aws_iam_role_policy" "kinesis-firehose-stream-role-s3-policy" {
  name   = "${var.name_prefix}KinesisFirehose-S3Access${var.name_suffix}"
  role   = aws_iam_role.kinesis-firehose-stream-role.id
  policy = data.aws_iam_policy_document.kinesis-firehose-stream-role-s3-policy.json
}

resource "aws_kinesis_firehose_delivery_stream" "kinesis-firehose-stream" {
  name        = "${var.name_prefix}cloudwatch-metric-stream${var.name_suffix}"
  destination = "http_endpoint"

  s3_configuration {
    role_arn           = aws_iam_role.kinesis-firehose-stream-role.arn
    bucket_arn         = aws_s3_bucket.kinesis-firehose-stream-failed-data.arn
    buffer_size        = 10  # MiB
    buffer_interval    = 300 # seconds
    compression_format = "GZIP"
  }

  http_endpoint_configuration {
    url                = var.newrelic_collector_endpoint
    name               = "New Relic - Metrics"
    access_key         = var.newrelic_license_key
    buffering_size     = 1  # MiB
    buffering_interval = 60 # seconds
    role_arn           = aws_iam_role.kinesis-firehose-stream-role.arn
    s3_backup_mode     = "FailedDataOnly"
    retry_duration     = 60 # seconds

    request_configuration {
      content_encoding = "GZIP"
    }
  }
}

# CloudWatch Metric Stream

resource "aws_iam_role" "cloudwatch-metric-stream-role" {
  name               = "${var.name_prefix}cloudwatch-metric-stream-role${var.name_suffix}"
  assume_role_policy = data.aws_iam_policy_document.cloudwatch-metric-stream-role-trust-policy.json

  tags = {
    Name = "${var.name_prefix}cloudwatch-metric-stream-role${var.name_suffix}"
  }
}

resource "aws_iam_role_policy" "cloudwatch-metric-stream-role-firehose-policy" {
  name   = "${var.name_prefix}MetricStreams-FirehosePutRecords${var.name_suffix}"
  role   = aws_iam_role.cloudwatch-metric-stream-role.id
  policy = data.aws_iam_policy_document.cloudwatch-metric-stream-role-firehose-policy.json
}

resource "aws_cloudwatch_metric_stream" "cloudwatch-metric-stream" {
  name          = "${var.name_prefix}newrelic-metric-stream${var.name_suffix}"
  role_arn      = aws_iam_role.cloudwatch-metric-stream-role.arn
  firehose_arn  = aws_kinesis_firehose_delivery_stream.kinesis-firehose-stream.arn
  output_format = "opentelemetry0.7"

  dynamic "include_filter" {
    for_each = var.cloudwatch_metric_stream_include_filter
    content {
      namespace = include_filter["value"]
    }
  }

  dynamic "exclude_filter" {
    for_each = var.cloudwatch_metric_stream_exclude_filter
    content {
      namespace = exclude_filter["value"]
    }
  }
}
