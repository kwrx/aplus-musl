
#if defined(__aplus__)

__asm__(
    ".text                  \n"
    ".global " START "      \n"
    START ":                \n"
    "	xor %rbp,%rbp       \n"
    ".weak _DYNAMIC         \n"
    ".hidden _DYNAMIC       \n"
    "	andq $-16,%rsp      \n"
    "	call " START "_c    \n"
);

#else

__asm__(
".text \n"
".global " START " \n"
START ": \n"
"	xor %rbp,%rbp \n"
"	mov %rsp,%rdi \n"
".weak _DYNAMIC \n"
".hidden _DYNAMIC \n"
"	lea _DYNAMIC(%rip),%rsi \n"
"	andq $-16,%rsp \n"
"	call " START "_c \n"
);

#endif
