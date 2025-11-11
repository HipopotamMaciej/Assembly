; Autor: Maciej Lemanski 
; Numer indeksu: s227781
; Rocznik: 2025/2026
; Numer grupy: 2
; Numer tematu: 6

ORG 100h

Start:
    JMP StartGlownegoKodu

StartGlownegoKodu:
    MOV DX, nienawidzeassemblera
    CALL WypiszNapis

PetlaGlowna:
    MOV DX, Pytanie1
    CALL WypiszNapis

    MOV DX, npt1
    MOV AH, 0Ah
    INT 21h
    CALL NowaLinia

    MOV SI, npt1 + 2
    MOV AL, [SI]
    CMP AL, '^'
    JE KoniecPracy

    MOV DX, Pytanie2
    CALL WypiszNapis

    MOV DX, npt2
    MOV AH, 0Ah
    INT 21h
    CALL NowaLinia

    MOV SI, npt1 + 2
    MOV CL, [npt1 + 1]
    MOV CH, 0

    CALL PoliczLitery
    PUSH AX

    MOV SI, npt2 + 2
    MOV CL, [npt2 + 1]
    MOV CH, 0

    CALL PoliczLitery

    POP BX

    CMP AX, BX
    JNE PokazRozne

PokazTakieSame:
    MOV DX, KomunikatTak
    CALL WypiszNapis
    CALL NowaLinia
    JMP PetlaGlowna

PokazRozne:
    MOV DX, KomunikatNie
    CALL WypiszNapis
    CALL NowaLinia
    JMP PetlaGlowna

KoniecPracy:
    MOV AH, 4Ch
    INT 21h

WypiszNapis:
    PUSH AX
    MOV AH, 09h
    INT 21h
    POP AX
    RET

NowaLinia:
    PUSH AX
    PUSH DX
    MOV DX, ZnakiNowejLinii
    MOV AH, 09h
    INT 21h
    POP DX
    POP AX
    RET

PoliczLitery:
    PUSH BX
    PUSH CX
    PUSH SI

    MOV BX, 0

    CMP CX, 0
    JE KoniecZliczania

PetlaZliczania:
    MOV AL, [SI]

    CMP AL, 'A'
    JB  NastepnyZnak
    CMP AL, 'Z'
    JBE JestLitera

    CMP AL, 'a'
    JB  NastepnyZnak
    CMP AL, 'z'
    JA  NastepnyZnak

JestLitera:
    INC BX

NastepnyZnak:
    INC SI
    LOOP PetlaZliczania

KoniecZliczania:
    MOV AX, BX

    POP SI
    POP CX
    POP BX
    RET

section .data
    npt1:
        db 64
        db 0
        times 64 db 0
    npt2:
        db 64
        db 0
        times 64 db 0

    nienawidzeassemblera: db 'Wprowadz dwa ciagi znakow.' ,13,10
                        db 'Program zliczy litery w kazdym z nich.' ,13,10
                        db 'Nastepnie sprawdzi, czy ilosc liter jest taka sama.' ,13,10
                        db 'Aby zakonczyc, wpisz ^ jako pierwszy znak.', 13,10,10,'$'

    Pytanie1:          db 'Podaj pierwszy ciag: $'
    Pytanie2:          db 'Podaj drugi ciag:   $'
    KomunikatTak:       db 'Wynik: Oba ciagi maja taka sama ilosc liter.$'
    KomunikatNie:       db 'Wynik: Ciagi maja rozna ilosc liter.$'
    ZnakiNowejLinii:    db 13, 10, '$'
