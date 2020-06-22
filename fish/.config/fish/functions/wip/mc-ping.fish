function mc-ping -a host -a port -d 'Ping a Minecraft server using the legacy Server List Ping protocol.'
	if test -z "$host"
		set name (status current-command)

		printf "\t$name host [port]\n" >&2
		return 1
	end

	if test -z "$port"
		set port 25565
	end

	printf '\xfe\x01' | nc -w 2 $host $port
end
