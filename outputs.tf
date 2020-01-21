output "base_url" {
  value = "${aws_api_gateway_deployment.main.invoke_url}"
}


output "api_key" {
  value = "${aws_api_gateway_api_key.main.id}"
}


##################
### Postgre RD ###
##################

output "address" {
  value = "${aws_db_instance.postgres.address}"
}

output "arn" {
  value = "${aws_db_instance.postgres.arn}"
}

output "availability_zone" {
  value = "${aws_db_instance.postgres.availability_zone}"
}

output "id" {
  value = "${aws_db_instance.postgres.id}"
}

output "multi_az" {
  value = "${aws_db_instance.postgres.multi_az}"
}

output "port" {
  value = "${aws_db_instance.postgres.port}"
}

output "status" {
  value = "${aws_db_instance.postgres.status}"
}
