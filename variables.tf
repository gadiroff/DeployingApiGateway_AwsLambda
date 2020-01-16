variable "role" {
  default = "article_rating_service"
}


variable "finance_product" {
   default = "article_rating_service"
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
    name               = "article_rating_service"
    s3_bucket          = "epic-lambda-artifacts"
    timeout            = 600
    memory_size        = 256
    trigger_rate       = "rate(60 minutes)"
  }
}

########################
### Elevio variables ###
########################


variable "elevio_api_key" {}

variable "elevio_auth_token" {}

variable "elevio_hash" {
  default = "3d1f26f7d02620a4df15dcdd70435eaf9548cd9f9dc47c3c6120bb797b3c10d8"
}
variable "elevio_user_email" {
  default = "vitali.gorobets@epicgames.com"
}

variable "elastic_url" {
  default = "http://support-kb-service-es-gamedev.ol.epicgames.net/"
}

variable "elevio_endpoint" {
  default = "https://api.elev.io/v1"
}
