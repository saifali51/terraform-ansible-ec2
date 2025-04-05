provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-0c02fb55956c7d316"  # Amazon Linux 2
  instance_type = "t2.micro"
  key_name      = "my-key"

  tags = {
    Name = "jenkins-ec2"
  }
}
output "public_ip" {
  value = aws_instance.web.public_ip
}

