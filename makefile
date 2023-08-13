VPATH=output
run:helloos.img tolset
	copy output\helloos.img tolset\z_tools\qemu\fdimage0.bin
	make -C tolset\z_tools\qemu
helloos.img:ipl.bin helloos.sys
	edimg.exe imgin:tolset/z_tools/fdimg0at.tek \
	wbinimg src:output\ipl.bin len:512 from:0 to:0   \
	copy from:output\helloos.sys to:@: \
	imgout:output/helloos.img
ipl.bin:ipl.asm
	nask ipl.asm output/$@ output/ipl.lst

change_display_mode:change_display_mode.asm
	nask change_display_mode.asm output/$@ output/change_display_mode.lst

asmhead.bin:asmhead.nas #编译bootloader的第一部分
	nask asmhead.nas output/$@ output/asmhead.lst

main.gas:main.cpp #编译main.cpp为某种叫gas的汇编语言,实际上是gcc用的汇编语言
	cc1 main.cpp -o output/$@

main.nas:main.gas #把gcc的汇编语言，转为nask能识别的汇编语言
	gas2nask -a output/main.gas output/main.nas

main.obj:main.nas 
	nask output/main.nas output/main.obj output/main.lst
io_hlt.obj:io_hlt.asm
	nask io_hlt.asm output/io_hlt.obj output/io_hlt.lst

main.bim: main.obj io_hlt.obj link_rule.rul# 把目标文件链接成某种中间格式（这个格式可以进一步加工成可执行文件）
	obj2bim @link_rule.rul out:output/main.bim stack:3136k map:output/main.map output/main.obj output/io_hlt.obj
main.hrb:main.bim
	bim2hrb output/main.bim output/main.hrb 0
clean:
	del /s /q output
helloos.sys: asmhead.bin main.hrb# 操作系统的bootloader,这个bootloader由两部分完成，一部分是纯汇编，另一部分是由c语言编译器编译而成的程序
	copy /B output\asmhead.bin+output\main.hrb output\$@

