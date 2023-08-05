stack {
  name        = "s3-flow-logs"
  
  after = [
    "../../kms"
  ]
}

import {
  source = "/modules/myproduct/environment/region/vpc/s3-flow-logs/stack.tm.hcl"
}
