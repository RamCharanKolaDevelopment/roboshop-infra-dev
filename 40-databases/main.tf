resource "aws_instance" "mongodb" {
  ami = local.ami_id
  instance_type = "t3.micro"
  subnet_id = local.database_subnet_id
  vpc_security_group_ids = [local.mongodb_sg_id]

  tags = merge(
    {
        Name = "${var.project}-${var.environment}-mongodb"
    },
    local.common_tags
  )
}

resource "terraform_data" "mongodb" {
  triggers_replace = [
    aws_instance.mongodb.id
  ]

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.mongodb.private_ip
  }

  provisioner "file" { # this file provisioner copy bootstrap.sh file to /tmp/bootstrap.sh destination inside mongodb ec2 instance server
    source      = "bootstrap.sh" # Local file path
    destination = "/tmp/bootstrap.sh"    # Destination path on the remote machine
  }

  provisioner "remote-exec" {
    inline = [ 
        "chmod +x /tmp/bootstrap.sh",
        "sudo sh /tmp/bootstrap.sh mongodb ${var.environment}" # to execute bootstrap.sh with mongodb argument
     ]
  }
}

resource "aws_instance" "redis" {
  ami = local.ami_id
  instance_type = "t3.micro"
  subnet_id = local.database_subnet_id
  vpc_security_group_ids = [ local.redis_sg_id ]

  tags = merge(
    {
        Name = "${var.project}-${var.environment}-redis"
    },
    local.common_tags
  )
}

resource "terraform_data" "bootstrap_redis" {
  triggers_replace = [
    aws_instance.redis.id
  ]

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.redis.private_ip
  }

  provisioner "file" {
    source      = "bootstrap.sh" # Local file path
    destination = "/tmp/bootstrap.sh"    # Destination path on the remote machine
  }

  provisioner "remote-exec" {
    inline = [ 
        "chmod +x /tmp/bootstrap.sh", # chmod is to change mode, +xis used alog with chmod to provide execution permission to a file
        "sudo sh /tmp/bootstrap.sh redis ${var.environment}" # to execute bootstrap.sh with redis argument
     ]
  }
}

resource "aws_instance" "mysql" {
  ami = local.ami_id
  instance_type = "t3.micro"
  subnet_id = local.database_subnet_id
  vpc_security_group_ids = [ local.mysql_sg_id ]
  iam_instance_profile = aws_iam_instance_profile.mysql.name # What is the use of this line of code ?

  tags = merge(
    {
        Name = "${var.project}-${var.environment}-mysql"
    },
    local.common_tags
  )
}

resource "terraform_data" "mysql" {
  triggers_replace = [
    aws_instance.mysql.id
  ]

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.mysql.private_ip
  }

  provisioner "file" {
    source      = "bootstrap.sh" # Local file path
    destination = "/tmp/bootstrap.sh"    # Destination path on the remote machine
  }

  provisioner "remote-exec" {
    inline = [ 
        "chmod +x /tmp/bootstrap.sh", # chmod is to change mode, +xis used alog with chmod to provide execution permission to a file
        "sudo sh /tmp/bootstrap.sh mysql ${var.environment}" # to execute bootstrap.sh with mysql argument
     ]
  }
}

resource "aws_instance" "rabbitmq" {
  ami = local.ami_id
  instance_type = "t3.micro"
  subnet_id = local.database_subnet_id
  vpc_security_group_ids = [ local.rabbitmq_sg_id ]

  tags = merge(
    {
        Name = "${var.project}-${var.environment}-rabbitmq"
    },
    local.common_tags
  )
}

resource "terraform_data" "rabbitmq" {
  triggers_replace = [
    aws_instance.rabbitmq.id
  ]

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.rabbitmq.private_ip
  }

  provisioner "file" {
    source      = "bootstrap.sh" # Local file path
    destination = "/tmp/bootstrap.sh"    # Destination path on the remote machine
  }

  provisioner "remote-exec" {
    inline = [ 
        "chmod +x /tmp/bootstrap.sh", # chmod is to change mode, +xis used alog with chmod to provide execution permission to a file
        "sudo sh /tmp/bootstrap.sh rabbitmq ${var.environment}" # to execute bootstrap.sh with rabbitmq argument
     ]
  }
}