; ==========================
; Group member 01: Yohali Malaika_Kamangu_u23618583
; Group member 02: Name_Surname_student-nr
; Group member 03: Name_Surname_student-nr
; ==========================
section .data
    global convertStringToFloat

convertStringToFloat:

    ; Function prologue
    push rbp                  ; Save the base pointer
    mov rbp, rsp              ; Set up the stack frame
    sub rsp, 16               ; Allocate space for local variables

    ; Local variables
    ; [rbp-4] : integer_part (int)
    ; [rbp-8] : fractional_part (float)
    ; [rbp-12] : divisor (float)
    ; [rbp-16] : sign (int)

    ; Initialize variables
    mov dword [rbp-4], 0      ; integer_part = 0
    mov dword [rbp-8], 0      ; fractional_part = 0.0
    mov dword [rbp-12], 1     ; divisor = 1.0
    mov dword [rbp-16], 1     ; sign = 1 (positive by default)

    ; Parse sign if present
    mov al, byte [rdi]        ; Load the first character of the string
    cmp al, '-'               ; Check if it's a '-'
    jne .check_plus           ; If not, check if it's a '+'
    mov dword [rbp-16], -1    ; Set sign to -1
    inc rdi                   ; Move to the next character
    jmp .parse_integer_part   ; Skip the next check

.check_plus:
    cmp al, '+'               ; Check if it's a '+'
    jne .parse_integer_part   ; If not, start parsing the integer part
    inc rdi                   ; Move to the next character

.parse_integer_part:
    ; Parse the integer part
    .integer_loop:
        mov al, byte [rdi]     ; Load the next character
        cmp al, '.'            ; Check if it's the decimal point
        je .parse_fractional_part
        cmp al, 0              ; Check if it's the null terminator
        je .final_calculation
        sub al, '0'            ; Convert ASCII to integer
        imul eax, 10           ; Multiply integer_part by 10
        add dword [rbp-4], eax ; Add the new digit
        inc rdi                ; Move to the next character
        jmp .integer_loop

.parse_fractional_part:
    inc rdi                    ; Move past the decimal point
    .fractional_loop:
        mov al, byte [rdi]     ; Load the next character
        cmp al, 0              ; Check if it's the null terminator
        je .final_calculation
        sub al, '0'            ; Convert ASCII to integer
        imul dword [rbp-12], 10 ; Increase the divisor
        cvtsi2ss xmm1, eax      ; Convert the digit to float
        divss xmm1, [rbp-12]    ; Divide by the current divisor
        addss [rbp-8], xmm1     ; Add to fractional_part
        inc rdi                 ; Move to the next character
        jmp .fractional_loop

.final_calculation:
    ; Combine integer and fractional parts
    cvtsi2ss xmm0, [rbp-4]    ; Convert integer_part to float
    addss xmm0, [rbp-8]       ; Add fractional_part to integer_part
    mov eax, [rbp-16]         ; Load sign
    cvtsi2ss xmm1, eax        ; Convert sign to float
    mulss xmm0, xmm1          ; Apply the sign

    ; Function epilogue
    mov rsp, rbp              ; Restore the stack
    pop rbp                   ; Restore the base pointer
    ret                       ; Return the result in xmm0