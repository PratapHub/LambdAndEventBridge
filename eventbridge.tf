resource "aws_cloudwatch_event_rule" "ToStopec2_event" {
name = "ToStopec2_event"
description = "To trigger the Lambda function which was defined to stop the ec2"
schedule_expression = cron(30 4 ? * MON-FRI *) 
}

resource "aws_cloudwatch_event_target" "ToStopec2_event" {
rule = aws_cloudwatch_event_rule.ToStopec2_event.name
target_id = "StopEc2"
arn = aws_lambda_function.ToStopEc2.arn
} 

resource "aws_lambda_permission" "allow_cloudwatch" {
statement_id = "AllowExecutionFromcloudWatch"
action = "lambda:InvokeFunction"
function_name = aws_lambda_function.ToStopEc2.function_name
principal = "events.amazonaws.com"
source_arn = aws_cloudwatch_event_rule.ToStopec2_event.arn

}