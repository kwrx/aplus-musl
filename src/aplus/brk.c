#define _BSD_SOURCE
#include <unistd.h>
#include <errno.h>
#include "syscall.h"

int brk(void *end)
{
	unsigned long cur = __syscall(SYS_brk, 0);
	unsigned long new = __syscall(SYS_brk, end);

	if(cur == end)
		return __syscall_ret(-ENOMEM);

	return 0;
}
