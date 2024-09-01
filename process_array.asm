; ==========================
; Group member 01: Yohali_Malaika_Kamangu_u23618583
; Group member 02: Aundrea_Nandie_Ncube_u22747363
; Group member 03: Mpho_Siminya_u21824241
; ==========================

    ;double processArray(float *arr, int arrSize)
    ;rdi : float array pointer
    ;rsi : array size

section .bss
    total resq 1

section .text
    global processArray

processArray:
    push rbp
    mov rbp, rsp

    cmp esi, 2
    jl .return_null  ;if size is less than 2, return 0

    xor rcx, rcx
    xorpd xmm0, xmm0

.loop:
    movss xmm1, dword [rdi + rcx * 4] 
    cvtss2sd xmm2, xmm1

    movss xmm3, dword [rdi + (rcx + 1) * 4] 
    cvtss2sd xmm4, xmm3

    mulsd xmm2, xmm4
    addsd xmm0, xmm2

    inc rcx
    cmp ecx, esi
    jl .loop  ;if rcx < size - 1, continu

    mov edx, esi
    dec rdx
    movss xmm1, dword [rdi + rdx * 4] 
    cvtss2sd xmm2, xmm1
    addsd xmm0, xmm2

    movsd [total], xmm0 ;store in memory
    mov r8, qword [total]
    mov rsp, rbp
    pop rbp
    ret

.return_null:
    xorpd xmm0, xmm0
    mov rsp, rbp
    pop rbp
    ret ;return
