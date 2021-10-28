[![New Relic Experimental header](https://github.com/newrelic/opensource-website/raw/master/src/images/categories/Experimental.png)](https://opensource.newrelic.com/oss-category/#new-relic-experimental)

# New Relic CloudWatch Metric Streams Terraform module

Terraform module which creates the necessary resources for using CloudWatch Metric Streams integration with New Relic.

This module will provision the following resources, including their necessary IAN permissions:

* IAM Role for linking your AWS account to New Relic One
* CloudWatch Metric Stream
* Kinesis Firehose Delivery Stream

Please note that this module is experimental, and if you find it useful, we would greatly appreciate your feedback!

## Terraform version

Terraform v0.12 or above is required.

## Providers

| Name          | Version   |
|---------------|-----------|
| hashicorp/aws | >= 3.42.0 |

## Notes

* Although this module provisions the IAM role and policy required for linking your AWS and New Relic accounts together, it does not do so automatically, and will have to be done either manually in New Relic UI, or using NerdGraph. See more details under "Getting Started" below.

* Please make sure to use the correct New Relic collector endpoint for your account using the variable `newrelic_collector_endpoint`. The correct URL can be found [here](https://docs.newrelic.com/docs/infrastructure/amazon-integrations/aws-integrations-list/aws-metric-stream/#manual-setup).

## Getting Started

First, you will need to include the module in your Terraform code. An example usage is documented below.

After your Terraform changes are applied, you will need to link each of your AWS accounts with your New Relic account.
To do so:

* Go to [one.newrelic.com](https://one.newrelic.com/) **> Infrastructure > AWS**, click on **Add an AWS account**, then on **Use metric streams**, and follow the steps.
* You may [automate this step with NerdGraph](https://docs.newrelic.com/docs/apis/nerdgraph/examples/nerdgraph-cloud-integrations-api-tutorial/#link-aws).

## Usage

Copy and paste into your Terraform configuration, insert the variables, and run `terraform init`:

```hcl
module "example-usage" {
  source = "git::ssh://git@github.com/newrelic-experimental/terraform-cloudwatch-metric-streams?ref=tags/v0.0.1"

  # Required variables
  
  newrelic_trusted_account_id = "<your-newrelic-account-id>"
  newrelic_license_key        = "<your-newrelic-license-key>"
  
  # The URL can be found on: https://docs.newrelic.com/docs/infrastructure/amazon-integrations/aws-integrations-list/aws-metric-stream/#manual-setup
  # Typically, this changes based on your account region.
  #   - For accounts in US: https://aws-api.newrelic.com/cloudwatch-metrics/v1
  #   - For accounts in EU: https://aws-api.eu01.nr-data.net/cloudwatch-metrics/v1
  newrelic_collector_endpoint = "<newrelic-collector-endpoint>"

  # Optional variables

  name_suffix = "-example"
  name_prefix = "example-"

  cloudwatch_metric_stream_include_filter = [
    "AWS/EC2",
    "AWS/S3",
    "AWS/SQS",
    "AWS/SageMaker"
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| newrelic\_trusted\_account\_id | This is your New Relic account id, and it is needed to only allow your account to assume the role needed for account linking. | `string` | - | yes |
| newrelic\_license\_key | This is your New Relic ingest license key, and it is needed for Kinesis Firehose to successfully send metrics to your New Relic account. | `string` | - | yes |
| newrelic\_collector\_endpoint | This is the New Relic collector endpoint. The URL changes based on your account region (US/EU), and can be found on https://docs.newrelic.com/docs/infrastructure/amazon-integrations/aws-integrations-list/aws-metric-stream/#manual-setup. | `string` | - | yes |
| name\_prefix | A prefix to prepend to the name of all resources created by this module. | `string` | empty ("") | no |
| name\_suffix | A suffix to append to the name of all resources created by this module. | `string` | empty ("") | no |
| cloudwatch\_metric\_stream\_include\_filter | List of namespaces to include from the CloudWatch Metric Stream. Mutually exclusive with `cloudwatch_metric_stream_exclude_filter`. | `list` | empty ([]) | no |
| cloudwatch\_metric\_stream\_exclude\_filter | List of namespaces to exclude from the CloudWatch Metric Stream. Mutually exclusive with `cloudwatch_metric_stream_include_filter`. | `list` | empty ([]) | no |

## Outputs

| Name | Description |
|------|-------------|
| newrelic-one-external-role-arn | The ARN of the provisioned IAM role used for New Relic account linking. |
| kinesis-firehose-stream-arn | The ARN of the provisioned Kinesis Firehose Delivery Stream. |
| kinesis-firehose-stream-role-arn | The ARN of the provisioned IAM role used by Kinesis Firehose Delivery Stream. |
| kinesis-firehose-stream-failed-data-s3-bucket-arn | The ARN of the provisioned S3 bucket used for storing data which Kinesis Firehose failed sending to New Relic. |
| cloudwatch-metric-stream-arn | The ARN of the provisioned CloudWatch Metric Stream. |
| cloudwatch-metric-stream-role-arn | The ARN of the provisioned IAM role used by CloudWatch Metric Stream. |

## Contributing
We encourage your contributions to improve [project name]! Keep in mind when you submit your pull request, you'll need to sign the CLA via the click-through using CLA-Assistant. You only have to sign the CLA one time per project.
If you have any questions, or to execute our corporate CLA, required if your contribution is on behalf of a company,  please drop us an email at opensource@newrelic.com.

**A note about vulnerabilities**

As noted in our [security policy](../../security/policy), New Relic is committed to the privacy and security of our customers and their data. We believe that providing coordinated disclosure by security researchers and engaging with the security community are important means to achieve our security goals.

If you believe you have found a security vulnerability in this project or any of New Relic's products or websites, we welcome and greatly appreciate you reporting it to New Relic through [HackerOne](https://hackerone.com/newrelic).

## License
Licensed under Apache 2.0, see [LICENSE](LICENSE) for full details.