# AWS elastic beanstalk application

This module can be used to deploy an AWS elastic beanstalk application. The environment must be created separately

Module Input Variables
----------------------

- `name` - The name of the application and environment
- `env` - The environment name
- `vpc_id` - The id of the vpc

Usage 
-----

```hcl
module "elastic-beanstalk-java" {
  source = "github.com/fierceventures/terraform-elastic-beanstalk-java"
  name = "primary"
  env = "test"
  vpc_id = "${module.vpc.id}"
}
```

Outputs
-------
- `eb_profile_name` - The iam instance profile name 
- `eb_role_name` - The role name 
- `eb_role_id` - The role id 
- `eb_name` - The name of the application
- `security_group_id` - The security group id

Author
------
Created and maintained by [Fierce Ventures](https://github.com/fierceventures/)
