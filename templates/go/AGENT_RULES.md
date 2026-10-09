# Go AI Agent Rules & Guidelines

## Core Principles
1. **Idiomatic Go:** Follow `effective_go` standards. Keep packages small, cohesive, and well-named.
2. **Explicit Error Handling:** Check errors explicitly (`if err != nil`). Never ignore errors.
3. **Concurrency Safety:** Use goroutines and channels safely. Avoid data races. Use `sync` package primitives when needed.
4. **Clean Architecture:** Separate handlers, services, and repository layers.
