global get_root

%define x_start xmm0
%define x_end xmm1
%define iters_num rdi

section .data 
    x dq 0
    sin_k dq 5
    answer dq 0
    eps dq 0.000001

    tmp_beg dq 0
    tmp_end dq 0

    tmp_x_start dq 0
    tmp_x_end dq 0

section .text
chord_method:
    ; a
    fld qword [tmp_beg]
    ; b - a
    fld qword [tmp_end]
    fld qword [tmp_beg]
    fsubp

    ; (b - a) * f(a)
    fld qword [tmp_beg]
    fstp qword [x]
    call func
    fmulp

    ; f(b) - f(a)
    fld qword [tmp_end]
    fstp qword [x]
    call func

    fld qword [tmp_beg]
    fstp qword [x]
    call func

    fsubp

    ; (b - a) * f(x) / (f(b) - f(a))
    fdivp
    ; a - (b - a) * f(a) / (f(b) - f(a))
    fsubp
    ret

func:
    ;x * x
    fld qword [x] 
    fld qword [x] 
    fmulp
    ; x * 5
    fld qword [x] 
    fild qword [sin_k]
    fmulp
    ; x * x + x * 5
    faddp
    ; sin(x * x + x * 5)
    fsin
    ret

get_root:
    movsd [tmp_x_start], x_start
    movsd [tmp_x_end], x_end

    get_root_loop:

    ; while (fabs(b - a) > eps)
    fld qword [tmp_x_end]
    fld qword [tmp_x_start]
    fsubp
    fabs
    fld qword [eps]
    fcompp
    fstsw ax 
    fwait    
    sahf     
    jnb exit

    cmp rdi, 0
    jle exit


    mov rax, qword [tmp_x_start]
    mov [tmp_beg], rax
    mov rax, qword [tmp_x_end]
    mov [tmp_end],  rax
    call chord_method
    fstp qword [tmp_x_start]

    mov rax, qword [tmp_x_end]
    mov [tmp_beg], rax
    mov  rax ,  qword [tmp_x_start]
    mov [tmp_end], rax
    call chord_method
    fstp qword [tmp_x_end]

    dec rdi
    jmp get_root_loop

    exit:
    movsd xmm0, qword [tmp_x_end]
    ret
