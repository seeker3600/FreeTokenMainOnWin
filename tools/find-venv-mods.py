# -*- coding: utf-8 -*-
""" Checks for modified files in the virtual environment.

If a file is missing or has been modified, it will be printed to stdout.
"""

from pathlib import Path
import base64
import csv
import hashlib

site = Path(".venv/Lib/site-packages").resolve()

for record in sorted(site.glob("*.dist-info/RECORD")):
    dist = record.parent.name

    with record.open("r", encoding="utf-8", newline="") as f:
        for path_str, hash_str, size_str in csv.reader(f):
            if not hash_str:
                continue

            algo, encoded = hash_str.split("=", 1)

            if algo != "sha256":
                continue

            path = (site / path_str).resolve()

            if not path.exists():
                print(f"MISSING   {dist}: {path}")
                continue

            actual = hashlib.sha256(path.read_bytes()).digest()
            actual_b64 = base64.urlsafe_b64encode(actual).rstrip(b"=").decode()

            if actual_b64 != encoded:
                print(f"MODIFIED  {dist}: {path}")