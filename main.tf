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
