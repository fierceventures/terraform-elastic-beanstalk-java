resource "aws_iam_role" "ebs_role" {
  name = "${terraform.workspace}-ebs"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "elasticbeanstalk.amazonaws.com"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "elasticbeanstalk"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ebs-service-attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
  role = "${aws_iam_role.ebs_role.name}"
}
resource "aws_iam_role_policy_attachment" "ebs-enhanced-health-attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
  role = "${aws_iam_role.ebs_role.name}"
}

resource "aws_elastic_beanstalk_environment" "environment" {
  application = "${aws_elastic_beanstalk_application.elastic-beanstalk.name}"
  name = "${var.env}-${var.name}"
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.7.1 running Java 8"

  setting {
    name = "SSLCertificateId"
    namespace = "aws:elb:loadbalancer"
    value = "${var.cert_arn}"
  }

  setting {
    name = "LoadBalancerHTTPSPort"
    namespace = "aws:elb:loadbalancer"
    value = "443"
  }

  setting {
    name = "LoadBalancerHTTPPort"
    namespace = "aws:elb:loadbalancer"
    value = "OFF"
  }

  setting {
    name = "EnvironmentType"
    namespace = "aws:elasticbeanstalk:environment"
    value = "LoadBalanced"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name = "VPCId"
    value = "${var.vpc_id}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name = "ELBSubnets"
    value = "${var.public_subnet_id}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name = "Subnets"
    value = "${var.public_subnet_id}"
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
    value = "${aws_iam_role.ebs_role.name}"
  }

  setting {
    name = "StreamLogs"
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    value = "true"
  }

  setting {
    name = "DeleteOnTerminate"
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    value = "${var.delete_logs_on_terminate}"
  }

  setting {
    name = "EC2KeyName"
    namespace = "aws:autoscaling:launchconfiguration"
    value = "${var.key_pair_name}"
  }

  setting {
    name = "SystemType"
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    value = "enhanced"
  }

  setting {
    name = "Application Healthcheck URL"
    namespace = "aws:elasticbeanstalk:application"
    value = "/health"
  }
}

resource "aws_iam_instance_profile" "eb_profile" {
  name = "${var.env}-${var.name}"
  role = "${aws_iam_role.eb_role.name}"
}

resource "aws_iam_role" "eb_role" {
  name = "${var.env}-${var.name}"
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
  name = "${var.env}-${var.name}"
}
