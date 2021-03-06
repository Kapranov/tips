#!/usr/bin/env bash
#
# Runs all tests the way they would be run on CI.

mix format --check-formatted || { echo 'Please format code with `mix format`.'; exit 1; }
MIX_ENV=test mix compile --force --warnings-as-errors || { echo 'Please fix all compiler warnings.'; exit 1; }
mix test || { echo 'Please fix all broken tests.'; exit 1; }
