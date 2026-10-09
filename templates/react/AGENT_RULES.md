# React (TypeScript) AI Agent Rules & Guidelines

## Core Principles
1. **TypeScript First:** Use strict TypeScript. Avoid `any` at all costs. Define clean interfaces/types for component props.
2. **Functional Components:** Write functional components with hooks.
3. **State Management:** Keep state local when possible. Use Zustand or Redux Toolkit for global application state.
4. **Clean Components:** Keep components modular and single-responsibility.

## Recommended Structure
```text
src/
├── components/
│   ├── ui/
│   └── common/
├── hooks/
├── services/
├── store/
├── types/
└── App.tsx
```

## Security Guardrails
- Sanitize user inputs to prevent XSS vulnerabilities.
- Use `.env` variables prefixed with `VITE_` or `REACT_APP_` for public config only; never put secret keys in frontend code.
