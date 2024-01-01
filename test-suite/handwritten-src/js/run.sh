#! /usr/bin/env bash
set -eu
sleep 1 && python3 -mwebbrowser http://localhost:8000/test.html &
python3 -m http.server
