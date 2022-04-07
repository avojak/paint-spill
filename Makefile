SHELL := /bin/bash

APP_ID := com.github.avojak.paint-spill

BUILD_DIR        := build
NINJA_BUILD_FILE := $(BUILD_DIR)/build.ninja

.PHONY: all flatpak lint translations clean
.DEFAULT_GOAL := flatpak

all: translations flatpak

init:
	flatpak remote-add --if-not-exists --system appcenter https://flatpak.elementary.io/repo.flatpakrepo
	flatpak install -y appcenter io.elementary.Platform io.elementary.Sdk

flatpak:
	flatpak-builder build $(APP_ID).yml --user --install --force-clean

lint:
	io.elementary.vala-lint ./src

$(NINJA_BUILD_FILE):
	meson build --prefix=/user

translations: $(NINJA_BUILD_FILE)
	ninja -C build $(APP_ID)-pot
	ninja -C build $(APP_ID)-update-po

clean:
	rm -rf build/
	rm -rf builddir/
	rm -rf .flatpak-builder/