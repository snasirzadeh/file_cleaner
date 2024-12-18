#!/usr/bin/env bash

set -x

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
}
