# from transcription.main import app
import psycopg2
import asyncpg
import os
from dotenv import load_dotenv
from pathlib import Path

# DATABASE_URL = "postgresql://username:password@localhost/user_db"

env_path = Path('../.env')
load_dotenv(env_path)


async def start_db():
    conn = None
    try:
        conn = await asyncpg.connect(
            host='127.0.0.1',
            port=5432,
            user='zappy',
            password='2030',
            database='zappy_db'
        )
        print("Connecting to PostgreSQL")
        return conn
    except Exception as e:
        print(f"Error: {e}")
    finally:
        if conn:
            print("Connected")


            # host=os.getenv("HOST"),
            # port=5432,
            # user=os.getenv("USER"),
            # password=os.getenv("PASSWORD"),
            # database=os.getenv("DATABASE")