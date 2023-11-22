#! /usr/bin/env bash
set -eu
tsc
browserify demo.js -o bundle.js
sleep 1 && python3 -mwebbrowser http://localhost:8000/demo.html &
python3 -m http.server
