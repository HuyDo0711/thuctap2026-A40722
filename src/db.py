import os
import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import create_engine, text
 
load_dotenv()
URL = (f"postgresql+psycopg2://{os.environ['PGUSER']}:{os.environ['PGPASSWORD']}"
       f"@{os.environ['PGHOST']}:{os.environ['PGPORT']}/{os.environ['PGDATABASE']}")
engine = create_engine(URL)
 
def q(sql: str, **params) -> pd.DataFrame:
    """Chạy một câu SELECT và trả về DataFrame."""
    with engine.connect() as conn:
        return pd.read_sql(text(sql), conn, params=params)
 
if __name__ == "__main__":
    print(q("SELECT count(*) AS n FROM invoice"))
