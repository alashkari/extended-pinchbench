---
id: task_api_endpoint_docs
name: API Endpoint Docs
category: writing
grading_type: automated
timeout_seconds: 120
workspace_files:
  - path: "openapi_snippet.json"
    content: |
      {
        "paths": {
          "/v1/widgets": {
            "post": {
              "summary": "Create a widget",
              "operationId": "createWidget",
              "requestBody": {
                "required": true,
                "content": {
                  "application/json": {
                    "schema": {
                      "type": "object",
                      "required": ["name", "color"],
                      "properties": {
                        "name": {
                          "type": "string",
                          "description": "Display name of the widget"
                        },
                        "color": {
                          "type": "string",
                          "enum": ["red", "green", "blue"],
                          "description": "Theme color"
                        },
                        "size": {
                          "type": "integer",
                          "description": "Optional size in pixels"
                        }
                      }
                    }
                  }
                }
              },
              "responses": {
                "201": {
                  "description": "Widget created",
                  "content": {
                    "application/json": {
                      "schema": {
                        "type": "object",
                        "properties": {
                          "id": { "type": "string" },
                          "name": { "type": "string" },
                          "color": { "type": "string" },
                          "size": { "type": "integer" }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
---

# API Endpoint Docs

## Prompt

Read `openapi_snippet.json` and write human-readable API documentation to `docs.md` for `POST /v1/widgets`.

The docs must include:

1. The path `/v1/widgets`
2. The HTTP method `POST`
3. The request fields (`name`, `color`, and optionally `size`)
4. The success response code `201`

## Expected Behavior

The agent should produce markdown docs summarizing the create-widget endpoint: method, path, request body fields, and 201 Created response.

## Grading Criteria

- [ ] File `docs.md` is created
- [ ] Mentions path `/v1/widgets`
- [ ] Mentions method POST
- [ ] Mentions request fields name and color
- [ ] Mentions response code 201

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import re

    scores = {
        "file_created": 0.0,
        "has_path": 0.0,
        "has_method": 0.0,
        "has_request_fields": 0.0,
        "has_response_201": 0.0,
    }

    workspace = Path(workspace_path)
    path = workspace / "docs.md"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    content = path.read_text(encoding="utf-8", errors="replace")
    lower = content.lower()

    if "/v1/widgets" in content:
        scores["has_path"] = 1.0

    if re.search(r"\bpost\b", lower):
        scores["has_method"] = 1.0

    has_name = re.search(r"\bname\b", lower) is not None
    has_color = re.search(r"\bcolor\b", lower) is not None
    if has_name and has_color:
        scores["has_request_fields"] = 1.0
    elif has_name or has_color:
        scores["has_request_fields"] = 0.5

    if re.search(r"\b201\b", content):
        scores["has_response_201"] = 1.0

    return scores
```

## Additional Notes

- Presence checks only; prose quality is not graded.
