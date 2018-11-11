#!/usr/bin/make
#
#     libsara - S.A.R.A.'s helper library
#     Copyright (C) 2017  Salvatore Mesoraca <s.mesoraca16@gmail.com>
#
#     This program is released under CC0 1.0 Universal license
#

DESTDIR ?= /
LIBDIR ?= usr/lib/
STATICLIBDIR ?= usr/lib/
INCLUDEDIR ?= usr/include/

CC ?= $(CROSS_COMPILE)gcc
LD ?= $(CROSS_COMPILE)ld
CFLAGS := -O2 -fstack-protector -fPIC $(CFLAGS)
LDFLAGS := -Wl,-z,relro -Wl,-z,now -Wl,-Bsymbolic-functions -shared $(LDFLAGS)
SRCDIR= ./

all: libsara.so libsara.a

$(SOURCE)%.o: $(SRCDIR)/$(SOURCE)%.c
	$(CC) -c -o $@ $< $(CFLAGS)

libsara.so: libsara.o
	$(CC) -o $@ $^ -Wl,-soname,$@.0 $(LDFLAGS)

libsara.a: libsara.o
	ar rcs $@ $^

install: all
	mkdir -p $(DESTDIR)/$(LIBDIR)
	mkdir -p $(DESTDIR)/$(STATICLIBDIR)
	mkdir -p $(DESTDIR)/$(INCLUDEDIR)
	mkdir -p $(DESTDIR)/$(LIBDIR)/pkgconfig/
	mkdir -p $(DESTDIR)/usr/share/man/man3/
	cp $(SRCDIR)/sara.h $(DESTDIR)/$(INCLUDEDIR)
	cp libsara.so $(DESTDIR)/$(LIBDIR)
	cp libsara.a $(DESTDIR)/$(STATICLIBDIR)
	cp libsara.pc $(DESTDIR)/$(LIBDIR)/pkgconfig/
	gzip -c man/sara.h.3 > $(DESTDIR)/usr/share/man/man3/sara.h.3.gz

uninstall:
	-rm $(DESTDIR)/$(INCLUDEDIR)/sara.h
	-rm $(DESTDIR)/$(LIBDIR)/libsara.so
	-rm $(DESTDIR)/$(STATICLIBDIR)/libsara.a
	-rm $(DESTDIR)/$(LIBDIR)/pkgconfig/libsara.pc
	-rm $(DESTDIR)/usr/share/man/man3/sara.h.3.gz
	-rmdir $(DESTDIR)/$(INCLUDEDIR)
	-rmdir $(DESTDIR)/$(LIBDIR)
	-rmdir $(DESTDIR)/$(STATICLIBDIR)
	-rmdir $(DESTDIR)/$(LIBDIR)/pkgconfig/

clean:
	-rm -f *.o *~
	-rm -f $(SRCDIR)/*~

distclean:
	-rm -f libsara.so* libsara.a

.PHONY: all install uninstall clean distclean
