variable "region"{
    description = "AWS region"
    type = string
    default = "ap-south-1"
}

variable "vpc_cidr_block"{
    description = "VPC CIDR range its a large pool for all resources that are launched in this vpc"
    type = string
    default = "10.0.0.0/16"
}

variable "vpc_name"{
    description = "Name of the VPC According to Environment"
    type = string
    default = "dev_vpc"
}

variable "public_subnet"{
    description = "Range of public subnet"
    type = string
    default = "10.0.1.0/24"
}

variable "public_subnet_name"{
    description = "Name of the public subnet"
    type = string
    default = "public_subnet"
}

variable "private_subnet"{
    description = "Range of public subnet"
    type = string
    default = "10.0.2.0/24"
}

variable "private_subnet_name"{
    description = "Name of the public subnet"
    type = string
    default = "private_subnet"
}

variable "subnet_zone"{
    description = "Name of the Zone"
    type = string
    default = "ap-south-1a"
}
variable "igw_name"{
    description = "Name of the internet Gateway "
    type = string
    default = "My_gateway"
}

variable "public_route_table"{
    description = "Name of the public route table"
    type = string
    default = "public_route_table"
}

variable "elastic_ip" {
    description = "Name of the Elastic IP for NAT Gateway"
    type = string
    default = "my_eip"
}

variable "NAT_gateway" {
    description = "Name of the NAT Gateway"
    type = string
    default = "my_natgateway"
}

variable "private_route_table"{
    description = " Name of the private route table"
    type = string
    default = "private_route_table"
}