section .data
	dcpu	db "D", 0x10, "C", 0x20, "P", 0x30, "U", 0x40, "-", 0x50, "1", 0x60, "6", 0x70, " ", 0x00, "E", 0x80, "m", 0x90, "u", 0xa0, "l", 0xb0, "a", 0xc0, "t", 0xd0, "o", 0xe0, "r", 0xf0, 0xdf, 0xf0
	character_map dw 0x000f, 0x0808, 0x080f, 0x0808, 0x08f8, 0x0808, 0x00ff, 0x0808, 0x0808, 0x0808, 0x08ff, 0x0808, 0x00ff, 0x1414, 0xff00, 0xff08, 0x1f10, 0x1714, 0xfc04, 0xf414, 0x1710, 0x1714, 0xf404, 0xf414, 0xff00, 0xf714, 0x1414, 0x1414, 0xf700, 0xf714, 0x1417, 0x1414, 0x0f08, 0x0f08, 0x14f4, 0x1414, 0xf808, 0xf808, 0x0f08, 0x0f08, 0x001f, 0x1414, 0x00fc, 0x1414, 0xf808, 0xf808, 0xff08, 0xff08, 0x14ff, 0x1414, 0x080f, 0x0000, 0x00f8, 0x0808, 0xffff, 0xffff, 0xf0f0, 0xf0f0, 0xffff, 0x0000, 0x0000, 0xffff, 0x0f0f, 0x0f0f, 0x0000, 0x0000, 0x005f, 0x0000, 0x0300, 0x0300, 0x3e14, 0x3e00, 0x266b, 0x3200, 0x611c, 0x4300, 0x3629, 0x7650, 0x0002, 0x0100, 0x1c22, 0x4100, 0x4122, 0x1c00, 0x2a1c, 0x2a00, 0x083e, 0x0800, 0x4020, 0x0000, 0x0808, 0x0800, 0x0040, 0x0000, 0x601c, 0x0300, 0x3e41, 0x3e00, 0x427f, 0x4000, 0x6259, 0x4600, 0x2249, 0x3600, 0x0f08, 0x7f00, 0x2745, 0x3900, 0x3e49, 0x3200, 0x6119, 0x0700, 0x3649, 0x3600, 0x2649, 0x3e00, 0x0024, 0x0000, 0x4024, 0x0000, 0x0814, 0x2241, 0x1414, 0x1400, 0x4122, 0x1408, 0x0259, 0x0600, 0x3e59, 0x5e00, 0x7e09, 0x7e00, 0x7f49, 0x3600, 0x3e41, 0x2200, 0x7f41, 0x3e00, 0x7f49, 0x4100, 0x7f09, 0x0100, 0x3e49, 0x3a00, 0x7f08, 0x7f00, 0x417f, 0x4100, 0x2040, 0x3f00, 0x7f0c, 0x7300, 0x7f40, 0x4000, 0x7f06, 0x7f00, 0x7f01, 0x7e00, 0x3e41, 0x3e00, 0x7f09, 0x0600, 0x3e41, 0xbe00, 0x7f09, 0x7600, 0x2649, 0x3200, 0x017f, 0x0100, 0x7f40, 0x7f00, 0x1f60, 0x1f00, 0x7f30, 0x7f00, 0x7708, 0x7700, 0x0778, 0x0700, 0x7149, 0x4700, 0x007f, 0x4100, 0x031c, 0x6000, 0x0041, 0x7f00, 0x0201, 0x0200, 0x8080, 0x8000, 0x0001, 0x0200, 0x2454, 0x7800, 0x7f44, 0x3800, 0x3844, 0x2800, 0x3844, 0x7f00, 0x3854, 0x5800, 0x087e, 0x0900, 0x4854, 0x3c00, 0x7f04, 0x7800, 0x447d, 0x4000, 0x2040, 0x3d00, 0x7f10, 0x6c00, 0x417f, 0x4000, 0x7c18, 0x7c00, 0x7c04, 0x7800, 0x3844, 0x3800, 0x7c14, 0x0800, 0x0814, 0x7c00, 0x7c04, 0x0800, 0x4854, 0x2400, 0x043e, 0x4400, 0x3c40, 0x7c00, 0x1c60, 0x1c00, 0x7c30, 0x7c00, 0x6c10, 0x6c00, 0x4c50, 0x3c00, 0x6454, 0x4c00, 0x0836, 0x4100, 0x0077, 0x0000, 0x4136, 0x0800, 0x0201, 0x0201, 0x704c, 0x7000
	mode_read db "rb"

	basic_op_table dd _basic_op.exit, _basic_op.set, _basic_op.add, _basic_op.sub, _basic_op.mul, _basic_op.mli, _basic_op.div, _basic_op.dvi, _basic_op.mod, _basic_op.mdi, _basic_op.and, _basic_op.bor, _basic_op.xor, _basic_op.shr, _basic_op.asr, _basic_op.shl, _basic_op.ifb, _basic_op.ifc, _basic_op.ife, _basic_op.ifn, _basic_op.ifg, _basic_op.ifa, _basic_op.ifl, _basic_op.ifu, _basic_op.exit, _basic_op.exit, _basic_op.adx, _basic_op.sbx, _basic_op.exit, _basic_op.exit, _basic_op.sti, _basic_op.std

section .bss
	ram		resw 0x10000
	registers	resw 8 ; A, B, C, X, Y, I, J
	pc_reg 		resw 1
	sp_reg		resw 1
	ex_reg		resw 1

	skip		resb 1

	display_state resb 1

section .text
	extern memcpy
	extern nanosleep
	extern exit
	extern fopen
	extern fclose
	extern fread

	extern _init_display

	global _start

_start:
	push 0x100 * 2
	push character_map
	push ram + 0x8180 * 2
	call memcpy
	add esp, 12

	push display_state
	push ram
	call _init_display
	add esp, 8

	cmp dword [esp], 2
	je .emulate
	call _demo
	jmp .exit
.emulate:
	mov eax, [esp + 8]
	push eax
	call _emulate

.exit:
	push 0
	call exit

_demo:
	mov word [ram + 0x8280 * 2], 0x2

	mov ecx, 0
.write:
	mov ax, [dcpu + ecx * 2]
	mov edx, 64 * 5 + 16
	mov word [edx + ecx * 2 + ram + 0x8000 * 2], ax
	inc ecx
	cmp ecx, 17
	jne .write

.loop:
	cmp byte [display_state], 0
	jne .exit

	push 10000
	push 0
	mov eax, esp
	push 0
	push eax
	call nanosleep
	add esp, 16

	jmp .loop

.exit:
	ret

_emulate:
	mov eax, [esp + 4]
	push mode_read
	push eax
	call fopen
	add esp, 8

	push 0

	push eax
	push 1
	push 1

.load_loop:
	mov ecx, [esp + 12]
	lea eax, [ecx * 2 + ram + 1]
	push eax
	call fread
	add esp, 4

	mov ecx, [esp + 12]
	lea eax, [ecx * 2 + ram]
	push eax
	call fread
	add esp, 4

	add dword [esp + 12], 1
	cmp dword [esp + 12], 0x1000
	jne .load_loop

	add esp, 8

	call fclose
	add esp, 8

	xor ecx, ecx
.zero_registers:
	mov word [ecx * 2 + registers], 0x0000
	inc ecx
	cmp ecx, 8
	jne .zero_registers

	mov word [pc_reg], 0x0000
	mov word [sp_reg], 0xffff
	mov word [ex_reg], 0x0000

.dcpu_cycle:
        cmp byte [display_state], 0
        jne .exit

	call _execute_instruction

        push 10000
        push 0
        mov eax, esp
        push 0
        push eax
        call nanosleep
        add esp, 16

	jmp .dcpu_cycle

.exit:
	ret

_execute_instruction:
	push ebx
	push esi
	push edi

	mov ax, [pc_reg]
	add word [pc_reg], 1
	mov cx, [eax * 2 + ram]
	mov bx, cx
	and ebx, 0x1f	; opcode
	mov si, cx
	shr si, 10
	and esi, 0x3f	; source
	mov di, cx
	shr di, 5
	and edi, 0x1f	; dest

_basic_op:
	push esi
	call _get_value
	add esp, 4
	mov esi, eax
	and esi, 0xffff

	push edi
	call _get_address
	add esp, 4
	mov edi, eax

	cmp byte [skip], 0
	je .not_skip
	sub ebx, 0x10
	cmp ebx, 0x17 - 0x10
	jbe .if
	mov byte [skip], 0
.if:
	jmp .exit
.not_skip:
	cmp ebx, 0x1f
	jg .exit
	jmp [ebx * 4 + basic_op_table]
.set:
	mov [edi], si
	jmp .exit
.add:
	mov ax, [edi]
	and eax, 0xffff
	add eax, esi
	mov [edi], ax
	shr eax, 16
	mov [ex_reg], ax
	jmp .exit
.sub:
	mov ax, [edi]
	and eax, 0xffff
	sub eax, esi
	mov [edi], ax
	shr eax, 16
	mov [ex_reg], ax
	jmp .exit
.mul:
	mov ax, [edi]
	and eax, 0xffff
	mul si
	mov [edi], ax
	mov [ex_reg], dx
	jmp .exit
.mli:
	mov ax, [edi]
	and eax, 0xffff
	imul si
	mov [edi], ax
	mov [ex_reg], dx
	jmp .exit
.div:
	mov ax, [edi]
	mov word [edi], 0
	mov word [ex_reg], 0
	cmp esi, 0
	je .exit
	shl eax, 16
	xor edx, edx
	div esi
	mov [ex_reg], ax
	shr eax, 16
	mov [edi], ax
	jmp .exit
.dvi:
	mov ax, [edi]
	mov word [edi], 0
	mov word [ex_reg], 0
	cmp esi, 0
	je .exit
	shl eax, 16
	xor edx, edx
	idiv esi
	mov [ex_reg], ax
	shr eax, 16
	mov [edi], ax
	jmp .exit
.mod:
	mov ax, [edi]
	mov word [edi], 0
	cmp esi, 0
	je .exit
	xor edx, edx
	div si
	mov [edi], dx
	jmp .exit
.mdi:
	mov ax, [edi]
	mov word [edi], 0
	cmp esi, 0
	je .exit
	mov dx, 0xffff
	cmp ax, 0
	jl .mdi_negative
	xor edx, edx
.mdi_negative:
	idiv si
	mov [edi], dx
	jmp .exit
.and:
	and [edi], si
	jmp .exit
.bor:
	or [edi], si
	jmp .exit
.xor:
	xor [edi], si
	jmp .exit
.shr:
	mov ax, [edi]
	mov cx, si
	shr ax, cl
	mov cx, [edi]
	mov [edi], ax
	mov ax, cx
	shl eax, 16
	mov cx, si
	sar eax, cl
	mov [ex_reg], ax
	jmp .exit
.asr:
	mov ax, [edi]
	mov cx, si
	sar ax, cl
	mov cx, [edi]
	mov [edi], ax
	mov ax, cx
	shl eax, 16
	mov cx, si
	shr eax, cl
	mov [ex_reg], ax
	jmp .exit
.shl:
	mov ax, [edi]
	mov cx, si
	shl ax, cl
	mov cx, [edi]
	mov [edi], ax
	mov ax, cx
	mov cx, si
	shl eax, cl
	sar eax, 16
	mov [ex_reg], ax
	jmp .exit
.ifb:
	test [edi], si
	jz .skip
	jmp .exit
.ifc:
	test [edi], si
	jnz .skip
	jmp .exit
.ife:
	cmp [edi], si
	jne .skip
	jmp .exit
.ifn:
	cmp [edi], si
	je .skip
	jmp .exit
.ifg:
	cmp [edi], si
	jbe .skip
	jmp .exit
.ifa:
	cmp [edi], si
	jle .skip
	jmp .exit
.ifl:
	cmp [edi], si
	jae .skip
	jmp .exit
.ifu:
	cmp [edi], si
	jge .skip
	jmp .exit
.adx:
	mov ax, [edi]
	and eax, 0xffff
	add eax, esi
	mov si, [ex_reg]
	add eax, esi
	mov [edi], ax
	shr eax, 16
	mov [ex_reg], ax
	jmp .exit
.sbx:
	mov ax, [edi]
	and eax, 0xffff
	sub eax, esi
	mov si, [ex_reg]
	add eax, esi
	mov [edi], ax
	shr eax, 16
	mov [ex_reg], ax
	jmp .exit
.sti:
	mov [edi], si
	add word [registers + 6 * 2], 1
	add word [registers + 7 * 2], 1
	jmp .exit
.std:
	mov [edi], si
	sub word [registers + 6 * 2], 1
	sub word [registers + 7 * 2], 1
	jmp .exit

.skip:
	mov byte [skip], 1

.exit:
	pop edi
	pop esi
	pop ebx
	ret

_get_value:
	mov eax, [esp + 4]

	cmp eax, 0x1e
	jg .literal
	push eax
	call _get_address
	add esp, 4
	mov ax, [eax]
	and eax, 0xffff
	ret
.literal:
	cmp eax, 0x1f
	jne .not_word
	mov ax, [pc_reg]
	add word [pc_reg], 1
	and eax, 0xffff
	mov ax, [eax * 2 + ram]
	ret
.not_word:
	cmp eax, 0x3f
	jg .not_literal
	sub ax, 0x21
	ret
.not_literal:
	xor eax, eax
	ret

_get_address:
	mov eax, [esp + 4]

	cmp eax, 0x07
	jg .not_register
	lea eax, [eax * 2 + registers]
	ret
.not_register:
	cmp eax, 0x0f
	jg .not_at_register
	sub eax, 0x08
	mov ax, [eax * 2 + registers]
	lea eax, [eax * 2 + ram]
	ret
.not_at_register:
	cmp eax, 0x17
	jg .not_at_register_plus_word
	sub eax, 0x10
	mov ax, [eax * 2 + registers]
	mov cx, [pc_reg]
	add word [pc_reg], 1
	and ecx, 0xffff
	add ax, [ecx * 2 + ram]
	lea eax, [eax * 2 + ram]
	ret
.not_at_register_plus_word:
	cmp eax, 0x18
	jne .not_pop
	mov ax, [sp_reg]
	add word [sp_reg], 1
	lea eax, [eax * 2 + ram]
	ret
.not_pop:
	cmp eax, 0x19
	jne .not_peek
	mov ax, [sp_reg]
	lea eax, [eax * 2 + ram]
	ret
.not_peek:
	cmp eax, 0x1a
	jne .not_pick_n
	mov ax, [sp_reg]
	mov cx, [pc_reg]
        add word [pc_reg], 1
        and ecx, 0xffff
	add ax, [ecx * 2 + ram]
	lea eax, [eax * 2 + ram]
	ret
.not_pick_n:
	cmp eax, 0x1b
	jne .not_sp
	lea eax, [sp_reg]
	ret
.not_sp:
	cmp eax, 0x1c
	jne .not_pc
	lea eax, [pc_reg]
	ret
.not_pc:
	cmp eax, 0x1d
	jne .not_ex
	lea eax, [ex_reg]
	ret
.not_ex:
	cmp eax, 0x1e
	jne .not_at_word
	mov ax, [pc_reg]
	add word [pc_reg], 1
	and eax, 0xffff
	mov ax, [eax * 2 + ram]
	lea eax, [eax * 2 + ram]
	ret
.not_at_word:
	xor eax, eax
	ret
