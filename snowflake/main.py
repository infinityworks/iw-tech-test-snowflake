import argparse
import os
import sys
sys.path.append(os.path.dirname(os.path.dirname(os.path.realpath(__file__))))
from snowflake.utils.run_shell_command import run_shell_command
from snowflake.utils.argument_parser import get_arguments


if __name__ == '__main__':
    description = 'E2E'
    parser = argparse.ArgumentParser(description=description)

    for argument in get_arguments("environment", "action"):
        default = argument.get('default', None)
        choices = argument.get('choices', None)

        parser.add_argument(
            argument['short_command'], argument["command"], help=argument["help"], default=default, choices=choices,
            required=argument['required'], nargs=argument['nargs'], type=argument['type']
        )

    args = parser.parse_args()
    env = args.environment
    action = args.action

    snowflake_setup = 'python utils/snowflake_setup.py -env {ENV}'.format(ENV=env)
    ingest_raw_to_s3_setup = 'python ingestion/raw_to_s3.py -env {ENV}'.format(ENV=env)
    ingest_s3_to_snowflake = 'python ingestion/s3_to_sf.py -env {ENV}'.format(ENV=env)
    transform = 'python ingestion/snowflake_transform.py -env {ENV}'.format(ENV=env)
    destroy = 'python utils/snowflake_setup.py -env {ENV} -ac destroy'.format(ENV=env)

    if action == 'setup':
        for each in [snowflake_setup, ingest_raw_to_s3_setup, ingest_s3_to_snowflake, transform]:
            run_shell_command(each)

    if action == 'destroy':
        run_shell_command(destroy)