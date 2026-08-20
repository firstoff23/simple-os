NASM ?= nasm
QEMU ?= qemu-system-i386

BUILD_DIR := build
IMAGE := $(BUILD_DIR)/simple-os.img
BOOT_SOURCE := boot/boot.asm

.PHONY: all build run test clean

all: build

build: $(IMAGE)

$(IMAGE): $(BOOT_SOURCE)
	mkdir -p $(BUILD_DIR)
	$(NASM) -f bin -Wall -Werror -o $(IMAGE) $(BOOT_SOURCE)
	test "$$(stat -c%s $(IMAGE))" -eq 512

run: $(IMAGE)
	$(QEMU) -drive format=raw,file=$(IMAGE),if=floppy

test: $(IMAGE)
	bash tests/boot-sector.sh $(IMAGE)

clean:
	rm -rf $(BUILD_DIR)
