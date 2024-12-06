output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.my_vpc.id
}
output "public_subnet_ids" {
  description = "The ID of the public subnet"
  value       = aws_subnet.public_subnet[*].id 
}
output "private_subnet_ids" {
  description = "The ID of the private subnet"
  value       = aws_subnet.private_subnet[*].id 
}
output "private_subnet_tags" {
  description = "The ID of the private subnet"
  value       = aws_subnet.private_subnet[*].tags
}
output "public_subnet_tags" {
  description = "The ID of the private subnet"
  value       = aws_subnet.public_subnet[*].tags
}
output "public_subnet_cidr" {
  description = "The ID of the private subnet"
  value       = aws_subnet.public_subnet[*].cidr_block
}
output "private_subnet_cidr" {
  description = "The ID of the private subnet"
  value       = aws_subnet.private_subnet[*].cidr_block
}
output "private_subnet_availabilityzones" {
  description = "The ID of the private subnet AZ"
  value       = aws_subnet.private_subnet[*].availability_zone
}
