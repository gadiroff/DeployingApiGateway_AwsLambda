#
# DNS records
#

resource "aws_route53_record" "postgres_CNAME" {
  zone_id = "${var.aws_ec2_zone_id}"
  name    = "${var.role}-${var.env}-postgres.${var.domain}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_db_instance.postgres.address}"]
}
