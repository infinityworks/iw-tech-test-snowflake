import sys
import os

sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__)))))

from snowflake.utils.generate_conf import get_conf_file_path_by_name, get_conf_file_by_path
from snowflake.commands.sf_transform_commands import PERSIST, ANALYTICS
from snowflake.utils.argument_parser import get_arguments
from snowflake.utils.generate_conf import generate_sf_conf_from_env_var
from snowflake.utils.sf_operators import SnowFlake
import argparse


def get_analytics_process(source):
    decode = {
        'PERSIST': PERSIST,
        'ANALYTICS': ANALYTICS,
        'ALL': [PERSIST, ANALYTICS]
    }
    return decode.get(source)


if __name__ == '__main__':

    description = 'Transform and analytics for product, customer and transactions'
    parser = argparse.ArgumentParser(description=description)

    for argument in get_arguments("environment", "data_source"):
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
    DB = config.get('DB')

    sf_config = generate_sf_conf_from_env_var()
    sf = SnowFlake(sf_config, f'TRANSFORM_{data_source}')
    sf_process = get_analytics_process(data_source)
    for each in sf_process:
        if isinstance(each, list):
            for each_query in each:
                each_query = each_query.format(DB=DB)
                sf.execute_query(each_query)
        else:
            each = each.format(DB=DB)
            sf.execute_query(each)