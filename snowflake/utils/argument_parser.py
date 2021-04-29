import sys
import os

sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__)))))


def get_arguments(*args):

    ARGUMENTS = {
        "environment": {
            "short_command": "-env",
            "command": "--environment",
            "help": "Set env here where the code will live",
            "required": True,
            "nargs": "?",
            "type": str,
            "choices": ["DEV", "PROD"]
        },
        "transfer_mode": {
            "short_command": "-m",
            "command": "--transfer_mode",
            "help": "Define write mode to GCS",
            "required": False,
            "nargs": "?",
            "type": str,
            "choices": ["delete_write", "write", "if_not_exists"]
        },
        "region": {
            "short_command": "-rg",
            "command": "--region",
            "help": "This parameter is used to specify a region",
            "required": False,
            "nargs": "?",
            "type": int
        },
        "data_source": {
            "short_command": "-ds",
            "command": "--data_source",
            "help": "This argument is to specify data source to be loaded",
            "default": "ALL",
            "required": False,
            "nargs": "?",
            "type": str,
            "choices": ["TRANSACTIONS", "CUSTOMERS", "PRODUCTS", "PERSIST", "ANALYTICS", "ALL"]
        },
        "action": {
            "short_command": "-ac",
            "command": "--action",
            "help": "This argument is to specify setup action to be taken",
            "required": False,
            "default": "setup",
            "nargs": "?",
            "type": str,
            "choices": ["setup", "destroy"]
        },
        "secret_name": {
            "short_command": "-sn",
            "command": "--secret_name",
            "help": "This argument is to specify secret_name for snowflake credentials",
            "required": False,
            "nargs": "?",
            "type": str
        },
        "bucket": {
            "short_command": "-b",
            "command": "--bucket",
            "help": "Bucket name should be used as your raw data destination",
            "required": False,
            "nargs": "?",
            "type": str
        }
    }

    back = [ARGUMENTS.get(arg) for arg in args if arg in ARGUMENTS]

    return back