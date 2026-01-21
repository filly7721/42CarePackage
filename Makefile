define check_binary
${shell env -i zsh -c 'source ~/.zshrc 2>/dev/null; (which ${1} 1>&2 && echo true) || echo false' 2>/dev/null}
endef
define create_dir
endef

binPath := ${HOME}/.local/bin
foundPath = ${shell env -i zsh -c 'source ~/.zshrc && echo :$$PATH:' 2>/dev/null}
isPathAdded = ${if ${findstring :${binPath}:,${foundPath}},true,false}
isOmzInstalled = ${call check_binary, omz}
isKittyInstalled = ${call check_binary, kitty}
isNvimInstalled = ${call check_binary, nvim}
isNvimAliased = ${shell env -i zsh -c 'source ~/.zshrc; alias vim | (grep -q nvim && echo true || echo false)' 2>/dev/null}
isJetBrainsAdded = ${shell ls ~/.local/share/fonts | (grep "JetBrainsMono" 1>/dev/null && echo true) || echo false}
all: ohmyzsh path kitty nvim lazyvim nerdfont

ohmyzsh:
ifeq (${isOmzInstalled}, true)
	@echo "oh-my-zsh is already installed";
else
	@echo "Installing oh-my-zsh"
	@curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash -s 1>/dev/null -- --unattended
	@echo "Installing Kitty Plugin"
	@sed -i 's|^plugins=(git)$$|plugins=(git kitty)|g' ~/.zshrc
endif

path:
	@mkdir -p ~/.local/bin
ifeq (${isPathAdded}, true)
	@echo ~/.local/bin is already in PATH
else
	@echo "Adding ${binPath} to Path"
	@echo "#Added by 42CarePackage" >> ~/.zshrc
	@echo 'PATH=$$PATH:${binPath}' >> ~/.zshrc
endif

kitty:
ifeq (${isKittyInstalled}, true)
	@echo "Kitty is already installed"
else
	@echo "Installing Kitty";
	@curl -L "https://sw.kovidgoyal.net/kitty/installer.sh" | sh /dev/stdin launch=n;
	@echo "Adding Kitty to Path";
	@ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/;
	@cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/;
	@cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/;
	@sed -i "s|Icon=kitty|Icon=$$HOME/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop;
	@sed -i "s|Exec=kitty|Exec=$$HOME/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop;
	@echo 'kitty.desktop' > ~/.config/xdg-terminals.list;
	@echo "adding default Kitty Config"
	@mkdir -p ~/.config/kitty
	@mv ./kitty/* ~/.config/kitty
endif

nvim:
ifeq (${isNvimInstalled}, true)
	@echo "NeoVim is already installed"
else
	@echo "Downloading NeoVim";
	@curl -LO "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz";
	@echo "Installing NeoVim";
	@rm -rf nvim-linux-x86_64;
	@tar -xzf "nvim-linux-x86_64.tar.gz";
	@rm -rf nvim-linux-x86_64.tar.gz;
	@cp -a nvim-linux-x86_64/. ~/.local/;
	@rm -rf nvim-linux-x86_64;
ifeq (${isNvimAliased}, false)
	@echo "#Added by 42CarePackage" >> ~/.zshrc
	@echo "alias vim=nvim" >> ~/.zshrc
endif
endif

lazyvim:
	@echo "Backing up old nvim config"
	@rm -rf ~/.config/nvim.bak
	@mv -f ~/.config/nvim ~/.config/nvim.bak
	@echo "Downloading LazyVim"
	@git clone https://github.com/LazyVim/starter ~/.config/nvim
	@rm -rf ~/.config/nvim/.git

nerdfont:
ifeq (${isJetBrainsAdded}, true)
	@echo "JetBrainsMono Already Added";
else 
	@echo "Downloading JetBrainsMono"
	@curl -LO "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip"
	@unzip -d "JetBrainsMono" JetBrainsMono.zip
	@rm -f JetBrainsMono.zip
	@mkdir -p ~/.local/share/fonts
	@mv JetBrainsMono/* ~/.local/share/fonts
	@rm -rf JetBrainsMono
	@fc-cache -fv;
endif

.PHONY: all ohmyzsh path kitty nvim lazyvim nerdfont

