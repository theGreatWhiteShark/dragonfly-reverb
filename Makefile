#!/usr/bin/make -f
# Makefile for DISTRHO Plugins #
# ---------------------------- #
# Created by falkTX
#

include dpf/Makefile.base.mk

all: dgl plugins gen

# --------------------------------------------------------------

dgl:
ifeq ($(HAVE_OPENGL),true)
	$(MAKE) -C dpf/dgl opengl
endif

plugins: dgl
	$(MAKE) all -C plugins/dragonfly-hall-reverb
	$(MAKE) all -C plugins/dragonfly-room-reverb
	$(MAKE) all -C plugins/dragonfly-plate-reverb
	$(MAKE) all -C plugins/dragonfly-early-reflections

ifneq ($(CROSS_COMPILING),true)
gen: plugins dpf/utils/lv2_ttl_generator
	@$(CURDIR)/dpf/utils/generate-ttl.sh
ifeq ($(MACOS),true)
	@$(CURDIR)/dpf/utils/generate-vst-bundles.sh
endif

dpf/utils/lv2_ttl_generator:
	$(MAKE) -C dpf/utils/lv2-ttl-generator
else
gen:
endif

# --------------------------------------------------------------

clean:
	$(MAKE) clean -C dpf/dgl
	$(MAKE) clean -C dpf/utils/lv2-ttl-generator
	$(MAKE) clean -C plugins/dragonfly-hall-reverb
	$(MAKE) clean -C plugins/dragonfly-room-reverb
	$(MAKE) clean -C plugins/dragonfly-plate-reverb
	$(MAKE) clean -C plugins/dragonfly-early-reflections
	rm -rf bin build

# --------------------------------------------------------------

.PHONY: plugins
