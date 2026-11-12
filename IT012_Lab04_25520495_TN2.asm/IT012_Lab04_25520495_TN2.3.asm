# Ma nguon 5 ? phan bac dien nang
.data
prompt: .asciiz ÅgNhap dien nang (kWh): Åg
msg:    .asciiz ÅgBac: Åg
nl:     .asciiz Åg\nÅh
 
.text
.globl main
main:
  li  $v0, 4
  la  $a0, prompt
  syscall
  li  $v0, 5            # doc kWh, ket qua o $v0
  syscall
  add $s0, $v0, $zero   # $s0 = dien nang (kWh)
  # >>> xac dinh bac (1..4) theo Bang 6, dat vao $s1
  slti $t0, $s0, 51     # Neu $s0 < 51 thi $t0 = 1, nguoc lai $t0 = 0
    bne  $t0, $zero, Bac1

    # Kiem tra Bac 2 (<= 100)
    slti $t0, $s0, 101    # Neu $s0 < 101 thi $t0 = 1, nguoc lai $t0 = 0
    bne  $t0, $zero, Bac2

    # Kiem tra Bac 3 (<= 200)
    slti $t0, $s0, 201    # Neu $s0 < 201 thi $t0 = 1, nguoc lai $t0 = 0
    bne  $t0, $zero, Bac3

    # Con lai (Neu > 200 thi r?t xu?ng ??y)
    j Bac4                # Chuyen huong den Bac 4 cho moi truong hop kWh > 200

Bac1:
    addi $s1, $zero, 1    # Dat bac = 1
    j Print
Bac2:
    addi $s1, $zero, 2    # Dat bac = 2
    j Print
Bac3:
    addi $s1, $zero, 3    # Dat bac = 3
    j Print
Bac4:
    addi $s1, $zero, 4    # Dat bac = 4
    j Print

Print:
    li  $v0, 4
    la  $a0, msg
    syscall

    li  $v0, 1
    add $a0, $s1, $zero
    syscall

    li  $v0, 4
    la  $a0, nl
    syscall
  # >>> in ÅgBac: Åg, roi $s1, roi xuong dong
  li  $v0, 10
  syscall
