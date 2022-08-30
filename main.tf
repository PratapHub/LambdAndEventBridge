locals {
  lambda_zip_location = outputs/stopec2
}
data "archive_file" "stopec2" {
  type        = "zip"
  source_file = "stopec2.py"
  output_path = "${locals.lambda_zip_location}"
}

resource "aws_lambda_function" "ToStopEc2" {
filename = "${local.lambda_zip_location}"
function_name= "ToStopEc2"
role = "${aws_iam_role.LambdaToStopAndStartEc2_role.arn}"
handler = "stopec2.lambda_handler"
runtime= "python3.7"
}