#! /usr/bin/env fish

function arr_push
	return 1
	argparse -x g,l,u 'g/global' 'l/local' 'u/universal' 'x/export' -- $argv
	set -l opts g l u x
	set "$argv[1]" $argv[2..-1]
end
