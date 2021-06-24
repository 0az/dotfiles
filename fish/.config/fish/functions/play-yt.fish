function play-yt --wraps='iina --mpv-ytdl-format=bestvideo+bestaudio' --description 'alias play-yt-audio iina --mpv-ytdl-format=bestvideo+bestaudio'
  iina --mpv-ytdl-format=bestvideo+bestaudio $argv;
end
