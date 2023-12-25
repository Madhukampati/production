resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags= {
    Name="aws-1"
  }
 
}
resource "aws_vpc" "vpc-1" {
  cidr_block = "10.1.0.0/16"
  tags= {
    Name="aws-2"
  }
 
 
}
resource "aws_subnet" "my_subnet" {
    vpc_id     =  "vpc-0e8bfe01fc7d153b3"
    cidr_block = "10.1.1.0/24"
    availability_zone = "us-east-1a"

    tags = {
    Name = "terra-subnet"
    }
}
resource "aws_internet_gateway" "gw" {
    vpc_id  = "vpc-0e8bfe01fc7d153b3"
    tags  = {
        Name = "igw"
    }
}
resource "aws_route_table" "RT"     {
    vpc_id = "vpc-0e8bfe01fc7d153b3"
    tags = {
        Name = "RT-1"
    }
    # since this is exactly the route AWS will create, the route will be adopted
        route  {
            cidr_block = "10.1.0.0/16"
            gateway_id = "local"
              }
    }
    resource "aws_security_group" "allow_tls" {
  name   = "allow"
  vpc_id = "vpc-0e8bfe01fc7d153b3"
  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sg-1"
  }
}
resource "aws_instance" "web-1" {
     ami = "ami-0230bd60aa48260c6"
     #ami = "ami-0d857ff0f5fc4e03b"
     #ami = "${data.aws_ami.my_ami.id}"
     availability_zone = "us-east-1a"
     instance_type = "t2.micro"
     key_name = "NEWUSERKEY"
     subnet_id = "${aws_subnet.my_subnet.id}"
     vpc_security_group_ids = ["${aws_security_group.allow_tls.id}"]
     associate_public_ip_address = true	
     tags = {
         Name = "Server-1"
         Env = "Prod"
         Owner = "Sree"

     }
 }
