#if 1

.syntax unified
.include "src/regs.s"
.global __boot
__boot:
	mov r2, #Bit10
	bl __boot_read_button
	bne __mikboot
	bl mainasm

// Read from button in r2
__boot_read_button:
	push {R0, R1, lr}

	ldr R0, =GPIOA
	ldr R1, [R0, IDR]
	tst R1, R2

	pop {R0, R1, pc}

__mikboot:
	bl mikmain
	b .

#endif
