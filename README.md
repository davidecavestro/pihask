# pihask

A low-end Kiosk for HomeAssistant on Raspberry Pi 3 with an HDMI/USB touchscreen.

## Requirements

- Raspberry Pi 3 running Raspberry Pi OS
- Docker installed (see https://docs.docker.com/engine/install/debian/)

## How to build and run

Copy `.env.example` into `.env` and adapt it to your needs, then run
```bash
docker compose -f compose.yml -f compose.dev.yml up --build
```
