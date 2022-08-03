import os
import pymysql
from pymysql.cursors import DictCursor
from dotenv import load_dotenv


def connection():
    load_dotenv()
    host = os.getenv('HOST')
    database = os.getenv('DATABASE')
    username = os.getenv('USERNAME')
    password = os.getenv('PASSWORD')
    conn = pymysql.connect(host=host, user=username,
                           password=password, database=database, cursorclass=DictCursor)
    return conn
