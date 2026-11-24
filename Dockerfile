# Stage 1: official xray image (scratch-based, no shell) - only for the binary
FROM teddysun/xray:26.11.9 AS xray

# Stage 2: Alpine with a shell
FROM alpine:3.21
RUN apk add --no-cache ca-certificates
COPY --from=xray /usr/bin/xray /usr/local/bin/xray
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh /usr/local/bin/xray

ENV PORT=3000
EXPOSE 3000
ENTRYPOINT ["/entrypoint.sh"]
