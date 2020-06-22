function conda_on
	fish -C 'source (/usr/local/miniconda3/bin/conda info --root)/etc/fish/conf.d/conda.fish' -C 'echo "Activating conda..."'
end
