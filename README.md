# Dotfiles

> *`$HOME` is just one `git clone` away.`*

### Modules

- Darwin
- Fish
- Git
- Kitty
- MPV
- Nix
- Obsidian
- SSH
- Shell
- Sublime
- Vim
- WezTerm

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

Vim depends on a recent version of Python 3 installed, including distutils.

### Roadmap

- Write a portable zero-dep stow replacement (Python)
