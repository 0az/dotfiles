# Dotfiles

> *`$HOME` is just one `git clone` away.`*

### Modules

- Amethyst
- Fish
- Git
- Kitty
- Launchd
- MPV
- Shell
- SSH
- Sublime
- Vim

### Usage

```sh
# Install GNU stow
brew install stow \
&& mkdir -p ~/.config \
&& stow shell git fish ssh vim kitty launchd \
&& true
```

Certain scripts expect the following:
```
fd
fish
fzf
kitty
python
ripgrep
```

Other useful utilities include:
```
jq
gron
ffmpeg
mpv
```

### Warnings

Certain stow packages depend on others. Specifically, assume that everything
depends on `shell`.

### Roadmap

- Write a portable zero-dep stow replacement (Python)
