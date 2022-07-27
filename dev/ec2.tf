# resource "aws_instance" "prd-front-pub-2a" {
#   ami           = data.aws_ami.amzn2.id
#   instance_type = "t2.micro"
#   availability_zone = "${var.aws_region}c"

#   subnet_id = aws_subnet.sec-pub-2c.id
#   key_name = "${var.appliance_bastion_key}"
#   associate_public_ip_address = true

#   security_groups = [aws_security_group.sec-bastion-sg.id]
  
#   lifecycle {
#     ignore_changes = all

#   }
#   tags = {
#     "TerraformManaged" = "true",
#     "Environment"      = "dev"
#   }
# }