#define _BSD_SOURCE
#include <unistd.h>
#include <stdint.h>
#include <errno.h>
#include "syscall.h"

void *sbrk(intptr_t inc)
{
	unsigned long cur = __syscall(SYS_brk, 0);

	if(!inc)
		return cur;


	unsigned long new = __syscall(SYS_brk, cur + inc);

	if(new == cur)
		return (void*) __syscall_ret(-ENOMEM);

	return cur;
}
