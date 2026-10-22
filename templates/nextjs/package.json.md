# package.json — Complete Guide

## 1. Overview

The `package.json` file is an essential configuration file in JavaScript and Next.js projects. It defines project metadata, dependencies, development tools, npm scripts, and other package settings.

This guide explains the purpose of `package.json` and how to configure it for a Next.js application.

## 2. What Is package.json?

The `package.json` file describes a Node.js project and its dependencies.

It helps developers:
- Manage project dependencies.
- Define development and production commands.
- Configure project metadata.
- Maintain consistent development workflows.
- Share project configuration with other developers.

Official documentation: https://docs.npmjs.com/cli/configuring-npm/package-json

## 3. Basic Structure

A typical Next.js project may contain the following fields:

```json
{
  "name": "nextjs-template",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start"
  },
  "dependencies": {},
  "devDependencies": {}
}
```

This is an illustrative example. Actual dependencies and scripts depend on the project configuration.

## 4. Important Fields

### name

Specifies the package name.

Example:

```json
"name": "nextjs-template"
```

### version

Specifies the current project version.

Example:

```json
"version": "1.0.0"
```

### private

Prevents accidental publication of the package to the npm registry when set to `true`.

Example:

```json
"private": true
```

### scripts

Defines commands that developers can run using npm.

Example:

```json
"scripts": {
  "dev": "next dev",
  "build": "next build",
  "start": "next start"
}
```

### dependencies

Contains packages required by the application at runtime.

Examples include Next.js, React, and React DOM.

### devDependencies

Contains development tools such as TypeScript, ESLint, and type definitions.

The exact distinction depends on how the project and deployment environment are configured.

## 5. Common Next.js Commands

| Command | Description |
|---|---|
| `npm install` | Install project dependencies |
| `npm run dev` | Start the development server |
| `npm run build` | Create a production build |
| `npm run start` | Start the production server after building |
| `npm run lint` | Run the configured lint script, if available |
| `npm run typecheck` | Run the configured TypeScript check, if available |

Note: A command can only be executed through `npm run` if the corresponding script is defined in `package.json`, except for npm's built-in shortcuts.

## 6. Dependencies vs devDependencies

### dependencies

These are packages needed by the application during runtime.

Examples:
- `next`
- `react`
- `react-dom`

### devDependencies

These are packages primarily used for development, type checking, linting, and testing.

Examples:
- `typescript`
- `eslint`
- `@types/node`

Install a runtime dependency:

```bash
npm install package-name
```

Install a development dependency:

```bash
npm install -D package-name
```

## 7. Version Numbers

Package versions commonly use Semantic Versioning:

`MAJOR.MINOR.PATCH`

For example:

`2.4.1`

- MAJOR: Potentially breaking changes.
- MINOR: Backward-compatible features.
- PATCH: Backward-compatible bug fixes.

Version range prefixes such as `^` and `~` affect which package versions npm may install. Always review compatibility before changing dependency versions.

## 8. package-lock.json

The `package-lock.json` file records the resolved dependency tree.

It helps keep dependency installations consistent across development and deployment environments.

Best practices:
- Commit `package-lock.json` for npm projects.
- Update dependencies using npm commands.
- Avoid manually editing the lockfile.
- Use `npm ci` in appropriate automated build environments.

## 9. Best Practices

1. Keep project metadata accurate.
2. Avoid installing unnecessary dependencies.
3. Use compatible Next.js and React versions.
4. Review package updates before upgrading.
5. Keep npm scripts clear and predictable.
6. Commit the package lockfile.
7. Never store passwords, API keys, or private tokens in `package.json`.
8. Inspect existing scripts before replacing them.
9. Run the available checks before submitting changes.
10. Document custom scripts and configuration.

## 10. Troubleshooting

### Dependency installation fails

Try checking the Node.js and npm versions:

```bash
node --version
npm --version
```

Then review the error message and the project's supported versions.

### A script is missing

Inspect the `scripts` section of `package.json`. Add a script only when the corresponding tool and command are configured correctly.

### Dependency conflicts

Check package compatibility and review the error output before upgrading or downgrading packages.

Avoid deleting the lockfile as a first troubleshooting step.

## 11. Recommended Workflow

1. Inspect the existing `package.json`.
2. Review installed dependencies and available scripts.
3. Make the smallest necessary configuration change.
4. Run `npm install` when dependencies change.
5. Run linting, type checking, tests, and production build checks when available.
6. Review the changes before committing them to GitHub.

## 12. Official Resources

- npm package.json documentation: https://docs.npmjs.com/cli/configuring-npm/package-json
- npm scripts documentation: https://docs.npmjs.com/cli/using-npm/scripts
- Next.js documentation: https://nextjs.org/docs
- Node.js documentation: https://nodejs.org/docs/

## 13. Summary

The `package.json` file manages project metadata, dependencies, and npm scripts. Understanding this file makes it easier to maintain, debug, develop, and deploy JavaScript and Next.js applications.
