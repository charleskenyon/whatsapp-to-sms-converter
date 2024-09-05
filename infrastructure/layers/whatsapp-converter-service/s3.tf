resource "aws_s3_bucket" "whatsapp_media_bucket" {
  bucket = "${var.project}-media"
}

resource "aws_s3_bucket_lifecycle_configuration" "whatsapp_media_bucket_lifecycle_rule" {
  bucket = aws_s3_bucket.whatsapp_media_bucket.bucket

  rule {
    id     = "DeleteOldObjects"
    status = "Enabled"

    expiration {
      days = 1
    }
  }
}

# resource "aws_s3_bucket_policy" "whatsapp_media_bucket_policy" {
#   bucket = aws_s3_bucket.whatsapp_media_bucket.id
#   policy = data.aws_iam_policy_document.whatsapp_media_bucket_policy_document.json
# }

# data "aws_iam_policy_document" "whatsapp_media_bucket_policy_document" {
#   statement {
#     actions = ["s3:PutObject"]

#     principals {
#       type        = "AWS"
#       identifiers = [aws_iam_role.whatsapp_converter_task_role.arn]
#     }

#     resources = [
#       "${aws_s3_bucket.whatsapp_media_bucket.arn}",
#       "${aws_s3_bucket.whatsapp_media_bucket.arn}/*"
#     ]
#   }
# }
