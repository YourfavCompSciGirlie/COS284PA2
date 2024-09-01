; ==========================
; Group member 01: Yohali Malaika_Kamangu_u23618583
; Group member 02: Name_Surname_student-nr
; Group member 03: Name_Surname_student-nr
; ==========================
section .text
    global processArray

processArray:
    ; Input: RDI = pointer to array, RSI = size
    ; Initialize sum to 0.0
    xor rax, rax              ; clear rax for index
    xor rdx, rdx              ; clear rdx for sum

.loop:
    ; Load floats from the array
    movq xmm0, [rdi + rax*8]  ; Load float[i] into xmm0
    movq xmm1, [rdi + rax*8 + 8] ; Load float[i+1] into xmm1
    mulsd xmm0, xmm1          ; Multiply float[i] * float[i+1]
    addsd xmm2, xmm0          ; Add result to sum

    ; Increment index
    inc rax
    cmp rax, rsi
    jl .loop                   ; Loop if i < size

    ; Return the sum in xmm0
    movq xmm0, rdx
    ret