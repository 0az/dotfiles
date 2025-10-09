#! /usr/bin/env bash

set -euo pipefail

if test -n "${DEBUG:-}"; then
	set -x
fi

tmpdir=
skip_cleanup=

DRY_RUN="${DRY_RUN:-}"

cleanup() {
	if test -n "$skip_cleanup"; then
		echo 'Skipping cleanup!'
		return
	fi

	start-section Cleanup
	echo "Cleaning up! tmpdir=$tmpdir"
	if test -n "$tmpdir" -a -d "$tmpdir"; then
		echo
		echo rm -ir "$tmpdir"
		rm -ir "$tmpdir"
	fi
	echo
}

trap cleanup EXIT

abort() {
	if test ${#FUNCNAME[@]} -gt 1; then
		echo "ERROR(${FUNCNAME[1]}): $*" >&2
	else
		echo "ERROR: $*" >&2
	fi
	exit 1
}

case "$BASH_VERSION" in
	1.*|2.*|3.*|4.0.*|4.1.*|4.2.*|4.3.*)
		escape-array() {
			# Supported at least since Bash v4.2
			printf '%q' "${1:-}"
			if test $# -gt 1; then
				for s in "${@:2}"; do
					printf ' %q' "$s"
				done
			fi
			echo
		}
		;;
	*)
		escape-array() {
			echo "${@@Q}"
		}
esac

join-array() {
	# printf '%s\n' "$@"
	# echo ---
	# echo $#
	if test $# -le 1; then
		return
	fi

	local first="${2-}"
	local IFS="$1"
	# echo "$IFS"
	shift 2
	printf %s "$first" "${@/#/ }"
}

set +e
read -r -d '' awk_login_defs <<'EOF'
/SYS_UID_MIN/ {
	uid_min = $2
}

/SYS_UID_MAX/ {
	uid_max = $2
}

/SYS_GID_MIN/ {
	gid_min = $2
}

/SYS_GID_MAX/ {
	gid_max = $2
}

END {
	if (uid_min && uid_max && gid_min && gid_max) {
		print uid_min, uid_max, gid_min, gid_max
	}
}
EOF

read -r -d '' awk_number_in_range <<'EOF'
range_min <= int($0) && int($0) <= range_max {
	print $0
}
EOF

read -r -d '' awk_locate_free_range <<'EOF'
# Iterates over reverse sorted integer input, looking for a gap of at least range_size.
# Vars: range_size, range_min, range_max
{
	if (!lowest_used) {
		lowest_used = $0
		next
	}
	if (lowest_used - range_size > $0) {
		found = 1
		print lowest_used - range_size, lowest_used - 1
		exit 0
	}
	lowest_used = $0
}

END {
	if (found) {
		exit 0
	}

	if (lowest_used - range_size < range_min) {
		exit 1
	}

	print lowest_used - range_size, lowest_used - 1
}
EOF
set -e

awk-number-in-range() {
	awk \
		-v range_min="$1" \
		-v range_max="$2" \
		"$awk_number_in_range"
}

awk-locate-free-range() {
	awk \
		-v range_size="$1" \
		-v range_min="$2" \
		-v range_max="$3" \
		"$awk_locate_free_range"
}

configure-lix-nixbld() {
	local lix_uid_base lix_uid_min lix_uid_max lix_gid

	# Find a safe range, or fall back to defaults
	read -r sys_uid_min sys_uid_max sys_gid_min sys_gid_max < <(
		awk "$awk_login_defs" /etc/login.defs
	) || return

	# shellcheck disable=SC2034
	read -r lix_uid_min lix_uid_max < <(
		cut -d : -f 3 /etc/passwd \
		| awk-number-in-range "$sys_uid_min" "$sys_uid_max" \
		| sort -nr \
		| awk-locate-free-range 32 "$sys_uid_min" "$sys_uid_max"
	) || return

	lix_uid_base=$((lix_uid_min - 1))

	# Check if $lix_uid_base is available, or search for an alternative otherwise
	if cut -d : -f 3 /etc/group | grep -q "$lix_uid_base"; then
		read -r lix_gid lix_gid < <(
			cut -d : -f 3 /etc/group \
			| awk-number-in-range "$sys_gid_min" "$sys_gid_max" \
			| sort -nr \
			| awk-locate-free-range 1 "$sys_gid_min" "$sys_gid_max" /etc/group
		) || [[ -n "$lix_gid" ]]
	else
		lix_gid="$lix_uid_min"
	fi

	echo "$lix_uid_base" "$lix_gid"
}

ensure-tmpdir() {
	if test -n "$tmpdir" -a -d "$tmpdir"; then
		test "$TMPDIR" != "$tmpdir" || abort "TMPDIR ($TMPDIR) does not match tmpdir ($tmpdir)"
		return
	fi

	if test -n "$DRY_RUN"; then
		return
	fi

	tmpdir="$(mktemp -d -t dotfiles-install.XXXXXX)"
	export TMPDIR="$tmpdir"
	test -d "$tmpdir" || abort 'Could not create tmpdir!'
}

ensure-tmpfile() {
	test $# -le 1 || abort 'Invalid argument count'

	local suffix="${1:-}"
	printf '%s%s\n' "$(mktemp)" "$suffix"
}

request-confirmation() {
	echo "Proposed command:"
	echo
	printf '\t%s\n' "$(escape-array "$@")"
	echo

	if test -n "$DRY_RUN"; then
		return
	fi

	read -rp 'Execute? [Y/n] ' REPLY
	echo

	case "$REPLY" in
		n|N)
			echo 'Aborting before execution.'
			exit 1
			;;
		""|y|Y)
			# Intentionally left blank
			;;
		*)
			abort 'Unexpected input'
			;;
	esac

}

run-command() {
	request-confirmation "$@"

	if test -n "$DRY_RUN"; then
		return
	fi

	"$@" || abort 'Command exited with non-zero status!'
	echo
}

run-curl-bash() {
	local url dest

	url="$1"
	shift 1

	dest="$(ensure-tmpfile .sh)"
	run-command curl -#fSL "$url" -o "$dest"
	run-command /bin/bash "$dest" "$@"
}

start-section() {
	local name="$1"
	printf '\n# %s\n\n' "$name"
}

section-dotfiles() {
	start-section 'Clone dotfiles repository'

	run-command git clone https://github.com/0az/dotfiles.git ~/dotfiles
}

section-homebrew() {
	start-section 'Install Homebrew'
	run-curl-bash https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
}

section-homebrew-packages() {
	local brew=
	if test -x /opt/homebrew/bin/brew; then
		brew=/opt/homebrew/bin/brew
	elif test -x /usr/local/bin/brew; then
		brew=/usr/local/bin/brew
	else
		abort 'ERROR: Could not locate Homebrew installation'
	fi

	run-command "$brew" install bash git fish
}

section-lix() {
	start-section 'Install Lix (Like Nix)'

	local lix_uid_base lix_gid
	declare -a lix_args

	local is_linux=
	if test "$(uname)" = Linux; then
		is_linux=1
		lix_args+=(linux)
	fi

	lix_args+=(
		--no-modify-profile
		"${lix_nixbld_opts[@]+"${lix_nixbld_opts[@]}"}"
		--extra-conf 'use-xdg-base-directories = true'
		# HACK: lix-installer's --enable-flakes actually turns off flakes?
		--extra-conf 'experimental-features = nix-command flakes'
	)

	if test -n "$is_linux"; then
		if test ! -d /run/systemd/system; then
			lix_args+=(--init none)
		fi

		if test -r /etc/login.defs; then
			echo 'Checking for free UIDs/GIDs...'
			echo

			if read -r lix_uid_base lix_gid < <(configure-lix-nixbld) || test -n "$lix_uid_base" -a "$lix_gid"; then
				lix_args+=(
					--nix-build-user-id-base "$lix_uid_base"
					--nix-build-group-id "$lix_gid"
				)
			fi
		fi
	fi

	PATH="$PATH:/sbin" run-curl-bash https://install.lix.systems/lix install "${lix_args[@]}"

	echo 'CAVEAT:'
	echo
	printf '\t%s\n' 'You may need to add the following to your shell profile:'
	echo
	printf '\t\t%s\n' '. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
	echo
}

run-sections() {
	declare -a section_cmds invalid_sections

	for section in "$@"; do
		case "$section" in
			dotfiles)
				section_cmds+=(section-dotfiles)
				;;
			homebrew)
				section_cmds+=(section-homebrew)
				;;
			homebrew-packages)
				section_cmds+=(section-homebrew-packages)
				;;
			lix)
				section_cmds+=(section-lix)
				;;
			*)
				invalid_sections+=("$section")
				;;
		esac

		if test -n "${invalid_sections[0]+.}"; then
			abort "Invalid section: $(join-array "$(escape-array "${invalid_sections[@]}")")"
		fi
	done

	echo
	echo 'Running the following installer sections:'
	printf '\t%s\n' "$@" >&2
	echo

	for section in "${section_cmds[@]}"; do
		"$section"
	done
}

sections=()

# $1: Section name
# $2: Skip flag. Skips this section if present or non-empty.
check-section() {
	if test -n "${2:-}"; then
		echo "Skipping section $1..."
		return
	fi
	sections+=("$1")
}

start-section 'Plan installation'

if test $# -eq 0 -o $# -eq 1 -a "${1:-}" = all; then
	no_dotfiles="${SKIP_DOTFILES:-}"
	if test -d "$HOME/dotfiles"; then
		no_dotfiles=1
	fi

	no_homebrew="${SKIP_HOMEBREW:-}"
	if test "$(uname)" != Darwin || command -v brew >/dev/null; then
		no_homebrew=1
	fi

	# Homebrew package installation is idempotent enough
	no_homebrew_packages="${SKIP_HOMEBREW_PACKAGES:-${no_homebrew}}"

	no_lix="${SKIP_LIX:-}"
	if test -x /nix/nix-installer -a -r /nix/receipt.json; then
		echo 'Found (partial?) Lix install at /nix/nix-installer and/or /nix/receipt.json...'
		no_lix=1
	fi

	check-section dotfiles "$no_dotfiles"
	check-section homebrew "$no_homebrew"
	check-section homebrew-packages "$no_homebrew_packages"
	check-section lix "$no_lix"
else
	sections=("$@")
fi

if test ${#sections[@]} -eq 0; then
	skip_cleanup=1
	echo
	echo 'No installer sections scheduled!'
	echo
	exit
fi

ensure-tmpdir

run-sections "${sections[@]}"
