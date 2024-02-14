function ls --description 'List contents of directory'
    set -l opts
    isatty stdout
    and set -a opts -F

    if command -q gls
        set -a opts -h --color=auto --group-directories-first
        command gls $opts $argv
    else
        set -a opts -Gh

        test "$TERM_PROGRAM" = Apple_Terminal
        and set -lx CLICOLOR 1

        command ls $opts $argv
    end
end
