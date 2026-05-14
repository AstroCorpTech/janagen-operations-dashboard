# JANAGEN Operations Dashboard

A static, single-page operations dashboard. Staff upload an Excel sheet
(`.xlsx`) and the dashboard parses + visualises it entirely in the browser
(via [SheetJS / xlsx](https://github.com/SheetJS/sheetjs)). No data ever
leaves the client.

## Local preview

```sh
open index.html        # macOS
# or just drag index.html into any browser
```

## Production deploy (Coolify)

The repo ships with a `Dockerfile` and `nginx.conf` so Coolify can build and
serve it as a hardened static site behind HTTP basic auth.

### One-time Coolify setup

1. **Create application** → Source: GitHub → `AstroCorpTech/janagen-operations-dashboard`
2. **Build pack**: `Dockerfile` (Coolify auto-detects)
3. **Port**: `80`
4. **Environment Variables** (required — the container refuses to start without these):
   - `BASIC_AUTH_USER` — e.g. `janagen`
   - `BASIC_AUTH_PASS` — pick a strong shared password
5. **Healthcheck path**: `/health`
6. **Domain**: defer for now → use Coolify's auto-generated URL; attach a
   custom domain later via Coolify > Domains.

### Deploy

Push to `main` → Coolify auto-builds and rolls out (if auto-deploy is on).
Otherwise hit "Deploy" in the Coolify UI.

### Rotating the password

Change `BASIC_AUTH_PASS` in Coolify > Environment Variables → redeploy. The
htpasswd file is regenerated on every container start.

## What the nginx config does

- **Basic auth** on every path except `/health`
- **Security headers**: HSTS, X-Frame-Options DENY, no-sniff, no-referrer,
  Permissions-Policy lockdown, CSP whitelisting only cdnjs + Google Fonts,
  X-Robots-Tag noindex
- **Cache-Control: no-cache** on everything (the only asset is `index.html`,
  and we want updates to be immediate)
- **gzip** for text/JS/CSS/SVG over 1 KB
- **client_max_body_size 25m** (Excel uploads are client-side parsed, but
  this gives headroom for any future server endpoints)

## File map

| File | Purpose |
| --- | --- |
| `index.html` | The dashboard itself (single-page app, Excel-driven) |
| `Dockerfile` | nginx:alpine + apache2-utils + healthcheck |
| `nginx.conf` | Server config (auth, headers, gzip) |
| `docker-entrypoint.d/40-htpasswd.sh` | Generates htpasswd from env vars at boot |
| `.dockerignore` | Keeps build context lean |
