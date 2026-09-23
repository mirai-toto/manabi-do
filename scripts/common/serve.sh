#!/usr/bin/env bash
# Serves a directory over HTTP and waits until it actually answers.
#
#   source "$(dirname "$0")/../common/serve.sh"
#   serve_dir "$APP/build/web" 8767
#
# Two things this gets right that the inline copies did not:
#
#   * `setsid` plus a redirected stdin, so the server outlives the shell that
#     started it. `nohup ... &` alone gets reaped when a tool call returns.
#   * Polling with curl instead of `sleep 1`, so a slow start is waited out and
#     a failed start is reported rather than silently returning success.
#
# Killing by port is deliberately tolerant: `pkill` is blocked outright in some
# sandboxes and returns a misleading exit code, so its failure is ignored.

serve_dir() {
  local dir="${1:?directory required}"
  local port="${2:-8767}"
  local bind="${3:-127.0.0.1}"

  pkill -f "http.server $port" 2>/dev/null || true

  setsid nohup python3 -m http.server "$port" --bind "$bind" \
    --directory "$dir" > "/tmp/serve-$port.log" 2>&1 < /dev/null &
  disown

  for _ in $(seq 1 20); do
    if curl -sf -o /dev/null "http://localhost:$port/"; then
      echo "✓ serving $dir at http://localhost:$port"
      return 0
    fi
    sleep 0.5
  done

  echo "✗ nothing answering on port $port — see /tmp/serve-$port.log" >&2
  return 1
}
