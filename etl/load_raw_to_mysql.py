import pandas as pd
from sqlalchemy import create_engine
from urllib.parse import quote_plus

USER = "root"
PASSWORD = "Maroti@25"
HOST = "localhost"
DB = "consumer360"

# encode special characters
PASSWORD = quote_plus(PASSWORD)

engine = create_engine(
    f"mysql+mysqlconnector://{USER}:{PASSWORD}@{HOST}/{DB}"
)

csv_path = r"D:\Consumer360\data\OnlineRetail.csv"

print("Reading CSV...")
df = pd.read_csv(csv_path, encoding="latin1")

df.columns = [
    "invoice_no",
    "stock_code",
    "description",
    "quantity",
    "invoice_date",
    "unit_price",
    "customer_id",
    "country"
]

# Convert invoice_date to MySQL-friendly datetime
df["invoice_date"] = pd.to_datetime(
    df["invoice_date"],
    format="%m/%d/%Y %H:%M",
    errors="coerce"
)


print("Rows in CSV:", len(df))

print("Uploading to MySQL...")
df.to_sql("raw_sales", engine, if_exists="append", index=False, chunksize=10000)

print("DONE ✅")
