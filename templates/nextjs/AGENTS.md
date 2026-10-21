# AGENTS.md — Next.js Project Instructions

## 1. Project Overview
- Build modern, responsive, accessible web applications using Next.js.
- Follow the existing project architecture and conventions.
- Inspect the repository before making any changes.
- Prefer simple, maintainable, reusable solutions.

## 2. Before Making Changes
- Read `README.md`, `package.json`, and relevant configuration files.
- Inspect the existing folder structure and installed dependencies.
- Identify the Next.js version, routing system, styling framework, and TypeScript configuration.
- Understand existing functionality before modifying files.
- If requirements are unclear, ask questions before making major changes.
- Present a short implementation plan for large changes.

## 3. Next.js Rules
- Follow the existing Next.js version and App Router or Pages Router architecture.
- Do not migrate routing systems unless explicitly requested.
- Use Server Components by default when using the App Router.
- Add `"use client"` only when client-side interactivity or browser APIs are needed.
- Use Next.js navigation utilities such as `next/link` and `next/navigation` where appropriate.
- Use the existing image optimization approach, including `next/image` when suitable.
- Follow the project's existing metadata and SEO conventions.
- Keep server-only code separate from client-side code.

## 4. TypeScript Rules
- Use TypeScript for new files when the project supports it.
- Define clear types and interfaces for component props and data.
- Avoid `any` unless absolutely necessary.
- Handle null, undefined, and unexpected API responses safely.
- Do not suppress TypeScript errors without a valid reason.

## 5. Project Structure
- Follow the existing folder structure.
- Keep routes, components, utilities, hooks, and services organized.
- Put shared UI elements in the existing components directory.
- Extract reusable logic when it improves maintainability.
- Avoid creating duplicate components or unnecessary files.
- Keep business logic separate from presentation where practical.
- Do not move or rename existing files unnecessarily.

## 6. UI and Styling
- Follow the existing design system, theme, and styling framework.
- Build responsive layouts for mobile, tablet, and desktop.
- Reuse existing components, design tokens, colors, and spacing.
- Maintain consistent typography, alignment, spacing, and visual hierarchy.
- Include loading, empty, success, and error states where relevant.
- Use semantic HTML and accessible form controls.
- Do not introduce a new UI library without checking existing dependencies and asking for approval when appropriate.

## 7. React Components
- Keep components focused and reusable.
- Use meaningful component, variable, and function names.
- Avoid unnecessary re-renders and premature optimization.
- Use React hooks according to their rules.
- Add appropriate keys when rendering lists.
- Keep effects and event handlers understandable.
- Avoid duplicating existing functionality.

## 8. API and Backend Integration
- Validate user input on the server when appropriate.
- Handle API failures, loading states, and invalid responses.
- Never expose secret keys, tokens, or private credentials.
- Keep private environment variables server-side.
- Use `NEXT_PUBLIC_` only for values intentionally exposed to the browser.
- Never trust client-side validation alone for security.
- Follow existing authentication and authorization patterns.
- Do not invent API endpoints or database schemas; inspect the existing implementation first.

## 9. Dependencies and Configuration
- Check `package.json` before installing packages.
- Prefer existing dependencies when they meet the requirements.
- Avoid unnecessary dependencies and breaking upgrades.
- Do not modify lockfiles manually.
- Do not overwrite environment files or project configuration without checking their contents.
- Never commit real secrets or credentials.

## 10. Error Handling and Security
- Handle errors gracefully and provide useful messages.
- Avoid logging passwords, tokens, or sensitive user data.
- Protect authenticated routes and sensitive server actions.
- Validate and sanitize untrusted input where appropriate.
- Follow least-privilege principles for permissions.
- Do not disable security checks merely to make a build pass.

## 11. Testing and Quality
- Inspect available scripts in `package.json`.
- Run relevant lint, type-check, test, and build commands when available.
- Add or update tests for important functionality when appropriate.
- Fix errors introduced by your changes.
- Do not claim tests passed unless they were actually executed successfully.
- Report any checks that could not be run.

## 12. Git Rules
- Do not overwrite unrelated user changes.
- Do not delete files without checking their purpose.
- Never run destructive Git commands without explicit approval.
- Do not commit or push changes unless requested.
- Keep changes focused on the requested task.

## 13. Working with Existing Code
- Preserve existing functionality unless a change is explicitly required.
- Follow existing naming conventions and coding patterns.
- Avoid unnecessary rewrites and large refactors.
- Reuse existing utilities, hooks, components, and services.
- Make the smallest reliable change that solves the problem.

## 14. Completion Report
After completing a task:
1. Summarize what changed.
2. List the files created or modified.
3. Explain important implementation decisions.
4. Report the checks and tests actually performed.
5. Mention remaining issues or limitations.
6. Provide instructions for running or verifying the changes.

## 15. General Principle
Prioritize correctness, security, accessibility, maintainability, and consistency with the existing project. Never assume a file, dependency, feature, or configuration exists without inspecting the repository first.
