#include <avr/io.h>
.global main
.global INT0_vect
.global TIMER0_COMPA_vect
.global TIMER2_COMPA_vect
.data
    .org 0x0100
    button_state:      .byte 1
    last_button_state: .byte 1
    servo_position:    .byte 1
    timer_count:       .byte 2    
    override_flag:     .byte 1    
.text
main:
    LDI r16, 16
    STS UBRR0L, r16
    LDI r16, 0
    LDI r16, (1<<TXEN0)
    STS UCSR0B, r16
    LDI r16, (1<<UCSZ01)|(1<<UCSZ00)
    STS UCSR0C, r16
    
    ; Pb1 servo output
    LDI r16, (1<<PB1)
    STS DDRB, r16
    
    ; PD4 (TRIG) output, PD5 (ECHO) input
    LDI r16, (1<<PD4)
    STS DDRD, r16
    
    LDI r16, 0
    STS button_state, r16
    STS last_button_state, r16
    STS timer_count, r16
    STS timer_count+1, r16
    STS override_flag, r16
    
    LDI r16, 1
    STS servo_position, r16
    
    LDI r16, (1<<WGM21)
    STS TCCR2A, r16
    LDI r16, (1<<CS22)|(1<<CS21)|(1<<CS20) 
    STS TCCR2B, r16
    LDI r16, 255
    STS OCR2A, r16
    LDI r16, (1<<OCIE2A)
    STS TIMSK2, r16
    
    RCALL print_init_msg
    RCALL move_servo_right
    
    SEI

main_loop:
    ; Add delay sebelum sensor reading
    LDI r24, 60    ; 60ms delay lalu sensor reading
    RCALL delay_ms
    
    ; Check distance HC-SR04
    RCALL check_distance
    CPI r24, 0    ; Distance check return 0 / 1 di r24
    BREQ no_object_detected
    
    ; Object detected - check kalau door sudah open
    LDS r16, servo_position
    CPI r16, 0    ; 0 = door open
    BREQ sensor_delay_and_continue    ; Door sudah open, keep delay dan continue
    
    ; Object detected + door closed, open
    RCALL print_door_opening
    RCALL move_servo_left
    LDI r16, 0
    STS servo_position, r16
    
    ; Reset + start timer utk auto close
    LDI r16, 0
    STS timer_count, r16
    STS timer_count+1, r16
    LDI r16, 1
    STS override_flag, r16
    
    ; Add delay agar tidak tertrigger berkali kali
    LDI r24, 200
    RCALL delay_ms
    RJMP main_loop

no_object_detected:
    ; No object detected - add delay and continue main loop
    LDI r24, 30    ; 30ms delay antara check saat no object
    RCALL delay_ms
    RJMP main_loop

sensor_delay_and_continue:
    ; Door sudah open, keep delay dan continue
    LDI r24, 30
    RCALL delay_ms
    RJMP main_loop

end_main:
    LDI r16, 0           ; Return value 0
    RET                  ; Return from main

move_servo_left:
    PUSH r20
    PUSH r24
    LDI r20, 20
    LDI r24, 30
left_loop:
    PUSH r24
    LDS r16, PORTB
    ORI r16, (1<<PB1)
    STS PORTB, r16
    RCALL delay_timer0
    LDS r16, PORTB
    ANDI r16, ~(1<<PB1)
    STS PORTB, r16
    RCALL delay_20ms
    POP r24
    DEC r20
    BRNE left_loop
    POP r24
    POP r20
    RET

move_servo_right:
    PUSH r20
    PUSH r24
    LDI r20, 20
    LDI r24, 93
right_loop:
    PUSH r24
    LDS r16, PORTB
    ORI r16, (1<<PB1)
    STS PORTB, r16
    RCALL delay_timer0
    LDS r16, PORTB
    ANDI r16, ~(1<<PB1)
    STS PORTB, r16
    RCALL delay_20ms
    POP r24
    DEC r20
    BRNE right_loop
    POP r24
    POP r20
    RET

delay_timer0:
    CLR r21
    STS TCNT0, r21
    MOV r21, r24
    STS OCR0A, r21
    LDI r21, 0b00001100
    STS TCCR0B, r21
dloop:
    LDS r21, TIFR0
    SBRS r21, OCF0A
    RJMP dloop
    CLR r21
    STS TCCR0B, r21
    LDI r21, (1<<OCF0A)
    STS TIFR0, r21
    RET

delay_20ms:
    LDI r21, 255
l4: LDI r22, 210
l5: LDI r23, 2
l6: DEC r23
    BRNE l6
    DEC r22
    BRNE l5
    DEC r21
    BRNE l4
    RET

delay_ms:
    PUSH r24
delay_ms_loop:
    LDI r21, 40
l1: LDI r22, 210
l2: LDI r23, 2
l3: DEC r23
    BRNE l3
    DEC r22
    BRNE l2
    DEC r21
    BRNE l1
    DEC r24
    BRNE delay_ms_loop
    POP r24
    RET

TIMER2_COMPA_vect:
    PUSH r16
    PUSH r17
    PUSH r18
    
    LDS r16, override_flag
    CPI r16, 1
    BREQ timer_active
    RJMP timer_done
    
timer_active:
    ; Increment timer_count
    LDS r16, timer_count
    LDS r17, timer_count+1
    LDI r18, 1
    ADD r16, r18
    ADC r17, r1
    STS timer_count, r16
    STS timer_count+1, r17
    
    LDI r18, hi8(440)
    CP r17, r18
    BRLO timer_done
    BRNE close_door
    LDI r18, lo8(440)
    CP r16, r18
    BRLO timer_done
    
close_door:
    LDI r16, 0
    STS timer_count, r16
    STS timer_count+1, r16
    STS override_flag, r16
    
    RCALL print_door_closing
    RCALL move_servo_right
    LDI r16, 1
    STS servo_position, r16
    
timer_done:
    POP r18
    POP r17
    POP r16
    RETI

print_init_msg:
    LDI r30, lo8(msg_init)
    LDI r31, hi8(msg_init)
    RCALL uart_send_string
    RET

print_door_opening:
    LDI r30, lo8(msg_opening)
    LDI r31, hi8(msg_opening)
    RCALL uart_send_string
    RET

print_door_closing:
    LDI r30, lo8(msg_closing)
    LDI r31, hi8(msg_closing)
    RCALL uart_send_string
    RET

uart_send_string:
    LPM r22, Z+
    CPI r22, 0
    BREQ uart_done
uart_wait:
    LDS r23, UCSR0A
    SBRS r23, UDRE0
    RJMP uart_wait
    STS UDR0, r22
    RJMP uart_send_string
uart_done:
    RET

msg_init:
    .ascii "Servo Door Control - Start\r\n"
    .ascii "Door initialized to CLOSED position\r\n"
    .byte 0
msg_opening:
    .ascii "Opening Door\r\n"
    .byte 0
msg_closing:
    .ascii "Door: CLOSING   \r\n"
    .byte 0