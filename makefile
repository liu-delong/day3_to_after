VPATH=output
run:helloos.img tolset
	copy output\helloos.img tolset\z_tools\qemu\fdimage0.bin
	make -C tolset\z_tools\qemu
helloos.img:ipl.bin
	edimg.exe   imgin:tolset/z_tools/fdimg0at.tek wbinimg src:output/ipl.bin len:512 from:0 to:0   imgout:output/helloos.img
ipl.bin:ipl.asm
	nask ipl.asm output/$@ output/ipl.lst
clean:
	del output/*
