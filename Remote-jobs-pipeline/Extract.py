import requests
import pandas as pd
url = "https://remotive.com/api/remote-jobs"

response = requests.get(url, timeout=30)
response.raise_for_status()

data = response.json()
jobs = data["jobs"]

df = pd.json_normalize(jobs)

print(f"Haettiin {len(df)} työpaikkaa")
print(df.head())

df.to_csv(
    "remote_jobs.csv",
    index=False,
    encoding="utf-8-sig"
)
print("Data tallennettu tiedostoon remote_jobs.csv")
