#! /usr/bin/env bash

set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." >/dev/null 2>&1 && pwd || exit 1)"
. "$root/_scripts/_common.sh"

flake="path:$root/nix/dot-config/flakey-profile"

nix flake update nixpkgs --flake "$flake"
nix run "$flake#profile.switch"
nix-collect-garbage --delete-older-than "${PROFILE_RETENTION:-7d}" --dry-run
