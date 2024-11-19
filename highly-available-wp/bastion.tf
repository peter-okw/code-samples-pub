## Create Bastion Host to Jump off to Private Subnet
resource "aws_instance" "jump-server" {
    for_each = aws_subnet.nacent-public-subnet

    ami = data.aws_ami.ubuntu.id
    instance_type = var.instance_type
    key_name = var.instance_keypair
    security_groups = [ aws_security_group.bastion-sg.id ]
    subnet_id = each.value.id
    tags = {
      Name = "Bastion Server${each.key}"
    }
}