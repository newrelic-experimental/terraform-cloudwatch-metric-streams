# Output variables file
# https://www.terraform.io/docs/configuration/modules.html#accessing-module-output-values 

output "newrelic-one-external-role-arn" {
  description = "The ARN of the provisioned IAM role used for New Relic account linking."
  value       = aws_iam_role.newrelic-one-external-role.arn
}

output "kinesis-firehose-stream-arn" {
  description = "The ARN of the provisioned Kinesis Firehose Delivery Stream."
  value       = aws_kinesis_firehose_delivery_stream.kinesis-firehose-stream.arn
}

output "kinesis-firehose-stream-role-arn" {
  description = "The ARN of the provisioned IAM role used by Kinesis Firehose Delivery Stream."
  value       = aws_iam_role.kinesis-firehose-stream-role.arn
}

output "kinesis-firehose-stream-failed-data-s3-bucket-arn" {
  description = "The ARN of the provisioned S3 bucket used for storing data which Kinesis Firehose failed sending to New Relic."
  value       = aws_s3_bucket.kinesis-firehose-stream-failed-data.arn
}

output "cloudwatch-metric-stream-arn" {
  description = "The ARN of the provisioned CloudWatch Metric Stream."
  value       = aws_cloudwatch_metric_stream.cloudwatch-metric-stream.arn
}

output "cloudwatch-metric-stream-role-arn" {
  description = "The ARN of the provisioned IAM role used by CloudWatch Metric Stream."
  value       = aws_iam_role.cloudwatch-metric-stream-role.arn
}
