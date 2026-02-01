# Kadachi: my personal NixOS configuration

**README is a WIP**

This is my personal NixOS configuration, it's largely inspired by the [Dendritic pattern](https://github.com/mightyiam/dendritic).

## Namespaces

### ⚙️ Adachi

Shared namespace containing generic configuration for aspects.

Can be used from outside the flake using [den](https://github.com/vic/den) with `den.ful.adachi.<aspect>`

### 🥖 Kasane

Private namespace, contains my personal configuration for various programs and services

## Hosts

### 🐬 Totsugeki

My main desktop computer

#### Desktop

| Name      | Description                        |
| --------- | ---------------------------------- |
| Hyprland  | Wayland compositor                 |
| Hyprlock  | Session lock                       |
| Caelestia | Shell (Launcher, notifications...) |
| awww      | Wallpaper                          |

#### Programs

| Name        | Description      |
| ----------- | ---------------- |
| Firefox     | Web browser      |
| kitty       | Desktop terminal |
| qBitTorrent | Torrent client   |

### 🐳 Great Yamada

Home server

#### Services

| Name         | Description                  | Local only |
| ------------ | ---------------------------- | :--------: |
| ACME         | Automatic SSL cert renewal   |            |
| AdGuard Home | DNS/DHCP server              |     X      |
| Forgejo      | Git server                   |            |
| Inadyn       | Automatic DDNS updates       |            |
| Jellyfin     | Media server                 |            |
| Koito        | Music scrobbler              |            |
| nginx        | Web server and reverse proxy |            |
| PostgreSQL   | Database                     |     X      |
| PgAdmin4     | PostgreSQL management tool   |     X      |
| Radicale     | CalDAV and CardDAV server    |     X      |
| Samba        | File sharing                 |     X      |
| SearXNG      | Metasearch engine            |     X      |
| Vaultwarden  | Password manager             |     X      |
| Wireguard    | VPN                          |            |

### 🎀 Mizuki

A very simple WSL configuration I use at work for Python and Typescript+Vue development

### 🦉 Malfestio (WIP)

Steam Deck

## References, name sources and special thanks

<!-- TODO -->

### Special thanks

- [Victor Borja](https://github.com/vic) for making [den](https://github.com/vic/den) and all of his Nix utilities
