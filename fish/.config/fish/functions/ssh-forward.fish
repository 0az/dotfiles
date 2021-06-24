function ssh-forward -a port -a host
	autossh -M 0 -NL $port:127.0.0.1:$port $host
end
