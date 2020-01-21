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



variable "pgpassword" {
  default = "admin"
}


variable "pgport" {
  default = "5431"
}



##################
### Postgre RD ###
##################


# Required Variables #


variable "aws_ec2_zone_id" {
  description = "Route53 ZoneID to manage postgres records"
}

variable "domain" {
  description = "Domain to use for DNS entries"
}


variable "postgres_version" {
  description = "Postgres version to deploy"
  default = "11.5"
}



# Optional Variables #

variable "allocated_storage" {
  description = "Size of the main EBS volume to use for redis nodes"
  default     = 20
}

variable "instance_class" {
  description = "Instance type for postgres nodes"
  default     = "db.t2.micro"
}

variable "multi_az" {
  description = "Setup the DB as multi-AZ (it will have read-only replicas)"
  default     = true
}


variable "publicly_accessible" {
  description = "Whether this DB should be publicaly accessible or not"
  default     = false
}

variable "storage_encrypted" {
  description = "Encrypt the DB"
  default     = false
}

variable "storage_type" {
  description = "Type of the data block device for redis"
  default     = "gp2"
}

