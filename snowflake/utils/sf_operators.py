import sys
import os
import snowflake.connector
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import serialization

sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__)))))


def connection_handler(f):
    def wrapper(*args, **kwargs):
        try:
            if args[0].con is None:
                args[0].con = args[0]._connect(args[0].connection_dictionary, args[0].script_name)
            return f(*args, **kwargs)
        except snowflake.connector.errors.ProgrammingError as e:
            print(e)
            print('Error {0} ({1}): {2} ({3})'.format(e.errno, e.sqlstate, e.msg, e.sfqid))
            raise e
        finally:
            args[0].con.close()
            args[0].con = None

    return wrapper


class SnowFlake(object):
    def __init__(self, connection_dictionary, script_name):
        self.script_name = script_name
        self.connection_dictionary = connection_dictionary
        self.con = self._connect(connection_dictionary, script_name)

    def _connect_key(self, connection_dictionary, script_name):
        p_key = serialization.load_pem_private_key(
            self._transform_pk(connection_dictionary['private_key']).encode(),
            password = connection_dictionary['private_key_password'].encode(),
            backend=default_backend()
        )
        pkb = p_key.private_bytes(
            encoding=serialization.Encoding.DER,
            format=serialization.PrivateFormat.PKCS8,
            encryption_algorithm=serialization.NoEncryption())
        return snowflake.connector.connect(
            user=connection_dictionary['username'],
            account=connection_dictionary['account'],
            private_key=pkb,
            session_parameters={
                'QUERY_TAG': script_name,
            })

    def _connect(self, connection_dictionary, script_name):
        return snowflake.connector.connect(
            user=connection_dictionary.get('USER_NAME'),
            password=connection_dictionary.get('PASSWORD'),
            account=connection_dictionary.get('ACCOUNT'),
            session_parameters={
                'QUERY_TAG': script_name,
            }
        )

    @connection_handler
    def execute_query(self, query):
        with self.con.cursor() as cur:
            print("SQL RUN ", query)
            cur.execute(query)
        cur.close()
        return True

    @connection_handler
    def execute_query_result(self, query):
        with self.con.cursor() as cur:
            print("SQL RUN ", query)
            res = cur.execute(query).fetchall()
        cur.close()
        return res

    @connection_handler
    def execute_query_result_one(self, query):
        with self.con.cursor() as cur:
            print("SQL RUN ", query)
            res = cur.execute(query).fetchone()
        cur.close()
        return res

    @connection_handler
    def execute_queries(self, queries):
        with self.con.cursor() as cur:
            for query in queries:
                print("SQL RUN ", query)
                cur.execute(query)
        cur.close()
        return True

    @connection_handler
    def execute_file(self, sql_file):
        # execute SQL script using connection
        with open(sql_file, 'r', encoding='utf-8') as f:
            for cur in self.con.execute_stream(f):
                for ret in cur:
                    print(ret)

    def test_connection(self):
        one_row = self.execute_query_result("SELECT current_version()")
        print(one_row[0])

    #
    # Helper function
    #
    def _transform_pk(self, private_key):
        header, body = private_key.split("----- ")
        header = header + "----- \n"
        body, footer = body.split(" -----")
        footer = "\n-----" + footer
        body = body.replace(" ", "\n")
        private_key = header + body + footer
        return private_key