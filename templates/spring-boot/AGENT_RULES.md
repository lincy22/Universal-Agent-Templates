# Java / Spring Boot AI Agent Rules & Guidelines

## Core Principles
1. **Layered Architecture:** Enforce strict separation between Controllers, Services, Repositories, and DTOs.
2. **Immutability & DTOs:** Use Java Records or Lombok `@Value` for Data Transfer Objects. Never expose entities directly in API endpoints.
3. **Dependency Injection:** Use constructor injection instead of `@Autowired` field injection.
4. **Exception Handling:** Use `@RestControllerAdvice` and standard `ProblemDetail` or custom response structures for uniform error reporting.

## Directory Structure
```text
src/main/java/com/example/demo/
├── config/             # Spring Security, OpenAPI, App Beans
├── controller/         # REST Controllers
├── dto/                # Request & Response DTOs
├── exception/          # Custom Exceptions & Global Handler
├── model/              # JPA Entities / Domain Models
├── repository/         # Spring Data Repositories
└── service/            # Service Interfaces & Implementations
```

## Security Guardrails
- Secure endpoints with Spring Security and OAuth2/JWT authentication.
- Avoid hardcoding database passwords or JWT secrets; use `application.yml` placeholders with environment variables.
