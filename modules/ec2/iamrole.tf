resource "aws_iam_role" "admin_role" {
  name = var.bastionhost_iamrole_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "admin_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.admin_role.name
}

resource "aws_iam_instance_profile" "bastionhostinstance_profile"{
    name = var.bastionhost_iaminstanceprofile_name
    role       = aws_iam_role.admin_role.name
}
