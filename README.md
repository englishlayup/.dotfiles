# dotfiles

## Neovim

### Setup [Neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim)

```bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
sudo mv ./nvim.appimage /usr/local/bin/
# Create soft link
sudo ln -s /usr/local/bin/nvim.appimage /usr/local/bin/nvim
# Or alias
alias nvim="/usr/local/bin/nvim.appimage"
```

### Setup Neovim plugins

All the plugins should be installed the first time you launch `nvim`. A few errors are expected, ignore them ;) ;)
Start `nvim` then type `:PackerSync` to update all plugins

## Tmux

## Zsh
