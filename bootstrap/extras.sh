#!/bin/bash
# insert additional commands to run at the end of bootstrapping below.

# Global extras:
ya pack -a yazi-rs/plugins:git
command -v aider >/dev/null || {
  echo 'installing aider...'
  uv tool install --force --python python3.12 --with pip --with google-generativeai aider-chat@latest
}
# uv tool install ra-aid # like aider

# Check OS
OS=$(uname -o)

# windows part
if [[ "$OS" =~ Cygwin|Msys|MinGW ]]; then

  # $EDITOR=nvim
  [[ -z "${EDITOR}" ]] &&
    powershell.exe -Command "[System.Environment]::SetEnvironmentVariable('EDITOR', 'nvim', 'User')" &&
    echo 'set EDITOR as nvim...' ||
    echo "$EDITOR already set..."

  # winget part: winget is werid on windows so just put it here
  command -v eza >/dev/null || {
    echo 'installing eza...'
    winget install eza-community.eza
  }
  command -v yazi >/dev/null || {
    echo 'installing yazi...'
    winget install sxyazi.yazi
  }
  command -v uv >/dev/null || {
    echo 'installing uv...'
    winget install --exact --id=astral-sh.uv
  }
  command -v docker >/dev/null || {
    echo 'installing docker...'
    winget install --exact --id Docker.DockerDesktop
  }
  command -v ollama >/dev/null || {
    echo 'installing ollama...'
    winget install --exact --id Ollama.Ollama
  }

# mac part
# elif [[ "$OS" = Darwin ]]; then
fi
