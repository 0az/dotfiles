function utcdate --wraps='date -u "+%Y-%m-%dT%H:%M:%SZ"' --description 'alias utcdate=date -u "+%Y-%m-%dT%H:%M:%SZ"'
  date -u "+%Y-%m-%dT%H:%M:%SZ" $argv
end
