FROM nginx:1.27-alpine

RUN apk add --no-cache apache2-utils curl

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY index.html /usr/share/nginx/html/index.html
COPY docker-entrypoint.d/40-htpasswd.sh /docker-entrypoint.d/40-htpasswd.sh
RUN chmod +x /docker-entrypoint.d/40-htpasswd.sh

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -fsS http://127.0.0.1/health || exit 1
