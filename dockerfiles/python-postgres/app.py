from flask import Flask
import psycopg2
from psycopg2 import OperationalError, sql, extensions
import os

app = Flask(__name__)

POSTGRES_USER = os.environ.get("POSTGRES_USER")
POSTGRES_PASSWORD = os.environ.get("POSTGRES_PASSWORD")
POSTGRES_HOST = os.environ.get("POSTGRES_HOST")
POSTGRES_PORT = os.environ.get("POSTGRES_PORT", "5432")  # Default port is 5432
POSTGRES_DB = os.environ.get("POSTGRES_DB")

def create_database_if_not_exists():
    # Connect without specifying a database
    conn = psycopg2.connect(
        user=POSTGRES_USER,
        password=POSTGRES_PASSWORD,
        host=POSTGRES_HOST,
        port=POSTGRES_PORT
    )
    conn.set_isolation_level(extensions.ISOLATION_LEVEL_AUTOCOMMIT)
    cursor = conn.cursor()

    try:
        cursor.execute(sql.SQL("CREATE DATABASE {}").format(sql.Identifier(POSTGRES_DB)))
        print(f"Database {POSTGRES_DB} created successfully.")
    except psycopg2.errors.DuplicateDatabase:
        print(f"Database {POSTGRES_DB} already exists.")
    finally:
        cursor.close()
        conn.close()

def can_connect_to_postgres():
    try:
        connection = psycopg2.connect(
            user=POSTGRES_USER,
            password=POSTGRES_PASSWORD,
            host=POSTGRES_HOST,
            port=POSTGRES_PORT,
            database=POSTGRES_DB
        )
        connection.close()
        return True
    except OperationalError:
        return False

@app.route('/')
def index():
    if can_connect_to_postgres():
        return "Connected to Postgres!", 200
    else:
        return "Failed to connect to Postgres!", 500

if __name__ == "__main__":
    create_database_if_not_exists()
    app.run(host='0.0.0.0')


