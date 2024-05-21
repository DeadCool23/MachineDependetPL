; Данный интерфейс был написан с помощью @OverGoro
; https://github.com/OverGoro/BMSTU/tree/main/4_sem/mdpl/lab_10

bits 64
global main

%define GTK_WIN_POS_CENTER 1
%define GTK_WIN_WIDTH 150
%define GTK_WIN_HEIGHT 150
%define GTK_ORIENTATION_VERTICAL 1
%define GTK_ORIENTATION_HORIZONTAL 0
%define LAYOUT_BOX_SPACING 10
%define ENTRY_SIZE 128

; функция получения корня
extern get_root

; Для расположения объектов
extern gtk_box_new
extern gtk_grid_new
extern gtk_grid_attach
extern gtk_container_add

; Для создания кнопки
extern gtk_button_new_with_label

; Для создание полей ввода/вывода
extern gtk_entry_buffer_new
extern gtk_entry_get_text
extern gtk_entry_new_with_buffer
extern gtk_entry_set_placeholder_text
extern gtk_label_new
extern gtk_label_set_text

; Для работы с текстом
extern sprintf
extern sscanf
extern gtk_entry_set_text

; Для работы с window
extern gtk_init
extern gtk_main
extern g_object_set
extern gtk_main_quit
extern gtk_window_new
extern gtk_widget_show_all
extern g_signal_connect
extern gtk_window_set_title
extern g_signal_connect_data
extern gtk_window_set_position
extern gtk_settings_get_default
extern gtk_widget_set_size_request
extern gtk_window_set_default_size

section .data
    solve_button_title          db "Calculate", 0
    ; solve_button_title          db "לחשב", 0
    title                       db "Root Finder", 0
    res_text                    db ENTRY_SIZE dup (0)

    start_x_placeholder_text    db "X begin", 0 
    ; start_x_placeholder_text    db "X התחל", 0 
    end_x_placeholder_text      db "X end", 0
    ; end_x_placeholder_text      db "X סוֹף", 0
    iters_num_placeholder_text  db "Iteration count", 0
    result_placeholder_text     db "Result", 0

    result_format               db "%lf", 0
    x_format                    db "%lf", 0
    iters_num_format            db "%d", 0

    float_start                 dq 0
    float_end                   dq 0
    int_iters_num               dq 0

section .bss
    window:             resq 1  ; Окно
    layout_box:         resq 1  ; Контейнер виджетов
    grid:               resq 1  ; Сетка для размещения элементов

    solve_button:       resq 1  ; Кнопка "Calculate"
    start_x_entry:      resq 1  ; Поле ввода стартового x
    end_x_entry:        resq 1  ; Поле ввода конечного x
    iters_num_entry:    resq 1  ; Поле ввода максимального числа итераций
    result_label:       resq 1  ; Поле вывода результата

    start_x_buffer:     resq 1 
    end_x_buffer:       resq 1 
    iters_num_buffer:   resq 1

section .rodata
    signal:
    .destroy: db "destroy", 0
    .clicked: db "clicked", 0

section .text
_destroy_window:
    jmp gtk_main_quit

solve_command:
    push rbp
    mov rbp, rsp

    mov rdi, qword [rel end_x_entry]
    call gtk_entry_get_text
    mov rdi, rax
    mov rsi, x_format
    mov rdx, float_end
    call sscanf

    mov rdi, qword [rel start_x_entry]
    call gtk_entry_get_text
    mov rdi, rax
    mov rsi, x_format
    mov rdx, float_start
    call sscanf

    mov rdi, qword [rel iters_num_entry]
    call gtk_entry_get_text
    mov rdi, rax
    mov rsi, iters_num_format
    mov rdx, int_iters_num
    call sscanf

    mov rdi, qword [int_iters_num]
    movq xmm0, qword [float_start]
    movq xmm1, qword [float_end]

    call get_root

    mov rdi, res_text
    mov rsi, result_format
    call sprintf

    mov rdi, qword [rel result_label]
    mov rsi, res_text
    call gtk_label_set_text

    pop rbp
    ret

main:
    push rbp
    mov rbp, rsp
    xor rdi, rdi
    xor rsi, rsi
    call gtk_init

    ; создание окна
    xor rdi, rdi
    call gtk_window_new
    mov qword [rel window], rax

    ; Задание заголовка окна
    mov rdi, qword [rel window]
    mov rsi, title
    call gtk_window_set_title

    ; задание размеров окна
    mov rdi, qword [rel window]
    mov rsi, GTK_WIN_WIDTH
    mov rdx, GTK_WIN_HEIGHT
    call gtk_window_set_default_size

    ; Задание положения окна
    mov rdi, qword [rel window]
    mov rsi, GTK_WIN_POS_CENTER
    call gtk_window_set_position

    ; Связывание сигнала закрытия
    mov rdi, qword [rel window]
    mov rsi, signal.destroy
    mov rdx, _destroy_window
    xor rcx, rcx
    xor r8d, r8d
    xor r9d, r9d
    call g_signal_connect_data

    ; Создание вертикального контейнера
    mov rdi, GTK_ORIENTATION_VERTICAL
    mov rsi, LAYOUT_BOX_SPACING
    call gtk_box_new
    mov qword [rel layout_box], rax

    ; Добавление контейнера в окно
    mov rdi, qword [rel window]
    mov rsi, qword [rel layout_box]
    call gtk_container_add

    ; Создание сетки для размещения элементов
    call gtk_grid_new
    mov qword [rel grid], rax

    ; Добавление сетки в контейнер
    mov rdi, qword [rel layout_box]
    mov rsi, qword [rel grid]
    call gtk_container_add

    ; Создание поля ввода start_x
    mov rdi, 0
    mov rsi, -1
    call gtk_entry_buffer_new
    mov qword [rel start_x_buffer], rax

    mov rdi, qword [rel start_x_buffer]
    call gtk_entry_new_with_buffer
    mov qword [rel start_x_entry], rax

    mov rdi, qword [rel start_x_entry]
    mov rsi, start_x_placeholder_text
    call gtk_entry_set_placeholder_text

    ; Добавление start_x_entry в сетку
    mov rdi, qword [rel grid]
    mov rsi, qword [rel start_x_entry]
    mov rdx, 0
    mov rcx, 0
    mov r8, 1
    mov r9, 1
    call gtk_grid_attach

    ; Создание поля ввода end_x
    mov rdi, 0
    mov rsi, -1
    call gtk_entry_buffer_new
    mov qword [rel end_x_buffer], rax

    mov rdi, qword [rel end_x_buffer]
    call gtk_entry_new_with_buffer
    mov qword [rel end_x_entry], rax

    mov rdi, qword [rel end_x_entry]
    mov rsi, end_x_placeholder_text
    call gtk_entry_set_placeholder_text

    ; Добавление end_x_entry в сетку
    mov rdi, qword [rel grid]
    mov rsi, qword [rel end_x_entry]
    mov rdx, 0
    mov rcx, 1
    mov r8, 1
    mov r9, 1
    call gtk_grid_attach

    ; Поле ввода числа итераций
    mov rdi, 0
    mov rsi, -1
    call gtk_entry_buffer_new
    mov qword [rel iters_num_buffer], rax

    mov rdi, qword [rel iters_num_buffer]
    call gtk_entry_new_with_buffer
    mov qword [rel iters_num_entry], rax

    mov rdi, qword [rel iters_num_entry]
    mov rsi, iters_num_placeholder_text
    call gtk_entry_set_placeholder_text

    ; Добавление iters_num_entry в сетку
    mov rdi, qword [rel grid]
    mov rsi, qword [rel iters_num_entry]
    mov rdx, 0
    mov rcx, 2
    mov r8, 1
    mov r9, 1
    call gtk_grid_attach

    ; Создание кнопки расчета
    mov rdi, solve_button_title
    call gtk_button_new_with_label
    mov qword [rel solve_button], rax

    ; Добавление кнопки в сетку
    mov rdi, qword [rel grid]
    mov rsi, qword [rel solve_button]
    mov rdx, 0
    mov rcx, 3
    mov r8, 1
    mov r9, 1
    call gtk_grid_attach

    ; Связывание сигнала нажатия кнопки "Calculate"
    mov rdi, qword [rel solve_button]
    mov rsi, signal.clicked
    mov rdx, solve_command
    xor rcx, rcx
    xor r8d, r8d
    xor r9d, r9d
    call g_signal_connect_data

    ; Создание поля вывода результата
    xor rdi, rdi
    call gtk_label_new
    mov qword [rel result_label], rax

    mov rdi, qword [rel result_label]
    mov rsi, result_placeholder_text
    call gtk_label_set_text

    ; Добавление result_label в сетку
    mov r8, 1
    mov r9, 1
    mov rdx, 0
    mov rcx, 4
    mov rdi, qword [rel grid]
    mov rsi, qword [rel result_label]
    call gtk_grid_attach

    ; Показ всех виджетов в окне
    mov rdi, qword [rel window]
    call gtk_widget_show_all

    ; Запуск главного цикла GTK
    call gtk_main

    pop rbp
    ret

