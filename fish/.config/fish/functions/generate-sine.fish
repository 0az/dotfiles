function generate-sine -a frequency
	set -l frequency $frequency
	set -l seconds 60
	set -l default

	if test -z $frequency
		set frequency 196
		set default 1
	end

	set -l dir ~/.local/cache/generate-wave
	set -l name sine-$frequency-$seconds.mp3
	mkdir -p $dir
	set -l out $dir/$name
	if test -e $out
		echo "Playing cached file $out..." >&2
	else
		ffmpeg -hide_banner -loglevel fatal -f lavfi -i "sine=frequency=$frequency:duration=$seconds" $out
	end
	set -l playlist "$(find $dir -type f -iname 'sine-*.mp3' | sort)"
	
	set -l start_name sine-$default
	if test -z $default
		set start_name $name
	end
	set -l start (echo "$playlist" | grep -n $start_name | head -n 1 | cut -d: -f 1)
	set start (math "$start - 1")
	mpv --force-window=no --playlist=(echo $playlist | psub) --playlist-start=$start --prefetch-playlist=yes --loop-file=inf
end
