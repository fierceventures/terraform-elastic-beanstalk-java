resource "aws_iam_instance_profile" "eb_profile" {
  name = "${terraform.workspace}-${var.name}"
  role = "${aws_iam_role.eb_role.name}"
}

resource "aws_iam_role" "eb_role" {
  name = "${terraform.workspace}-${var.name}"
  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "eb_web_tier_policy" {
  role = "${aws_iam_role.eb_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_security_group" "security-group" {
  vpc_id = "${var.vpc_id}"

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}

resource "aws_elastic_beanstalk_application" "elastic-beanstalk" {
  name = "${terraform.workspace}-${var.name}"
}

resource "aws_elastic_beanstalk_environment" "environment" {
  application = "${aws_elastic_beanstalk_application.elastic-beanstalk.name}"
  name = "${terraform.workspace}-${var.name}"
  solution_stack_name = "64bit Amazon Linux 2017.09 v2.6.0 running Java 8"

  setting {
    name = "EnvironmentType"
    namespace = "aws:elasticbeanstalk:environment"
    value = "SingleInstance"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name = "VPCId"
    value = "${var.vpc_id}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name = "Subnets"
    value = "${var.subnet}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name = "AssociatePublicIpAddress"
    value = "true"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "IamInstanceProfile"
    value = "${aws_iam_instance_profile.eb_profile.name}"
  }

  setting {
    name = "InstanceType"
    namespace = "aws:autoscaling:launchconfiguration"
    value = "${var.instance_type}"
  }

  setting {
    name = "SecurityGroups"
    namespace = "aws:autoscaling:launchconfiguration"
    value = "${aws_security_group.security-group.id}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name = "ServiceRole"
    value = "aws-elasticbeanstalk-service-role"
  }
}
