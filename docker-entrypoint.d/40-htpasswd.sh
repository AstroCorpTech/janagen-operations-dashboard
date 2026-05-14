#!/bin/sh
# Generates /etc/nginx/.htpasswd from BASIC_AUTH_USER and BASIC_AUTH_PASS at
# container start. Fails fast if missing — refuses to expose the dashboard
# without auth.
set -e

if [ -z "${BASIC_AUTH_USER:-}" ] || [ -z "${BASIC_AUTH_PASS:-}" ]; then
    echo "[entrypoint] FATAL: BASIC_AUTH_USER and BASIC_AUTH_PASS env vars are required." >&2
    echo "[entrypoint] Set them in Coolify > Environment Variables before deploying." >&2
    exit 1
fi

htpasswd -bc /etc/nginx/.htpasswd "$BASIC_AUTH_USER" "$BASIC_AUTH_PASS" >/dev/null
chmod 644 /etc/nginx/.htpasswd
echo "[entrypoint] htpasswd generated for user '$BASIC_AUTH_USER'"
