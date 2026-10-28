import pandas as pd

# Lue API:sta tallennettu data
df = pd.read_csv("remote_jobs.csv")

print("Alkuperäiset rivit:", len(df))
print("Sarakkeet:", df.columns.tolist())

# Poista työpaikat, joilta puuttuu nimi
df = df.dropna(subset=["title"])

# Poista duplikaatit työpaikan tunnisteen perusteella
if "id" in df.columns:
    df = df.drop_duplicates(subset=["id"])
else:
    df = df.drop_duplicates()

print("Rivit puhdistuksen jälkeen:", len(df))
print("Puuttuvat arvot sarakkeittain:")
print(df.isna().sum())

# Tallenna puhdistettu data erilliseen tiedostoon
df.to_csv(
    "remote_jobs_clean.csv",
    index=False,
    encoding="utf-8-sig"
)

print("Puhdistettu data tallennettu: remote_jobs_clean.csv")
