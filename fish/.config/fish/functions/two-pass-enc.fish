#! /usr/bin/env fish

function two-pass-enc
	function _help
		echo 'two-pass-enc [-h/--help]'
		echo '             [-n/--dry-run]'
		echo '             [-b/--bitrate BITRATE]'
		echo '             [-p/--preset PRESET]'
		echo '             [-g/--group-of-pictures GOP]'
		echo '             [--vsync VSYNC]'
		echo '             [--vf VIDEO_FILTERGRAPH]'
		echo '             [--test-encode]'
		echo '             input output'
	end

	if not argparse --name=two-pass-enc \
		'h/help' \
		'n/dry-run' \
		'b/bitrate=' \
		'g/gop=' \
		'p/preset=' \
		'vsync=' \
		'vf=' \
		'test-encode' \
		-- $argv
		# end if

		echo 'Error: Could not parse args!' >&2
		_help >&2
		return 1
	end
	
	if test $_flag_h
		_help
		return 0
	end

	if test (count $argv) -ne 2
		echo 'Error: Insufficent args!' >&2
		_help >&2
		return 1
	end

	set input $argv[1]
	set output $argv[2]

	if test -n "$_flag_b"
		set bitrate $_flag_b
	else
		set bitrate 2500k
	end

	if test -n "$_flag_p"
		set preset -preset $_flag_p
	else
		set preset -preset fast
	end

	if test -n "$_flag_g"
		set dash_g -g $_flag_g
	else
		set dash_g
	end

	set -q _flag_vf
	and set vf -vf $_flag_vf

	set -q _flag_vsync
	and set vsync -vsync $_flag_vf

	set -q _flag_test_encode
	and set subset -t 00:00:30.0

	set common -i $input $subset -c:v libx264 $preset -b:v $bitrate $vf $dash_g -movflags +faststart $vsync

	echo 'ffmpeg -hide_banner -y '(string escape -- $common | string join ' ')" -pass 1 -an -f null /dev/null"
	echo 'ffmpeg -hide_banner    '(string escape -- $common | string join ' ')" -pass 2 -c:a copy   "(string escape -- $output)

	if set -q _flag_n
		return 0
	end

	ffmpeg -hide_banner -y $common -pass 1 $preset -an -f null /dev/null && \
	ffmpeg -hide_banner    $common -pass 2 $preset -c:a copy   $output
	return $status
end
