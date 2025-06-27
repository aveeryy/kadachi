---
gitea: none
include_toc: true
---

# NixOS system configurations

<!-- ## Installation (WIP) -->

## Hosts

### 🐬 Totsugeki | Desktop

Main desktop configuration

#### Programs

|               Name | Type                |
| -----------------: | :------------------ |
|           Hyprland | Wayland compositor  |
|           Hyprlock | Session locking     |
|  Aylur's GTK Shell | Bar and launcher    |
|              kitty | Terminal emulator   |
|             Neovim | Text editor         |
|            Firefox | Web browser         |
|         PCManFM-Qt | File manager        |
|        qBittorrent | Torrent client      |
|                mpv | Video player        |
|        LibreOffice | Office suite        |
|               GIMP | Photo editor        |
|           Inkscape | Vector image editor |
|        EasyEffects | Audio equalizer     |
| MusicBrainz Picard | Music tagging       |
|            Element | Matrix client       |
|            Vesktop | Discord client      |

#### Games and game-related stuff

|           Name | Type                                    |
| -------------: | :-------------------------------------- |
|          Steam | Game launcher                           |
|         Heroic | Games launcher for Epic, GOG and Amazon |
| Prism Launcher | Minecraft launcher                      |
|      osu!lazer | Rhythm game, open source version        |
|       r2modman | Mod manager                             |
|    ProtonUp-Qt | Tool to update Proton-GE and similar    |

### 🐳 Great Yamada | Home server

#### Services

|         Name | Type                           | Public-facing |
| -----------: | :----------------------------- | :-----------: |
|        Nginx | Web server and reverse proxy   |       x       |
|         ACME | Automatic SSL cert renew       |               |
|       Inadyn | Automatic DDNS updates         |               |
|   PostgreSQL | Database engine                |               |
|     PgAdmin4 | PostgreSQL management tool     |               |
|      Forgejo | Git repository                 |       x       |
|       Fabric | Minecraft server               |       x       |
| AdGuard Home | DNS server and content blocker |               |
|      SearXNG | Metasearch engine              |               |
|     Radicale | CalDAV / CardDAV server        |               |
|     Jellyfin | Media server                   |       x       |
|        Koito | Scrobbler                      |       x       |
|  Vaultwarden | Password manager               |               |

### 🎀 Mizuki | Development on WSL

Windows Subsystem for Linux configuration

Uses the common Neovim and zsh config
