# VPC ID to reference in environment
variable "vpc_id" {
  description = "The VPC ID to which the resources will be deployed. This should be a valid VPC ID in your AWS account."
  type        = string
  default     = "vpc-xxxxxx"  # Replace with your default VPC ID or leave empty to be passed as input
}

# Public Subnet 1 CIDR block for EKS Cluster
variable "eks_public_subnet_1" {
  description = "CIDR block for the first public subnet where EKS worker nodes will be deployed."
  type        = string
  default     = "10.0.1.0/24"
}

# Name of Public Subnet 1 (usually used for tagging)
variable "eks_public_subnet_name_1" {
  description = "Name of the first public subnet for the EKS Cluster. Used for identification and tagging purposes."
  type        = string
  default     = "eks-public-subnet-1"
}

# Availability Zone (Region) for Public Subnet 1
variable "eks_public_subnet_1_region" {
  description = "The AWS Availability Zone for the first public subnet."
  type        = string
  default     = "ap-south-1a"
}

# Public Subnet 2 CIDR block for EKS Cluster
variable "eks_public_subnet_2" {
  description = "CIDR block for the second public subnet where EKS worker nodes will be deployed."
  type        = string
  default     = "10.0.2.0/24"
}

# Name of Public Subnet 2 (usually used for tagging)
variable "eks_public_subnet_name_2" {
  description = "Name of the second public subnet for the EKS Cluster. Used for identification and tagging purposes."
  type        = string
  default     = "eks-public-subnet-2"
}

# Availability Zone (Region) for Public Subnet 2
variable "eks_public_subnet_2_region" {
  description = "The AWS Availability Zone for the second public subnet."
  type        = string
  default     = "ap-south-1b"
}

# Private Subnet 1 CIDR block for EKS Cluster
variable "eks_private_subnet_1" {
  description = "CIDR block for the first private subnet where EKS worker nodes and other internal services will be deployed."
  type        = string
  default     = "10.0.3.0/24"
}

# Name of Private Subnet 1 (usually used for tagging)
variable "eks_private_subnet_name_1" {
  description = "Name of the first private subnet for the EKS Cluster. Used for identification and tagging purposes."
  type        = string
  default     = "eks-private-subnet-1"
}

# Availability Zone (Region) for Private Subnet 1
variable "eks_private_subnet_1_region" {
  description = "The AWS Availability Zone (Region) for the first private subnet."
  type        = string
  default     = "ap-south-1a"
}

# Private Subnet 2 CIDR block for EKS Cluster
variable "eks_private_subnet_2" {
  description = "CIDR block for the second private subnet where EKS worker nodes and other internal services will be deployed."
  type        = string
  default     = "10.0.4.0/24"
}

# Name of Private Subnet 2 (usually used for tagging)
variable "eks_private_subnet_name_2" {
  description = "Name of the second private subnet for the EKS Cluster. Used for identification and tagging purposes."
  type        = string
  default     = "eks-private-subnet-2"
}

# Availability Zone (Region) for Private Subnet 2
variable "eks_private_subnet_2_region" {
  description = "The AWS Availability Zone  for the second private subnet."
  type        = string
  default     = "ap-south-1b"
}

# Private Subnet 3 CIDR block for EKS Cluster
variable "eks_private_subnet_3" {
  description = "CIDR block for the third private subnet where EKS worker nodes and other internal services will be deployed."
  type        = string
  default     = "10.0.5.0/24"
}

# Name of Private Subnet 3 (usually used for tagging)
variable "eks_private_subnet_name_3" {
  description = "Name of the third private subnet for the EKS Cluster. Used for identification and tagging purposes."
  type        = string
  default     = "eks-private-subnet-3"
}

# Availability Zone (Region) for Private Subnet 3
variable "eks_private_subnet_3_region" {
  description = "The AWS Availability Zone for the third private subnet."
  type        = string
  default     = "ap-south-1c"
}

# Name of the Internet Gateway (IGW) for the VPC
variable "eks_igw_name" {
  description = "The name to assign to the Internet Gateway (IGW) in the VPC. IGWs allow communication between instances in the VPC and the internet."
  type        = string
  default     = "eks-igw"
}

# Name of the Elastic IP to be created
variable "elastic_ip_name" {
  description = "The name to assign to the Elastic IP (EIP). EIP is typically used for NAT Gateway or other internet-facing resources."
  type        = string
  default     = "eks-elastic-ip"
}

# Name of the NAT Gateway for routing internet traffic to private subnets
variable "eks_nat_gateway_name" {
  description = "The name to assign to the NAT Gateway in the VPC. The NAT Gateway allows instances in private subnets to access the internet."
  type        = string
  default     = "eks-nat-gateway"
}

# Name of the EKS Cluster Control Plane
variable "eks_cluster_name" {
  description = "The name for the EKS Cluster control plane. This is the main entry point to your EKS Cluster."
  type        = string
  default     = "eks-cluster"
}

# Instance type for EKS Worker Nodes
variable "worker_instance_type" {
  description = "The EC2 instance type to use for the worker nodes in the EKS Node Group. Example: 't3.medium'."
  type        = string
  default     = "t2.micro"
}

# Name of the worker nodes in the EKS cluster
variable "worker_nodes_name" {
  description = "The name of the worker nodes in the EKS Node Group. Used for identification and tagging purposes."
  type        = string
  default     = "eks-worker-nodes"
}
