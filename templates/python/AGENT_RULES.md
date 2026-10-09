# Python AI Agent Rules & Guidelines

## Core Principles
1. **Type Annotations:** Always use explicit type hints (`mypy` compliant) for parameters and return types.
2. **Code Style:** Strictly follow PEP 8 standards. Use `black` and `ruff` for formatting and linting.
3. **Async IO:** Prefer `async`/`await` for I/O bound operations (FastAPI, httpx).
4. **Environment Safety:** Load configuration strictly through `pydantic-settings` or `.env` files.

## Recommended Structure
```text
src/
├── core/
│   ├── config.py
│   ├── security.py
│   └── database.py
├── api/
│   └── v1/
├── services/
├── models/
└── main.py
tests/
```

## Security Guardrails
- Never hardcode secrets. Use Pydantic `BaseSettings` reading from `.env`.
- Always write Unit Tests using `pytest` for business logic functions.
