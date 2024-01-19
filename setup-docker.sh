#!/usr/bin/env bash
# Docker Setup Script
# Run this first if you're using/testing hadoop script on an Ubuntu Docker image

apt install -y sudo wget neovim                   # install basic dependencies
adduser user
usermod -aG sudo user
