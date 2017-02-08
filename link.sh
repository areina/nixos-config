#!/usr/bin/env bash

set -e
dir=$(pwd)

ln -fs "${dir}/thinkpad-x250.nix" /etc/nixos/configuration.nix
