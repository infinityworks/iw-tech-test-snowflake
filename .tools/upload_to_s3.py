#!/usr/bin/python3

import logging
import boto3
from botocore.exceptions import ClientError
import os
import glob
import sys


def upload_files(base_path, bucket):
    """
    Keeps the stucture relative to path on s3.
    """
    count = 0

    len_base_parts = len(base_path.split("/"))-1
    for root, dirs, files in os.walk(base_path):
        for file in files:
            s3_key = "/".join(root.split("/")[len_base_parts:])

            print(f"Uploading {root}/{file} to s3://{bucket}/{s3_key}/{file}..")
            upload_file(
                os.path.join(root, file), bucket, os.path.join(s3_key, file)
            )
            count += 1

    print(f"Done. {count} files uploaded.")

def upload_file(file_name, bucket, object_name=None):
    """Upload a file to an S3 bucket

    :param file_name: File to upload
    :param bucket: Bucket to upload to
    :param object_name: S3 object name. If not specified then file_name is used
    :return: True if file was uploaded, else False
    """

    # If S3 object_name was not specified, use file_name
    if object_name is None:
        object_name = file_name

    # Upload the file
    s3_client = boto3.client("s3")
    try:
        response = s3_client.upload_file(file_name, bucket, object_name)
    except ClientError as e:
        logging.error(e)
        return False
    return True


# Keeping this really simple for speed. I know there's better ways
# which would totally implement in production environment!"
# should test that the file exists etc.
# should also be extablishing a session with boto3 etc..
def main(bucket=None):

    data_root_path = "input_data/starter/"

    upload_files(data_root_path, bucket)


if __name__ == "__main__":
    main(sys.argv[1])
