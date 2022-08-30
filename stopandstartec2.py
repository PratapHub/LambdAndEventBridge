import boto3
import json
import base64
import os

region = 'us-east-1'

ec2 = boto3.client('ec2', region_name=region)
ec2_resource = boto3.resource('ec2', region_name=region)

class EC2Controler:

    def action_receiver(self, raw_action):
        print(raw_action)
        request_body = base64.b64decode(raw_action["body-json"])
        instance_payload = json.loads(request_body)
        ec2_instances = instance_payload["ec2_instances"]
        my_instances = ec2_instances.split()
        
        ec2_inst = ec2_resource.instances.filter(
            InstanceIds=[
                my_instances[0],
            ],
        )
        instance_name = ""
        for instance in ec2_inst:
            instance = instance.tags[0]
            instance_name += instance['Value']
            
        responseMessage = ""
        user = raw_action["context"]["user-arn"]
        user_split = user.split("/")
        aws_username = user_split[1]
        
        if instance_payload["ec2_status"] == "Stop":
            ec2.stop_instances(InstanceIds=my_instances)
            responseMessage = str(instance_name) +"(" + str(my_instances[0]) + ")" + " is stopped by " + str(aws_username)
        elif instance_payload["ec2_status"] == "Start":    
            ec2.start_instances(InstanceIds=my_instances)
            responseMessage = str(instance_name) +"(" + str(my_instances[0]) + ")" + " is started by " + str(aws_username)
        self.notify_users(responseMessage)
        
        return json.loads(json.dumps(responseMessage, default=str))
    
    def notify_users(self, instance):
        sns_client = boto3.client('sns')
        snsarn = str(os.environ['sns_arn'])
        message = "This mail is to notify team that EC2 Instance: " + str(instance)
            
        response = sns_client.publish(
            TopicArn = snsarn,
            Message = message ,
            Subject='EC2 Instance Alert'
        )
        
def lambda_handler(event, context):
    ec2_control = EC2Controler()
    ec2_control.action_receiver(event)

    return {'message': 'Success'}