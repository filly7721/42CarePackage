define check_binary
  zsh -c 'source ~/.zshrc || true; which $(1) ' 1>/dev/null 2>&1
endef

foundPath = ${shell zsh -c 'source ~/.zshrc && echo :$$PATH:'}
localPath != echo :$$HOME/.local/bin:

all: path kitty nvim lazyvim

path:
	@if [ "${findstring ${localPath},${foundPath}}" != "" ]; then\
		echo "Path is already updated";\
	else \
		echo "Updating Path..."; \
		echo "PATH=$$PATH:$$HOME/.local/bin " >> ~/.zshrc;\
	fi

kitty:
	@if $(call check_binary,kitty); then \
		echo "Kitty is already installed"; \
	else \
		echo "Installing Kitty"; \
		curl -L "https://sw.kovidgoyal.net/kitty/installer.sh" | sh /dev/stdin launch=n; \
		echo "Adding Kitty to Path"; \
		ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/; \
		cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/; \
		cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/; \
		sed -i "s|Icon=kitty|Icon=$$HOME/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop; \
		sed -i "s|Exec=kitty|Exec=$$HOME/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop; \
		echo 'kitty.desktop' > ~/.config/xdg-terminals.list; \
	fi

nvim:
	@if $(call check_binary,nvim); then \
		echo "Neovim is already installed"; \
	else \
		echo "Downloading Neo Vim"; \
		curl -LO "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"; \
		echo "Extracting File"; \
		rm -rf nvim-linux-x86_64; \
		tar -xzf "nvim-linux-x86_64.tar.gz"; \
		rm -rf nvim-linux-x86_64.tar.gz; \
		cp -a nvim-linux-x86_64/. ~/.local/; \
		rm -rf nvim-linux-x86_64; \
		zsh -c 'source ~/.zshrc 2>/dev/null || true; \
			alias vim 2>/dev/null | grep -q "nvim" || { \
				echo "Adding alias vim=nvim"; \
				echo "\n# Use Neovim by default\nalias vim=nvim" >> ~/.zshrc; \
			}' 2>/dev/null; \
	fi

lazyvim:
	@echo "Backing up old nvim config"
	@rm -rf ~/.config/nvim.bak
	@mv -f ~/.config/nvim ~/.config/nvim.bak
	@echo "Downloading LazyVim"
	@git clone https://github.com/LazyVim/starter ~/.config/nvim
	@rm -rf ~/.config/nvim/.git

.PHONY: nvim all path kitty

