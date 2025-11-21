resource "aws_sqs_queue" "images_dlq" {
  name = "images-dlq"
}

resource "aws_sqs_queue" "images_processing" {
  name = "images-processing"

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.images_dlq.arn
    maxReceiveCount     = 5
  })
}
