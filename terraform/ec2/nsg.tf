data "aws_vpc" "default" {
  default = true
}


# Aqui eu tento pegar o meu ip usando o provider http.
data "http" "my_ip" {
  url = "https://ifconfig.me/ip"
}

locals {
  my_ip_with_cidr = "${trimspace(data.http.my_ip.response_body)}/32"
}



resource "aws_security_group" "this" {
  name        = "nsg-ec2"
  description = "Allow HTTP and HTTPS inbound traffic and all outbound traffic"
  vpc_id      = data.aws_vpc.default.id

  # Aqui eu permito o trafego de saída
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    var.aws_common_tags,
    {
        Name = "allow_http_https"
    }
  )
}

resource "aws_security_group_rule" "allow_http_ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.this.id
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/24"]
}

resource "aws_security_group_rule" "allow_https_ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.this.id
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/24"]
}


resource "aws_security_group_rule" "allow_my_ip" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [local.my_ip_with_cidr]
  security_group_id = aws_security_group.this.id
}