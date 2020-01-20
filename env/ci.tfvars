env = "ci"


subnets = [
  "subnet-010101a3a3", # test_ci_2_1
  "subnet-020202b3b3", # test_ci_2_2
]


security_groups = [
  "sg-e", # test_internal_nets
  "sg-0", # test_mgt_nets
  "sg-7", # test_ci_nets
]