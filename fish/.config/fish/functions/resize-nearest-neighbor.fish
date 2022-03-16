function resize-nearest-neighbor -a scale -a src -a dest
	convert $from -interpolate Integer -filter Point -resize $scale $dest
end
