#! /usr/bin/env bash
set -eu
tsc
browserify demo.js -o bundle.js
