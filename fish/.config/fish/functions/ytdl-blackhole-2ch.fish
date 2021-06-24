function ytdl-blackhole-2ch --wraps=mpv --description 'MPV/YTDL Blackhole Alias'
  mpv --ytdl-format=bestaudio --audio-device='coreaudio/BlackHole2ch_UID' $argv;
end
