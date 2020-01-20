variable "role" {
  default = "testt"
}


variable "finance_product" {
   default = "testt"
}

variable "finance_owner" {
  default = "web"
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


variable "testt" {
  default = {
    name               = "testt"
    s3_bucket          = "testt-lambda-artifacts"
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
  default = "testt"
}

variable "pgport" {
  default = "5431"
}

