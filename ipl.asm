ORG 0x7c00 ;伪指令，告诉编译器第一条指令的地址是0x7c00,cpu并不执行
    JMP		entry
	DB		0x90
	DB		"HELLOIPL"		; �u�[�g�Z�N�^�̖��O�����R�ɏ����Ă悢�i8�o�C�g�j
	DW		512				; 1�Z�N�^�̑傫���i512�ɂ��Ȃ���΂����Ȃ��j
	DB		1				; �N���X�^�̑傫���i1�Z�N�^�ɂ��Ȃ���΂����Ȃ��j
	DW		1				; FAT���ǂ�����n�܂邩�i���ʂ�1�Z�N�^�ڂ���ɂ���j
	DB		2				; FAT�̌��i2�ɂ��Ȃ���΂����Ȃ��j
	DW		224				; ���[�g�f�B���N�g���̈�̑傫���i���ʂ�224�G���g���ɂ���j
	DW		2880			; ���̃h���C�u�̑傫���i2880�Z�N�^�ɂ��Ȃ���΂����Ȃ��j
	DB		0xf0			; ���f�B�A�̃^�C�v�i0xf0�ɂ��Ȃ���΂����Ȃ��j
	DW		9				; FAT�̈�̒����i9�Z�N�^�ɂ��Ȃ���΂����Ȃ��j
	DW		18				; 1�g���b�N�ɂ����̃Z�N�^�����邩�i18�ɂ��Ȃ���΂����Ȃ��j
	DW		2				; �w�b�h�̐��i2�ɂ��Ȃ���΂����Ȃ��j
	DD		0				; �p�[�e�B�V�������g���ĂȂ��̂ł����͕K��0
	DD		2880			; ���̃h���C�u�傫����������x����
	DB		0,0,0x29		; �悭�킩��Ȃ����ǂ��̒l�ɂ��Ă����Ƃ����炵��
	DD		0xffffffff		; ���Ԃ�{�����[���V���A���ԍ�
	DB		"HELLO-OS   "	; �f�B�X�N�̖��O�i11�o�C�g�j
	DB		"FAT12   "		; �t�H�[�}�b�g�̖��O�i8�o�C�g�j
	RESB	18				; �Ƃ肠����18�o�C�g�����Ă���
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
data:
    DB 0x0a ;换行
    DB "hello_world!"
    DB 0x0a ;换行
    DB 0 ;结束符
fill:
    RESB 0x7dfe-$
    DB 0x55,0xaa