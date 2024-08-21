resource "aws_sns_topic" "whatsapp_sms_topic" {
  name = "${var.project}-sns-sms-topic"
}

resource "aws_sns_topic_subscription" "whatsapp_email_subscription" {
  topic_arn = aws_sns_topic.whatsapp_sms_topic.arn
  protocol  = "email"
  endpoint  = var.email
}

# resource "aws_sns_topic_subscription" "whatsapp_sms_subscription" {
#   topic_arn = aws_sns_topic.whatsapp_sms_topic.arn
#   protocol  = "sms"
#   endpoint  = var.number
# }
