#!/usr/bin/env bash
echo "Installing Rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -q -y --no-modify-path
source ~/.cargo/env
completions=~/.local/share/bash-completion/completions
mkdir -p $completions
rustup completions bash > $completions/rustup
rustup completions bash cargo > $completions/cargo
