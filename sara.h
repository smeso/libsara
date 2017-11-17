/*
 *    libsara - S.A.R.A.'s helper library
 *    Copyright (C) 2017  Salvatore Mesoraca <s.mesoraca16@gmail.com>
 *
 *    This program is released under CC0 1.0 Universal license
 */


#ifndef _SARA_H
#define _SARA_H

#include <stdint.h>
#include <unistd.h>

#define SARA_ERROR		0xffff
#define SARA_HEAP		0x0001
#define SARA_STACK		0x0002
#define SARA_OTHER		0x0004
#define SARA_WXORX		0x0008
#define SARA_COMPLAIN		0x0010
#define SARA_VERBOSE		0x0020
#define SARA_MMAP		0x0040
#define SARA_FORCE_WXORX	0x0080
#define SARA_EMUTRAMP		0x0100
#define SARA_TRANSFER		0x0200
#define SARA_NONE		0x0000
#define SARA_MPROTECT		(SARA_HEAP		| \
				 SARA_STACK		| \
				 SARA_OTHER		| \
				 SARA_WXORX)
#define SARA_FULL		(SARA_MPROTECT		| \
				 SARA_MMAP		| \
				 SARA_FORCE_WXORX)

int set_wxprot_self_flags(uint16_t flags) __attribute__((warn_unused_result));
int add_wxprot_self_flags(uint16_t flags) __attribute__((warn_unused_result));
int rm_wxprot_self_flags(uint16_t flags) __attribute__((warn_unused_result));
uint16_t get_wxprot_flags(pid_t pid);
uint16_t get_wxprot_self_flags(void);
int is_emutramp_active(void);

#endif /* _SARA_H */
