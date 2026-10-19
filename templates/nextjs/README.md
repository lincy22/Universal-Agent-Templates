# Next.js Agent Template

A reusable Next.js project template with structured instructions for AI coding agents. It helps developers maintain consistent coding standards, project structure, and development workflows.

## Overview

This template provides a foundation for building web applications using Next.js. It can be used with AI coding assistants to guide code generation, debugging, refactoring, and feature development.

## Features

- **Next.js Support** — Build modern React-based web applications.
- **TypeScript** — Write type-safe and maintainable code.
- **AI Agent Instructions** — Define rules and guidelines for AI coding assistants.
- **Reusable Template** — Use the same project structure and conventions across projects.
- **Code Quality** — Follow consistent naming conventions and coding practices.
- **Maintainable Architecture** — Organize components, pages, and application logic clearly.
- **Documentation** — Keep project instructions and development guidelines in Markdown files.

## Technology Stack

- Next.js
- React
- TypeScript
- JavaScript
- Node.js
- npm
- Git and GitHub

## Getting Started

### 1. Install Node.js

Download and install Node.js from:

https://nodejs.org/

Verify the installation:

```bash
node --version
npm --version
```

### 2. Create a Next.js Project

```bash
npx create-next-app@latest my-nextjs-app
```

### 3. Navigate to the Project

```bash
cd my-nextjs-app
```

### 4. Install Dependencies

```bash
npm install
```

### 5. Start the Development Server

```bash
npm run dev
```

Open the following URL in your browser:

http://localhost:3000

## AI Agent Guidelines

When working with this project, the AI coding agent should:

1. Read the existing project instructions before making changes.
2. Understand the existing folder structure and architecture.
3. Follow the project's current coding conventions.
4. Reuse existing components and utilities whenever possible.
5. Avoid unnecessary dependencies and duplicate code.
6. Use TypeScript types appropriately.
7. Handle errors and loading states correctly.
8. Preserve existing functionality when modifying code.
9. Run available linting and build checks after significant changes.
10. Update documentation when project behavior changes.

## Recommended Project Structure

```text
my-nextjs-app/
├── public/
├── src/
│   ├── app/
│   │   ├── layout.tsx
│   │   ├── page.tsx
│   │   └── globals.css
│   ├── components/
│   ├── lib/
│   └── types/
├── AGENTS.md
├── package.json
├── tsconfig.json
└── README.md
```

The exact structure depends on the project configuration. For example, `src/` is optional in Next.js.

## Useful Commands

| Command | Description |
|---|---|
| `npm run dev` | Start the development server |
| `npm run build` | Build the production application |
| `npm run start` | Start the production server |
| `npm run lint` | Run linting if configured |

## Best Practices

- Keep components small and reusable.
- Separate application logic from UI components.
- Use environment variables for secrets and configuration.
- Never commit API keys or passwords to GitHub.
- Validate user input and handle errors safely.
- Follow the official Next.js documentation for version-specific APIs.
- Test important features before deploying.

## Official Documentation

- Next.js: https://nextjs.org/docs
- React: https://react.dev/
- TypeScript: https://www.typescriptlang.org/docs/
- Node.js: https://nodejs.org/docs/

## License

Add the appropriate license information for your project.

---

**Note:** This is a general README template for a Next.js project with AI-agent instructions. It is not a verified copy of the README from the linked repository. Replace or adjust the details to match the actual template files.
