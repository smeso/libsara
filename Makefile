#!/usr/bin/make
#
#     libsara - S.A.R.A.'s helper library
#     Copyright (C) 2017  Salvatore Mesoraca <s.mesoraca16@gmail.com>
#
#     This program is released under CC0 1.0 Universal license
#

ifndef DESTDIR
DESTDIR := /
endif
ifndef LIBDIR
LIBDIR := usr/lib/
endif
ifndef STATICLIBDIR
STATICLIBDIR := usr/lib/
endif
ifndef INCLUDEDIR
INCLUDEDIR := usr/include/
endif

CC := $(CROSS_COMPILE)gcc
LD := $(CROSS_COMPILE)ld
CFLAGS := -O2 -fstack-protector -fPIC $(CFLAGS)
LDFLAGS := -Wl,-z,relro -Wl,-z,now -Wl,-Bsymbolic-functions -shared $(LDFLAGS)

all: libsara.so libsara.a

$(SOURCE)%.o: $(SOURCE)%.c
	$(CC) -c -o $@ $< $(CFLAGS)

libsara.so: libsara.o
	$(CC) -o $@ $^ -Wl,-soname,$@.0 $(LDFLAGS)

libsara.a: libsara.o
	ar rcs $@ $^

ifdef DESTDIR
ifdef LIBDIR
ifdef STATICLIBDIR
ifdef INCLUDEDIR
install: all
	mkdir -p $(DESTDIR)/$(LIBDIR)
	mkdir -p $(DESTDIR)/$(STATICLIBDIR)
	mkdir -p $(DESTDIR)/$(INCLUDEDIR)
	cp sara.h $(DESTDIR)/$(INCLUDEDIR)
	cp libsara.so $(DESTDIR)/$(LIBDIR)
	cp libsara.a $(DESTDIR)/$(STATICLIBDIR)
uninstall:
	-rm $(DESTDIR)/$(INCLUDEDIR)/sara.h
	-rm $(DESTDIR)/$(LIBDIR)/libsara.so
	-rm $(DESTDIR)/$(STATICLIBDIR)/libsara.a
endif
endif
endif
endif

clean:
	-rm -f libsara.so* libsara.a
	-rm -f *.o *~

.PHONY: all install uninstall clean
