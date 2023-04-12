# Create a VPC with the specified CIDR block
resource "aws_vpc" "my_vpc" {
  cidr_block = var.cidr_block
}

# Create an Internet Gateway and attach it to the VPC
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
}

# Create a public subnet with the specified CIDR block
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.public_cidr_block

  # Enable public IP assignment for instances in this subnet
  map_public_ip_on_launch = true
}

# Create a private subnet with the specified CIDR block
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.private_cidr_block
}

# Create an Elastic IP for the NAT gateway
resource "aws_eip" "nat_eip" {}

# Create a NAT gateway using the Elastic IP created above and associate it with the public subnet
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id

  # Add the Internet Gateway ID to the list of dependencies to ensure that the NAT Gateway is created after the Internet Gateway
  depends_on = [
    aws_internet_gateway.my_igw
  ]
}

# Create a public route table for the VPC
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id
}

# Create a private route table for the VPC
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my_vpc.id
}

# Associate the public route table with the public subnet
resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Associate the private route table with the private subnet
resource "aws_route_table_association" "private_route_table_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

# Add a route to the private route table that directs traffic to the NAT gateway
resource "aws_route" "nat_gateway_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}

# Create a security group that allows SSH traffic
resource "aws_security_group" "vm_security_group" {
  name_prefix = "vm_security_group"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch an EC2 instance in the private subnet and output the VM's public IP address
resource "aws_instance" "vm_instance" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet.id # add ".id

  vpc_security_group_ids = [aws_security_group.vm_security_group.id]tags = {
    Name    = "Discover-Dollar2"
    Project = "TWO"
  }

}