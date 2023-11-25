#! /usr/bin/env bash
#! /usr/bin/env bash
set -eu
# compile TS
tsc
# bundle
browserify main.js -o bundle.js
# then run the selenium tests
sleep 1 && python3 run-tests-selenium.py

