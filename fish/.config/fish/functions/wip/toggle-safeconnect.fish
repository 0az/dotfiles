function toggle-safeconnect --description 'Enable/disable the SafeConnect services'
	# TODO: Work in Progress
	exit 1

	sudo -v

	function is-service-running -a service
		test (launchctl print $service | grep -E '^\s+state\s+=\s+' | sed -E 's/^[[:space:]]*state *= *//') = 'running'
		return
	end

	set -l client gui/501/scClient
	set -l server system/scManagerD

	if is-service-running $client || is-service-running $server
		echo "Killing $client and $server..."
		launchctl kill SIGTERM $client
		sudo launchctl kill SIGTERM $server
	else
		echo "Starting $client and $server..."
		launchctl kickstart $client
		sudo launchctl kickstart $server
	end
end
