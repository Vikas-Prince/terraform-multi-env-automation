# resource "aws_vpc" "EKS-Vpc"{
#     cidr_block = "10.0.0.0/16"
#     instance_tenancy = "default"

#     tags = {
#         Name = "Eks-VPC"
#     }
# }

# Fetching the existing VPC using its ID
data "aws_vpc" "EKS-Vpc"{
    id = var.vpc_id
}

# Creating public subnet 1a in the VPC
resource "aws_subnet" "eks-public-subnet-1a"{
    vpc_id = data.aws_vpc.EKS-Vpc.id
    cidr_block = var.eks_public_subnet_1
    map_public_ip_on_launch = true
    availability_zone = var.eks_public_subnet_1_region

    tags = {
        Name = var.eks_public_subnet_name_1
    }
}

# Creating public subnet 1b in the VPC
resource "aws_subnet" "eks-public-subnet-1b"{
    vpc_id = data.aws_vpc.EKS-Vpc.id
    cidr_block = var.eks_public_subnet_2
    map_public_ip_on_launch = true
    availability_zone = var.eks_public_subnet_2_region

    tags= {
        Name = var.eks_public_subnet_name_2
    }
}

# Creating private subnet 1a for worker nodes
resource "aws_subnet" "worker-private-subnet-1a"{
    vpc_id = data.aws_vpc.EKS-Vpc.id
    cidr_block = var.eks_private_subnet_1
    availability_zone = var.eks_private_subnet_1_region

    tags = {
        Name = var.eks_private_subnet_name_1
    }
}

# Creating private subnet 1b for worker nodes
resource "aws_subnet" "worker-private-subnet-1b"{
    vpc_id = data.aws_vpc.EKS-Vpc.id
    cidr_block = var.eks_private_subnet_2
    availability_zone = var.eks_private_subnet_2_region

    tags = {
        Name = var.eks_private_subnet_name_2
    }
}

# Creating private subnet 1c for worker nodes
resource "aws_subnet" "worker-private-subnet-1c"{
    vpc_id = data.aws_vpc.EKS-Vpc.id
    cidr_block = var.eks_private_subnet_3
    availability_zone = var.eks_private_subnet_3_region

    tags ={
        Name = var.eks_private_subnet_name_3
    }
}

# Creating an Internet Gateway for EKS VPC
resource "aws_internet_gateway" "eks-internet-gateway"{
    vpc_id = data.aws_vpc.EKS-Vpc.id
    
    tags = {
        Name = var.eks_igw_name
    }
}

# Creating a route table to route traffic through the Internet Gateway
resource "aws_route_table" "eks-route-table"{
    vpc_id = data.aws_vpc.EKS-Vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.eks-internet-gateway.id
    }
}

# Associating public subnet 1a with the route table
resource "aws_route_table_association" "routes"{
    subnet_id = aws_subnet.eks-public-subnet-1a.id
    route_table_id = aws_route_table.eks-route-table.id
}

# Associating public subnet 1b with the route table
resource "aws_route_table_association" "routes1"{
    subnet_id = aws_subnet.eks-public-subnet-1b.id
    route_table_id = aws_route_table.eks-route-table.id
}

# Creating an Elastic IP for the NAT Gateway
resource "aws_eip" "eks-elastic_ip"{
    domain = "vpc"

    tags = {
        Name = var.elastic_ip_name
    }
}

# Creating NAT Gateway in public subnet 1a
resource "aws_nat_gateway" "worker-nat-gateway"{
    allocation_id = aws_eip.eks-elastic_ip.id
    subnet_id = aws_subnet.eks-public-subnet-1a.id

    tags = {
        Name = var.eks_nat_gateway_name
    }
}

# Creating a route table for private subnets to use the NAT Gateway
resource "aws_route_table" "worker-private-route"{
    vpc_id = data.aws_vpc.EKS-Vpc.id

    route{
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.worker-nat-gateway.id
    }
}

# Associating private subnet 1a with the private route table
resource "aws_route_table_association" "worker-routes1"{
    subnet_id = aws_subnet.worker-private-subnet-1a.id
    route_table_id = aws_route_table.worker-private-route.id
}

# Associating private subnet 1b with the private route table
resource "aws_route_table_association" "worker-routes2"{
    subnet_id = aws_subnet.worker-private-subnet-1b.id
    route_table_id = aws_route_table.worker-private-route.id
}

# Associating private subnet 1c with the private route table
resource "aws_route_table_association" "worker-routes3"{
    subnet_id = aws_subnet.worker-private-subnet-1c.id
    route_table_id = aws_route_table.worker-private-route.id
}

# Creating an IAM role for the EKS control plane
resource "aws_iam_role" "eks-cluster-role-test" {
  name = "eks-cluster-role-new"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      }
    ]
  })

  tags = {
    tag-key = "Eks-cluster-role"
  }
}

# Attaching AmazonEKSClusterPolicy to the EKS cluster role
resource "aws_iam_role_policy_attachment" "eks-role-policy"{
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role = aws_iam_role.eks-cluster-role-test.name
}

# Creating EKS Cluster control plane with VPC configuration
resource "aws_eks_cluster" "eks-control-plane"{
    name = var.eks_cluster_name
    role_arn = aws_iam_role.eks-cluster-role-test.arn

    vpc_config{
        subnet_ids = [
            aws_subnet.eks-public-subnet-1a.id,
            aws_subnet.eks-public-subnet-1b.id,
        ]
    }

    depends_on = [ aws_iam_role_policy_attachment.eks-role-policy ]
}

# Creating IAM role for EKS worker nodes
resource "aws_iam_role" "eks-worker-role"{
    name = "eks-worker-role"

    assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
      },
    ]
    })
}

# Attaching policies to the EKS worker role
resource "aws_iam_role_policy_attachment" "eks-worker-policy"{
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role = aws_iam_role.eks-worker-role.name
}

# Attaching AmazonEC2ContainerRegistryReadOnly policy to the worker role
resource "aws_iam_role_policy_attachment" "eks-ec2-container-policy"{
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role = aws_iam_role.eks-worker-role.name
}

# Attaching AmazonEKS_CNI_Policy to the worker role
resource "aws_iam_role_policy_attachment" "eks-worker-cni-policy"{
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role = aws_iam_role.eks-worker-role.name
}

# Creating EKS Node Group with worker node instances
resource "aws_eks_node_group" "eks-node-group"{
    cluster_name    = aws_eks_cluster.eks-control-plane.name
    node_group_name = var.worker_nodes_name
    node_role_arn = aws_iam_role.eks-worker-role.arn
    subnet_ids = [
        aws_subnet.worker-private-subnet-1a.id,
        aws_subnet.worker-private-subnet-1b.id,
        aws_subnet.worker-private-subnet-1c.id
    ]

    instance_types = [var.worker_instance_type]

    tags = {
        Name = var.worker_nodes_name
    }
    scaling_config {
      desired_size = 2
      max_size = 6
      min_size = 1
    }
    update_config {
      max_unavailable = 1
    }

    depends_on = [ 
        aws_iam_role_policy_attachment.eks-worker-policy,
        aws_iam_role_policy_attachment.eks-ec2-container-policy,
        aws_iam_role_policy_attachment.eks-worker-cni-policy
     ]
}
