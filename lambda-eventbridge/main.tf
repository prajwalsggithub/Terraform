# -------------------------------------------------------------
# PROVIDER CONFIGURATION
# -------------------------------------------------------------
provider "aws" {
  region = "ap-south-1"  # Change if needed
}

# -------------------------------------------------------------
# IAM ROLE for Lambda
# -------------------------------------------------------------
resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_roless"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# -------------------------------------------------------------
# ATTACH POLICIES
# -------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "lambda_logging" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# -------------------------------------------------------------
# LAMBDA FUNCTION (from local zip)
# -------------------------------------------------------------
resource "aws_lambda_function" "lambda_function" {
  function_name = "eventbridge-lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.13"

  filename         = "lambda_function1.zip"
  source_code_hash = filebase64sha256("lambda_function1.zip")

  memory_size = 128
  timeout     = 60
}

# -------------------------------------------------------------
# EVENTBRIDGE (CloudWatch Event Rule)
# -------------------------------------------------------------
resource "aws_cloudwatch_event_rule" "lambda_schedule" {
  name                = "lambda-schedule-1min"
  description         = "Trigger Lambda every 1 minute"
  schedule_expression = "rate(1 minute)"
}

# -------------------------------------------------------------
# EVENTBRIDGE TARGET
# -------------------------------------------------------------
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.lambda_schedule.name
  target_id = "lambda-target"
  arn       = aws_lambda_function.lambda_function.arn
}

# -------------------------------------------------------------
# LAMBDA PERMISSION (Allow EventBridge to invoke)
# -------------------------------------------------------------
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_schedule.arn
}
