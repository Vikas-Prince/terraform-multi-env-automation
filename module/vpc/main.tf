resource "aws_vpc" "my_vpc"{
    cidr_block = var.vpc_cidr_block
    instance_tenancy = "default"

    tags = {
        Name = var.vpc_name
    }
}

resource "aws_subnet" "public_subnet"{
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = var.public_subnet
    availability_zone = var.subnet_zone
    tags = {
        Name = var.public_subnet_name
    }
}

resource "aws_subnet" "private_subnet"{
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = var.private_subnet
    availability_zone = var.subnet_zone

    tags = {
        Name = var.private_subnet_name
    }
}

resource "aws_internet_gateway" "my_gateway"{
    vpc_id = aws_vpc.my_vpc.id

    tags  = {
        Name= var.igw_name
    }
}

resource "aws_route_table" "public_route_table"{
    vpc_id = aws_vpc.my_vpc.id
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_gateway.id
    }

    tags = {
        Name = var.public_route_table
    }
}

resource "aws_route_table_association" "route_association"{
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_route_table.id
}

resource "aws_eip" "elastic_ip"{
    domain = "vpc"

    tags = {
        Name = var.elastic_ip
    }
}

resource "aws_nat_gateway" "private_gateway"{
    allocation_id = aws_eip.elastic_ip.id
    subnet_id = aws_subnet.public_subnet.id

    tags = {
        Name = var.NAT_gateway
    }
}

resource "aws_route_table"  "private_route_table" {
    vpc_id =  aws_vpc.my_vpc.id

    route{
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.private_gateway.id
    }

    tags = {
        Name = var.private_route_table
    }
}

resource "aws_route_table_association" "private_route_association"{
    subnet_id = aws_subnet.private_subnet.id
    route_table_id =  aws_route_table.private_route_table.id
}



