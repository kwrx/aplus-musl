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




#define HAVE_MORECORE                       1
#define HAVE_MMAP                           0
#define HAVE_MREMAP                         0

#define USE_BUILTIN_FFS                     0

#define MORECORE_CANNOT_TRIM                1
#define ABORT_ON_ASSERT_FAILURE             1
#define NO_MALLOC_STATS                     0
#define REALLOC_ZERO_BYTES_FREES            1
#define MMAP_CLEARS                         0
#define MALLOC_ALIGNMENT                    16


#define MALLOC_FAILURE_ACTION               \
    errno = ENOMEM;

#define malloc_getpagesize                  \
    PAGE_SIZE

#define DLMALLOC_EXPORT                     \
    weak

#define MORECORE(size)                      \
    sbrk(size)

#define POINTER_UINT                        \
    unsigned _POINTER_INT


#define MALLOC_LOCK         ((void) 0)
#define MALLOC_UNLOCK       ((void) 0)


#include "dlmalloc.h"
