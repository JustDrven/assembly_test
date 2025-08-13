section .data                       ; Statická (globální) data – uložená v .data segmentu
    msg db "Staticka paměť!", 0xA
    msg_len equ $ - msg             ; délka řetězce

section .bss                        ; Neinitializovaná data – dostanou nulovou hodnotu při startu
    buffer resb 64                  ; rezervujeme 64 bajtů

section .text
    global _start

_start:
    ; ---------------------------
    ; 1) Ukázka práce se zásobníkem
    ; ---------------------------
    push rbp                        ; uložíme starý base pointer
    mov rbp, rsp                    ; nastavíme nový
    sub rsp, 32                     ; "alokujeme" 32 bajtů na zásobníku (pro lokální proměnné)

    mov qword [rbp-8], 123456       ; uložíme hodnotu do "lokální proměnné"
    
    ; ---------------------------
    ; 2) Výpis statické zprávy (.data segment)
    ; ---------------------------
    mov rax, 1                    ; syscall: write
    mov rdi, 1                    ; fd = stdout
    mov rsi, msg                  ; adresa zprávy
    mov rdx, msg_len              ; délka
    syscall

    ; ---------------------------
    ; 3) Dynamická alokace paměti na haldě (mmap)
    ; ---------------------------
    mov rax, 9                    ; syscall: mmap
    xor rdi, rdi                  ; adresa = NULL (OS vybere)
    mov rsi, 4096                 ; velikost 4 KiB
    mov rdx, 3                    ; PROT_READ | PROT_WRITE
    mov r10, 0x22                 ; MAP_PRIVATE | MAP_ANONYMOUS
    mov r8, -1                    ; fd = -1 (nepoužíváme soubor)
    xor r9, r9                    ; offset = 0
    syscall
    ; návratová hodnota (adresa) je v RAX
    mov rbx, rax                  ; uložíme si adresu alokované paměti

    ; zapíšeme hodnotu do alokované paměti
    mov qword [rbx], 0x1122334455667788

    ; ---------------------------
    ; 4) Uvolnění paměti (munmap)
    ; ---------------------------
    mov rax, 11                   ; syscall: munmap
    mov rdi, rbx                  ; adresa, kterou jsme dostali
    mov rsi, 4096                 ; velikost
    syscall

    ; ---------------------------
    ; 5) Ukončení programu
    ; ---------------------------
    mov rsp, rbp                  ; navrácení zásobníku
    pop rbp
    mov rax, 60                   ; syscall: exit
    xor rdi, rdi                  ; návratový kód 0
    syscall
