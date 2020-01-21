env = "cd"

subnets = [
  "subnet-b", # test_cd_2_3
  "subnet-7", # test_cd_2_4
]

security_groups = [
  "sg-e", # test_internal_nets
  "sg-0", # test_mgt_nets
  "sg-6", # test_cd_nets
]

aws_ec2_zone_id = "qwert123w3es" # private - ck.test.net.

domain = "ck.test.net"
