define check_binary
zsh -c 'source ~/.zshrc 2>/dev/null || true; which $(1) >/dev/null 2>&1 && echo "$(1) is already installed"'
endef

all: path kitty nvim

path:
	@echo "Checking ~/.local/bin in PATH"
	@zsh -c ' \
		source ~/.zshrc 2>/dev/null || true; \
		case ":$$PATH:" in \
			*":$$HOME/.local/bin:"*) \
				echo "~/.local/bin already in PATH" ;; \
			*) \
				echo "Adding ~/.local/bin to PATH in .zshrc"; \
				echo "\n# Added by Makefile\n"; \
				echo 'export PATH=$PATH'":\"$$HOME/.local/bin\"" >> ~/.zshrc ;; \
		esac'

kitty:
	@$(call check_binary,kitty) && exit 0 || true
	@echo "Installing Kitty"
	@curl -L "https://sw.kovidgoyal.net/kitty/installer.sh" | sh /dev/stdin
	@echo "Adding Kitty to Path"
	@ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
	@cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
	@cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
	@sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
	@sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
	@echo 'kitty.desktop' > ~/.config/xdg-terminals.list

nvim:
	@$(call check_binary,nvim) && exit 0 || true
	@echo "Downloading Neo Vim"
	@curl -LO "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
	@echo "extracting File"
	@rm -rf nvim-linux-x86_64
	@tar -xzf "nvim-linux-x86_64.tar.gz"
	@rm -rf nvim-linux-x86_64.tar.gz
	@cp -a nvim-linux-x86_64/. ~/.local/
	@rm -rf nvim-linux-x86_64
	@zsh -c ' \
		source ~/.zshrc 2>/dev/null || true; \
		alias vim 2>/dev/null | grep -q "nvim" || { \
			echo "Adding alias vim=nvim"; \
			echo "\n# Use Neovim by default\nalias vim=nvim" >> ~/.zshrc; \
		}'

.PHONY: nvim all path kitty
