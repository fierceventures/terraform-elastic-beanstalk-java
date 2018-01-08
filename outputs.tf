output "eb_profile_name" {
  value = "${aws_iam_instance_profile.eb_profile.name}"
}

output "eb_role_name" {
  value = "${aws_iam_role.eb_role.name}"
}

output "eb_role_id" {
  value = "${aws_iam_role.eb_role.id}"
}

output "eb_application_name" {
  value = "${aws_elastic_beanstalk_application.elastic-beanstalk.name}"
}

output "security_group_id" {
  value = "${aws_security_group.security-group.id}"
}
