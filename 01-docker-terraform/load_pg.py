import pandas as pd
from sqlalchemy import create_engine


def load_large_csv_to_postgres(csv_file, table_name, database_url, chunksize=100000):
    engine = create_engine(database_url)
    reader = pd.read_csv(csv_file, chunksize=chunksize)

    for chunk in reader:
        chunk.to_sql(table_name, engine, if_exists="replace", index=False)


if __name__ == "__main__":
    load_large_csv_to_postgres(
        "01-docker-terraform/green_tripdata_2019-09.csv",
        "green_tripdata",
        "postgresql://root:root@localhost:5432/test_db",
    )
