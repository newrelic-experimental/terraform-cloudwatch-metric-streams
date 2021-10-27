# Input variables file
# https://www.terraform.io/docs/configuration/modules.html#calling-a-child-module

# required

variable "newrelic_trusted_account_id" {
  description = "This is your New Relic account id, and it is needed to only allow your account to assume the role needed for account linking."
  type        = string
}

variable "newrelic_license_key" {
  description = "This is your New Relic ingest license key, and it is needed for Kinesis Firehose to successfully send metrics to your New Relic account."
  type        = string
}

variable "newrelic_collector_endpoint" {
  description = "This is the New Relic collector endpoint. The URL changes based on your account region (US/EU), and can be found on https://docs.newrelic.com/docs/infrastructure/amazon-integrations/aws-integrations-list/aws-metric-stream/#manual-setup."
  type        = string
}

# optional

variable "name_prefix" {
  description = "A prefix to prepend to the name of all resources created by this module. Optional."
  type        = string
}

variable "name_suffix" {
  description = "A suffix to append to the name of all resources created by this module. Optional."
  type        = string
}

variable "cloudwatch_metric_stream_include_filter" {
  description = "List of namespaces to include from the CloudWatch Metric Stream. Mutually exclusive with cloudwatch_metric_stream_exclude_filter. Optional."
  type        = list
  default     = []
}

variable "cloudwatch_metric_stream_exclude_filter" {
  description = "List of namespaces to exclude from the CloudWatch Metric Stream. Mutually exclusive with cloudwatch_metric_stream_include_filter. Optional."
  type        = list
  default     = []
}
