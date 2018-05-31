output "cname" {
  value = "${aws_elastic_beanstalk_environment.environment.cname}"
}

output "eb_profile_name" {
  value = "${aws_iam_instance_profile.eb_profile.name}"
}

output "eb_role_id" {
  value = "${aws_iam_role.eb_role.id}"
}

output "eb_role_name" {
  value = "${aws_iam_role.eb_role.name}"
}
