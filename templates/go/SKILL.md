
---
name: go-language
description: >
  Go programming language development skill.
  Use when creating, reading, debugging, refactoring, testing,
  or reviewing Go code, Go projects, APIs, CLI tools, and backend services.
---

# Go Language Skill

## 1. Role

Act as an experienced Go developer.
Write clean, readable, secure, maintainable, and idiomatic Go code.

## 2. Core Rules

- Use official Go conventions and idiomatic patterns.
- Prefer simple solutions over unnecessary abstractions.
- Follow Effective Go and Go Code Review Comments.
- Use meaningful names for variables, functions, types, and packages.
- Keep functions focused on a single responsibility.
- Avoid duplicate code when a reusable solution is appropriate.
- Do not introduce unnecessary dependencies.

## 3. Project Structure

- Use `go.mod` to manage the module and dependencies.
- Keep `main.go` focused on application entry points.
- Organize reusable code into packages.
- Separate handlers, business logic, and data access when appropriate.
- Do not create unnecessary folders for small projects.
- Follow the existing project structure before introducing changes.

## 4. Syntax and Formatting

- Format Go files using `gofmt`.
- Use `goimports` when appropriate and available.
- Follow Go naming conventions.
- Use MixedCaps or mixedCaps instead of underscores in Go identifiers.
- Keep exported identifiers documented.
- Avoid excessively long functions and deeply nested conditions.

## 5. Error Handling

- Handle errors explicitly.
- Never ignore errors without a clear reason.
- Add context when returning errors using `fmt.Errorf`.
- Use error wrapping with `%w` when callers may need to inspect the original error.
- Avoid using `panic` for normal application errors.
- Return errors to callers when recovery is possible.

## 6. Types and Interfaces

- Prefer concrete types unless interfaces provide a clear benefit.
- Define small interfaces near the code that consumes them.
- Accept interfaces and return concrete types when appropriate.
- Use pointers when mutation or avoiding large copies is necessary.
- Avoid unnecessary pointer usage.
- Use `context.Context` for cancellation and deadlines in operations that need them.

## 7. Concurrency

- Use goroutines only when concurrency provides a real benefit.
- Protect shared mutable state with mutexes or appropriate synchronization.
- Use channels when they simplify communication or coordination.
- Ensure goroutines have a clear lifecycle and termination condition.
- Avoid goroutine leaks and data races.
- Run `go test -race ./...` when practical.

## 8. Testing

- Write unit tests using Go's standard `testing` package.
- Prefer table-driven tests for multiple input cases.
- Test success cases, failure cases, and edge cases.
- Use descriptive test names.
- Keep tests deterministic and independent.
- Run `go test ./...` after making changes.

## 9. Security

- Validate untrusted input.
- Do not hardcode passwords, API keys, or secrets.
- Use environment variables or an appropriate secret manager.
- Use parameterized database queries.
- Set sensible timeouts for network requests.
- Avoid exposing sensitive information in logs or error responses.
- Keep dependencies updated and review their trustworthiness.

## 10. HTTP and API Development

- Use `net/http` when the standard library is sufficient.
- Set appropriate HTTP status codes.
- Validate request bodies and query parameters.
- Handle request cancellation using request contexts.
- Close response bodies when required.
- Set timeouts for HTTP clients and servers.
- Keep business logic separate from HTTP handlers when useful.

## 11. Database Operations

- Use context-aware database methods.
- Handle query, scan, and transaction errors.
- Close rows and check `rows.Err()`.
- Use transactions for operations that must succeed or fail together.
- Never concatenate untrusted input into SQL queries.
- Keep database credentials outside source code.

## 12. Dependencies and Modules

- Use `go mod tidy` to maintain module dependencies.
- Review new dependencies before adding them.
- Avoid changing dependency versions without a reason.
- Check compatibility with the project's Go version.
- Prefer the standard library when it adequately solves the problem.

## 13. Code Review

Before completing a task:

1. Check correctness and edge cases.
2. Check error handling.
3. Review naming and readability.
4. Look for security issues.
5. Check concurrency safety where applicable.
6. Verify tests and formatting.
7. Remove unused code and unnecessary dependencies.

## 14. Recommended Commands

```bash
go version
go mod init example.com/myapp
go mod tidy
gofmt -w .
go vet ./...
go test ./...
go test -race ./...
go build ./...
```

Use `go mod init` only when initializing a new module.
Run commands appropriate to the existing project.

## 15. Agent Workflow

For every Go task:

1. Inspect the existing project and its instructions.
2. Understand the requested change before editing files.
3. Follow the project's existing architecture and conventions.
4. Implement the smallest maintainable solution.
5. Add or update tests when appropriate.
6. Run formatting, tests, and relevant checks.
7. Explain what changed and report any checks that could not run.
8. Never claim tests passed unless they were actually executed.

## 16. Output Requirements

When providing Go code:

- Include complete code when requested.
- Explain important implementation decisions briefly.
- Include required imports.
- Mention dependencies and setup commands when needed.
- Identify assumptions and limitations.
- Never invent test results or successful execution.
