# Node.js AI Agent Rules & Guidelines

## Core Principles
1. **Modular Architecture:** Organize code by feature or module (Controllers, Services, Repositories/Models).
2. **Asynchronous Patterns:** Use `async/await` consistently. Avoid raw callbacks or unhandled Promise rejections.
3. **Strict Validation:** Use validation libraries like `zod`, `joi`, or `express-validator` for all incoming request payloads.
4. **Structured Logging:** Use structured loggers (`winston`, `pino`) with environment-based log levels.

## Directory Structure
```text
src/
├── config/             # Environment variables & setup
├── controllers/        # Route handlers
├── middleware/         # Auth, error handling, validation
├── models/             # Database schemas & models
├── routes/             # API routes definition
├── services/           # Business logic
├── utils/              # Helper functions
└── app.js              # Application entrypoint
```

## Security Guardrails
- Store secrets in `.env` files; never commit raw credentials.
- Use `helmet` and `cors` middleware for web security headers.
- Always sanitize SQL/NoSQL query inputs against injection.
