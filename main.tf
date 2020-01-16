terraform {
  backend "s3" {
    bucket         = "ton-tf-state"
    key            = "tf-projects/article-rating-service"
    dynamodb_table = "ton-tf-state"
    region         = "us-east-1"
  }
}

provider "aws" {
  region     = "us-east-1"
  version = "~> 2.39.0"
  access_key = "${var.aws_access_key_id}"
  secret_key = "${var.aws_secret_access_key}"
}



######################
### Lambda Archive ###
######################


resource "local_file" "latest_zip" {
  filename = "${path.module}/latest.js"
}


data "archive_file" "lambda_archive" {
  type        = "zip"
  output_path = "${path.module}/latest.zip"

  source {
    content  = "console.log('Hello World')"
    filename = "latest.js"
  }
}

  
###########################
### AWS Lambda Function ###
###########################

resource "aws_lambda_function" "article_rating_service_lambda_function" {           
  function_name = "${var.article_rating_service["name"]}-${var.env}"
  role          = "${aws_iam_role.article_rating_service_lambda_role.arn}"
  s3_bucket     = "${var.article_rating_service["s3_bucket"]}"
  s3_key        = "article_rating_service/${var.env}/latest.zip"   
  handler       = "index.handler"
  timeout       = "${var.article_rating_service["timeout"]}"
  memory_size   = "${var.article_rating_service["memory_size"]}"

  runtime = "nodejs12.x"

  vpc_config = {
    subnet_ids         = "${var.subnets}"
    security_group_ids = "${var.security_groups}"
  }


  environment = {
    variables = {
      "EPIC_PST_SSP_ELEVIO_ENDPOINT"    = "${var.elevio_endpoint}"
      "EPIC_PST_SSP_ELASTIC_URL"        = "${var.elastic_url}"
      "EPIC_PST_SSP_ELEVIO_API_KEY"     = "${var.elevio_api_key}"
      "EPIC_PST_SSP_ELEVIO_AUTH_TOKEN"  = "${var.elevio_auth_token}"
      "EPIC_PST_SSP_ELEVIO_USER_EMAIL"  = "${var.elevio_user_email}"
      "EPIC_PST_SSP_ELEVIO_HASH"        = "${var.elevio_hash}"

    }
  }


 
tags {
    Role                      = "${var.role}-${var.env}"
    Tier                      = "${var.tier}"
    "EpicFinance:Environment" = "${var.env}"
    "EpicFinance:Product"     = "${var.finance_product}"
    "EpicFinance:Owner"       = "${var.finance_owner}"
  }

}


resource "aws_iam_role" "article_rating_service_lambda_role" {
  name = "article-rating-service-lambda-${var.env}-role"

 assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  
  tags {
    Role                      = "${var.role}-${var.env}"
    Tier                      = "${var.tier}"
    "EpicFinance:Environment" = "${var.env}"
    "EpicFinance:Product"     = "${var.finance_product}"
    "EpicFinance:Owner"       = "${var.finance_owner}"
  }
  
}



resource "aws_iam_policy" "article_rating_service_lambda_policy" {
  name = "article-rating-service-lambda-${var.env}-policy"
  path        = "/"


  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "*",
      "Resource": "*"
    }
  ]
}
EOF
}


resource "aws_iam_policy_attachment" "article_rating_service_lambda_attach" {
  name       = "article-rating-service-lambda-attachment"
  roles      = ["${aws_iam_role.article_rating_service_role.name}"]
  policy_arn = "${aws_iam_policy.article_rating_service_policy.arn}"
}


###########################
####### API GATEWAY #######
###########################


resource "aws_api_gateway_rest_api" "main" {
  name        = "article-rating-service"
  description = "article-rating-service"
}




resource "aws_api_gateway_resource" "main" {
   rest_api_id = "${aws_api_gateway_rest_api.main.id}"
   parent_id   = "${aws_api_gateway_rest_api.main.root_resource_id}"
   path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "main" {
   rest_api_id   = "${aws_api_gateway_rest_api.main.id}"
   resource_id   = "${aws_api_gateway_resource.main.id}"
   http_method   = "ANY"
   authorization = "NONE"
 }




resource "aws_api_gateway_integration" "lambda" {
   rest_api_id = "${aws_api_gateway_rest_api.main.id}"
   resource_id = "${aws_api_gateway_method.main.resource_id}"
   http_method = "${aws_api_gateway_method.main.http_method}"

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = "${aws_lambda_function.main.invoke_arn}"
 }


 

  resource "aws_api_gateway_method" "main_root" {
   rest_api_id   = "${aws_api_gateway_rest_api.main.id}"
   resource_id   = "${aws_api_gateway_rest_api.main.root_resource_id}"
   http_method   = "ANY"
   authorization = "NONE"
 }

 resource "aws_api_gateway_integration" "lambda_root" {
   rest_api_id = "${aws_api_gateway_rest_api.main.id}"
   resource_id = "${aws_api_gateway_method.main_root.resource_id}"
   http_method = "${aws_api_gateway_method.main_root.http_method}"

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = "${aws_lambda_function.main.invoke_arn}"
 }




 resource "aws_lambda_permission" "apigw" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = "${aws_lambda_function.article_rating_service_lambda_function.function_name}"
   principal     = "apigateway.amazonaws.com"

   
   source_arn = "${aws_api_gateway_rest_api.main.execution_arn}:${var.role}-${var.env}/*/*"
 }

 

 resource "aws_api_gateway_deployment" "main" {
   depends_on = [
     "${aws_api_gateway_integration.lambda}",
     "${aws_api_gateway_integration.lambda_root}"
   ]

   rest_api_id = "${aws_api_gateway_rest_api.main.id}"
   stage_name  = "${var.role}-${var.env}"

   depends_on = [
    "${aws_api_gateway_integration.lambda}",
    "${aws_api_gateway_integration.lambda_root}"
  ]
 }



