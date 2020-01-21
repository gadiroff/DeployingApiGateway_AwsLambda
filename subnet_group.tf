resource "aws_db_subnet_group" "postgres" {
  name_prefix = "${var.role}-${var.env}"
  subnet_ids  = "${var.subnets}"

  tags {
    Cluster = "${var.role}-${var.env}"
  }
}
