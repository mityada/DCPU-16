section .data
	fopen_mode     dd "r"
	format_int     db "%i", 10, 0
	format_char    db "%c", 0
	format_str     db "%s", 10, 0
	file_handle    dd 0
	file_size      dd 0
	file_name      dd 0
	buff           dd 0
	buff_size      dd 0
	buff2          dd 0 ; pointer to temporary buffer
	buff2_size     dd 0
	curr           dd 0 ; used by append
	symbols        db ";:[],+-_" ; additional symbols allowed in the input file
	symbols_cnt    dd 8
	usage          db "Usage: compile file.dasm", 10, 0
	no_file        db "Unable to open file", 10, 0
	
	positions      dd 0 ; pointer to array with token positions in buff
	types          dd 0 ; pointer to array with token types
	sizes          dd 0 ; pointer to array with token resulting sizes
	places         dd 0 ; pointer to array with token resulting places

section .text
	extern exit
	extern fopen
	extern fclose
	extern fgetc
	extern fseek
	extern ftell
	extern rewind
	extern printf
	extern malloc
	extern free
	
	global _start
	
;-------------------------------------
_start:

	cmp dword [esp], 2
	jne _usage
	
	mov esi, dword[esp + 8]
	mov dword [file_name], esi
	
	push dword [file_name]
	call _printf_s
	add esp, 4


	call _read_file
	call _remove_comments
	call _print_buff
	
	push dword [buff]
	call _strlen
	mov [esp], eax
	call _printf_i
	add esp, 4
	push dword [buff_size]
	call _printf_i
	add esp, 4

	jmp _exit

;-------------------------------------
_read_file:
	push fopen_mode
	push dword [file_name]
	call fopen
	add esp, 8
	test eax, eax
	jz _no_file
	mov dword [file_handle], eax
	
	push 2 ; SEEK_END
	push 0
	push dword [file_handle]
	call fseek
	add  esp, 12
	
	push dword [file_handle]
	call ftell
	add esp, 4
	mov dword [file_size], eax
	
	push dword  [file_size]
	call _printf_i
	add esp, 4
	
	push dword [file_handle]
	call rewind
	add esp, 4
	
	push dword [file_size]
	call malloc
	pop dword [buff_size]
	mov dword [buff], eax
	
	mov ebp, 0
.read_loop:
	push dword [file_handle]
	call fgetc
	add esp, 4
	mov edx, dword[buff]
	mov byte [edx + ebp], al
	
	inc ebp
	cmp ebp, dword [file_size]
	jb .read_loop
	
	push dword [file_handle]
	call fclose
	add esp, 4
	
	ret
	
;-------------------------------------
_remove_comments:
	push dword [buff_size]
	call malloc
	pop dword [buff2_size]
	mov dword [buff2], eax
	
	mov dword [curr], 0

	mov ebp, 0
	mov esi, 0 ; 0 - not comment, 1 - comment
	mov ebx, 0 ; 0 - not in "", 1 - in ""
.loop:
	mov edx, dword [buff]
	movzx eax, byte [edx + ebp]
	
	cmp eax, 10
	je .newln
	test esi, esi
	jnz .cont
	cmp eax, 34 ; ascii for "
	je .string
	cmp eax, 39 ; ascii for '
	je .quote
	cmp eax, ';'
	je .comm
	jmp .out
.newln:
	test esi, esi
	jz .out
	not esi
	jmp .out
.comm:
	test ebx, ebx
	jnz .out
	not esi
	jmp .cont
.quote:
	push ebp
	call _append
	add esp, 4
	inc ebp
	push ebp
	call _append
	add esp, 4
	inc ebp
	push ebp
	call _append
	add esp, 4
	jmp .cont
.string:
	not ebx
.out:
	test esi, esi
	jnz .cont
	push ebp
	call _append
	add esp, 4
.cont:
	inc ebp
	cmp ebp, dword [buff_size]
	jb .loop
	
	
.end:
	push -1
	call _append
	add esp, 4

	push dword [buff]
	call free
	add esp, 4
	mov eax, dword [buff2]
	mov dword [buff], eax
	mov ecx, dword [curr]
	dec ecx
	mov dword [buff_size], ecx

	ret

;-------------------------------------	
_append: ; will append to buff2 symbol buff[arg1], or 0 if arg1 == -1
	mov eax, [esp + 4]
	mov edx, dword [buff]
	cmp eax, 0
	jb .null
	movzx ecx, byte [edx + eax]
	jmp .not_null
.null:
	xor ecx, ecx
.not_null:
	mov eax, dword [curr]
	mov edx, dword [buff2]
	mov byte [edx + eax], cl
	inc dword [curr]
	ret
	
;-------------------------------------
_tokenize: ; parse buff into tokens
	
	
;-------------------------------------
_test_symbol: ; will check if arg1 is valid symbol
	mov ecx, [esp + 4]
	lea edx, [ecx - '0']
	cmp edx, '9' - '0'
	jbe .ok
	lea edx, [ecx - 'a']
	cmp edx, 'z' - 'a'
	jbe .ok
	lea edx, [ecx - 'A']
	cmp edx, 'Z' - 'A'
	jbe .ok
	xor edx, edx
	xor eax, eax
.loop:
	cmp cl, byte [symbols + eax]
	jne .cnt
	inc edx
.cnt:
	inc eax
	cmp eax, dword [symbols_cnt]
	jb .loop
	
	
	test edx, edx
	jnz .ok
		
	xor eax, eax
	ret
.ok:
	mov eax, 1
	ret

;-------------------------------------
_print_buff:
	mov ebp, 0
.out_loop:
	mov edx, dword [buff]
	movzx eax, byte [edx + ebp]
	push eax
	call _printf_c
	add esp, 4
	inc ebp
	cmp ebp, dword [buff_size]
	jb .out_loop
	
	ret

;-------------------------------------
_strlen:
	mov ecx, [esp + 4]
	xor eax, eax
	xor edx, edx
.loop:
	mov dl, byte [ecx]
	test dl, dl
	jz .end
	inc eax
	inc ecx
	jmp .loop
.end:
	ret
;-------------------------------------
_printf_i:
	push dword [esp + 4]
	push format_int
	call printf
	add esp, 8
	ret	
;-------------------------------------
_printf_s:
	push dword [esp + 4]
	push format_str
	call printf
	add esp, 8
	ret
;-------------------------------------
_printf_c:
	push dword [esp + 4]
	push format_char
	call printf
	add esp, 8
	ret
;-------------------------------------
_no_file:
	push no_file
	call _printf_s
	add esp, 4
	jmp _exit

_usage:
	push usage
	call _printf_s
	add esp, 4

_exit:
	push 0
	call exit
