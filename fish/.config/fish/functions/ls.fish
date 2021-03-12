function ls --description 'List contents of directory'
    set -l opt
	isatty stdout
	and set -a opt -F

	if command -q gls
		set -a opt -h
		set -a opt --color=auto --group-directories-first
		command gls $opt $argv
	else
		set -a opt -Gh

		command ls $opt $argv
	end
end