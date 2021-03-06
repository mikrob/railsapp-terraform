resource "aws_security_group" "internal_allow_all" {
  name        = "internal-allow-all"
  description = "Terraform Allow all inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  # we allow only IP from private network to input to every port on every protocol
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      var.aws_subnet_cidr,
    ]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port   = 0
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["::/0"]
  }

  # we allow all machine to output to every port on every protocol on all ips
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 0
    to_port          = -1
    protocol         = "icmp"
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Environment = terraform.workspace
    Name        = "Internal allow all for ${terraform.workspace}"
  }
}


resource "aws_security_group" "ssh" {
  name        = "ssh"
  description = "ssh"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 22
    to_port   = 22
    protocol  = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = terraform.workspace
    Name        = "Internal ssh for ${terraform.workspace}"
  }
}

resource "aws_security_group" "https_http_security_group" {
  name        = "https_http"
  description = "https_http"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = terraform.workspace
    Name        = "http/https for ${terraform.workspace}"
  }
}
