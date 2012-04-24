section .text
	extern _create_window
	extern _process_events

	global _start

_start:
	call _create_window

_loop:
	call _process_events
	jmp _loop
