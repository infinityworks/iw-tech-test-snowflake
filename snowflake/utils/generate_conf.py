import os
import sys
import json

syspath = os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__))))
sys.path.append(syspath)
conf_path = os.path.join(syspath, 'snowflake/conf-repo/')


def get_conf_file_by_path(conf_file_path=None):
    if not conf_file_path:
        conf_file_path = conf_path
    print(conf_file_path)
    with open(conf_file_path) as json_file:
        data = json.load(json_file)
    return data


def get_conf_file_path_by_name(env):
    decode = {
        "DEV":"config-dev.json",
        "PROD": "config-prod.json"
    }
    file = decode.get(env)
    file_path = os.path.join(conf_path, file)
    if os.path.exists(file_path):
        return file_path
    else:
        print("Configuration json with this name does not exists!")


def generate_sf_conf_from_env_var():
    return {"ACCOUNT": os.getenv('ACCOUNT'), "PASSWORD": os.getenv('PASSWORD'), "USER_NAME": os.getenv('USER_NAME')}
