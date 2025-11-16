[default]
help:
	just --list

stylua:
	fd -H -g '*.lua' --exec-batch stylua
