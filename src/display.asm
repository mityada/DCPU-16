%define DCPU_PIXEL_SIZE 4

section .data
	wm_delete_window db "WM_DELETE_WINDOW", 0

section .bss
	display resd 1
	screen	resd 1
	window	resd 1
	event	resd 24
	gc	resd 1

	character_map 	resd 1
	video_ram	resd 1
	background	resd 1
	colors		resd 16

section .text
	extern gettimeofday

	extern XOpenDisplay
	extern XCloseDisplay
	extern XCreateSimpleWindow
	extern XDestroyWindow
	extern XSelectInput
	extern XMapWindow
	extern XNextEvent
	extern XCreateGC
	extern XSetForeground
	extern XSetBackground
	extern XFillRectangle
	extern XFlush
	extern XPending
	extern XAllocSizeHints
	extern XSetWMNormalHints
	extern XFree
	extern XInternAtom
	extern XSetWMProtocols
	extern XAllocColor

	global _create_window
	global _process_events
	global _redraw_display

_create_window:
	mov eax, [esp + 4]
	mov [character_map], eax
	mov eax, [esp + 8]
	mov [video_ram], eax
	mov eax, [esp + 12]
	mov [background], eax

	push 0
	call XOpenDisplay
	add esp, 4
	mov [display], eax

	mov ecx, [eax + 33 * 4]			; default_screen
	mov eax, [eax + 35 * 4]			; screens
	lea eax, [eax + ecx * 4]		; screens[default_screen]
	mov [screen], eax

	mov ecx, [eax + 14 * 4]			; black_pixel
	push ecx				; background
	push ecx				; border
	push 0					; border_width
	push (12 * 8 + 8) * DCPU_PIXEL_SIZE	; height
	push (32 * 4 + 8) * DCPU_PIXEL_SIZE	; width
	push 0					; y
	push 0					; x
	mov ecx, [eax + 2 * 4]			; root
	push ecx				; parent
	mov eax, [display]
	push eax				; display
	call XCreateSimpleWindow
	add esp, 9 * 4
	mov [window], eax

	push 1 << 15				; Expose
	push eax				; w
	mov eax, [display]
	push eax				; display
	call XSelectInput
	add esp, 12

	push 0
	push wm_delete_window
	mov eax, [display]
	push eax
	call XInternAtom
	add esp, 12

	push eax
	lea eax, [esp]
	push 1
	push eax
	mov eax, [window]
	push eax
	mov eax, [display]
	push eax
	call XSetWMProtocols
	add esp, 20

	call XAllocSizeHints
	mov dword [eax], 1 << 4 | 1 << 5			; PMinSize | PMaxSize
	mov dword [eax + 20], (32 * 4 + 8) * DCPU_PIXEL_SIZE	; min_width
	mov dword [eax + 24], (12 * 8 + 8) * DCPU_PIXEL_SIZE	; min_height
	mov dword [eax + 28], (32 * 4 + 8) * DCPU_PIXEL_SIZE	; max_width
	mov dword [eax + 32], (12 * 8 + 8) * DCPU_PIXEL_SIZE	; max_height
	push eax				; hints
	mov eax, [window]
	push eax				; w
	mov eax, [display]
	push eax				; display
	call XSetWMNormalHints
	add esp, 8

	call XFree
	add esp, 4

	mov eax, [window]
	push eax				; w
	mov eax, [display]
	push eax				; display
	call XMapWindow
	add esp, 8

	push 0					; values
	push 0					; valuemask
	mov eax, [window]
	push eax				; d
	mov eax, [display]
	push eax				; display
	call XCreateGC
	add esp, 16
	mov [gc], eax

;_wait_map_notify:
;	call _next_event
;	cmp dword [event], 19			; MapNotify
;	jne _wait_map_notify

	call _init_colors

	ret

_init_colors:
	push ebx

	mov eax, [screen]
	mov eax, [eax + 12 * 4]			; cmap
	sub esp, 12				; XColor
	push esp				; screen_in_out
	push eax				; colormap
	mov eax, [display]
	push eax				; display

	mov ebx, 0
_colors_loop:
	mov word [esp + 16], 0
	mov word [esp + 18], 0
	mov word [esp + 20], 0

	test ebx, 8
	jz _no_highlight
	add word [esp + 16], 0x5555
	add word [esp + 18], 0x5555
	add word [esp + 20], 0x5555
_no_highlight:
	test ebx, 4
	jz _no_red
	add word [esp + 16], 0xaaaa
_no_red:
	test ebx, 2
	jz _no_green
	add word [esp + 18], 0xaaaa
_no_green:
	test ebx, 1
	jz _no_blue
	add word [esp + 20], 0xaaaa
_no_blue:
	mov eax, ebx
	and eax, 0xe
	cmp eax, 6
	jne _no_more_blue
	add word [esp + 20], 0x5555
_no_more_blue:

	call XAllocColor
	mov eax, [esp + 12]			; pixel
	mov [colors + ebx * 4], eax

	inc ebx
	cmp ebx, 16
	jne _colors_loop

	add esp, 24

	pop ebx

	ret

_process_events:
	mov eax, [display]
	push eax				; display
	call XPending
	add esp, 4

	test eax, eax
	jz _no_events

	call _next_event

	cmp dword [event], 12			; Expose
	jne _not_expose
	cmp dword [event + 9 * 4], 0		; count
	jnz _not_expose
	call _redraw_display
_not_expose:
	cmp dword [event], 33			; ClientMessage
	jne _process_events

	mov eax, [window]
	push eax
	mov eax, [display]
	push eax
	call XDestroyWindow
	add esp, 8

	mov eax, [display]
	push eax
	call XCloseDisplay
	add esp, 4

	mov eax, 1
	ret

	jmp _process_events

_no_events:
	ret

_redraw_display:
	push ebx
	push esi
	push edi

	mov eax, [background]
	mov eax, [eax]
	mov eax, [colors + eax * 4]
	push eax			; foreground
	mov eax, [gc]
	push eax			; gc
	mov eax, [display]
	push eax			; display
	call XSetForeground
	add esp, 12

	push (12 * 8 + 8) * DCPU_PIXEL_SIZE		; height
	push (32 * 4 + 8) * DCPU_PIXEL_SIZE		; width
	push 0				; y
	push 0				; x
	mov eax, [gc]
	push eax			; gc
	mov eax, [window]
	push eax			; d
	mov eax, [display]
	push eax			; display
	call XFillRectangle
	add esp, 7 * 4

	sub esp, 8
	mov eax, esp
	push 0
	push eax
	call gettimeofday
	add esp, 8

	mov ebx, 0

	mov edi, 0
_row:
	mov esi, 0
_char:
	mov eax, [video_ram]
	mov dx, [eax + ebx * 2]
	mov cx, dx
	shr ecx, 8
	and ecx, 0xf
	push ecx
	mov cx, dx
	shr ecx, 12
	and ecx, 0xf
	push ecx
	test dx, 0x80
	jz .no_blink
	cmp dword [esp + 12], 500000
	jl .no_blink
	mov ecx, [esp + 4]
	mov [esp], ecx
.no_blink:
	and edx, 127
	mov ecx, [character_map]
	mov eax, [ecx + edx * 4]
	shl eax, 16
	mov ax, [ecx + edx * 4 + 2]
	push eax
	push edi
	push esi
	call _draw_char
	add esp, 20

	add ebx, 1

	add esi, 1
	cmp esi, 32
	jne _char

	add edi, 1
	cmp edi, 12
	jne _row

	add esp, 8

	pop edi
	pop esi
	pop ebx
	ret

_next_event:
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

	mov eax, [esp + 32]		; background
	mov eax, [colors + eax * 4]
	push eax			; foreground
	mov eax, [gc]
	push eax			; gc
	mov eax, [display]
	push eax			; display
	call XSetForeground
	add esp, 12

	mov ecx, [esp + 16]
	lea ecx, [ecx * DCPU_PIXEL_SIZE]
	lea ecx, [ecx * 4 + DCPU_PIXEL_SIZE * 4]
	mov edx, [esp + 20]
	lea edx, [edx * DCPU_PIXEL_SIZE]
	lea edx, [edx * 8 + DCPU_PIXEL_SIZE * 4]
	push DCPU_PIXEL_SIZE * 8
	push DCPU_PIXEL_SIZE * 4
	push edx
	push ecx
	mov eax, [gc]
	push eax			; gc
	mov eax, [window]
	push eax			; d
	mov eax, [display]
	push eax			; display
	call XFillRectangle
	add esp, 7 * 4

	mov eax, [esp + 28]		; foreground
	mov eax, [colors + eax * 4]
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
	lea eax, [esi + ecx * DCPU_PIXEL_SIZE + DCPU_PIXEL_SIZE * 4]
	mov [esp + 12], eax
	mov edx, [esp + 28]
	lea eax, [edi + edx * DCPU_PIXEL_SIZE + DCPU_PIXEL_SIZE * 4]
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
