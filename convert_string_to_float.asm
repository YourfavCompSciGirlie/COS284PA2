; ==========================
; Group member 01: Yohali Malaika_Kamangu_u23618583
; Group member 02: Name_Surname_student-nr
; Group member 03: Name_Surname_student-nr
; ==========================
section .text
    global convertStringToFloat
    extern strtof

convertStringToFloat:
    ; Function prologue
    push    rbp                    ; Save the base pointer
    mov     rbp, rsp               ; Set the base pointer to the current stack pointer
    sub     rsp, 64                ; Allocate 64 bytes of space on the stack

    ; Check if the string pointer is null
    test    rdi, rdi               ; Test if rdi (input string pointer) is null
    je      return_zero            ; If null, jump to return_zero

    ; Call strtof function to convert the string to a float
    xor     rsi, rsi               ; Clear rsi (setting it to NULL, no endptr)
    call    strtof                 ; Call the strtof function with rdi as the string and rsi as NULL

    ; Function epilogue
    leave                          ; Restore the previous stack frame (mov rsp, rbp; pop rbp)
    ret                            ; Return from the function

return_zero:
    xorps   xmm0, xmm0             ; Clear xmm0, setting it to 0.0 (return value for null input)
    leave                          ; Restore the previous stack frame
    ret                            ; Return from the function