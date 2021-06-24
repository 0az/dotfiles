function play-yt-stream --wraps='iina --mpv-ytdl-format=bestvideo' --description 'alias play-yt-stream iina --mpv-ytdl-format=bestvideo'
  iina --mpv-ytdl-format=best $argv;
end
