#! /usr/bin/env bash
set -eu
tsc
browserify main.js -o bundle.js
sleep 1 && python3 -mwebbrowser http://localhost:8000/test.html &
python3 -m http.server
