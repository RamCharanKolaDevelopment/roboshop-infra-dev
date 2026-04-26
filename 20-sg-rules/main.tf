# Bastion
resource "aws_security_group_rule" "bastion_internet" { # bastion allowing traffic or requests from internet
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]  # This will accept traffice from any IP address, my_ip will be changed every day so that this will helps to accept traffic but my_ip is best practice
  # cidr_blocks = [local.my_ip] # using this would be best practice
  # which SG you are creating this rule
  security_group_id = local.bastion_sg_id
}

# MongoDB 
resource "aws_security_group_rule" "mongodb_bastion" { # mongodb allowing traffic or requests from bastion
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.bastion_sg_id  
  security_group_id = local.mongodb_sg_id
}

resource "aws_security_group_rule" "mongodb_catalogue" { # mongodb allowing traffic or requests from catalogue
  type = "ingress"
  from_port = 27017
  to_port = 27017
  protocol = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.catalogue_sg_id
  security_group_id = local.mongodb_sg_id
}

resource "aws_security_group_rule" "mongodb_user" { # mongodb allowing traffic or requests from user
  type = "ingress"
  from_port = 27017
  to_port = 27017
  protocol = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.user_sg_id
  security_group_id = local.mongodb_sg_id
}

# Redis
resource "aws_security_group_rule" "redis_bastion" { # redis allowing traffic or requests from bastion
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.bastion_sg_id
  security_group_id = local.redis_sg_id
}

resource "aws_security_group_rule" "redis_user" { # redis allowing traffic or requests from user
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.user_sg_id
  security_group_id = local.redis_sg_id
}

resource "aws_security_group_rule" "redis_cart" { # redis allowing traffic or requests from cart
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.cart_sg_id
  security_group_id = local.redis_sg_id
}

# MySQL
resource "aws_security_group_rule" "mysql_bastion" { # mysql allowing traffic or requests from bastion
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.bastion_sg_id
  security_group_id = local.mysql_sg_id
}

resource "aws_security_group_rule" "mysql_shipping" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.shipping_sg_id
  security_group_id = local.mysql_sg_id
}

# RabbitMQ
resource "aws_security_group_rule" "rabbitmq_bastion" { # rabbitmq allowing traffic or requests from bastion
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.bastion_sg_id
  security_group_id = local.rabbitmq_sg_id
}

resource "aws_security_group_rule" "rabbitmq_payment" { # rabbitmq allowing traffic or requests from payment
  type              = "ingress"
  from_port         = 5672
  to_port           = 5672
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.payment_sg_id
  security_group_id = local.rabbitmq_sg_id
}

# Catalogue
resource "aws_security_group_rule" "catalogue_bastion" { # catalogue allowing traffic or requests from bastion
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.bastion_sg_id
  security_group_id = local.catalogue_sg_id
}

resource "aws_security_group_rule" "catalogue_backend_alb" { # catalogue allowing traffic or requests from backend_alb
  type = "ingress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.backend_alb_sg_id
  security_group_id = local.catalogue_sg_id
}

# User
resource "aws_security_group_rule" "user_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.bastion_sg_id
  security_group_id = local.user_sg_id
}

resource "aws_security_group_rule" "user_backend_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.backend_alb_sg_id
  security_group_id = local.user_sg_id
}

# Cart
resource "aws_security_group_rule" "cart_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.bastion_sg_id
  security_group_id = local.cart_sg_id
}

resource "aws_security_group_rule" "cart_backend_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.backend_alb_sg_id
  security_group_id = local.cart_sg_id
}

# Shipping
resource "aws_security_group_rule" "shipping_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.bastion_sg_id
  security_group_id = local.shipping_sg_id
}

resource "aws_security_group_rule" "shipping_backend_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.backend_alb_sg_id
  security_group_id = local.shipping_sg_id
}

# Payment
resource "aws_security_group_rule" "payment_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.bastion_sg_id
  security_group_id = local.payment_sg_id
}

resource "aws_security_group_rule" "payment_backend_alb" { 
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.backend_alb_sg_id
  security_group_id = local.payment_sg_id
}

# Backend ALB
resource "aws_security_group_rule" "backend_alb_bastion" { # backend_alb allowing traffic or requests from bastion
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.bastion_sg_id
  security_group_id = local.backend_alb_sg_id
}

resource "aws_security_group_rule" "backend_alb_catalogue" { # catalogue allowing traffic or requests from backend_alb
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.catalogue_sg_id
  security_group_id = local.backend_alb_sg_id
}

resource "aws_security_group_rule" "backend_alb_user" { # user allowing traffic or requests from backend_alb
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.user_sg_id
  security_group_id = local.backend_alb_sg_id
}

resource "aws_security_group_rule" "backend_alb_cart" { # cart allowing traffic or requests from backend_alb
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.cart_sg_id
  security_group_id = local.backend_alb_sg_id
}

resource "aws_security_group_rule" "backend_alb_shipping" { # shipping allowing traffic or requests from backend_alb
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.shipping_sg_id
  security_group_id = local.backend_alb_sg_id
}

resource "aws_security_group_rule" "backend_alb_payment" { # payment allowing traffic or requests from backend_alb
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.payment_sg_id
  security_group_id = local.backend_alb_sg_id
}

resource "aws_security_group_rule" "backend_alb_frontend" { # backend_alb allowing traffic or requests from frontend
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.frontend_sg_id
  security_group_id = local.backend_alb_sg_id
}

# Frontend
resource "aws_security_group_rule" "frontend_bastion" { # frontend allowing traffic or requests from bastion
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.bastion_sg_id
  security_group_id = local.frontend_sg_id
}

resource "aws_security_group_rule" "frontend_frontend_alb" { # frontend allowing traffic or requests from frontend_alb
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.frontend_alb_sg_id
  security_group_id = local.frontend_sg_id
}

# Frontend ALB
resource "aws_security_group_rule" "frontend_alb_public" { # frontend_alb allowing traffic or requests from public
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  # Where traffic is coming from
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = local.frontend_alb_sg_id
}

# Open VPN
resource "aws_security_group_rule" "openvpn_public_443" { # OpenVPN allowing traffic or requests from public through port number 443
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  # Where traffic is coming from
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = local.openvpn_sg_id
}

# Admin UI
resource "aws_security_group_rule" "openvpn_public_943" { # OpenVPN allowing traffic or requests from OpenVPN Client through port number 943
  type              = "ingress"
  from_port         = 943
  to_port           = 943
  protocol          = "tcp"
  # Where traffic is coming from
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = local.openvpn_sg_id
}

resource "aws_security_group_rule" "backend_alb_openvpn" { # Backend ALB allowing traffic or requests from OpenVPN
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.openvpn_sg_id
  security_group_id = local.backend_alb_sg_id
}