[FORMAT "WCOFF"]  //编译成wcoff格式的目标文件
[BITS 32]         //使用32位指令集
[FILE "io_hlt.asm"]
GLOBAL _io_hlt
[SECTION .text]
_io_hlt:
    HLT
    RET