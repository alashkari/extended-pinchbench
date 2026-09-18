def transform_records(records):
    output = []
    for record in records:
        try:
            score = int(record.get("score", 0))
        except Exception:
            continue
        if record.get("status") == "active" and score > 58:
            bucket = "urgent" if score > 78 else "watch"
            output.append({"code": str(record.get("code", "")).upper(), "bucket": bucket})
    return sorted(output, key=lambda item: item["code"])
