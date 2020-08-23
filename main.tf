provider "aws" {
  region = "ap-southeast-2"
}

module "lambda" {
  source = "git::https://github.com/tuan231195/terraform-modules.git//modules/aws-lambda?ref=master"
  function_name = "test-terraform-lambda"
  handler = "index.handler"
  source_path = "${path.module}/src"
  runtime = "nodejs12.x"
  environment = {
    variables = {
      S3_BUCKET = aws_s3_bucket.s3.bucket
    }
  }
  policy = {
    json = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Action": [
            "s3:GetObject"
        ],
        "Resource": "arn:aws:s3:::${aws_s3_bucket.s3.bucket}/*",
        "Effect": "Allow"
    }
  ]
}
EOF
  }
  layer_config = {
    package_file = "${path.module}/src/package.json"
    compatible_runtimes = [
      "nodejs12.x"]
  }
}

resource "aws_s3_bucket" "s3" {
  bucket = "terraform-test-s3-bucket-lambda"
}

resource "aws_s3_bucket_object" "s3_item" {
  bucket = aws_s3_bucket.s3.bucket
  key = "response.json"
  content = <<EOF
{"message": "OK" }
EOF
}
