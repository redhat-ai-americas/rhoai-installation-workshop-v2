#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
HTPASSWD_FILE="${SCRIPT_DIR}/.htpasswd"

# Create the file and add the first user
htpasswd -cb "${HTPASSWD_FILE}" admin admin

# Add the second user
htpasswd -b "${HTPASSWD_FILE}" dev dev
