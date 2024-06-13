# # Create a VPC
# resource "aws_vpc" "example" {
#   cidr_block = "10.0.0.0/16"
# }

# # Create public subnets
# resource "aws_subnet" "public" {
#   count             = 2
#   vpc_id            = aws_vpc.example.id
#   cidr_block        = cidrsubnet(aws_vpc.example.cidr_block, 8, count.index)
#   map_public_ip_on_launch = true
#   availability_zone = element(["us-west-2a", "us-west-2b"], count.index)
# }

# # Create an Internet Gateway
# resource "aws_internet_gateway" "example" {
#   vpc_id = aws_vpc.example.id
# }

# # Create a route table
# resource "aws_route_table" "example" {
#   vpc_id = aws_vpc.example.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.example.id
#   }
# }

# # Associate route table with subnets
# resource "aws_route_table_association" "public" {
#   count          = 2
#   subnet_id      = element(aws_subnet.public.*.id, count.index)
#   route_table_id = aws_route_table.example.id
# }
