global _start

section .text

%macro pushaq 0
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
%endmacro

%macro popaq 0
    pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rax
%endmacro

%macro read_0xA 0
    mov rax, 0
    mov rdi, 0
    mov rsi, random
    mov rdx, 1
    syscall
%endmacro

;insert car in cars array
insert_car: ;rax = car_name, rdi = car_name_lenght, rsi = car_index
    mov r8, 0

    push rax
    mov rax, 30
    mul rsi
    mov rsi, rax
    pop rax

insert_car_loop:
    mov bl, [rax + r8]
    mov [cars + r8 + rsi], bl

    inc r8
    cmp r8, rdi
    jne insert_car_loop

    ret



;print cars from cars array
print_car: ;rsi = car_index
    pushaq

    push rsi
    mov rax, 1
    mov rdi, 1
    mov rsi, print_car_message
    mov rdx, print_car_message_len
    syscall
    pop rsi

    mov r8, cars
    
    push rax
    mov rax, 30
    mul rsi
    mov rsi, rax
    pop rax

    add r8, rsi

    mov rax, 1
    mov rdi, 1
    mov rsi, r8
    mov rdx, 30
    syscall
    popaq
    ret

;read car from user and insert it in cars array
read_car_from_user: ; rsi = car_index
    pushaq

    push rsi

    mov rax, 1
    mov rdi, 1
    mov rsi, insert_car_message
    mov rdx, insert_car_message_len
    syscall
    
    pop rsi

    mov r8, cars
    
    push rax
    mov rax, 30
    mul rsi
    mov rsi, rax
    pop rax

    add r8, rsi

    mov rax, 0
    mov rdi, 0
    mov rsi, r8
    mov rdx, 30
    syscall

    mov r8, [number_of_cars]
    inc r8
    mov [number_of_cars], r8

    popaq
    ret



;see all cars
see_all_cars:
    mov r8, 0 ; print cars from cars array
print_loop:
    mov rsi,r8
    call print_car

    inc r8
    cmp r8, [number_of_cars]
    jne print_loop
    ret

print_menu:
    mov rax, 1
    mov rdi, 1
    mov rsi, menu
    mov rdx, menu_len
    syscall
    ret

get_menu_option:
    mov rax, 0
    mov rdi, 0
    mov rsi, menu_option
    mov rdx, 1
    syscall
    ret

_start:
    mov rax, test_car  ; insert test_car in cars array
    mov rdi, test_car_len
    mov rsi, 0
    call insert_car

    mov rax, test_car2 ; insert test_car2 in cars array
    mov rdi, test_car_len2
    mov rsi, 1
    call insert_car

    mov rax, test_car3 ; insert test_car3 in cars array
    mov rdi, test_car_len3
    mov rsi, 2
    call insert_car

    ; mov rsi, 3 ; insert car from user in cars array
    ; call read_car_from_user

    ; call see_all_cars ; print all cars from cars array

menu_loop:
    call print_menu
    call get_menu_option
    
    mov al, [menu_option]

    cmp al, 49    ; 48 + 1
    je insert_car_option
    
    cmp al, 50    ; 48 + 2
    je see_all_cars_option

    cmp al, 51    ; 48 + 3
    je quit_app
    
    jmp menu_loop


insert_car_option:
    read_0xA
    mov rsi, [number_of_cars]
    call read_car_from_user
    jmp menu_loop

see_all_cars_option:
    read_0xA
    call see_all_cars
    jmp menu_loop

quit_app:
    read_0xA
    mov rax, 60
    mov rdi, 0
    syscall


section .data
number_of_cars: dq 3 ;8bytes

cars: TIMES 1050 db 0 ; 35 cars * 30 bytes per car
cars_len: equ $ - cars

test_car: db "Toyota LINDO", 0xA
test_car_len: equ $ - test_car

test_car2: db "Renault 19 MAQUINA", 0xA
test_car_len2: equ $ - test_car2

test_car3: db "Toyota Corolla Perfeito", 0xA
test_car_len3: equ $ - test_car3

insert_car_message: db "Insert car name: ", 0x00
insert_car_message_len: equ $ - insert_car_message

print_car_message: db "Car -> ", 0x00
print_car_message_len: equ $ - print_car_message

menu: db 0xA,"1 - Insert car", 0xA
      db "2 - See all cars", 0xA
      db "3 - Exit", 0xA
      db "Option: ", 0x00
menu_len: equ $ - menu

menu_option: db 0x00, 0x00

random: db 0x00