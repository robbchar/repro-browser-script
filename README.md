# Storybook v10 `BROWSER` script / `xdg-open` ENOENT repro

Minimal reproduction for [storybookjs/storybook#32949](https://github.com/storybookjs/storybook/issues/32949): Storybook v10 crashes on startup when `BROWSER` points to a shell script and `xdg-open` is missing. The `BROWSER` script is ignored and Storybook attempts to spawn `xdg-open`, resulting in `spawn xdg-open ENOENT`.

## Prereqs
- Node 22 (see `.nvmrc`). The issue also reproduces on Node 24 (as in the linked report).
- A Linux environment **without** `xdg-open` (i.e., without `xdg-utils`). The easiest path is a clean `node:22-bullseye` container.

## Quickstart (Docker, recommended)
```bash
docker run -it node:22-bullseye bash

# Inside the container:
apt-get update && apt-get purge -y xdg-utils || true   # ensure no xdg-open
corepack enable || true                                # optional, harmless

git clone https://github.com/robbchar/repro-browser-script
cd repro-browser-script
npm ci
./scripts/run-repro.sh
```

## Expected result
- Storybook crashes immediately with `Error: spawn xdg-open ENOENT`.
- The `scripts/open-browser.sh` helper is **not** invoked (check `/tmp/browser-invocations.log` stays empty).

## How this repro is wired
- `scripts/open-browser.sh` is a simple shell script that logs its invocations.
- `scripts/run-repro.sh` sets `BROWSER` to that script and disables telemetry, then runs `npm run storybook`.
- If `xdg-open` is installed, you may not see the crash. Remove `xdg-utils` (or use the Docker flow above) to trigger it.

## For CodeSpaces:
To make sure xdg-utils is not there:

#### fix the apt lists dir if needed
```bash
sudo rm -rf /var/lib/apt/lists/*
sudo mkdir -p /var/lib/apt/lists/partial
```

#### refresh and remove xdg-utils (xdg-open)
```bash
sudo apt-get clean
sudo apt-get update
sudo apt-get purge -y xdg-utils
```

