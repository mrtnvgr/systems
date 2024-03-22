<h1 align="center">❄️</h1>

[![Automatic ISO builds](https://github.com/mrtnvgr/nixfiles/actions/workflows/build_iso.yml/badge.svg)](https://github.com/mrtnvgr/nixfiles/actions/workflows/build_iso.yml)
[![Grawler checks](https://github.com/mrtnvgr/nixfiles/actions/workflows/grawler.yml/badge.svg)](https://github.com/mrtnvgr/nixfiles/actions/workflows/grawler.yml)

This repository contains my [NixOS](https://nixos.org/) configurations

> [!WARNING]
> Work in progress, expect bugs and regressions

## Hosts

### Desktops

- **nixie** - daily driver laptop
- _**thlix** - personal ISO with secrets (basically personal `nixie`)_
- _**minix** - base for all desktops (mainly used for ISO builds)_

### Servers

- **cloud** - main server

## Usage

### Real-hardware installation

- Follow the official NixOS installation [guide](https://nixos.wiki/wiki/NixOS_Installation_Guide) **until `NixOS Installation` section**
- Clone this repo: `git clone https://github.com/mrtnvgr/nixfiles`
- Create your host (look in `flake.nix` and `hosts` for examples)
  - Copy `/mnt/etc/nixos/hardware-configuration.nix` to `hardware.nix`
- Install: `nixos-install --root /mnt --flake .#<YOUR-HOST-NAME>`
- Move this repo to installed system: `mv nixfiles /mnt/home/<your-username>/`
- Reboot: `reboot`

### Portable environment

#### Pick a format

- **isoplus** - LiveISO, heavily compressed, loaded into the RAM for performance
  - For **persistence** support, specify `--special-arg persistence 1` while creating the image
- **rawplus** - full mutability, image of a *regular* installation
  - Expect a *horrible* experience on USB sticks
  - Consider **only** for external SSD/HDD drives
  - Specify `--disk-size <MEGABYTES>` while creating the image

#### Steps

- Bring `nixos-generators` into the scope: `nix shell github:nix-community/nixos-generators`
- Use the `minix` host or create your own
- Generate an image: `nixos-generate --flake .#<YOUR-HOST-NAME> --format-path genfmts/<FORMAT>.nix`
- Flash: `cat <path-to-image> > /dev/sdX`
- **Only for isoplus with persistence**:
  - Create a new volume: `fdisk /dev/sdX <<<$'n\np\n\n\n\nw'`
  - Format the volume: `mkfs.ext4 -L <YOUR-HOST-NAME>persistence /dev/sdX3`
