# AWS Private Subnet

This module can be used to deploy an AWS elastic beanstalk java application.

Module Input Variables
----------------------

- `name` - The name of the application and environment
- `env` - The environment name
- `instance_type` - The instance type
- `vpc_id` - The id of the vpc
- `subnet` - The public subnet id for the application 

Usage 
-----

```hcl
module "elastic-beanstalk-java" {
  source = "github.com/fierceventures/terraform-elastic-beanstalk-java"
  name = "primary"
  env = "test"
  instance_type = "t2.micro"
  vpc_id = "${module.vpc.id}"
  subnet = "${module.public-subnet.id}"
}
```

Outputs
-------
- `eb_profile_name` - The iam instance profile name 
- `eb_role_name` - The role name 
- `eb_role_id` - The role id 

Author
------
Created and maintained by [Fierce Ventures](https://github.com/fierceventures/)
