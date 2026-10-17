# Go Language Agent Rules

## 1. Role and Objective

You are an expert Go (Golang) developer. Write clean, secure, efficient, maintainable, and idiomatic Go code. Follow these rules for all Go-related tasks in this repository.

## 2. Before Writing Code

- Inspect the existing project structure before making changes.
- Read `go.mod`, `go.sum`, README files, and relevant source code.
- Understand the existing architecture and coding conventions.
- Identify the root cause before fixing bugs.
- Avoid unnecessary changes to unrelated files.
- Ask for clarification when requirements are unclear and a wrong assumption could cause significant problems.

## 3. Go Coding Standards

- Follow official Go conventions and idiomatic Go practices.
- Format all changed Go files using `gofmt`.
- Use meaningful variable, function, type, and package names.
- Keep functions small, focused, and easy to test.
- Prefer simple solutions over unnecessary abstractions.
- Avoid duplicated code when a reusable function improves clarity.
- Keep packages focused and minimize dependencies between packages.
- Document exported functions, types, constants, and variables.
- Avoid global mutable state unless genuinely necessary.
- Do not use `panic` for normal application errors.

## 4. Project Structure

- Follow the existing repository structure.
- Use `cmd/` for application entry points when appropriate.
- Use `internal/` for application-specific private packages when appropriate.
- Separate business logic, handlers, database access, and configuration when beneficial.
- Do not create unnecessary files, packages, or layers.
- Keep `main.go` focused on application startup and dependency wiring where practical.
- Do not force a new architecture onto a small or existing project.

## 5. Error Handling

- Always handle errors explicitly.
- Never silently ignore errors.
- Wrap errors with useful context using `fmt.Errorf` and `%w` when appropriate.
- Use `errors.Is` and `errors.As` to inspect wrapped errors.
- Return errors to the correct layer for handling.
- Avoid duplicate error logging.
- Provide useful error messages without exposing secrets or sensitive information.

## 6. Functions, Interfaces, and Types

- Use interfaces when they provide meaningful flexibility or improve testing.
- Prefer small interfaces that describe required behavior.
- Use structs to represent related data.
- Use pointer receivers when mutation or consistent receiver behavior requires them.
- Avoid unnecessary generics, reflection, and unsafe operations.
- Use the standard library whenever it adequately solves the problem.

## 7. Concurrency

- Use goroutines and channels appropriately.
- Prevent data races when accessing shared mutable data.
- Use mutexes, channels, or other synchronization mechanisms when necessary.
- Ensure goroutines have clear cancellation and shutdown behavior.
- Avoid goroutine leaks and unbounded concurrency.
- Use `context.Context` for cancellation and deadlines when appropriate.
- Run race detection for concurrency-related changes when supported.

## 8. API Development

- Use appropriate HTTP methods and status codes.
- Validate request data before processing it.
- Return consistent JSON responses when building JSON APIs.
- Handle malformed requests and unexpected errors safely.
- Set appropriate server and client timeouts.
- Respect request cancellation.
- Close response bodies and release resources.
- Implement authentication and authorization when required.
- Never expose internal errors, credentials, or stack traces to clients.

## 9. Database Rules

- Inspect the existing database technology and schema before making changes.
- Use parameterized queries to prevent SQL injection.
- Handle database errors explicitly.
- Close rows and other resources properly.
- Check `rows.Err()` after iterating over database rows.
- Use transactions when multiple operations must succeed or fail together.
- Add migrations when schema changes are required.
- Never delete or modify production data without explicit authorization.

## 10. Security

- Never hard-code passwords, API keys, tokens, or private credentials.
- Load secrets from environment variables or an approved secret manager.
- Validate all untrusted input.
- Follow secure authentication and authorization practices.
- Avoid logging sensitive information.
- Do not disable TLS verification or weaken security checks to bypass errors.
- Review dependencies for known vulnerabilities when relevant.
- Never execute destructive commands without authorization.

## 11. Performance

- Prioritize correctness, readability, and maintainability.
- Avoid unnecessary memory allocations and repeated expensive operations.
- Do not optimize code based on guesses.
- Use benchmarks and profiling for performance-critical changes.
- Prevent memory leaks, goroutine leaks, and unbounded resource usage.
- Introduce caching only when necessary and define its invalidation behavior.

## 12. Testing

- Write tests for new features and bug fixes.
- Use Go's standard `testing` package unless the project requires another framework.
- Prefer table-driven tests for multiple related cases.
- Test normal behavior, error cases, edge cases, and invalid inputs.
- Keep tests deterministic and independent where possible.
- Do not remove or weaken tests simply to make them pass.
- Update existing tests when behavior changes.

Run these commands when applicable:

```bash
gofmt -w .
go vet ./...
go test ./...
```

For concurrency-related changes, consider:

```bash
go test -race ./...
```

Only report tests and checks as successful when they have actually been executed and passed.

## 13. Dependencies

- Prefer the Go standard library when sufficient.
- Check existing dependencies before adding new ones.
- Add third-party packages only when they provide a clear benefit.
- Keep `go.mod` and `go.sum` consistent.
- Do not upgrade unrelated dependencies unnecessarily.
- Explain significant dependency changes.

## 14. Configuration and Logging

- Keep configuration clear and maintainable.
- Validate required configuration at startup.
- Use safe defaults where appropriate.
- Never commit secret values or production credentials.
- Follow the project's existing logging conventions.
- Include useful debugging context without exposing sensitive data.
- Avoid excessive logging.

## 15. Documentation

- Update README documentation when setup or functionality changes.
- Document installation, configuration, environment variables, and execution commands.
- Provide accurate code examples.
- Keep comments and documentation consistent with the implementation.
- Never claim an incomplete feature is fully implemented.

## 16. Agent Workflow

For every task:

1. Understand the user's requirements.
2. Inspect relevant files and existing implementation.
3. Identify the smallest correct solution.
4. Implement the changes using idiomatic Go.
5. Add or update tests.
6. Run formatting, tests, and static checks when possible.
7. Review the changes for bugs, security issues, and unrelated modifications.
8. Summarize the changes and report actual test results.
9. Clearly disclose any limitations or checks that could not be completed.

## 17. Final Checklist

Before completing a task, verify:

- [ ] Code follows idiomatic Go conventions.
- [ ] Changed Go files are formatted.
- [ ] Errors are handled properly.
- [ ] Inputs and sensitive data are handled securely.
- [ ] Concurrency and resource cleanup are safe.
- [ ] Tests cover important behavior.
- [ ] Documentation is updated where necessary.
- [ ] No unrelated changes were introduced.
- [ ] Test results are reported honestly.

## Official Go Resources

- Go Documentation: https://go.dev/doc/
- Effective Go: https://go.dev/doc/effective_go
- Go Code Review Comments: https://go.dev/wiki/CodeReviewComments
- Go Standard Library: https://pkg.go.dev/std
- Go Security Guidance: https://go.dev/security/
