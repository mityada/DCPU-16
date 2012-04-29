section .data
	fopen_mode     dd "r"
	format_int     db "%i", 10, 0
	format_char    db "%c", 0
	format_str     db "%s", 10, 0
	file_handle    dd 0
	file_size      dd 0
	file_name      dd 0
	buff           dd 0
	buff_size      dd 512
	curr           dd 0
	symbols        db ";:[],+-_"
	symbolscnt     dd 8
	usage          dd "Usage: compile file.dasm", 10, 0
	no_file        dd "Unable to open file", 10, 0

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
	
	global _start
	
;-------------------------------------
_start:

	pop esi
	cmp esi, 2
	jne _usage
	
	pop esi
	pop dword [file_name]
	
	push dword [file_name]
	call _printf_s
	add esp, 4

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
	add esp, 4
	mov dword [buff], eax	
	
	mov ebp, 0
.read_loop:
	push dword [file_handle]
	call fgetc
	add esp, 4
	mov byte [buff + ebp], al
	inc ebp
	cmp ebp, dword [file_size]
	jb .read_loop
	
	mov ebp, 0
.out_loop:
	movzx eax, byte [buff + ebp]
	push eax
	call _printf_c
	add esp, 4
	inc ebp
	cmp ebp, dword [file_size]
	jb .out_loop
	

_eof:
	push dword [file_handle]
	call fclose
	add esp, 4
	jmp _exit
;-------------------------------------
_test_symbol:
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
	cmp eax, dword [symbolscnt]
	jb .loop
	
	
	test edx, edx
	jnz .ok
		
	xor eax, eax
	ret
.ok:
	mov eax, 1
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
