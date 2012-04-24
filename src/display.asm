%define DCPU_PIXEL_SIZE 4

section .bss
	display resd 1
	screen	resd 1
	window	resd 1
	event	resd 24
	gc	resd 1

section .text
	extern XOpenDisplay
	extern XCreateSimpleWindow
	extern XSelectInput
	extern XMapWindow
	extern XNextEvent
	extern XCreateGC
	extern XSetForeground
	extern XFillRectangle
	extern XFlush

	global _create_window
	global _process_events
	global _draw_char

_create_window:
	push 0
	call XOpenDisplay
	add esp, 4
	mov [display], eax

	mov ecx, [eax + 33 * 4]		; default_screen
	mov eax, [eax + 35 * 4]		; screens
	lea eax, [eax + ecx * 4]	; screens[default_screen]
	mov [screen], eax

	mov ecx, [eax + 14 * 4]		; black_pixel
	push ecx			; background
	push ecx			; border
	push 0				; border_width
	push 12 * 8 * DCPU_PIXEL_SIZE	; height
	push 32 * 4 * DCPU_PIXEL_SIZE	; width
	push 0				; y
	push 0				; x
	mov ecx, [eax + 2 * 4]		; root
	push ecx			; parent
	mov eax, [display]
	push eax			; display
	call XCreateSimpleWindow
	add esp, 9 * 4
	mov [window], eax

	push 1 << 17			; event_mask
	push eax			; w
	mov eax, [display]
	push eax			; display
	call XSelectInput
	add esp, 12

	mov eax, [window]
	push eax			; w
	mov eax, [display]
	push eax			; display
	call XMapWindow
	add esp, 8

	push 0				; values
	push 0				; valuemask
	mov eax, [window]
	push eax			; d
	mov eax, [display]
	push eax			; display
	call XCreateGC
	add esp, 16
	mov [gc], eax

_wait_map_notify:
	call _process_events
	cmp dword [event], 19
	jne _wait_map_notify

	ret

_process_events:
	push event			; event_return
	mov eax, [display]
	push eax			; display
	call XNextEvent
	add esp, 8

	ret

_draw_char:
	push ebx
	push esi
	push edi

	mov eax, [screen]
	mov eax, [eax + 13 * 4]		; black_pixel
	push eax			; foreground
	mov eax, [gc]
	push eax			; gc
	mov eax, [display]
	push eax			; display
	call XSetForeground
	add esp, 12

	mov esi, [esp + 16]		; x
	mov edi, [esp + 20]		; y
	mov ebx, [esp + 24]		; char

	lea esi, [esi * 4]
	lea edi, [edi * 8]
	lea esi, [esi * DCPU_PIXEL_SIZE]
	lea edi, [edi * DCPU_PIXEL_SIZE]

	push 0
	push 7

	push DCPU_PIXEL_SIZE		; height
	push DCPU_PIXEL_SIZE		; width
	push 0				; y
	push 0				; x
	mov eax, [gc]
	push eax			; gc
	mov eax, [window]
	push eax			; d
	mov eax, [display]
	push eax			; display

_loop_height:
	mov dword [esp + 28], 7
_loop_width:
	test ebx, 1 << 31
	jz _continue

	mov ecx, [esp + 32]
	lea eax, [esi + ecx * DCPU_PIXEL_SIZE]
	mov [esp + 12], eax
	mov edx, [esp + 28]
	lea eax, [edi + edx * DCPU_PIXEL_SIZE]
	mov [esp + 16], eax
	call XFillRectangle

_continue:
	shl ebx, 1

	sub dword [esp + 28], 1
	jge _loop_width
	add dword [esp + 32], 1
	cmp dword [esp + 32], 4
	jne _loop_height

	add esp, 7 * 4

	add esp, 8

	mov eax, [display]
	push eax
	call XFlush
	add esp, 4

	pop edi
	pop esi
	pop ebx
	ret
