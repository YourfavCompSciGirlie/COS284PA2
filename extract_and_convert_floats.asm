; ==========================
; Group member 01: Name_Surname_student-nr
; Group member 02: Name_Surname_student-nr
; Group member 03: Name_Surname_student-nr
; ==========================

section .data
    prompt db "Enter values separated by whitespace and enclosed in pipes (|):", 0
    format db "%f", 0          ; Format string for sscanf to convert string to float
    pipe db "|", 0             ; Pipe character for delimiters
    error_msg db "Error: Invalid input or memory allocation failed.", 10, 0

section .bss
    input resb 256             ; Buffer to store user input (256 bytes max)
    floats resq 100            ; Buffer to temporarily store floating-point numbers (100 floats max, 8 bytes each)
    num_floats resd 1          ; Variable to store the number of floats extracted (32-bit integer)

section .text
    extern printf, scanf, malloc, free, sscanf
    global extractAndConvertFloats

extractAndConvertFloats:
    push rbp
    mov rbp, rsp
    sub rsp, 16               ; Align stack to 16 bytes and make room for local variables

    ; Save the address of numFloats (passed in rsi) to a local variable
    mov [rbp-8], rsi

    ; Print the prompt message
    mov rdi, prompt
    xor eax, eax              ; Clear RAX (no floating-point arguments)
    call printf

; =====================================problem of segmentation fault starts above here 
    ; Read the input string from the user
    mov rdi, input
    xor eax, eax              ; Clear RAX (no floating-point arguments)
    call scanf

    ; Find the first pipe '|' character in the input string
    mov rdi, input
    call find_pipe
    
    ; Check if the first pipe was found
    test rax, rax
    jz no_pipe_found

    ; Find the second pipe '|' character starting from the position after the first pipe
    mov rdi, rax
    inc rdi                   ; Skip past the first '|'
    call find_pipe
    
    ; Check if the second pipe was found
    test rax, rax
    jz no_pipe_found

    ; Extract and convert floats between the pipes
    mov rdi, rax
    inc rdi                   ; Skip past the first '|'
    
    ; Initialize num_floats to 0
    mov dword [num_floats], 0  ; Clear the number of floats

parse_floats:
    ; Check if we have reached the end of the valid section (second '|')
    cmp byte [rdi], '|'
    je done_parsing

    ; Check if we've reached the maximum number of floats
    mov eax, [num_floats]
    cmp eax, 100
    jge done_parsing

    ; Convert the substring to a floating-point number
    mov rsi, format
    mov rdx, floats
    imul rax, rax, 8           ; Multiply num_floats by 8 (size of a float)
    add rdx, rax               ; Add the offset to floats array
    xor eax, eax               ; Clear RAX (no floating-point arguments)
    call sscanf

    ; Check if sscanf was successful
    test eax, eax
    jle parse_error

    ; Increment the float count
    inc dword [num_floats]

    ; Move to the next potential float in the string
    call skip_whitespace

    ; Loop back to parse the next float
    jmp parse_floats

done_parsing:
    ; Allocate memory for the array of floats
    mov edi, [num_floats]
    imul edi, 8                ; Calculate total size (number of floats * 8 bytes)
    call malloc

    ; Check if malloc was successful
    test rax, rax
    jz malloc_error

    ; Copy floats from the temporary buffer to the dynamically allocated array
    mov rdi, rax
    mov rsi, floats
    mov ecx, [num_floats]
    rep movsq                  ; Copy floats from buffer to allocated memory

    ; Set the number of floats in the output parameter
    mov rsi, [rbp-8]           ; Retrieve the address of numFloats
    mov ecx, [num_floats]
    mov dword [rsi], ecx       ; Store the number of floats at the address passed in RSI

    ; Clean up and return
    leave
    ret

no_pipe_found:
malloc_error:
parse_error:
    ; Handle errors
    mov rdi, error_msg
    xor eax, eax
    call printf

    xor rax, rax               ; Return null pointer (0)
    leave
    ret

find_pipe:
    ; Find the '|' character in a string
    mov al, '|'
.loop:
    cmp byte [rdi], 0          ; Check for end of string
    je .not_found
    cmp byte [rdi], al         ; Check if the current character is '|'
    je .found
    inc rdi
    jmp .loop

.found:
    ; Return the position of the '|' character in RAX
    mov rax, rdi
    ret

.not_found:
    ; Return 0 if the '|' character was not found
    xor rax, rax
    ret

skip_whitespace:
    ; Skip whitespace characters
.loop:
    cmp byte [rdi], ' '
    je .skip
    cmp byte [rdi], 9          ; Tab character
    je .skip
    ret
.skip:
    inc rdi
    jmp .loop
