/*
 * Author:
 *      Antonino Natale <antonio.natale97@hotmail.com>
 * 
 * Copyright (c) 2013-2019 Antonino Natale
 * 
 * 
 * This file is part of aPlus.
 * 
 * aPlus is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * aPlus is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with aPlus.  If not, see <http://www.gnu.org/licenses/>.
 */


#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <errno.h>
#include "libc.h"

extern void *sbrk(intptr_t inc);

#define USE_LOCKS               1
#define USE_SPIN_LOCKS          0
#define USE_RECURSIVE_LOCKS     1
#define LOCK_AT_FORK            1
#define HAVE_MORECORE           1
#define HAVE_MMAP               0
#define HAVE_MREMAP             0
#define USE_BUILTIN_FFS         1

#include "dlmalloc.h"
