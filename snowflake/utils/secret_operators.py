import boto3
import base64
import json
from botocore.exceptions import ClientError
import sys
import os

sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__)))))


class AWSSecret:

    def __init__(self, region_name):
        self.region_name = region_name

        session = boto3.session.Session()
        self.secretsmanager_client = session.client(
            service_name='secretsmanager',
            region_name=self.region_name
        )

    def create_secret(self, name, secret_value):

        try:
            kwargs = {'Name': name}
            if isinstance(secret_value, str):
                kwargs['SecretString'] = secret_value
            elif isinstance(secret_value, bytes):
                kwargs['SecretBinary'] = secret_value
            response = self.secretsmanager_client.create_secret(**kwargs)

            print("Created secret %s.", name)
        except ClientError:
            print("Couldn't get secret %s.", name)
            raise
        else:
            return response

    def get_secret(self, name):

        try:
            get_secret_value_response = self.secretsmanager_client.get_secret_value(
                SecretId=name
            )
        except ClientError as e:
            return False
        else:
            # Decrypts secret using the associated KMS CMK.
            # Depending on whether the secret is a string or binary, one of these fields will be populated.
            if 'SecretString' in get_secret_value_response:
                secret = get_secret_value_response['SecretString']
                credentials = json.loads(secret)
                return credentials
            else:
                decoded_binary_secret = base64.b64decode(get_secret_value_response['SecretBinary'])
                return decoded_binary_secret

    def put_value(self, name, value, stages=None):

        try:
            kwargs = {'SecretId': name}
            if isinstance(value, str):
                kwargs['SecretString'] = value
            elif isinstance(value, bytes):
                kwargs['SecretBinary'] = value
            if stages is not None:
                kwargs['VersionStages'] = stages
            response = self.secretsmanager_client.put_secret_value(**kwargs)
            print("Value put in secret %s.", name)
        except ClientError:
            print("Couldn't put value in secret %s.", name)
            raise
        else:
            return response