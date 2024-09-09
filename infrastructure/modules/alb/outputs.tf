output "alb_url" {
  value = "http://${aws_alb.whatsapp_converter_alb.dns_name}"
}

output "security_group_id" {
  value = aws_security_group.example_alb_security_group.id
}
