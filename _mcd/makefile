################################################################################
# MEGADEV - Development framework for Sega Mega CD hardware
# https://github.com/drojaazu/megadev
################################################################################

# This will be used for filename output
PROJECT_NAME=disc

## Directory paths are relative to the location of the makefile
## (which should be the root of your project directory)

# Source code path
SRC_PATH:=src

# Disc staging path
# This is the staging directory for fiels that will appear on the final iso for
# each Mega CD disc. Inside this path will be a subdirectory matching the stem of
# each .iso.def in your project. Any files in these subdirectories will be included
# in the iso image.
# (This option is ignored for cartridge ROM projects.)
DISCS_PATH:=discs

# Resources path
# This is where graphics, audio and any other non-executable content should be
# stored.
RES_PATH:=res

# Build path
# This is where compile time build artifacts will be stored, including
# symbol maps
BUILD_PATH:=build

# Disc paths
# A space-delimited list of subdiorectories representing the content for each
# disc in your project
# This is used by the `init` rule to create directories before building
DISC_PATHS:=disc

# Optional compiler flags
# Here you can add any additional compiler flags
OPT_FLAGS:=-O1 -fconserve-stack

# Path to the Megadev directory
MEGADEV_PATH:=$(shell pwd)/../../megadev

M68K_PREFIX:=~/marsdev/mars/m68k-elf/bin/m68k-elf-

AS_FLAGS:=-Wa,--bitwise-or -Wa,-I../_debugger/blob

include $(MEGADEV_PATH)/megadev.make

.PHONY: disc clean

disc: \
	init \
	disc/ip.bin \
	disc/ipx.mmd \
	disc/sp.bin \
	disc/spx.smd \
	disc/* \
	disc.iso

clean:
	@rm -rf disc.iso disc/*.mmd disc/*.smd build/*

disc/ipx.mmd: \
	ipx_layout.s \
	ipx_init.s \
	ipx.c \
	$(BUILD_PATH)/ip.bin

disc/ip.bin: $(BUILD_PATH)/ip.bin
	cp $< $@

disc/spx.smd: \
	spx_layout.s \
	spx.c \
	$(BUILD_PATH)/sp.bin \
	spx_pcm.s

disc/sp.bin: $(BUILD_PATH)/sp.bin
	cp $< $@
