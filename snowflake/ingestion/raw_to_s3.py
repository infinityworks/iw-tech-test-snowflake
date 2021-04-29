import os
import sys
import datetime
import argparse

project_path = os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__))))
sys.path.append(project_path)
input_path = os.path.join(project_path, 'input_data')

from snowflake.utils.s3_operators import transfer_to_s3, generate_file_name
from snowflake.utils.generate_conf import get_conf_file_path_by_name, get_conf_file_by_path
from snowflake.utils.argument_parser import get_arguments


def process_raw(source, destination):
    decode = {
        'TRANSACTIONS': 'transactions',
        'CUSTOMERS': 'customers.csv',
        'PRODUCTS': 'products.csv',
        'ALL': ['transactions', 'customers.csv', 'products.csv']
    }

    if decode.get(source) == 'transactions' or source == 'ALL':
        walk_dir = os.path.abspath(os.path.join(input_path, 'starter/transactions'))
        for root, subdirs, files in os.walk(walk_dir):
            print('--\nroot = ' + root)
            for subdir in subdirs:
                print('\t- subdirectory ' + subdir)
                list_file_path = os.path.join(root, subdir)

                print('list_file_path = ' + list_file_path)
                list_files = [os.path.join(list_file_path, f) for f in os.listdir(list_file_path)]
                for list_file in list_files:
                    with open(list_file, 'r') as lf:
                        f_content = lf.read()
                        loadtime = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
                        filename = generate_file_name('json', suffix=loadtime)
                        filekey = '/'.join(['TRANSACTIONS', subdir, filename])
                        transfer_to_s3(f_content, destination, filekey, 'overwrite', 1)

    if decode.get(source) == 'customers.csv' or source == 'ALL':
        file = os.path.abspath(os.path.join(input_path, f'starter/customers.csv'))
        with open(file, 'r') as lf:
            f_content = lf.read()
            loadtime = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
            filename = generate_file_name('csv', suffix=loadtime)
            filekey = '/'.join(['CUSTOMERS', filename])
            transfer_to_s3(f_content, destination, filekey, 'overwrite')

    if decode.get(source) == 'products.csv' or source == 'ALL':
        file = os.path.abspath(os.path.join(input_path, f'starter/products.csv'))
        with open(file, 'r') as lf:
            f_content = lf.read()
            loadtime = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
            filename = generate_file_name('csv', suffix=loadtime)
            filekey = '/'.join(['PRODUCTS', filename])
            transfer_to_s3(f_content, destination, filekey, 'overwrite')


if __name__ == '__main__':

    description = 'Ingestion for product, customer and transactions'
    parser = argparse.ArgumentParser(description=description)

    for argument in get_arguments("environment", "transfer_mode", "data_source", "bucket", "secret_name"):
        default = argument.get('default', None)
        choices = argument.get('choices', None)

        parser.add_argument(
            argument['short_command'], argument["command"], help=argument["help"], default=default, choices=choices,
            required=argument['required'], nargs=argument['nargs'], type=argument['type']
        )

    args = parser.parse_args()
    env = args.environment
    data_source = args.data_source
    config_path = get_conf_file_path_by_name(env)
    config = get_conf_file_by_path(config_path)

    bucket_name = args.bucket or config.get('BUCKET_NAME', args.bucket)

    process_raw(data_source, bucket_name)