; ==========================
; Group member 01: Yohali_Malaika_Kamangu_u23618583
; Group member 02: Aundrea_Nandie_Ncube_u22747363
; Group member 03: Mpho_Siminya_u21824241
; ==========================
section .text
    global convertStringToFloat
    extern strtof

convertStringToFloat:
    ; Function setup
    push    rbp                    ; Preserve the base pointer
    mov     rbp, rsp               ; Set base pointer to current stack pointer
    sub     rsp, 64                ; Reserve 64 bytes on the stack for local storage

    ; Validate the input string pointer
    test    rdi, rdi               ; Check if rdi (input string) is null
    je      zero_return            ; If null, jump to zero_return

    ; Utilize the strtof function to perform the conversion
    xor     rsi, rsi               ; Reset rsi to NULL (no end pointer needed)
    call    strtof                 ; Convert string in rdi to float, rsi set to NULL

    ; Function teardown
    leave                          ; Revert the stack to previous state (mov rsp, rbp; pop rbp)
    ret                            ; Exit the function and return result in xmm0

zero_return:
    xorps   xmm0, xmm0             ; Set xmm0 to 0.0 to return for null input
    leave                          ; Revert the stack to previous state
    ret                            ; Exit the function