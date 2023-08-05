stack {
  name        = "vpc"

  after = [
    "../s3-flow-logs"
  ]
}

import {
  source = "/modules/myproduct/environment/region/vpc/vpc/stack.tm.hcl"
}
