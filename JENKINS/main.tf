# Configure AWS provider with proper credentials
provider "aws" {
  region = "us-east-1"
}
 
# Create default VPC if one does not exist
resource "aws_default_vpc" "default_vpc" {
  tags = {
    Name = "default vpc"
  }
}

# Use data source to get all availability zones in region
data "aws_availability_zones" "available_zones" {}

# Create default subnet if one does not exist
resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.available_zones.names[0]

  tags = {
    Name = "default subnet"
  }
}

# Create security group for the EC2 instance
resource "aws_security_group" "ec2_security_group_jenkins" {
  name        = "ec2 security group_jenkins"
  description = "allow access on ports 8080, 22, and 9000"
  vpc_id      = aws_default_vpc.default_vpc.id

  # Allow access on port 8080 (HTTP)
  ingress {
    description = "HTTP proxy access"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow access on port 22 (SSH)
  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow access on port 9000 (SonarQube)
  ingress {
    description = "SonarQube access"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  
  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all egress traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  tags = {
    Name = "jenkins server security group"
  }
}

# Use data source to get a registered Amazon Linux 2 AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

# Launch the EC2 instance and install website
resource "aws_instance" "ec2_instance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.2xlarge"
  subnet_id              = aws_default_subnet.default_az1.id
  vpc_security_group_ids = [aws_security_group.ec2_security_group_jenkins.id]
  key_name               = "Udemyclass2"
  user_data            = file("install_jenkins.sh")

  tags = {
    Name = "jenkins_server"
  }
}

/*# An empty resource block
resource "null_resource" "name" {
  # SSH into the EC2 instance 
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/Downloads/Udemyclass2.pem")
    host        = aws_instance.ec2_instance.public_ip
  }

  # Copy the install_jenkins.sh file from your computer to the EC2 instance 
  provisioner "file" {
    source      = "install_jenkins.sh"
    destination = "/tmp/install_jenkins.sh"
  }

  # Set permissions and run the install_jenkins.sh file
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/install_jenkins.sh",
      "sh /tmp/install_jenkins.sh",
    ]
  }

  # Wait for EC2 to be created
  depends_on = [aws_instance.ec2_instance]
} */

# Print the URL of the Jenkins server
output "website_url" {
  value = "http://${aws_instance.ec2_instance.public_ip}:8080"
}
