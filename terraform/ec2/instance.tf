data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "key" {
  key_name   = "key"
  public_key = file("./desafiodevios.pem.pub")
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.this.id]

  key_name                    = aws_key_pair.key.key_name

  tags = merge(
    var.aws_common_tags,
    {
      Misson = "Desafio-DevOps"
    }
  )
}


