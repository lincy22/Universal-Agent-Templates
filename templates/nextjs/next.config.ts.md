# next.config.ts — Complete Guide

## 1. Overview

The `next.config.ts` file is used to configure a Next.js application.

It allows developers to customize framework behavior, image optimization, redirects, rewrites, build settings, and other supported configuration options.

The file is written in TypeScript and uses the `NextConfig` type provided by Next.js.

Official documentation: https://nextjs.org/docs/app/api-reference/config/next-config-js

## 2. What Is next.config.ts?

The `next.config.ts` file is a project-level configuration file.

It is normally located in the root directory of a Next.js project, alongside `package.json`.

Example project structure:

```text
my-app/
├── app/
├── public/
├── package.json
├── tsconfig.json
├── next.config.ts
└── README.md
```

## 3. Basic Configuration

A basic `next.config.ts` file looks like this:

```typescript
import type { NextConfig } from 'next'

const nextConfig: NextConfig = {
  // Add supported Next.js configuration options here.
}

export default nextConfig
```

### Explanation

- `import type { NextConfig } from 'next'`: Imports the TypeScript type for Next.js configuration.
- `const nextConfig`: Defines the configuration object.
- `NextConfig`: Helps TypeScript validate supported configuration properties.
- `export default nextConfig`: Exports the configuration for Next.js to use.

No additional configuration options are required for a basic project.

## 4. Common Configuration Options

### 4.1 reactStrictMode

Controls React Strict Mode behavior in supported Next.js versions.

```typescript
import type { NextConfig } from 'next'

const nextConfig: NextConfig = {
  reactStrictMode: true,
}

export default nextConfig
```

Strict Mode helps identify certain potential problems during development.

### 4.2 poweredByHeader

Controls whether Next.js sends the `X-Powered-By` response header.

```typescript
const nextConfig = {
  poweredByHeader: false,
}

export default nextConfig
```

Disabling this header can reduce framework disclosure, but it is not a complete security solution.

### 4.3 trailingSlash

Controls whether generated page URLs use trailing slashes.

```typescript
const nextConfig = {
  trailingSlash: true,
}

export default nextConfig
```

For example, URLs may use `/about/` instead of `/about`.

Choose a consistent URL convention for your project.

### 4.4 basePath

Deploys the application under a URL prefix.

```typescript
const nextConfig = {
  basePath: '/dashboard',
}

export default nextConfig
```

The application can then be served under a path such as `/dashboard`.

Use this option only when your deployment requires a URL prefix.

## 5. Image Optimization

Next.js supports image optimization through the `next/image` component.

When using remote images, configure the permitted image sources.

Example:

```typescript
import type { NextConfig } from 'next'

const nextConfig: NextConfig = {
  images: {
    remotePatterns: [
      {
        protocol: 'https',
        hostname: 'images.example.com',
      },
    ],
  },
}

export default nextConfig
```

Replace `images.example.com` with the actual image host used by your application.

Best practices:
- Allow only required image hosts.
- Prefer optimized images.
- Provide appropriate image dimensions or layout behavior.
- Avoid unrestricted remote image access.

Official documentation: https://nextjs.org/docs/app/api-reference/components/image

## 6. Redirects

Redirects send visitors from one URL to another.

Example:

```typescript
import type { NextConfig } from 'next'

const nextConfig: NextConfig = {
  async redirects() {
    return [
      {
        source: '/old-page',
        destination: '/new-page',
        permanent: true,
      },
    ]
  },
}

export default nextConfig
```

Explanation:
- `source`: The original URL.
- `destination`: The destination URL.
- `permanent: true`: Creates a permanent redirect.
- `permanent: false`: Creates a temporary redirect.

Use redirects when changing page URLs or retiring old routes.

Official documentation: https://nextjs.org/docs/app/api-reference/config/next-config-js/redirects

## 7. Rewrites

Rewrites map an incoming URL to another destination without changing the URL shown in the browser.

Example:

```typescript
import type { NextConfig } from 'next'

const nextConfig: NextConfig = {
  async rewrites() {
    return [
      {
        source: '/api/external/:path*',
        destination: 'https://api.example.com/:path*',
      },
    ]
  },
}

export default nextConfig
```

Replace the example API host with the real service.

Important:
- Rewrites do not automatically provide authentication.
- They do not replace server-side input validation.
- Check the destination and security requirements before enabling a rewrite.

Official documentation: https://nextjs.org/docs/app/api-reference/config/next-config-js/rewrites

## 8. Environment Variables

Use environment variables for configuration that changes between development and production.

For example, store a private API endpoint or credential in an environment file when appropriate.

```text
.env.local
```

Example:

```bash
API_BASE_URL=https://api.example.com
```

Access a private environment variable from server-side code using:

```typescript
process.env.API_BASE_URL
```

Security rules:
- Never commit real secrets to GitHub.
- Keep `.env.local` out of version control.
- Do not use the `NEXT_PUBLIC_` prefix for secrets.
- Remember that `NEXT_PUBLIC_` variables may be exposed to the browser.
- Avoid putting secrets in the `next.config.ts` file.

Environment variables generally do not need to be declared in `next.config.ts` just to be read through `process.env`.

Official documentation: https://nextjs.org/docs/app/guides/environment-variables

## 9. Build Configuration

Next.js supports configuration options for controlling aspects of the build and deployment process.

For example, a custom build output directory can be configured using `distDir`.

```typescript
import type { NextConfig } from 'next'

const nextConfig: NextConfig = {
  distDir: 'build-output',
}

export default nextConfig
```

The default build directory is `.next`.

Change it only when there is a specific requirement, and ensure that your deployment setup supports the change.

## 10. TypeScript Configuration

Using the `NextConfig` type provides editor assistance and catches many invalid configuration values.

```typescript
import type { NextConfig } from 'next'

const nextConfig: NextConfig = {
  typedRoutes: true,
}

export default nextConfig
```

The `typedRoutes` option enables typed route support in compatible Next.js versions.

Next.js generates route type information during development or build processes.

Official documentation: https://nextjs.org/docs/app/api-reference/config/typescript

## 11. Complete Example

The following example combines several commonly used configuration options.

Review each option before adopting it in an existing project.

```typescript
import type { NextConfig } from 'next'

const nextConfig: NextConfig = {
  reactStrictMode: true,
  poweredByHeader: false,

  images: {
    remotePatterns: [
      {
        protocol: 'https',
        hostname: 'images.example.com',
      },
    ],
  },

  async redirects() {
    return [
      {
        source: '/old-page',
        destination: '/new-page',
        permanent: true,
      },
    ]
  },
}

export default nextConfig
```

This example:
- Enables React Strict Mode.
- Disables the `X-Powered-By` header.
- Allows remote images from a specified hostname.
- Redirects an old page to a new page.

The example image hostname and redirect route must be adapted to your project.

## 12. Common Mistakes

### Invalid configuration values

Use supported options and values for the installed Next.js version.

### Incorrect image hostname

Remote images may fail if their hostname is not allowed by the image configuration.

### Incorrect redirects

Check the source and destination paths before deployment.

### Exposing secrets

Never place credentials in browser-visible configuration.

### Changing configuration without testing

Review the configuration and run the available build checks after making changes.

## 13. Testing and Troubleshooting

From the project root, run:

```bash
npm run dev
```

For production build verification:

```bash
npm run build
```

Check the following if errors occur:
1. Confirm that `next.config.ts` is in the project root.
2. Check TypeScript syntax and configuration property names.
3. Confirm that options are supported by the installed Next.js version.
4. Review the terminal error message.
5. Revert unrelated configuration changes if necessary.

Do not claim that the configuration is valid until it has been checked against the actual project.

## 14. Best Practices

- Keep configuration simple.
- Use the `NextConfig` TypeScript type.
- Add options only when the application needs them.
- Restrict remote image hosts to trusted sources.
- Avoid exposing credentials.
- Keep deployment-specific settings documented.
- Check official documentation for version compatibility.
- Test configuration changes before deployment.
- Preserve existing configuration unless a change is required.

## 15. Official Resources

- Next.js configuration: https://nextjs.org/docs/app/api-reference/config/next-config-js
- Image optimization: https://nextjs.org/docs/app/api-reference/components/image
- Redirects: https://nextjs.org/docs/app/api-reference/config/next-config-js/redirects
- Rewrites: https://nextjs.org/docs/app/api-reference/config/next-config-js/rewrites
- TypeScript: https://nextjs.org/docs/app/api-reference/config/typescript
- Environment variables: https://nextjs.org/docs/app/guides/environment-variables

## 16. Summary

The `next.config.ts` file controls supported Next.js framework settings.

It can configure image sources, redirects, rewrites, build behavior, and other framework features.

Use only the options required by your application, check compatibility with the installed Next.js version, and test configuration changes before deployment.
