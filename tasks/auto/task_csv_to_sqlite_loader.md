---
id: task_csv_to_sqlite_loader
name: CSV to SQLite Loader
category: coding
grading_type: automated
timeout_seconds: 180
workspace_files:
  - path: "input.csv"
    content: |
      id,name,price
      1,widget,9.99
      2,gadget,14.50
      3,doohickey,3.25
---

# CSV to SQLite Loader

## Prompt

Write a Python script named `load_csv.py` that uses the standard library modules `csv` and `sqlite3` to load `input.csv` into a SQLite database.

Requirements:

1. Create (or open) a database file named `items.db`
2. Create a table named `items` with columns matching the CSV header (`id`, `name`, `price`)
3. Insert all rows from `input.csv` into the `items` table
4. Commit and close the connection

The file `input.csv` is already in the workspace.

## Expected Behavior

The agent should create `load_csv.py` that:

1. Imports `csv` and `sqlite3`
2. Reads `input.csv`
3. Uses `CREATE TABLE` (or equivalent) for table `items`
4. Inserts each CSV row into `items`
5. Persists data to `items.db`

Using pandas `to_sql` is also acceptable if the table name is still `items`.

## Grading Criteria

- [ ] File `load_csv.py` exists
- [ ] File contains valid Python syntax
- [ ] Imports `sqlite3`
- [ ] Imports `csv` or uses pandas to_sql
- [ ] Creates or writes table named `items`
- [ ] Performs INSERT or to_sql load

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import ast
    import re

    scores = {
        "file_exists": 0.0,
        "valid_python": 0.0,
        "imports_sqlite3": 0.0,
        "imports_csv_or_pandas": 0.0,
        "table_items": 0.0,
        "insert_or_to_sql": 0.0,
    }

    workspace = Path(workspace_path)
    script = workspace / "load_csv.py"
    if not script.exists():
        return scores

    scores["file_exists"] = 1.0
    content = script.read_text(encoding="utf-8")

    try:
        ast.parse(content)
        scores["valid_python"] = 1.0
    except SyntaxError:
        return scores

    if re.search(r"import\s+sqlite3|from\s+sqlite3\s+import", content):
        scores["imports_sqlite3"] = 1.0

    if re.search(r"import\s+csv|from\s+csv\s+import", content) or re.search(
        r"to_sql\s*\(|import\s+pandas|from\s+pandas", content
    ):
        scores["imports_csv_or_pandas"] = 1.0

    if re.search(r"""['\"]items['\"]|\bitems\b""", content, re.IGNORECASE) and re.search(
        r"CREATE\s+TABLE|to_sql\s*\(", content, re.IGNORECASE
    ):
        scores["table_items"] = 1.0
    elif re.search(r"\bitems\b", content, re.IGNORECASE):
        scores["table_items"] = 0.5

    if re.search(r"INSERT\s+INTO|executemany\s*\(|to_sql\s*\(", content, re.IGNORECASE):
        scores["insert_or_to_sql"] = 1.0

    return scores
```

## Additional Notes

- Fixture `input.csv` has three product rows.
- Prefer stdlib `csv` + `sqlite3`; pandas `to_sql` is graded as an alternate path.
