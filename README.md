---
gitea: none
include_toc: true
---

# NixOS system configurations

<!-- ## Installation (WIP) -->

## Hosts

### 🐬 Totsugeki | Desktop

Desktop with NixOS as a primary system and Windows 11 N as secondary. Has secure boot support.

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

**Still a WIP**

|         Name | Type                           | Public-facing |
| -----------: | :----------------------------- | :-----------: |
|        Nginx | Web server and reverse proxy   |       x       |
|   PostgreSQL | Database engine                |
|      Forgejo | Git repository                 |       x       |
|      PaperMC | Minecraft server               |       x       |
| AdGuard Home | DNS server and content blocker |               |
|    Invidious | YouTube proxy                  |               |
|      SearXNG | Metasearch engine              |               |
|     Radicale | CalDAV / CardDAV server        |               |
