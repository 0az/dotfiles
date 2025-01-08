#! /bin/bash
# This snippet's useful, so it gets to live in dotfiles.

# shellcheck disable=SC2034
root="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd || exit 1)"

sed -n '5p' "${BASH_SOURCE[0]}"
