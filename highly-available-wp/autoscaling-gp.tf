
## Create Data Resource to Bootstrap Wordpress Application Instances
/*
data "template_file" "user_data" {
  template = "${file("user-data-wp-instance.tpl")}"
}
*/
# Launch Template Resource
resource "aws_launch_template" "wp-app-inst-lt" {
  name = "wp-app-inst-lt"
  description = "WordPress App Launch Template"
  image_id = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.instances-sg.id, aws_security_group.bastion-sg.id]
  key_name = var.instance_keypair  
  user_data = file("user-data-wp-instance.sh")
}


# Autoscaling Group For WordPress App Instace
resource "aws_autoscaling_group" "wp-asg" {
  name_prefix = "wp-asg"
  desired_capacity   = 3
  max_size           = 9
  min_size           = 3
  launch_template {
    id      = aws_launch_template.wp-app-inst-lt.id
    version = aws_launch_template.wp-app-inst-lt.latest_version
  }
  vpc_zone_identifier  = [for subnet in aws_subnet.nacent-private-subnet : subnet.id]
  target_group_arns = [aws_lb_target_group.nacent-wp-tg.arn]
  health_check_type = "ELB"
  health_check_grace_period = 300   
}







