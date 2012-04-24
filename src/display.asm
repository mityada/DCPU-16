%define DCPU_PIXEL_SIZE 5

section .bss
	display resd 1
	screen	resd 1
	window	resd 1
	event	resd 24

section .text
	extern XOpenDisplay
	extern XCreateSimpleWindow
	extern XSelectInput
	extern XMapWindow
	extern XNextEvent

	global _create_window
	global _process_events

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

	ret

_process_events:
	push event		; event_return
	mov eax, [display]
	push eax		; display
	call XNextEvent
	add esp, 8

	ret
