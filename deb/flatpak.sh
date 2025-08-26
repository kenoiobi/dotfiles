#!/usr/bin/env sh

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub\
    com.discordapp.Discord\
    com.valvesoftware.Steam\
    md.obsidian.Obsidian
