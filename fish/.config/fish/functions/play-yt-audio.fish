function play-yt-audio --wraps='iina --mpv-ytdl-format=bestaudio' --description 'alias play-yt-audio iina --mpv-ytdl-format=bestaudio'
  iina --mpv-ytdl-format=bestaudio $argv;
end
