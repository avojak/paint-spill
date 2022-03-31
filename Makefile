# I'm lazy, and it's easier to remember 'make all' than the entire flatpak-builder command :)

SHELL := /bin/bash

.PHONY: all flatpak lint clean

all: flatpak

init:
	flatpak remote-add --if-not-exists --system appcenter https://flatpak.elementary.io/repo.flatpakrepo
	flatpak install -y appcenter io.elementary.Platform io.elementary.Sdk

flatpak:
	flatpak-builder build com.github.avojak.flood.yml --user --install --force-clean

lint:
	io.elementary.vala-lint ./src

translations:

clean:
	rm -rf build/
	rm -rf builddir/
	rm -rf .flatpak-builder/