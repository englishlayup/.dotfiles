# dotfiles

## Bare cloning this repo to a new system

```bash
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
git clone --bare https://github.com/englishlayup/.dotfiles.git $HOME/.dotfiles
config checkout
config config --local status.showUntrackedFiles no
```

If `config checkout` failed because some config files already existed, use this to back them up them:
```bash
mkdir -p .config-backup && \
config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
xargs -I{} mv {} .config-backup/{}
```
Then run `config checkout` again.

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

### Use the Windows clipboard from WSL

curl -sLo/tmp/win32yank.zip https://github.com/equalsraf/win32yank/releases/download/v0.0.4/win32yank-x64.zip
unzip -p /tmp/win32yank.zip win32yank.exe > /tmp/win32yank.exe
chmod +x /tmp/win32yank.exe
sudo mv /tmp/win32yank.exe /usr/local/bin/

## Tmux

## Zsh
