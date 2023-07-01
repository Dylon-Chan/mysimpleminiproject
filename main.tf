resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "WengSiongVPC"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "WengSiongPublicSubnet"
  }
}

resource "aws_security_group" "my_security_group" {
  name = "WengSiong-SecurityGroup"
  vpc_id = aws_vpc.my_vpc.id

  # SSH
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ICMP
  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "Webserver-1" {
  ami = "ami-0310483fb2b488153"  # Change this with the correct AMI 
  instance_type = "t2.micro"
  key_name = "wengsiong-sydney-keypair"  # Use the name of existing keypair
  subnet_id = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  associate_public_ip_address = true
  tags = {
    Name = "Webserver-WS-1"
  }
}

resource "aws_instance" "Webserver-2" {
  ami = "ami-0310483fb2b488153"  # Change this with the correct AMI 
  instance_type = "t2.micro"
  key_name = "wengsiong-sydney-keypair"  # Use the name of existing keypair
  subnet_id = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  associate_public_ip_address = true
  tags = {
    Name = "Webserver-WS-2"
  }
}

resource "aws_instance" "Ansibleserver" {
  ami = "ami-0310483fb2b488153"  # Change this with the correct AMI 
  instance_type = "t2.micro"
  key_name = "wengsiong-sydney-keypair"  # Use the name of existing keypair
  subnet_id = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  associate_public_ip_address = true
  tags = {
    Name = "AnsibleServer-WS"
  }

  user_data = <<-EOF
                #!/bin/bash
                sudo yum update -y
                sudo yum install pip -y
                sudo python3 -m pip install --user ansible
                EOF
}