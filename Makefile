GCC := gcc
CLANG := clang
GLINK := ld
CLINK := ld.lld
CC ?= $(GCC)
LD ?= $(GLINK)
AS := nasm

ASFLAGS := \
	-f \
	elf64

NOPIE_LINK := \
	-no-pie

BUILDDIR := build/
ARCHDIR_X64 := x86_64/
HOSTEDDIR := hosted/
FREESTDIR := freest/
EXEDIR := bin/
LIBDIR := lib/
SRCDIR := src/

.PHONY: genbuild_hosted
genbuild_hosted:
	mkdir -p $(BUILDDIR) \
		$(BUILDDIR)$(HOSTEDDIR)$(ARCHDIR_X64) \
		$(BUILDDIR)$(HOSTEDDIR)$(ARCHDIR_X64)$(EXEDIR) \
		$(BUILDDIR)$(HOSTEDDIR)$(ARCHDIR_X64)$(LIBDIR)

.PHONY: genbuild_freest
genbuild_freest:
	mkdir -p $(BUILDDIR) \
		$(BUILDDIR)$(FREESTDIR)$(ARCHDIR_X64) \
		$(BUILDDIR)$(FREESTDIR)$(ARCHDIR_X64)$(EXEDIR) \
		$(BUILDDIR)$(FREESTDIR)$(ARCHDIR_X64)$(LIBDIR)

.PHONY: clean
clean:
	rm -rf $(BUILDDIR)
	find . -name "*.o" -delete
