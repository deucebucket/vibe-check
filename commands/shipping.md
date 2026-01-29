# Shipping Check - Deployment Security Audit

**Run this BEFORE deploying to production.** This catches the config and deployment issues that code review misses.

These are the exact vulnerabilities found in 1/3 of vibe-coded apps audited in the wild. Source maps leaking full source code. Supabase RLS "enabled" but wide open. Admin routes accessible to anyone who can type /admin.

---

## The Deployment Blind Spot

Code review catches code bugs. This catches **deployment bugs**:
- Your code is secure, but your build config leaks source maps
- Your auth logic is solid, but your RLS policy says "allow all"
- Your admin check works, but there's no middleware on the route
- Your secrets are in .env, but they're also in the JS bundle

**These issues are invisible in dev and catastrophic in prod.**

---

## Part 1: Source Map Exposure (Most Common)

Source maps let anyone see your full, unminified source code. Comments, file structure, API routes you haven't linked yet - all public.

### Check for Source Maps

```bash
# Check if source maps exist in build output
find . -name "*.map" -path "*/dist/*" -o -name "*.map" -path "*/build/*" -o -name "*.map" -path "*/.next/*" 2>/dev/null

# Check if source maps are referenced in JS files
grep -r "sourceMappingURL" dist/ build/ .next/ 2>/dev/null | head -20

# For a deployed site, check if maps are accessible
curl -s "https://YOUR-SITE.com/path/to/bundle.js.map" | head -c 200
```

### Framework-Specific Fixes

**Next.js** (`next.config.js`):
```javascript
module.exports = {
  productionBrowserSourceMaps: false, // DEFAULT IS TRUE!
}
```

**Vite** (`vite.config.js`):
```javascript
export default {
  build: {
    sourcemap: false, // or 'hidden' for error tracking only
  }
}
```

**Create React App**:
```bash
# In package.json scripts
"build": "GENERATE_SOURCEMAP=false react-scripts build"
```

**Webpack**:
```javascript
module.exports = {
  devtool: false, // In production config
}
```

### Verdict
- [ ] No .map files in production build
- [ ] No sourceMappingURL comments in production JS
- [ ] Source maps not accessible via direct URL

---

## Part 2: Supabase RLS Misconfiguration

Row Level Security "on" but empty is worse than no RLS - it gives false confidence.

### Common Dangerous Patterns

```sql
-- DANGEROUS: Allows everyone to read everything
CREATE POLICY "public_read" ON users
FOR SELECT USING (true);

-- DANGEROUS: Allows authenticated users to do anything
CREATE POLICY "auth_all" ON users
FOR ALL USING (auth.role() = 'authenticated');

-- DANGEROUS: No policy at all (with RLS enabled = no access, but often disabled)
-- Check if RLS is actually enabled!
```

### Check Your Policies

```sql
-- List all tables and their RLS status
SELECT schemaname, tablename, rowsecurity
FROM pg_tables
WHERE schemaname = 'public';

-- List all policies
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual
FROM pg_policies
WHERE schemaname = 'public';

-- Find tables with RLS enabled but no policies (DANGER!)
SELECT t.tablename
FROM pg_tables t
LEFT JOIN pg_policies p ON t.tablename = p.tablename
WHERE t.schemaname = 'public'
  AND t.rowsecurity = true
  AND p.policyname IS NULL;
```

### Test Your RLS (Critical!)

```javascript
// Test with anon key (what attackers have)
const { data, error } = await supabase
  .from('users')
  .select('*')

// If this returns ALL users, your RLS is broken
console.log('Anon can see:', data?.length, 'users')

// Test cross-user access
const { data: otherUser } = await supabase
  .from('user_data')
  .select('*')
  .eq('user_id', 'not-my-id')

// If this returns data, you have an IDOR vulnerability
```

### Secure Policy Examples

```sql
-- Users can only read their own data
CREATE POLICY "users_read_own" ON user_data
FOR SELECT USING (auth.uid() = user_id);

-- Users can only modify their own data
CREATE POLICY "users_modify_own" ON user_data
FOR ALL USING (auth.uid() = user_id);

-- Public read, but only for published items
CREATE POLICY "public_read_published" ON posts
FOR SELECT USING (published = true);

-- Only owners can modify their posts
CREATE POLICY "owners_modify" ON posts
FOR UPDATE USING (auth.uid() = author_id);
```

### Verdict
- [ ] RLS enabled on all sensitive tables
- [ ] Every table with RLS has appropriate policies
- [ ] Policies restrict by user ID, not just auth status
- [ ] Tested with anon key - can't access other users' data
- [ ] No "USING (true)" policies on sensitive data

---

## Part 3: Unprotected Routes

Hiding the "Admin" button doesn't protect the /admin route.

### The Problem

```javascript
// This is NOT security - it's just hiding a button
{user.isAdmin && <Link to="/admin">Admin</Link>}

// Anyone can still type: yoursite.com/admin
```

### Check Your Routes

**Next.js** - Check for middleware:
```typescript
// middleware.ts should exist and protect routes
export function middleware(request: NextRequest) {
  // If /admin routes aren't checked here, they're unprotected
}

export const config = {
  matcher: ['/admin/:path*', '/dashboard/:path*']
}
```

**Check what happens without auth:**
```bash
# Try accessing protected routes directly
curl -s "https://YOUR-SITE.com/admin" -o /dev/null -w "%{http_code}"
curl -s "https://YOUR-SITE.com/dashboard" -o /dev/null -w "%{http_code}"
curl -s "https://YOUR-SITE.com/api/admin/users" -o /dev/null -w "%{http_code}"

# 200 = BAD (accessible)
# 401/403 = GOOD (blocked)
# 302 to /login = GOOD (redirect)
```

### Common Unprotected Routes to Check

```
/admin
/dashboard
/settings
/api/admin/*
/api/internal/*
/api/users (listing all users)
/_next/data/* (Next.js data routes)
/graphql (introspection enabled?)
```

### Proper Route Protection

**Next.js Middleware:**
```typescript
import { NextResponse } from 'next/server'
import type { NextRequest } from 'next/server'

export function middleware(request: NextRequest) {
  const session = request.cookies.get('session')

  if (request.nextUrl.pathname.startsWith('/admin')) {
    if (!session) {
      return NextResponse.redirect(new URL('/login', request.url))
    }
    // Also verify admin role server-side!
  }
}
```

**API Route Protection:**
```typescript
// Every admin API route needs this
export async function GET(request: Request) {
  const session = await getSession()
  if (!session?.user?.role === 'admin') {
    return new Response('Unauthorized', { status: 403 })
  }
  // ... actual logic
}
```

### Verdict
- [ ] Middleware protects all sensitive routes
- [ ] API routes verify auth server-side
- [ ] Admin routes verify admin ROLE, not just auth
- [ ] Direct URL access returns 401/403, not 200
- [ ] GraphQL introspection disabled in production

---

## Part 4: HTTP Security Headers

Missing headers = missing protection. Browsers have built-in security features you're not using.

### Check Current Headers

```bash
# Check headers on your deployed site
curl -I https://YOUR-SITE.com 2>/dev/null | grep -iE "strict-transport|content-security|x-frame|x-content-type"
```

### Required Headers

| Header | Purpose | If Missing |
|--------|---------|------------|
| `Strict-Transport-Security` | Force HTTPS | Downgrade attacks possible |
| `Content-Security-Policy` | Control resource loading | XSS attacks easier |
| `X-Frame-Options` | Prevent clickjacking | Site can be embedded in malicious iframes |
| `X-Content-Type-Options` | Prevent MIME sniffing | Browser may execute files incorrectly |

### Minimal Secure Headers

**Next.js** (`next.config.js`):
```javascript
module.exports = {
  async headers() {
    return [
      {
        source: '/:path*',
        headers: [
          { key: 'X-Frame-Options', value: 'DENY' },
          { key: 'X-Content-Type-Options', value: 'nosniff' },
          { key: 'Strict-Transport-Security', value: 'max-age=31536000; includeSubDomains' },
          { key: 'Content-Security-Policy', value: "default-src 'self'; script-src 'self' 'unsafe-inline'" },
        ],
      },
    ]
  },
}
```

**Vercel** (`vercel.json`):
```json
{
  "headers": [
    {
      "source": "/:path*",
      "headers": [
        { "key": "X-Frame-Options", "value": "DENY" },
        { "key": "X-Content-Type-Options", "value": "nosniff" },
        { "key": "Strict-Transport-Security", "value": "max-age=31536000" }
      ]
    }
  ]
}
```

### Verdict
- [ ] HSTS header present
- [ ] X-Frame-Options set (DENY or SAMEORIGIN)
- [ ] X-Content-Type-Options: nosniff
- [ ] CSP header present (even basic)

---

## Part 5: Exposed Secrets in Frontend

The browser downloads your JS. Anything in that JS is public.

### What Should NEVER Be in Frontend Code

- Database connection strings
- API keys with write access
- Admin credentials
- Private keys
- Internal service URLs
- Webhook secrets

### What's OK in Frontend (By Design)

- Supabase anon key (designed to be public, RLS protects data)
- Stripe publishable key (pk_)
- Public API keys (read-only, rate-limited)

### Check for Exposed Secrets

```bash
# Search built JS for common secret patterns
grep -r "sk_live\|sk_test" dist/ build/ .next/ 2>/dev/null  # Stripe secret
grep -r "password\|secret\|private" dist/ build/ .next/ --include="*.js" 2>/dev/null | head -20
grep -r "mongodb://\|postgres://\|mysql://" dist/ build/ .next/ 2>/dev/null  # DB strings

# Check for .env values that leaked into build
grep -r "process\.env\." dist/ build/ .next/ --include="*.js" 2>/dev/null | head -20
```

### Framework-Specific Checks

**Next.js**: Only `NEXT_PUBLIC_*` vars should appear in browser JS
```bash
# Find non-public env vars in client bundle
grep -r "process.env" .next/static/ 2>/dev/null
```

**Vite**: Only `VITE_*` vars are exposed
```bash
grep -r "import.meta.env" dist/ 2>/dev/null
```

### Verdict
- [ ] No secret keys in frontend bundles
- [ ] No database URLs in frontend code
- [ ] No internal service URLs exposed
- [ ] Only intended public keys present
- [ ] .env.example doesn't contain real values

---

## Part 6: Rate Limiting

No rate limiting = bots can hammer your API forever.

### Check for Rate Limiting

```bash
# Hammer an endpoint and see what happens
for i in {1..100}; do
  curl -s -o /dev/null -w "%{http_code}\n" "https://YOUR-SITE.com/api/endpoint"
done | sort | uniq -c

# If all 100 return 200, you have no rate limiting
# Should see 429 (Too Many Requests) after threshold
```

### Critical Endpoints That NEED Rate Limiting

- `/api/auth/login` - Prevent brute force
- `/api/auth/register` - Prevent spam accounts
- `/api/auth/forgot-password` - Prevent email bombing
- `/api/contact` - Prevent spam
- Any endpoint that sends email
- Any endpoint that costs you money (AI, SMS, etc.)

### Basic Rate Limiting

**Vercel** (Edge Config or KV):
```typescript
import { Ratelimit } from '@upstash/ratelimit'
import { kv } from '@vercel/kv'

const ratelimit = new Ratelimit({
  redis: kv,
  limiter: Ratelimit.slidingWindow(10, '10 s'), // 10 requests per 10 seconds
})

export async function POST(request: Request) {
  const ip = request.headers.get('x-forwarded-for') ?? 'anonymous'
  const { success } = await ratelimit.limit(ip)

  if (!success) {
    return new Response('Too many requests', { status: 429 })
  }
  // ... actual logic
}
```

### Verdict
- [ ] Auth endpoints have rate limiting
- [ ] Contact/email endpoints have rate limiting
- [ ] Expensive operations have rate limiting
- [ ] 429 responses returned when limit exceeded

---

## Part 7: Debug/Dev Features in Production

Debug endpoints are goldmines for attackers.

### Common Debug Leaks

```bash
# Check for common debug endpoints
curl -s "https://YOUR-SITE.com/api/debug" -w "%{http_code}"
curl -s "https://YOUR-SITE.com/api/health" -w "%{http_code}"  # OK if limited info
curl -s "https://YOUR-SITE.com/_debug" -w "%{http_code}"
curl -s "https://YOUR-SITE.com/graphql" -d '{"query":"{ __schema { types { name } } }"}' # Introspection

# Check for exposed error details
curl -s "https://YOUR-SITE.com/api/nonexistent" | head -20  # Should NOT show stack traces
```

### What to Check

- [ ] No /debug or /test endpoints accessible
- [ ] Error responses don't include stack traces
- [ ] GraphQL introspection disabled
- [ ] No verbose logging to browser console
- [ ] React/Vue devtools hints removed from production build

---

## Quick Shipping Checklist

Run through this before every production deploy:

### Source Maps
- [ ] `productionBrowserSourceMaps: false` (Next.js)
- [ ] No .map files served
- [ ] No sourceMappingURL in production JS

### Database Security
- [ ] RLS enabled on sensitive tables
- [ ] RLS policies actually restrict access
- [ ] Tested with anon key - can't see other users' data

### Route Protection
- [ ] Middleware protects /admin, /dashboard, etc.
- [ ] API routes verify auth server-side
- [ ] Direct URL access blocked (401/403)

### Headers
- [ ] HSTS enabled
- [ ] X-Frame-Options set
- [ ] CSP header present

### Secrets
- [ ] No secret keys in frontend JS
- [ ] Only NEXT_PUBLIC_/VITE_ vars in browser

### Rate Limiting
- [ ] Auth endpoints protected
- [ ] Email-sending endpoints protected

### Debug
- [ ] No debug endpoints accessible
- [ ] No stack traces in errors
- [ ] GraphQL introspection disabled

---

## Output Format

```
## Shipping Security Check

### Source Maps: [PASS/FAIL]
[Details]

### Supabase RLS: [PASS/FAIL/N/A]
[Details]

### Route Protection: [PASS/FAIL]
[Details]

### Security Headers: [PASS/FAIL]
- HSTS: [Present/Missing]
- X-Frame-Options: [Present/Missing]
- CSP: [Present/Missing]
- X-Content-Type-Options: [Present/Missing]

### Exposed Secrets: [PASS/FAIL]
[Details]

### Rate Limiting: [PASS/FAIL]
[Details]

### Debug Endpoints: [PASS/FAIL]
[Details]

### Overall: [READY TO SHIP / FIX BEFORE SHIPPING]

### Required Fixes
1. [Critical issues]
2. [High priority]
3. [Should fix]
```

---

## Remember

These aren't edge cases. These are the exact issues found in **1 out of every 3 vibe-coded apps** audited in the wild.

- Source maps expose your entire codebase
- Empty RLS policies are worse than no RLS
- Hidden buttons aren't protected routes
- The browser downloads and exposes your frontend code
- Bots will find unprotected endpoints

**Your code review passed. Now check your deployment.**
