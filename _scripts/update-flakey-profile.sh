#! /usr/bin/env bash

set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." >/dev/null 2>&1 && pwd || exit 1)"
. "$root/_scripts/_common.sh"

extra_args=()

if test -n "${DEBUG:-}"; then
	extra_args+=(--show-trace)
	set -x
fi

extra_args+=(--no-use-registries)

flake="path:$root/nix/dot-config/flakey-profile"

if test -z "${SKIP_NIXPKGS_UPDATE:-}"; then
	nix flake update nixpkgs "${extra_args[@]}" --flake "$flake"
fi

nix run "${extra_args[@]}" "$flake#profile.switch"

nix-collect-garbage --delete-older-than "${PROFILE_RETENTION:-7d}" --dry-run
