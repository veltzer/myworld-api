# TOFIX

Findings from a code scan on 2026-10-04.

## High

- `app.yaml:2` - `runtime: python27` is the retired App Engine Python 2.7 runtime, yet `main.py:85` and `main.py:143` use f-strings, which are a syntax error under Python 2.7, so the app as committed cannot deploy or start. Either port the service to a current runtime (`python3xx` with the Endpoints Frameworks v2 / a plain Flask/FastAPI app) or retire the repo; the two halves currently contradict each other.
- `pyproject.toml:9` - the only declared dependency, `protorpc` (0.12.0 in `uv.lock:267`), does not import on the repo's own Python (`requires-python = ">=3.14"`): `import protorpc.messages` fails with `ModuleNotFoundError: No module named 'cgi'`. And `main.py:19` imports `endpoints`, which is not declared at all. Nothing in `main.py` can be imported in the repo venv; port off protorpc/endpoints or drop the Python 3 project metadata.
- `main_test.py:20` - every test takes a `testbed` fixture that is defined nowhere in the repo (no `conftest.py`), so `pytest` errors on all four tests (`fixture 'testbed' not found`) even before the import failures above. Add the fixture (the upstream sample's `conftest.py`) or drop the parameter.

## Medium

- `rsconstruct.toml:1` - `ruff`, `mypy` and `pytest` are declared in the dev group (`pyproject.toml:14`-`16`) but no processor runs them, so `main.py`/`main_test.py` are never linted or tested and the breakages above go unnoticed by CI. Add ruff/mypy/pytest processors with `src_files = ["main.py", "main_test.py"]` once the code imports.
- `main.py:112` - `WEB_CLIENT_ID`, `ANDROID_CLIENT_ID` and `IOS_CLIENT_ID` are still the sample's `'replace this with ...'` placeholders, so `AuthedGreetingApi` (`main.py:123`) only accepts the API Explorer client and the `ANDROID_AUDIENCE` audience check can never match a real token. Fill in real client IDs or remove the authed API.

## Low

- `README.md:1` - the README is only the title; it does not say what the API is, how to run/deploy it, or point to `doc/notes.txt`. Add a short usage section.
- `main.py:59` - comment typos left over from the sample: "encapsuate" (line 59) and "and integer named 'id'" (line 65).
