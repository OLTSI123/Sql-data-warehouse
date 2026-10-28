
import subprocess
import sys
from pathlib import Path

# Projektin pääkansio
BASE_DIR = Path(__file__).resolve().parent

# Pipeline-vaiheet oikeassa järjestyksessä
scripts = [
    "Extract.py",
    "Transform.py",
    "Load.py"
]


def run_pipeline():
    print("Pipeline käynnistyy!")

    for script in scripts:
        script_path = BASE_DIR / script

        print(f"\nSuoritetaan: {script}")

        subprocess.run(
            [sys.executable, str(script_path)],
            check=True,
            cwd=BASE_DIR
        )

        print(f"{script} onnistui!")

    print("\nPipeline suoritettu onnistuneesti!")


if __name__ == "__main__":
    run_pipeline()
