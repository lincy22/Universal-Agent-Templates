# Universal Agent Kit

> Standardized AI agent rules, coding instructions, and folder structure templates for multi-language projects.

Universal Agent Kit provides reusable AI agent instructions and project templates for **Flutter / Dart**, **React**, **Python**, **Node.js**, **Next.js**, **Java / Spring Boot**, and **Go**.

---

## 🌟 Key Features

- **Multi-Language Agent Templates:** Clean rules, security guardrails, and architectural guidelines for your tech stack.
- **Multi-AI Tool Support:** Export rules for **Google Antigravity**, **Cursor** (`.cursorrules`), **Windsurf** (`.windsurfrules`), **Claude Code** (`CLAUDE.md`), and **GitHub Copilot**.
- **Dart CLI Tool:** Install language-specific agent rules into your project using a single command.
- **AI Audit (`check`):** Verify that AI-generated code complies with your project's rules and security standards.

---

## 📁 Repository Structure

```text
Universal-Agent-Templates/
├── cli/                        # Dart CLI source code
│   ├── bin/                    # Binary entrypoints
│   ├── lib/                    # Core logic & commands
│   └── pubspec.yaml
├── templates/                  # Language & Framework Templates
│   ├── flutter/
│   ├── react/
│   ├── python/
│   ├── nextjs/
│   ├── nodejs/
│   ├── spring-boot/
│   └── go/
└── README.md
```

---

## 🛠️ Quick Start

### Installation via Dart CLI

```bash
# Activate locally from source
dart pub global activate --source path ./cli

# Or run directly
dart run cli/bin/universal_agent.dart init react
```

---

## 🤝 Contributing

Contributions for new language templates, AI tool exporters, and CLI features are welcome! Please open an issue or pull request.

License: MIT
