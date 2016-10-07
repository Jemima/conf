#!/usr/bin/env zsh
([[ -e ~/.zshrc ]] && echo zshrc already exists, not overwriting) || echo source ~/conf/.zshrc > ~/.zshrc
