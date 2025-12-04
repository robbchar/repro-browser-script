#!/usr/bin/env sh
set -eu

echo "BROWSER script invoked with: $@" >&2
printf '%s %s\n' "$(date -Iseconds)" "$*" >> /tmp/browser-invocations.log

