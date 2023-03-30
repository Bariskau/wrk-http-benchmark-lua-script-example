#!/usr/bin/env bash

if [[ ! -z "$1" ]]; then
  exec wrk "$@"
else
  tail -f /dev/null
fi
