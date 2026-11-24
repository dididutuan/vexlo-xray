# vexlo-xray

xray (VLESS + WebSocket) for Vexlo, deployed from this public repo with
its Dockerfile. Vexlo terminates TLS at the edge and serves the app on
a `*.vexlo.app` (or similar) HTTPS address, so xray itself listens
plain WS inside the container.

## Files

- `Dockerfile` — multi-stage: copies the xray binary out of the
  official `teddysun/xray:26.11.9` image (scratch-based, no shell) into
  Alpine 3.21 with a shell.
- `entrypoint.sh` — generates `/etc/xray-config.json` from env vars
  and runs xray.

## Deploy (Vexlo console)

1. New application → connect this GitHub repository.
2. Region: Singapore. Environment: Production.
3. Settings → Environment, add:
   - `XRAY_UUID` = the node's UUID (generated per node, kept in the
     local credentials file, never committed).
   - `PORT` = `3000` (container listen port; Vexlo routes 443 → 3000).
4. Resources: keep inside the free Starter tier (0.5 vCPU / 512 MB RAM).
5. Deploy. The app gets an HTTPS address.

## Client (Shadowrocket)

```
vless://<UUID>@<host>:443?encryption=none&security=tls&sni=<host>&type=ws&path=%2F<UUID>#Vexlo-SG
```

Delivered to the user as a QR code only, never pasted as text.

## Acceptance

- Real client connects through the node: `generate_204` returns 204.
- Exit IP geolocation matches Singapore.
- Final check is always the user's own phone on Shadowrocket.
