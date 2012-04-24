section .text
	extern _create_window
	extern _process_events
	extern _draw_char

	global _start

_start:
	call _create_window

	mov ecx, 12
_draw:
	push ecx

	push 0xf00ff00f
	push ecx
	push ecx
	call _draw_char
	add esp, 12

	pop ecx
	loop _draw

_loop:
	call _process_events

	push 0xffffffff
	push 0
	push 0
	call _draw_char
	add esp, 12

	jmp _loop
