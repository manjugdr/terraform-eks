/*
output "bastionhost_iam_role_arn" {
  value = aws_iam_role.admin_role.arn
}*/

output "bastionhost_publicip" {
  value = aws_eip.bastionhost_eip.public_ip
 #value = aws_instance.bastion_host.public_ip
}

output "bastionhost_privateip" {
  value = aws_instance.bastion_host.private_ip
}
