# output "public_ip"{
#     description = "public of ${terraform.workspace}"
#     value = aws_instance.test.public_ip
# }

output "vpc_id"{
    description = "VPC Id"
    value = aws_vpc.dev_vpc.id
}
output "lb_dns"{
    description = "Load Balancer DNS "
    value = aws_lb.application_lb.dns_name
}