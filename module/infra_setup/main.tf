resource "aws_vpc" "dev_vpc"{
    cidr_block = var.vpc_cidr_block
    instance_tenancy = var.instance_tenancy

    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = var.vpc_name
    }
}

resource "aws_subnet" "public_subnet_1"{
    vpc_id = aws_vpc.dev_vpc.id
    cidr_block = var.public_subnet_1_cidr
    availability_zone = var.availability_zone_1
    tags = {
        Name = "public subnet"
    }
}

resource "aws_subnet" "public_subnet_2"{
    vpc_id = aws_vpc.dev_vpc.id
    cidr_block = var.public_subnet_2_cidr
    availability_zone = var.availability_zone_2
    tags = {
        Name = "public subnet"
    }
}

resource "aws_subnet" "private_subnet"{
    vpc_id = aws_vpc.dev_vpc.id
    cidr_block = var.private_subnet_cidr
    availability_zone = var.private_subnet_az

    tags = {
        Name = "private subnet"
    }
}

resource "aws_internet_gateway" "web_igw"{
    vpc_id = aws_vpc.dev_vpc.id

    tags = {
        Name = "web-igw"
    }
}

resource "aws_route_table" "public_route_table"{
    vpc_id = aws_vpc.dev_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.web_igw.id
    }
}

resource "aws_route_table" "public_route_table2"{
    vpc_id = aws_vpc.dev_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.web_igw.id
    }
}

resource "aws_route_table_association" "public_route_association"{
    subnet_id = aws_subnet.public_subnet_1.id
    route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_route_association2"{
    subnet_id = aws_subnet.public_subnet_2.id
    route_table_id = aws_route_table.public_route_table2.id
}

resource "aws_eip" "web_elastic_ip"{
    domain = "vpc"

    tags = {
        Name = "web_elastic_ip"
    }
}

resource "aws_nat_gateway" "web_nat"{
    allocation_id = aws_eip.web_elastic_ip.id
    subnet_id = aws_subnet.public_subnet_1.id

    tags = {
        Name = "web_nat"
    }
}

resource "aws_route_table" "private_route_table"{
    vpc_id = aws_vpc.dev_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.web_nat.id
    }
}

resource "aws_route_table_association" "private_route_association" {
    subnet_id = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.private_route_table.id
}

resource "aws_security_group" "alb_security_group"{
    name = "lb-sg"
    description = "Load Balancer Security group"
    vpc_id = aws_vpc.dev_vpc.id

    ingress{
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "ec2_sg"{
    name = "ec2-sg"
    description = "EC2 Security Group"
    vpc_id = aws_vpc.dev_vpc.id

    ingress{
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [aws_security_group.alb_security_group.id]
    }

    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


data "aws_s3_bucket" "bucket" {
    bucket = var.bucket_name
}

resource "aws_lb" "application_lb"{
    name = "app-loadbalancer"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.alb_security_group.id]
    subnets = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

    enable_cross_zone_load_balancing = true
    enable_deletion_protection = false

    access_logs {
      bucket = data.aws_s3_bucket.bucket.id
      prefix = var.access_logs_bucket_prefix
      enabled = true
    }
}

resource "aws_lb_target_group" "lb_tgp"{
    name = "instance-target-group"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.dev_vpc.id

    health_check {
    interval            = 30
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_alb_listener" "alb_listener"{
    load_balancer_arn = aws_lb.application_lb.arn
    port = 80
    protocol = "HTTP"

    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.lb_tgp.arn
      
    }
}


resource "aws_launch_template" "auto_scale_conf"{
    name = "ASG-Launch-temlate"
    image_id = var.ami_id
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.ec2_sg.id]
    user_data = base64encode("#!/bin/bash\nsudo yum update -y\nsudo yum install httpd -y\nsudo systemctl start httpd\nsudo systemctl enable httpd")
    
    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "auto_scale_group"{
    name = "ASG-Group"
    # availability_zones = ["ap-south-1a"]
    vpc_zone_identifier = [aws_subnet.private_subnet.id]
    desired_capacity = var.desired_capacity
    min_size = var.min_size
    max_size = var.max_size
    launch_template {
      id = aws_launch_template.auto_scale_conf.id
      version = "$Latest"
    }

    target_group_arns = [aws_lb_target_group.lb_tgp.arn]
    
}