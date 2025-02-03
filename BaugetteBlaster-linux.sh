#!/bin/sh
echo -ne '\033c\033]0;BaugetteBlaster\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/BaugetteBlaster-linux.x86_64" "$@"
