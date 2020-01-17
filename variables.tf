variable "role" {
  default = "article-rating-service"
}


variable "finance_product" {
   default = "article-rating-service"
}

variable "finance_owner" {
  default = "online-web"
}

variable "tier" {
  default = "88"
}

variable "env" {}

variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}

variable "subnets" {
  type = "list"
}

variable "security_groups" {
  type = "list"
}

###########################
### AWS Lambda Function ###
###########################


variable "article_rating_service" {
  default = {
    name               = "article-rating-service"
    s3_bucket          = "epic-lambda-artifacts"
    timeout            = 60
    memory_size        = 256
  }
}



####################################
####### POSTGRESQL Variables #######
####################################

variable "pguser" {
  default = "admin"
}

variable "pghost" {
  default = "localhost"
}

variable "pgpassword" {
  default = "admin"
}

variable "pgdatabase" {
  default = "ratings"
}

variable "pgport" {
  default = "5431"
}

