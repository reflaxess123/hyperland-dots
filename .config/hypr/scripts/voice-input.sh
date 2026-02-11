#!/bin/bash
# Voice input: CTRL+SUPER toggle — first press starts, second stops & transcribes
# Uses faster-whisper large-v3-turbo on CUDA

RECORDING_PID="/tmp/voice-recording.pid"
RECORDING_FILE="/tmp/voice-recording.wav"
VOICE_STATE="/tmp/waybar-voice.json"
LOCK_FILE="/tmp/voice-input.lock"
VENV="$HOME/.local/share/voice-input/venv"
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
WAYBAR_SIGNAL=8

# Prevent duplicate launches during transcription
if [[ -f "$LOCK_FILE" ]]; then
    exit 0
fi

update_waybar() {
    echo "{\"text\": \"$1\", \"class\": \"$2\"}" > "$VOICE_STATE"
    pkill -RTMIN+$WAYBAR_SIGNAL waybar 2>/dev/null
}

is_recording() {
    [[ -f "$RECORDING_PID" ]] && kill -0 "$(cat "$RECORDING_PID")" 2>/dev/null
}

start_recording() {
    rm -f "$RECORDING_FILE"
    update_waybar "●" "recording"
    pw-record "$RECORDING_FILE" &
    echo $! > "$RECORDING_PID"
}

stop_and_transcribe() {
    touch "$LOCK_FILE"
    kill -INT "$(cat "$RECORDING_PID")" 2>/dev/null
    sleep 0.2
    rm -f "$RECORDING_PID"

    if [[ ! -s "$RECORDING_FILE" ]]; then
        rm -f "$LOCK_FILE"
        update_waybar "" "idle"
        return
    fi

    update_waybar "●" "processing"

    text=$("$VENV/bin/python" "$SCRIPT_DIR/transcribe.py" "$RECORDING_FILE" 2>/dev/null)

    if [[ -n "$text" ]]; then
        wl-copy "$text"
        wtype -M ctrl v -m ctrl
    fi

    rm -f "$RECORDING_FILE" "$LOCK_FILE"
    update_waybar "" "idle"
}

if is_recording; then
    stop_and_transcribe
else
    start_recording
fi
