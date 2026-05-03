ifeq ($(OS),Windows_NT)
SHELL := cmd.exe
.SHELLFLAGS := /C
PREFIX ?= $(USERPROFILE)
POWERSHELL ?= powershell
else
SHELL := /bin/bash
PREFIX ?= $(HOME)
endif

ITERM2_CONFIG_DIR ?= $(PREFIX)/.config/iterm2
ITERM2_COLOR_DIR ?= $(ITERM2_CONFIG_DIR)/colors
ITERM2_DYNAMIC_PROFILES_DIR ?= $(PREFIX)/Library/Application Support/iTerm2/DynamicProfiles
GHOSTTY_THEME_DIR ?= $(PREFIX)/.config/ghostty/themes
TMUX_THEME_DIR ?= $(PREFIX)/.config/tmux/themes
NVIM_COLOR_DIR ?= $(PREFIX)/.config/nvim/colors
EZA_THEME_DIR ?= $(PREFIX)/.config/eza/themes
DELTA_THEME_DIR ?= $(PREFIX)/.config/delta/themes
LAZYGIT_THEME_DIR ?= $(PREFIX)/.config/lazygit/themes

ITERM2_COLOR_PRESETS := \
	home/.config/iterm2/colors/nothing-light.itermcolors \
	home/.config/iterm2/colors/nothing-dark.itermcolors

ITERM2_DYNAMIC_PROFILES := \
	home/.config/iterm2/DynamicProfiles/nothing-light.json \
	home/.config/iterm2/DynamicProfiles/nothing-dark.json

GHOSTTY_THEMES := \
	home/.config/ghostty/themes/nothing-light \
	home/.config/ghostty/themes/nothing-dark

TMUX_THEMES := \
	home/.config/tmux/themes/nothing-light.conf \
	home/.config/tmux/themes/nothing-dark.conf

NVIM_COLORSCHEMES := \
	home/.config/nvim/colors/nothing-light.lua \
	home/.config/nvim/colors/nothing-dark.lua

EZA_THEMES := \
	home/.config/eza/themes/nothing-light.yml \
	home/.config/eza/themes/nothing-dark.yml

DELTA_THEMES := \
	home/.config/delta/themes/nothing-light.gitconfig \
	home/.config/delta/themes/nothing-dark.gitconfig

LAZYGIT_THEMES := \
	home/.config/lazygit/themes/nothing-light.yml \
	home/.config/lazygit/themes/nothing-dark.yml

.PHONY: all validate install deploy deploy-light install-iterm2 deploy-iterm2 install-ghostty deploy-ghostty install-tmux deploy-tmux install-nvim deploy-nvim install-eza deploy-eza install-delta deploy-delta install-lazygit deploy-lazygit install-wallpapers deploy-wallpapers

all: validate

ifeq ($(OS),Windows_NT)

validate:
	@$(POWERSHELL) -NoProfile -ExecutionPolicy Bypass -File tests\validate-theme.ps1

install: validate
	@$(POWERSHELL) -NoProfile -ExecutionPolicy Bypass -File scripts\install-theme.ps1 -Prefix "$(PREFIX)" -Targets iterm2,ghostty,tmux,nvim,eza,delta,lazygit
	@$(POWERSHELL) -NoProfile -ExecutionPolicy Bypass -File scripts\deploy-windows-light.ps1 -Prefix "$(PREFIX)"

deploy: install

deploy-light: install
	@$(POWERSHELL) -NoProfile -ExecutionPolicy Bypass -File scripts\deploy-windows-light.ps1 -Prefix "$(PREFIX)"

install-iterm2: validate
	@$(POWERSHELL) -NoProfile -ExecutionPolicy Bypass -File scripts\install-theme.ps1 -Prefix "$(PREFIX)" -Targets iterm2

deploy-iterm2: install-iterm2

install-ghostty: validate
	@$(POWERSHELL) -NoProfile -ExecutionPolicy Bypass -File scripts\install-theme.ps1 -Prefix "$(PREFIX)" -Targets ghostty

deploy-ghostty: install-ghostty

install-tmux: validate
	@$(POWERSHELL) -NoProfile -ExecutionPolicy Bypass -File scripts\install-theme.ps1 -Prefix "$(PREFIX)" -Targets tmux

deploy-tmux: install-tmux

install-nvim: validate
	@$(POWERSHELL) -NoProfile -ExecutionPolicy Bypass -File scripts\install-theme.ps1 -Prefix "$(PREFIX)" -Targets nvim

deploy-nvim: install-nvim

install-eza: validate
	@$(POWERSHELL) -NoProfile -ExecutionPolicy Bypass -File scripts\install-theme.ps1 -Prefix "$(PREFIX)" -Targets eza

deploy-eza: install-eza

install-delta: validate
	@$(POWERSHELL) -NoProfile -ExecutionPolicy Bypass -File scripts\install-theme.ps1 -Prefix "$(PREFIX)" -Targets delta

deploy-delta: install-delta

install-lazygit: validate
	@$(POWERSHELL) -NoProfile -ExecutionPolicy Bypass -File scripts\install-theme.ps1 -Prefix "$(PREFIX)" -Targets lazygit

deploy-lazygit: install-lazygit

install-wallpapers: validate
	@$(POWERSHELL) -NoProfile -ExecutionPolicy Bypass -File scripts\deploy-windows-light.ps1 -Prefix "$(PREFIX)" -InstallOnly

deploy-wallpapers: deploy-light

else

validate:
	@tests/validate-iterm2-theme.sh
	@tests/validate-ghostty-theme.sh
	@tests/validate-tmux-theme.sh
	@tests/validate-nvim-theme.sh
	@tests/validate-eza-theme.sh
	@tests/validate-delta-theme.sh
	@tests/validate-lazygit-theme.sh
	@tests/validate-dark-backgrounds.sh

install: install-iterm2 install-ghostty install-tmux install-nvim install-eza install-delta install-lazygit

deploy: deploy-iterm2 deploy-ghostty deploy-tmux deploy-nvim deploy-eza deploy-delta deploy-lazygit

install-iterm2: validate
	install -d "$(ITERM2_COLOR_DIR)" "$(ITERM2_DYNAMIC_PROFILES_DIR)"
	install -m 0644 $(ITERM2_COLOR_PRESETS) "$(ITERM2_COLOR_DIR)/"
	install -m 0644 $(ITERM2_DYNAMIC_PROFILES) "$(ITERM2_DYNAMIC_PROFILES_DIR)/"
	@echo "Installed iTerm2 Dynamic Profiles to $(ITERM2_DYNAMIC_PROFILES_DIR)"
	@echo "Copied iTerm2 color presets to $(ITERM2_COLOR_DIR)"

deploy-iterm2: install-iterm2

install-ghostty: validate
	install -d "$(GHOSTTY_THEME_DIR)"
	install -m 0644 $(GHOSTTY_THEMES) "$(GHOSTTY_THEME_DIR)/"
	@echo "Installed Ghostty themes to $(GHOSTTY_THEME_DIR)"

deploy-ghostty: install-ghostty

install-tmux: validate
	install -d "$(TMUX_THEME_DIR)"
	install -m 0644 $(TMUX_THEMES) "$(TMUX_THEME_DIR)/"
	@echo "Installed tmux themes to $(TMUX_THEME_DIR)"

deploy-tmux: install-tmux

install-nvim: validate
	install -d "$(NVIM_COLOR_DIR)"
	install -m 0644 $(NVIM_COLORSCHEMES) "$(NVIM_COLOR_DIR)/"
	@echo "Installed Neovim colorschemes to $(NVIM_COLOR_DIR)"

deploy-nvim: install-nvim

install-eza: validate
	install -d "$(EZA_THEME_DIR)"
	install -m 0644 $(EZA_THEMES) "$(EZA_THEME_DIR)/"
	@echo "Installed eza themes to $(EZA_THEME_DIR)"

deploy-eza: install-eza

install-delta: validate
	install -d "$(DELTA_THEME_DIR)"
	install -m 0644 $(DELTA_THEMES) "$(DELTA_THEME_DIR)/"
	@echo "Installed delta themes to $(DELTA_THEME_DIR)"

deploy-delta: install-delta

install-lazygit: validate
	install -d "$(LAZYGIT_THEME_DIR)"
	install -m 0644 $(LAZYGIT_THEMES) "$(LAZYGIT_THEME_DIR)/"
	@echo "Installed lazygit themes to $(LAZYGIT_THEME_DIR)"

deploy-lazygit: install-lazygit

endif
