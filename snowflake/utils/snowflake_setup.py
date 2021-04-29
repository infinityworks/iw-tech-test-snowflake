import sys
import os

sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__)))))

from snowflake.utils.generate_conf import get_conf_file_path_by_name, get_conf_file_by_path
from snowflake.commands.sf_setup_commands import SETUP_DB_OBJECTS, SETUP_USER_AND_ROLE
from snowflake.commands.sf_destroy_commands import DESTROY
from snowflake.utils.sf_operators import SnowFlake
from snowflake.utils.argument_parser import get_arguments
from snowflake.utils.generate_conf import generate_sf_conf_from_env_var
import argparse


if __name__ == '__main__':
    description = 'Snowflake setup'
    parser = argparse.ArgumentParser(description=description)

    for argument in get_arguments("environment", "bucket", "secret_name", "region", "action"):
        default = argument.get('default', None)
        choices = argument.get('choices', None)

        parser.add_argument(
            argument['short_command'], argument["command"], help=argument["help"], default=default, choices=choices,
            required=argument['required'], nargs=argument['nargs'], type=argument['type']
        )

    args = parser.parse_args()
    env = args.environment
    action = args.action

    config_path = get_conf_file_path_by_name(env)
    config = get_conf_file_by_path(config_path)

    bucket_name = args.bucket or config.get('BUCKET_NAME', args.bucket)
    region = args.region or os.getenv('REGION', args.region)

    sf_creds = generate_sf_conf_from_env_var()
    AWS_KEY_ID = os.getenv('AWS_ACCESS_KEY_ID')
    AWS_SECRET_KEY = os.getenv('AWS_SECRET_ACCESS_KEY')
    DB = config.get('DB')
    PASSWORD = sf_creds.get('PASSWORD')
    USER_NAME = sf_creds.get('USER_NAME')
    BUCKET = bucket_name

    sf = SnowFlake(sf_creds, action)

    if action == 'setup':
        for query in SETUP_USER_AND_ROLE:
            query = query.format(DB=DB, PASSWORD=PASSWORD, USER_NAME=USER_NAME)
            sf.execute_query(query)

        for query in SETUP_DB_OBJECTS:
            query = query.format(DB=DB, BUCKET=BUCKET, AWS_KEY_ID=AWS_KEY_ID, AWS_SECRET_KEY=AWS_SECRET_KEY)
            sf.execute_query(query)

    if action == 'destroy':
        sf = SnowFlake(sf_creds, action)
        for query in DESTROY:
            query = query.format(DB=DB)
            sf.execute_query(query)