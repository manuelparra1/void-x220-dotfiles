#!/usr/bin/env python3

from pathlib import Path
from datetime import date, datetime
import re
import shutil

SOURCE_DIR = Path.home() / "aston" / "Notes" / "Obsidian" / "aston"
DEST_DIR = Path.home() / "Downloads" / "Weekly-Update-Prep"
START_DATE = date(2026, 3, 2)
END_DATE = date(2026, 3, 6)

DAY_PREFIX = {
    0: "01-Monday",
    1: "02-Tuesday",
    2: "03-Wednesday",
    3: "04-Thursday",
    4: "05-Friday",
    5: "06-Saturday",
    6: "07-Sunday",
}

CREATED_RE = re.compile(r"^created:\s*([0-9T:\-]+)", re.MULTILINE)

def extract_created(md_file: Path):
    try:
        text = md_file.read_text(encoding="utf-8")
    except Exception:
        return None

    if not text.startswith("---\n"):
        return None

    parts = text.split("---", 2)
    if len(parts) < 3:
        return None

    frontmatter = parts[1]
    match = CREATED_RE.search(frontmatter)
    if not match:
        return None

    try:
        return datetime.fromisoformat(match.group(1)).date()
    except ValueError:
        return None

def unique_dest(path: Path):
    if not path.exists():
        return path

    stem = path.stem
    suffix = path.suffix
    counter = 2
    while True:
        candidate = path.with_name(f"{stem}-{counter}{suffix}")
        if not candidate.exists():
            return candidate
        counter += 1

def main():
    DEST_DIR.mkdir(parents=True, exist_ok=True)

    for md_file in SOURCE_DIR.rglob("*.md"):
        created_date = extract_created(md_file)
        if not created_date:
            continue

        if START_DATE <= created_date <= END_DATE:
            prefix = DAY_PREFIX[created_date.weekday()]
            dest_name = f"{prefix}-{md_file.name}"
            dest_path = unique_dest(DEST_DIR / dest_name)
            shutil.copy2(md_file, dest_path)
            print(f"Copied: {md_file} -> {dest_path}")

if __name__ == "__main__":
    main()
