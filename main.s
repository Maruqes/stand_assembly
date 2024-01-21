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
    mov r8, [number_of_cars]
    cmp r8, 0
    je end_see_all_cars
    
    mov r8, 0 ; print cars from cars array
print_loop:
    mov rsi,r8
    call print_car

    inc r8
    cmp r8, [number_of_cars]
    jne print_loop
end_see_all_cars:
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

; compare string with car
compare_string_and_car: ; rsi = car_index
    pushaq
    
    mov rax, 30
    mul rsi

    mov r8, cars
    add r8, rax; r8 addr de car no array nº rsi

    mov r9, 0 ; loop pelas 30 chars do car
compare_loop:
    mov r10b, [buy_car_option + r9] ; r10b = char da string dada
    mov r11b, [r8 + r9] ; r11b = char do car rs1
    cmp r10b, r11b
    jne not_equal

    inc r9
    cmp r9, 29
    jne compare_loop

    equal:
    popaq
    mov rax, 0
    ret

    not_equal:
    popaq
    mov rax, -1
    ret


delete_car: ; rsi = car_index
    pushaq
    mov r8, [number_of_cars]
    dec r8
    cmp rsi, r8
    je delete_last_car

    mov r8, [number_of_cars]
    sub r8, rsi
    dec r8


    mov r12, 0
delete_car_loop2:
    mov rax, 30
    mul rsi

    mov r9, 0
    mov r10, 29
    mov r11, 0
    delete_car_loop:

    mov r11b, [cars + rax + r9 + 30]
    mov [cars + rax + r9], r11b

    inc r9
    cmp r9, r10
    jne delete_car_loop

    inc rsi
    inc r12
    cmp r12, r8
    jne delete_car_loop2


    ;delete last car
delete_last_car:
    mov r8, [number_of_cars]
    dec r8

    mov rax, 30
    mul r8

    mov r9,0
    mov r10, 29
    delete_last_car_loop:
    mov byte[cars + rax + r9], 0
    inc r9
    cmp r9, r10
    jne delete_last_car_loop

    mov r8, [number_of_cars]
    dec r8
    mov [number_of_cars], r8

    popaq
    ret
    

buy_car:

    ;clear buy_car_msg
    mov r8,0
    mov r9, buy_car_option
    mov r10, 29
    clear_buy_car_msg:
    mov byte[r9 + r8], 0
    inc r8
    cmp r8, r10
    jne clear_buy_car_msg

    mov rax, 1
    mov rdi, 1
    mov rsi, buy_car_msg
    mov rdx, buy_car_msg_len
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, buy_car_option
    mov rdx, 30
    syscall

    mov rsi, 0
search_all_cars:
    call compare_string_and_car

    cmp rax, 0
    je car_found

    cmp rsi, [number_of_cars]
    je car_not_found

    inc rsi
    jmp search_all_cars

car_found:
    call delete_car
    mov rax, 1
    mov rdi, 1
    mov rsi, buy_car_msg2
    mov rdx, buy_car_msg_len2
    syscall
    ret

car_not_found:
    mov rax, 1
    mov rdi, 1
    mov rsi, buy_car_not_found
    mov rdx, buy_car_not_found_len
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
    je buy_caroption

    cmp al, 52    ; 48 + 4
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

buy_caroption:
    read_0xA
    call buy_car
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
      db "3 - Buy car", 0xA
      db "4 - Exit", 0xA
      db "Option: ", 0x00
menu_len: equ $ - menu

menu_option: db 0x00, 0x00

random: db 0x00

buy_car_msg: db "Name of the car: ", 0xA
buy_car_msg_len: equ $ - buy_car_msg
buy_car_msg2: db "Car bought!", 0xA
buy_car_msg_len2: equ $ - buy_car_msg2
buy_car_option: TIMES 30 db 0
buy_car_not_found: db "Car not found!", 0xA
buy_car_not_found_len: equ $ - buy_car_not_found