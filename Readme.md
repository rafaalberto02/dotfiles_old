# Fael DotFiles

## Before

### Install homebrew
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew bundle install
```

### Install oh-my-zsh
```
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Install vim-plug

```
curl -fLo '~/.vim/autoload/plug.vim' --create-dirs 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```

## After
### Openjdk Install
```
sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
```

```
echo 'export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"' >> ~/.zshrc
```

```
echo 'export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"' >> ~/.zshrc
```

### Spicetify Config
```
spicetify config
spicetify backup apply
spicetify update
cd ~/Downloads
git clone https://github.com/catppuccin/spicetify.git
cd spicetify
cp -r catppuccin-* ~/.config/spicetify/Themes/\ncp 
cp js/* ~/.config/spicetify/Extensions/
spicetify update
spicetify apply
spicetify config current_theme catppuccin-mocha\nspicetify config color_scheme lavender\nspicetify config inject_css 1 replace_colors 1 overwrite_assets 1\nspicetify config extensions catppuccin-mocha.js
spicetify update
spicetify apply
```
