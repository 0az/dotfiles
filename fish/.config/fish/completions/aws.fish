command -q aws_completer && complete --command aws --no-files --arguments '(begin
	set -lx COMP_SHELL fish
	set -lx COMP_LINE (commandline)
	aws_completer | sed \'s/ $//\'
end)'
