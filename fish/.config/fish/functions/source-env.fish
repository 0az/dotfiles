function source-env --description 'Read environment variables from .env files'
    argparse 'n/dry-run' -- $argv

    set -l shell
    if ! set shell (command -s dash)
        set shell (command -s sh)
    end

    for f in $argv
        if ! dash -n "$f" && grep -Eqvx "\w+=.+|\s+" "$f"
            echo "Invalid env file: $f" >&2
            return 1
        end
    end

    diff -u0 \
        (env | sort | psub) \
        (
            dash -eu -c '
                for __word in "$@"; do
                    if test "${__word#*/}" = "$__word"; then
                        __word=./"$__word"
                    fi
                    set -a
                    . $__word
                    set +a
                done
                env
            ' -- $argv \
            | sort | psub \
        ) \
    | if test -z "$_flag_dry_run"
        sed -E -n '
            3,${
                /^-|^@@/d
                s/^\\+/export /
                p
            }
        ' | source
    else
        sed -E -n '
            3,${
                /^-|^@@/d
                s/^\\+//
                p
            }
        '
    end

end
