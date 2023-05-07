# dotfiles

## Bare cloning this repo to a new system

```bash
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
git clone --bare https://github.com/englishlayup/.dotfiles.git $HOME/.dotfiles
config checkout
config config --local status.showUntrackedFiles no
source .zshrc
```

If `config checkout` failed because some config files already existed, use this
to back them up:

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

All the plugins should be installed the first time you launch `nvim`.
Start `nvim` then type `:PackerSync` to update all plugins

### Use the Windows clipboard from WSL

```bash
curl -sLo/tmp/win32yank.zip https://github.com/equalsraf/win32yank/releases/download/v0.0.4/win32yank-x64.zip
unzip -p /tmp/win32yank.zip win32yank.exe > /tmp/win32yank.exe
chmod +x /tmp/win32yank.exe
sudo mv /tmp/win32yank.exe /usr/local/bin/
```

## Zsh

### Install plugins and p10k theme

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.zsh/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/plugins/zsh-syntax-highlighting
git clone https://github.com/agkozak/zsh-z ~/.zsh/plugins/zsh-z
git clone --depth=2 https://github.com/romkatv/powerlevel10k.git ~/.zsh/plugins/powerlevel10k
```

### Install fzf

```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

### Useful aliases for git

```bash
git config --global alias.st "status -uno -sb"
git config --global alias.tree "log --graph --oneline --decorate"
git config --global alias.lg "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'"
```

## Known Issues

### WSL

Calling any Windows executables yeilds `Invalid argument` error:

```bash
/usr/local/bin/win32yank.exe: Invalid argument
                                              %
/mnt/c/windows/explorer.exe: Invalid argument
                                             %
```

Reproduce: ???

Occurs on WSL
