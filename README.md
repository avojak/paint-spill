![CI](https://github.com/avojak/flood/workflows/CI/badge.svg)
![Lint](https://github.com/avojak/flood/workflows/Lint/badge.svg)
![GitHub](https://img.shields.io/github/license/avojak/flood.svg?color=blue)
![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/avojak/flood?sort=semver)

<p align="center">
  <img src="data/assets/flood.svg" alt="Icon" />
</p>
<h1 align="center">Flood</h1>
<!-- <p align="center">
  <a href="https://appcenter.elementary.io/com.github.avojak.flood"><img src="https://appcenter.elementary.io/badge.svg" alt="Get it on AppCenter" /></a>
</p> -->

## Flood the board with all the same color!

The classic puzzle game, designed for elementary OS.

| ![Screenshot](data/assets/screenshots/flood-screenshot-01.png) |
|------------------------------------------------------------------|

## Install from Source

You can install Flood by compiling from source. Here's the list of
dependencies required:

- `libgranite (>= 6.2.0)`
- `libgtk-3-dev (>= 3.24.20)`
- `libgee-0.8-dev (>= 3.24.20)`
- `libhandy-1-dev (>= 1.2.0)`
- `meson`
- `valac (>= 0.28.0)`

## Building and Running

```
$ meson build --prefix=/usr
$ sudo ninja -C build install
$ com.github.avojak.flood
```

### Flatpak

Flatpak is the preferred method of building Flood:

```bash
$ flatpak-builder build com.github.avojak.flood.yml --user --install --force-clean
$ flatpak run --env=G_MESSAGES_DEBUG=all com.github.avojak.flood
```

### Updating Translations

When new translatable strings are added, ensure that `po/POTFILES` contains a
reference to the file with the translatable string.

Update the `.pot` file which contains the translatable strings:

```
$ ninja -C build com.github.avojak.flood-pot
```

Generate translations for the languages listed in the `po/LINGUAS` files:

```
$ ninja -C build com.github.avojak.flood-update-po
```