output "instance_id" {
  value = aws_instance.server.id
}

output "public_ip" {
  value = aws_eip.web.public_ip
}

output "ssh_command" {
  value = "ssh ubuntu@${aws_eip.web.public_ip}"
}
