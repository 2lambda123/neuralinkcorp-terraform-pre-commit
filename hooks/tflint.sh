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
  tflint $file
done
