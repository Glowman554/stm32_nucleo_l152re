#if 1

.syntax unified
.include "./core/src/regs.s"
.global mainasm
mainasm:
	mov R1, #0
	mov R0, #1


loop:
	bl random
	mov r1, r0
	bl set_led

	bl delay

	b loop

// set led's starting at lc 0 to r1
set_led:
	push {R0, lr}

	ldr R0, =GPIOC
	strb R1, [R0, ODR]

	pop {R0, pc}

// Read from button in r2
read_button:
	push {R0, R1, lr}

	ldr R0, =GPIOA
	ldr R1, [R0, IDR]
	tst R1, R2

	pop {R0, R1, pc}

random:
	push {r1, r2, r3, lr}

	ldr R1, =0


	tst r1, r2, lsr #1
	movs r2, r0, rrx
	adc r1, r1, r1
	eor r2, r2, r0, lsl #12
	eor r0, r2, r2, lsr #20

	pop {r1, r2, r3, pc}

/*
delay:
	push {R3, R4, lr}
	ldr R3, =32000000 / 25

	mov R4, #1

wait_1s:
	subs R3, R4
	bne wait_1s

	pop {R3, R4, lr}
*/

delay:
	push {r0, lr}

	mov r0, #50
	bl HAL_Delay

	pop {r0, pc}

#endif
