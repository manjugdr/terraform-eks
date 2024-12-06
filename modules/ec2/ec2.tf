# Data block to fetch the latest Amazon Linux 2023 AMI
# This helps dynamically select the AMI based on specific filters and ensures the most recent version is always used.
data "aws_ami" "latest_amazon_linux" {
  most_recent = true                     # Ensure the latest AMI matching the filter is selected
  owners      = ["amazon"]               # Restrict the AMI selection to those owned by Amazon

  filter {
    name   = "name"                      # Filter the AMIs by their name attribute
    values = ["al2023-ami-2023*-x86_64"] # Match Amazon Linux 2023 AMIs with x86_64 architecture
  }
}

# Allocate a new Elastic IP (EIP) for the bastion host
# This provides a static public IP address for the instance.
resource "aws_eip" "bastionhost_eip" {
  vpc = true                              # Allocate the EIP for use in a VPC environment
  tags = {
    "Name" = "${var.project_name}-${var.environment}-bastionhosteip" # Tag the EIP for identification
  }
}

# Create an EC2 instance to serve as a bastion host
# The bastion host enables secure access to other instances within the private network.
resource "aws_instance" "bastion_host" { 
  ami                    = "ami-08718895af4dfa033" # Hardcoded AMI ID; replace with data.aws_ami.latest_amazon_linux.id for dynamic selection
  instance_type          = var.instanceType       # Instance type is defined as a variable for flexibility
  subnet_id              = var.public_subnet_ids[0] # Deploy the instance in the first public subnet from the list
  key_name               = var.keypairname        # Specify the SSH key pair name for secure access
  iam_instance_profile   = aws_iam_instance_profile.bastionhostinstance_profile.name # Attach an IAM instance profile for additional permissions
  associate_public_ip_address = var.associate_public_ip_address # Assign a public IP address to the instance if specified
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]    # Attach a security group to control inbound and outbound traffic

  # Define the root block device configuration
  root_block_device {
    volume_size = var.ebs_rootvol_size["bastion"]  # Specify the size of the root volume
    volume_type = var.ebs_vol_type["default"]      # Use the default volume type, typically gp3 or gp2
    encrypted   = "true"                           # Encrypt the root volume for added security
    tags = {
      "Name" = "${var.project_name}-${var.environment}-bastionrootvol" # Tag the root volume for identification
    }
  }

  # Add tags to the EC2 instance for better management and visibility
  tags = {
    Name = "${var.project_name}-${var.environment}-bastionhost" # Tag the instance with project and environment details
  }  
}

# Associate the Elastic IP with the bastion host EC2 instance
# This links the allocated EIP to the specific instance, making it accessible via the static IP.
resource "aws_eip_association" "bastionhost_eip_assoc" {
  instance_id   = aws_instance.bastion_host.id   # Link the EIP to the bastion host instance
  allocation_id = aws_eip.bastionhost_eip.id     # Use the allocation ID of the previously created EIP
}
