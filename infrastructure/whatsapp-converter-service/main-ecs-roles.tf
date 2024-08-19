resource "aws_iam_role" "whatsapp_converter_task_execution_role" {
  name               = "${var.project}-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role_policy_document.json
}

data "aws_iam_policy_document" "ecs_task_assume_role_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "ecs_task_execution_role_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.whatsapp_converter_task_execution_role.name
  policy_arn = data.aws_iam_policy.ecs_task_execution_role_policy.arn
}

resource "aws_iam_role" "whatsapp_converter_task_role" {
  name               = "${var.project}-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role_policy_document.json
}

resource "aws_iam_role_policy" "whatsapp_converter_task_role_policy" {
  name   = "${var.project}-task-role-policy"
  role   = aws_iam_role.whatsapp_converter_task_role.id
  policy = data.aws_iam_policy_document.whatsapp_converter_task_role_policy_document.json
}

data "aws_iam_policy_document" "whatsapp_converter_task_role_policy_document" {
  statement {
    actions = ["s3:PutObject"]
    resources = [
      "${aws_s3_bucket.whatsapp_media_bucket.arn}/*"
    ]
  }
}
