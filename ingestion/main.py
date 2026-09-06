import json
import os
import sys
from datetime import datetime, timezone

import requests
from google.cloud import bigquery, storage

from idfm_lines import DEFAULT_LINES, line_ref

API_URL = "https://prim.iledefrance-mobilites.fr/marketplace/general-message"


def fetch_line_messages(api_key: str, line: str) -> dict:
    response = requests.get(
        API_URL,
        params={"LineRef": line_ref(line)},
        headers={"Accept": "application/json", "apikey": api_key},
        timeout=20,
    )
    response.raise_for_status()
    return {"line": line, "status": "ok", "raw": response.json()}


def fetch_all(api_key: str, lines: list[str]) -> list[dict]:
    results = []
    for line in lines:
        try:
            results.append(fetch_line_messages(api_key, line))
        except requests.RequestException as exc:
            results.append({"line": line, "status": "error", "error": str(exc)})
    return results


def upload_to_gcs(bucket_name: str, payload: dict, fetched_at: datetime) -> str:
    blob_path = (
        f"raw/idfm_trafic/dt={fetched_at:%Y-%m-%d}/hr={fetched_at:%H}/"
        f"idfm_trafic_{fetched_at:%Y%m%dT%H%M%SZ}.json"
    )
    client = storage.Client()
    bucket = client.bucket(bucket_name)
    bucket.blob(blob_path).upload_from_string(
        json.dumps(payload, ensure_ascii=False), content_type="application/json"
    )
    return blob_path


def load_to_bigquery(table: str, fetched_at: datetime, results: list[dict]) -> None:
    rows = [
        {
            "fetched_at": fetched_at.isoformat(),
            "line": r["line"],
            "status": r["status"],
            "error": r.get("error"),
            "raw": r.get("raw"),
        }
        for r in results
    ]
    client = bigquery.Client()
    job_config = bigquery.LoadJobConfig(
        source_format=bigquery.SourceFormat.NEWLINE_DELIMITED_JSON,
        write_disposition=bigquery.WriteDisposition.WRITE_APPEND,
    )
    client.load_table_from_json(rows, table, job_config=job_config).result()


def main() -> int:
    api_key = os.environ["IDFM_API_KEY"]
    bucket_name = os.environ["GCS_BUCKET"]
    bq_table = os.environ["BQ_TABLE"]
    lines = os.environ.get("IDFM_LINES", ",".join(DEFAULT_LINES)).split(",")

    fetched_at = datetime.now(timezone.utc)
    results = fetch_all(api_key, lines)
    payload = {"fetched_at": fetched_at.isoformat(), "lines": results}

    blob_path = upload_to_gcs(bucket_name, payload, fetched_at)
    print(f"Uploaded gs://{bucket_name}/{blob_path}")

    load_to_bigquery(bq_table, fetched_at, results)
    print(f"Loaded {len(results)} rows into {bq_table}")

    if all(r["status"] == "error" for r in results):
        print("Toutes les lignes ont échoué", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
