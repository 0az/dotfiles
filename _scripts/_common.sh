#! /usr/bin/env bash

nix_daemon_profile=/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

_opts=$-
if [[ $- =~ e ]]; then
	set +e
fi

# shellcheck disable=SC1090
test -e "$nix_daemon_profile" && . "$nix_daemon_profile"

if [[ $_opts =~ e ]]; then
	set -e
fi
