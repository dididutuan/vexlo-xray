#!/bin/sh
# Generate xray config from env vars and run it.
# Env vars (set in Vexlo Settings -> Environment, never in the repo):
#   XRAY_UUID - VLESS client id (required)
#   PORT      - container listen port (Vexlo routes to it, default 3000)
#   WS_PATH   - websocket path (default /<XRAY_UUID>)
set -e

PORT="${PORT:-3000}"
UUID="${XRAY_UUID:-}"
WS_PATH="${WS_PATH:-/$UUID}"

if [ -z "$UUID" ]; then
  echo "FATAL: XRAY_UUID is not set. Set it in Vexlo Settings -> Environment and redeploy." >&2
  exit 1
fi

cat > /etc/xray-config.json <<EOF
{
  "log": {"loglevel": "warning"},
  "inbounds": [
    {
      "port": $PORT,
      "protocol": "vless",
      "settings": {
        "clients": [{"id": "$UUID"}],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {"path": "$WS_PATH"}
      }
    }
  ],
  "outbounds": [{"protocol": "freedom"}]
}
EOF

echo "starting xray on port $PORT, ws path $WS_PATH"
exec /usr/local/bin/xray run -c /etc/xray-config.json
