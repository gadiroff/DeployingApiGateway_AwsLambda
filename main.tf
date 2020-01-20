terraform {
  backend "s3" {
    bucket         = "ton-tf-test"
    key            = "tf-projects/test"
    dynamodb_table = "ton-tf-test"
    region         = "us-east-1"
  }
}

provider "aws" {
  region     = "us-east-1"
  version = "~> 2.39.0"
  access_key = "${var.aws_access_key_id}"
  secret_key = "${var.aws_secret_access_key}"
}

  
###########################
### AWS Lambda Function ###
###########################

resource "aws_lambda_function" "testt_lambda_function" {           
  function_name = "${var.testt["name"]}-${var.env}"
  role          = "${aws_iam_role.testt_lambda_role.arn}"
  s3_bucket     = "${var.testt["s3_bucket"]}"
  s3_key        = "testt/${var.env}/testt.zip"   
  handler       = "handler.createTesTT"
  timeout       = "${var.testt["timeout"]}"
  memory_size   = "${var.testt["memory_size"]}"

  runtime = "nodejs12.x"

  vpc_config = {
    subnet_ids         = "${var.subnets}"
    security_group_ids = "${var.security_groups}"
  }


  environment = {
    variables = {
      "PGUSER"    = "${var.pguser}"
      "PGHOST"        = "${var.pghost}"
      "PGPASSWORD"     = "${var.pgpassword}"
      "PGDATABASE"  = "${var.pgdatabase}"
      "PGPORT"  = "${var.pgport}"

    }
  }


 
tags {
    Role                      = "${var.role}-${var.env}"
    Tier                      = "${var.tier}"
    "Environment" = "${var.env}"
    "Product"     = "${var.finance_product}"
    "Owner"       = "${var.finance_owner}"
  }

}


resource "aws_iam_role" "testt_lambda_role" {
  name = "testt-lambda-${var.env}-role"

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
    "Environment" = "${var.env}"
    "Product"     = "${var.finance_product}"
    "Owner"       = "${var.finance_owner}"
  }
  
}



resource "aws_iam_policy" "testt_lambda_policy" {
  name = "testt-lambda-${var.env}-policy"
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


resource "aws_iam_policy_attachment" "testt_lambda_attach" {
  name       = "testt-lambda-attachment"
  roles      = ["${aws_iam_role.testt_lambda_role.name}"]
  policy_arn = "${aws_iam_policy.testt_lambda_policy.arn}"
}


###########################
####### API GATEWAY #######
###########################


resource "aws_api_gateway_rest_api" "main" {
  name        = "${var.role}-${var.env}"
  description = "${var.role}-${var.env}"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
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
   uri                     = "${aws_lambda_function.testt_lambda_function.invoke_arn}"
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
   uri                     = "${aws_lambda_function.testt_lambda_function.invoke_arn}"
 }




 resource "aws_lambda_permission" "apigw" {
   statement_id  = "AllowmainInvoke"
   action        = "lambda:InvokeFunction"
   function_name = "${aws_lambda_function.testt_lambda_function.arn}"
   principal     = "apigateway.amazonaws.com"

   
   source_arn = "${aws_api_gateway_rest_api.main.execution_arn}:${var.role}-${var.env}/*/*"
 }

 

 resource "aws_api_gateway_deployment" "main" {
   depends_on = [
     "aws_api_gateway_integration.lambda",
     "aws_api_gateway_integration.lambda_root",
   ]

   rest_api_id = "${aws_api_gateway_rest_api.main.id}"
   stage_name  = "${var.role}-${var.env}"
 }



