import json
import boto3
from decimal import Decimal

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('cwresume-dbtable')

def lambda_handler(event, context):
    try:

        print(f"Received event: {json.dumps(event)}")
    

        response = table.get_item(Key={'VisitCounter': 'VisitCounter'})


        if 'Item' not in response:
            TotalVisits = 1
        else:
            TotalVisits = response['Item']['TotalVisits']
            TotalVisits = int(TotalVisits) + 1  


        table.put_item(Item={
            'VisitCounter': 'VisitCounter',
            'TotalVisits': TotalVisits
        })


        return {
            'statusCode': 200,
            'headers': {
                "Access-Control-Allow-Origin": "https://cwcloudresume.me",
                "Access-Control-Allow-Methods": "POST,GET,OPTIONS",
                "Access-Control-Allow-Headers": "Content-Type"
            },
            'body': json.dumps({'message': 'Counter updated successfully', 'new_count': TotalVisits})  
        }

    except Exception as e:
        error_message = {
            'error': 'Internal server error',
            'details': str(e)  
        }
        print(f"An error occurred: {error_message}")  
        return {
            'statusCode': 500,

            'body': json.dumps(error_message)  
        }

