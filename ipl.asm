ORG 0x7c00 ;伪指令，告诉编译器第一条指令的地址是0x7c00,cpu并不执行
	JMP		readinit
	DB		0x90
	DB		"HELLOIPL"		; 启动区的名称可以是任意字符（8字节） 作者：白羽b612 https://www.bilibili.com/read/cv7922792/ 出处：bilibili
	DW		512				; 每个扇区（sector）的大小（必须为512字节） 作者：白羽b612 https://www.bilibili.com/read/cv7922792/ 出处：bilibili
	DB		1				;  簇（cluster）的大小（必须为1个扇区） 作者：白羽b612 https://www.bilibili.com/read/cv7922792/ 出处：bilibili
	DW		1				; FAT的起始位置（一般从第一个扇区开始） 作者：白羽b612 https://www.bilibili.com/read/cv7922792/ 出处：bilibili
	DB		2				; FAT的个数（必须为2） 作者：白羽b612 https://www.bilibili.com/read/cv7922792/ 出处：bilibili
	DW		224				; 根目录大小（一般设为224项）
	DW		2880			; 该磁盘的大小，共2880扇区
	DB		0xf0			; 磁盘的种类
	DW		9				; FAT的长度 9扇区
	DW		18				; 1个磁道有几个扇区
	DW		2				; 有几个磁头
	DD		0				; 不适用分区
	DD		2880			; 重写一次磁盘大小
	DB		0,0,0x29		; 意义不明，固定
	DD		0xffffffff		; （可能是）卷标号码
	DB		"HARIBOTEOS "	; 磁盘的名称
	DB		"FAT12   "		; 磁盘格式名称
	RESB	18				; 空出18字节
;day3之读磁盘，从C0-H0-S1 读到 C10-H1-S18,C表示柱面，H表示磁头，S表示扇区
;一共（10*2*18）*512=18KB(184320)字节。
;数据读到从0x8000开始的连续18KB字节的内存中。
readinit:
	MOV SP,0x7c00
	MOV SI,0x0820
	MOV ES,SI  ;把拓展段寄存器设置为0x0820,因为缓冲地址的计算方式是ES*16+BX。
	
	MOV CH,0    ;设置读取第0柱面
	MOV CL,2    ;设置读取第2扇区
	MOV DH,0    ;设置读取第0磁头
	MOV DL,0    ;驱动器号填0
	MOV BX,0    ;从ES*16+BX=8200开始存
readloop:
	MOV SI,0
retry:
	MOV AH,0x02 ;设置为读盘
	MOV AL,1    ;设置每次中断读取一个扇区
	INT 0x13
	JNC next   ;如果成功读取就跳转到next
	ADD SI,1
	CMP SI,5   
	JB retry   ;如果还没重复够5次，则重试
	JMP load_error    ;否则，跳到结束，硬盘有问题
next:
	MOV AH,0x02 ;设置为读盘
	MOV AL,1    ;设置每次中断读取一个扇区
	ADD BX,512  ;缓冲区后移动512字节
	ADD CL,1
	CMP CL,18
	JBE readloop
	MOV CL,1
	ADD DH,1
	CMP DH,2
	JB readloop
	MOV DH,0
	ADD CH,1
	CMP CH,10
	JBE readloop
	JMP entry
entry:
	MOV SI,data
putloop:
    ;为显卡中断做参数准备
    MOV AL,[SI] ;AL 要打印的字符
    CMP AL,0
	JE end
    MOV AH,0x0e ;操作码，0x0e是打印字符
    MOV BL,15   ;颜色码
    MOV BH,0    ;规定填0
    INT 0x10    ;显卡中断，填充好AL,AH,BL,BH,进行显卡中断将显示一个字符
    ADD SI,1
    JMP putloop
end:
    HLT
    JMP end
load_error:
	MOV SI,load_error_msg
	JMP putloop
data:
    DB 0x0a ;换行
    DB "hello_world!"
    DB 0x0a ;换行
    DB 0 ;结束符
load_error_msg:
	DB 0x0a ;换行
    DB "load_error!"
    DB 0x0a ;换行
	DB 0 ;结束符
fill:
    RESB 0x7dfe-$
    DB 0x55,0xaa