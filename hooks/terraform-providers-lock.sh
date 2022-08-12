#!/bin/sh
#
#/ Usage: terraform-providers-lock.sh
#/
#/ Run `terraform providers lock` with important platforms
#/
#/

set -eu

usage() {
    grep "^#/" "$0" | cut -c"4-" >&2
    exit "$1"
}

while [ "$#" -gt 0 ]
do
    case "$1" in
        -h|--help) usage 0;;
        -*) usage 1;;
        *) break;;
    esac
done

ORIGINAL_DIRECTORY="$(pwd)"

# https://learn.hashicorp.com/tutorials/terraform/automate-terraform?in=terraform%2Fautomation#controlling-terraform-output-in-automation
export TF_IN_AUTOMATION=1

# Store and return last failure from validate so this can validate every directory passed before exiting
LOCK_ERROR=0

for dir in $(echo "$@" | xargs -n1 dirname | sort -u | uniq); do
  echo "---=> Running 'terraform providers lock' in $dir"
  cd "$dir"
  terraform init -backend=false || LOCK_ERROR=$?
  terraform providers lock \
      -platform=darwin_amd64 \
      -platform=linux_amd64 \
      -platform=darwin_arm64 \
      -platform=linux_arm64 \
    || LOCK_ERROR=$?

  cd "${ORIGINAL_DIRECTORY}"
done

exit ${LOCK_ERROR}
