
variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "Name of the VPC."
  type        = string
  default     = "dev-vpc"
}

variable "instance_tenancy" {
  description = "The tenancy of instances launched in the VPC."
  type        = string
  default     = "default"
}

variable "availability_zone_1" {
  description = "The availability zone for the first public subnet."
  type        = string
  default     = "ap-south-1a"
}

variable "availability_zone_2" {
  description = "The availability zone for the second public subnet."
  type        = string
  default     = "ap-south-1b"
}

variable "private_subnet_az" {
  description = "The availability zone for the private subnet."
  type        = string
  default     = "ap-south-1a"
}

variable "public_subnet_1_cidr" {
  description = "The CIDR block for the first public subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "The CIDR block for the second public subnet."
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_cidr" {
  description = "The CIDR block for the private subnet."
  type        = string
  default     = "10.0.3.0/24"
}

variable "bucket_name" {
  description = "The name of the S3 bucket for logging."
  type        = string
  default     = "vikas-multi-env-bucket"
}

variable "ami_id" {
  description = "The AMI ID to use for launching EC2 instances."
  type        = string
  default     = "ami-05c179eced2eb9b5b"
}

variable "instance_type" {
  description = "The instance type for EC2 instances."
  type        = string
  default     = "t2.micro"
}


variable "desired_capacity" {
  description = "The desired capacity for the Auto Scaling group."
  type        = number
  default     = 3
}

variable "min_size" {
  description = "The minimum size for the Auto Scaling group."
  type        = number
  default     = 2
}

variable "max_size" {
  description = "The maximum size for the Auto Scaling group."
  type        = number
  default     = 5
}

variable "access_logs_bucket_prefix" {
  description = "The S3 bucket prefix for load balancer access logs."
  type        = string
  default     = "lb_logs"
}
