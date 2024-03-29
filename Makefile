#      This file is part of the KoraOS project.
#  Copyright (C) 2015-2021  <Fabien Bavent>
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU Affero General Public License as
#  published by the Free Software Foundation, either version 3 of the
#  License, or (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Affero General Public License for more details.
#
#  You should have received a copy of the GNU Affero General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
topdir ?= $(shell readlink -f $(dir $(word 1,$(MAKEFILE_LIST))))
gendir ?= $(shell pwd)

include $(topdir)/make/global.mk
srcdir = $(topdir)/src

all: libsnd

install: $(prefix)/lib/libsnd.so install-headers

include $(topdir)/make/build.mk
include $(topdir)/make/check.mk
include $(topdir)/make/targets.mk

CFLAGS ?= -Wall -Wextra -Wno-unused-parameter -ggdb

# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

disto ?= kora

# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
SRCS_l += $(wildcard $(srcdir)/*.c)
SRCS_l += $(srcdir)/addons/$(disto).c

CFLAGS_l += $(CFLAGS)
CFLAGS_l += -I$(topdir)/include
CFLAGS_l += -fPIC

ifneq ($(sysdir),)
CFLAGS_l += -I$(sysdir)/include
LFLAGS_l += -L$(sysdir)/lib
LFLAGS_l += -Wl,-rpath-link,$(sysdir)/lib
endif


$(eval $(call comp_source,l,CFLAGS_l))
$(eval $(call link_shared,snd,SRCS_l,LFLAGS_l,l))


# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

install-headers: $(patsubst $(topdir)/%,$(prefix)/%,$(wildcard $(topdir)/include/*.h))

$(prefix)/include/%.h: $(topdir)/include/%.h
	$(S) mkdir -p $(dir $@)
	$(V) cp -vrP $< $@


check: $(patsubst %,val_%,$(CHECKS))

ifeq ($(NODEPS),)
-include $(call fn_deps,SRCS_l,l)
endif
