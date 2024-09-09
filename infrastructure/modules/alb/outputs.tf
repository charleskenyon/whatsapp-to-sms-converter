output "alb_url" {
  value = "http://${aws_alb.whatsapp_converter_alb.dns_name}"
}
