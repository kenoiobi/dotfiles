#!/usr/bin/env bash
# Toggle region screen record for Hyprland (Meta+Del).
# First press: slurp → record to ~/Videos. Second press: stop (SIGINT, clean file end).
# Needs: wf-recorder, slurp. Optional: notify-send (libnotify-bin)

set -euo pipefail

PIDFILE="${XDG_RUNTIME_DIR:-/tmp}/hypr-screenrecord.pid"
OUTDIR="${HOME}/Videos"
mkdir -p "$OUTDIR"

notify() {
	if command -v notify-send >/dev/null 2>&1; then
		notify-send -a "Screen record" "$1" "${2:-}"
	fi
}

if [[ -f "$PIDFILE" ]]; then
	pid="$(cat "$PIDFILE" 2>/dev/null || true)"
	if [[ -n "${pid}" ]] && kill -0 "${pid}" 2>/dev/null; then
		kill -INT "${pid}" 2>/dev/null || true
		rm -f "$PIDFILE"
		notify "Recording stopped"
		exit 0
	fi
	rm -f "$PIDFILE"
fi

if ! command -v wf-recorder >/dev/null 2>&1; then
	notify "Missing wf-recorder" "sudo apt install wf-recorder"
	exit 1
fi
if ! command -v slurp >/dev/null 2>&1; then
	notify "Missing slurp" "sudo apt install slurp"
	exit 1
fi

geom="$(slurp)" || exit 0
out="${OUTDIR}/record-$(date +%Y%m%d-%H%M%S).mp4"

log="${XDG_CACHE_HOME:-${HOME}/.cache}/hypr-record.log"
mkdir -p "$(dirname "${log}")"

# .mp4 → MP4 muxer; -x yuv420p is widely compatible for players / editors
wf-recorder -g "${geom}" -f "${out}" -x yuv420p >>"${log}" 2>&1 &
rec_pid=$!

sleep 0.2
if ! kill -0 "${rec_pid}" 2>/dev/null; then
	rm -f "${PIDFILE}"
	notify "Recording failed to start" "See ${log} · screencopy / wf-recorder"
	exit 1
fi

echo "${rec_pid}" >"${PIDFILE}"
disown 2>/dev/null || true
notify "Recording…" "${out}\nPress Meta+Del again to stop"
