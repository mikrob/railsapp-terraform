resource "aws_vpc" "vpc" {
  cidr_block = var.aws_network_cidr

  #### this 2 true values are for use the internal vpc dns resolution
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name        = "${terraform.workspace}-vpc"
    Environment = terraform.workspace
  }
}

resource "aws_network_acl" "all_internal" {
  vpc_id     = aws_vpc.vpc.id
  subnet_ids = aws_subnet.vpc_subnet.*.id

  egress {
    protocol   = "-1"
    rule_no    = 1
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 4
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 5
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 6
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  # spotted
  ingress {
    protocol   = "tcp"
    rule_no    = 7
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024 #32768
    to_port    = 65535
  }

  ingress {
    protocol   = "udp"
    rule_no    = 9
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024 #32768
    to_port    = 65535
  }

  ingress {
    rule_no    = 10
    protocol   = "icmp"
    icmp_type  = -1
    icmp_code  = -1
    from_port  = 0
    to_port    = 0
    cidr_block = var.aws_network_cidr
    action     = "allow"
  }


  ingress {
    protocol   = "-1"
    rule_no    = 16
    action     = "allow"
    cidr_block = var.aws_network_cidr
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name        = "${terraform.workspace} network acl"
    Environment = terraform.workspace
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${terraform.workspace} internet gw terraform generated"
    Environment = terraform.workspace
  }
}

resource "aws_route_table" "internet" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${terraform.workspace} Internet"
    Environment = terraform.workspace
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.gw.id
  }

  lifecycle {
    ignore_changes = [tags.Name]
  }
}

resource "aws_subnet" "vpc_subnet" {
  cidr_block                      = var.aws_subnet_cidr
  vpc_id                          = aws_vpc.vpc.id
  map_public_ip_on_launch         = true

  availability_zone = var.aws_zone

  tags = {
    Name        = "${terraform.workspace}-subnet"
    Environment = terraform.workspace
  }
}

resource "aws_route_table_association" "public_routing_table" {
  subnet_id      = aws_subnet.vpc_subnet.id
  route_table_id = aws_route_table.internet.id
}
