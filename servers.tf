resource "aws_key_pair" "keypair" {
  key_name = "sshkey-${terraform.workspace}"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAtfWGk8lSEIbwvXSBvK8osch/eU7Uwdq5GsXOihKM5OsxN0VTrmVYro/eL/2fwdTlbgOxYF8bMlgY8EA/IngzxwmMfUpTk2mZ1p6+ScgQI6EVOM4YVvNEcaI2ZvXhnJxm21XQX1Aeh4EwcXac/e6FyT/f32TG+V5eQdE+VhE7iIVxCF/wCUBPDcRnRsbohNRDcaJ8kIM6+rflwU5XozaAOIow8Y/kDDzKZVEBK9LulY9HskLaiuxxI72XW5DnAzoAcbkmw3df9Ve21qFtXY6+ClKfnc2pL+HnrgjPtWa6P/gghEByXsDVFCARu69g3CYrweCsDrSgWU50EsvthxSdZQ== octo-mro@octo-mro-laptop"
}

resource "aws_instance" "front" {
  ami                    = var.ubuntu_ami
  subnet_id              = aws_subnet.vpc_subnet.id
  instance_type          = "t2.medium"
  vpc_security_group_ids =  [
                              aws_security_group.internal_allow_all.id,
                              aws_security_group.https_http_security_group.id,
                              aws_security_group.ssh.id
                            ]
  key_name               = aws_key_pair.keypair.key_name

  root_block_device {
    volume_size = 24
  }

  tags = {
    Name        = format("front01-%s", terraform.workspace)
    Environment = terraform.workspace
    Role        = "Front"
    Provider    = "aws"
  }
}

resource "aws_instance" "app" {
  ami                    = var.ubuntu_ami
  subnet_id              = aws_subnet.vpc_subnet.id
  instance_type          = "t2.medium"
  vpc_security_group_ids =  [
                              aws_security_group.internal_allow_all.id,
                              aws_security_group.ssh.id
                            ]
  key_name               = aws_key_pair.keypair.key_name

  root_block_device {
    volume_size = 24
  }

  tags = {
    Name        = format("app01-%s", terraform.workspace)
    Environment = terraform.workspace
    Role        = "App"
    Provider    = "aws"
  }
}

resource "aws_instance" "bdd" {
  ami                    = var.ubuntu_ami
  subnet_id              = aws_subnet.vpc_subnet.id
  instance_type          = "t2.medium"
  vpc_security_group_ids =  [
                              aws_security_group.internal_allow_all.id,
                              aws_security_group.ssh.id
                            ]
  key_name               = aws_key_pair.keypair.key_name

  root_block_device {
    volume_size = 24
  }

  tags = {
    Name        = format("bdd01-%s", terraform.workspace)
    Environment = terraform.workspace
    Role        = "Bdd"
    Provider    = "aws"
  }
}
