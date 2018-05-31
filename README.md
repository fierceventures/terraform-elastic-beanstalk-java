# AWS elastic beanstalk application

This module can be used to deploy an AWS elastic beanstalk application and environment.

Module Input Variables
----------------------

- `name` - Unique name for application & environment
- `env`
- `vpc_id`
- `cert_arn`
- `public_subnet_id`
- `instance_type`
- `delete_logs_on_terminate`
- `key_pair_name`

Usage 
-----

```hcl
module "elastic-beanstalk-java" {
  source = "github.com/fierceventures/terraform-elastic-beanstalk-java"
  name = "${var.namespace}-server"
  env = "${terraform.workspace}"
  vpc_id = "${module.vpc.id}"
  cert_arn = "${module.backend_cert.arn}"
  public_subnet_id = "${module.public_subnet.id}"
  instance_type = "${var.server_instance_type}"
  key_pair_name = "${aws_key_pair.key_pair.key_name}"
}
```

Outputs
-------
- `cname` - cname/url 
- `eb_profile_name` - Instance profile name
- `eb_role_id`
- `eb_role_name`

Author
------
Created and maintained by [Fierce Ventures](https://github.com/fierceventures/)
