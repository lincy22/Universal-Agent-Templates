# Next.js App Router AI Agent Rules

## Core Principles
1. **App Router Conventions:** Utilize `app/` directory with Server Components by default. Use `'use client'` only when state/interactivity is required.
2. **Server Actions:** Use Server Actions for form submissions and mutations with input validation (Zod).
3. **SEO & Performance:** Export proper `metadata` objects on page routes. Use `next/image` and `next/font`.
4. **API Routes:** Keep Route Handlers in `app/api/` clean and validated.
