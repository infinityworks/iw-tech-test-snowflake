import gzip
import boto3
import os
import uuid
import sys

sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__)))))


def transfer_to_s3(data, bucket_name, file_key, mode, zip=None):
    path_key = os.path.dirname(file_key)
    s3 = boto3.resource('s3')
    bucket = s3.Bucket(bucket_name)
    s3object = s3.Object(bucket.name, file_key)
    b_data = bytes(data.encode('utf-8'))

    if zip:
        print('File compress enabled')
        b_data = gzip_bytes(b_data=b_data)
        file_key += '.gz'
        s3object = s3.Object(bucket.name, file_key)

    print(f'Write mode set to {mode}')
    if mode == 'append':
        s3object.put(Body=b_data)
        print(f'File {file_key} was successfully appended to S3 bucket {bucket_name}')

    elif mode == 'overwrite':
        for obj in bucket.objects.filter(Prefix=path_key):
            s3.Object(bucket.name, obj.key).delete()
            print(f'{obj.key} has been deleted')

        s3object.put(Body=b_data)
        print(f'File {file_key} was successfully written to S3 bucket {bucket_name}')

    elif mode == 'if_not_exists':
        l = []
        for obj in bucket.objects.filter(Prefix=path_key):
            l.append(obj)
        if len(l) == 0:
            s3object.put(Body=b_data)
            print(f'File {file_key} was successfully written to S3 bucket {bucket_name}')
        else:
            print(f'{path_key} is already populated with data')


def generate_file_name(extention, prefix=None, suffix=None):
    filename = ''.join([str(uuid.uuid4())])
    if prefix:
        prefix = str(prefix)
        filename = '-'.join([prefix, filename])
    if suffix:
        suffix = str(suffix)
        filename = '-'.join([filename, suffix])
    return '.'.join([filename, extention])


def gzip_bytes(b_data):
    if isinstance(b_data, bytes):
        return gzip.compress(b_data)