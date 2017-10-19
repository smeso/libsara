/*
 *    libsara - S.A.R.A.'s helper library
 *    Copyright (C) 2017  Salvatore Mesoraca <s.mesoraca16@gmail.com>
 *
 *    This program is released under CC0 1.0 Universal license
 */

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include "sara.h"

int set_wxprot_self_flags(uint16_t flags)
{
	FILE *f;

	f = fopen("/proc/self/attr/sara/wxprot", "w");
	if (f == NULL)
		return 1;
	if (fprintf(f, "0x%04x\n", flags) != 7)
		return 1;
	if (fclose(f) != 0)
		return 1;
	return 0;
}

static uint16_t __get_wxprot_flags(char *str)
{
	FILE *f;
	char path[33];
	char buf[7] = {0};

	snprintf(path, sizeof(path), "/proc/%s/attr/sara/wxprot", str);
	f = fopen(path, "r");
	if (f == NULL)
		return SARA_ERROR;
	if (fread(buf, sizeof(buf)-1, 1, f) != 1)
		return SARA_ERROR;
	fclose(f);
	return (uint16_t) strtoul(buf, NULL, 16);
}

uint16_t get_wxprot_self_flags(void)
{
	return __get_wxprot_flags("self");
}

uint16_t get_wxprot_flags(pid_t pid)
{
	char p[10];

	snprintf(p, sizeof(p), "%d", pid);
	return __get_wxprot_flags(p);
}

int add_wxprot_self_flags(uint16_t flags)
{
	uint16_t cflags = get_wxprot_self_flags();

	if (cflags == SARA_ERROR)
		return 1;
	flags |= cflags;
	return set_wxprot_self_flags(flags);
}

int rm_wxprot_self_flags(uint16_t flags)
{
	uint16_t cflags = get_wxprot_self_flags();

	if (cflags == SARA_ERROR)
		return 1;
	flags = cflags & ~flags;
	return set_wxprot_self_flags(flags);
}

int is_emutramp_active(void)
{
	if (get_wxprot_self_flags() & SARA_EMUTRAMP)
		return 1;
	else
		return 0;
}
