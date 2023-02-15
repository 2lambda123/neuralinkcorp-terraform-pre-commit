#!/usr/bin/env bash

set -e

# OSX GUI apps do not pick up environment variables the same way as Terminal apps and there are no easy solutions,
# especially as Apple changes the GUI app behavior every release (see https://stackoverflow.com/q/135688/483528). As a
# workaround to allow GitHub Desktop to work, add this (hopefully harmless) setting here.
export PATH=$PATH:/usr/local/bin

# Note that we expect the environment this runs in to already have run `tflint --init`!
# During CI, the image should already have the desired plugins cached, so we're not blasting GitHub
# too many times.

for file in "$@"; do
  CMD="tflint"

  # Find first tflint config in folder hierarchy
  CONFIG_PATH=$(readlink -f ${file%/*})
  while [[ "$CONFIG_PATH" != "" && ! -e "$CONFIG_PATH/.tflint.hcl" ]]; do
    CONFIG_PATH="${CONFIG_PATH%/*}"
  done

  # If .tflint is found, pass that to command
  if [ "$CONFIG_PATH" != "" ]; then
    CONFIG_FILE="$CONFIG_PATH/.tflint.hcl"
    CMD="tflint -c $CONFIG_FILE"
  fi

  $CMD $file
done
