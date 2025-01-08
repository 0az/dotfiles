#! /usr/bin/env bash

nix_daemon_profile=/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
# shellcheck disable=SC1090
test -e "$nix_daemon_profile" && . "$nix_daemon_profile"
