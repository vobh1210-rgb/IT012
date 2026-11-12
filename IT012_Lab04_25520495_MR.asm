# Ma nguon Mo Rong - Dem so thang theo bac gia
.data
  m1:      .asciiz "Thang "
  m2:      .asciiz ": "
  mt:      .asciiz "Tong: "
  mm:      .asciiz "Thang cao nhat: "
  lp:      .asciiz " ("
  rp:      .asciiz ")"
  nl:      .asciiz "\n"
  
  mbac:    .asciiz "Bac "       # Chu?i in b?c
  
  reading: .word 1000, 1095, 1205, 1345, 1510, 1715, 1955
           .word 2210, 2440, 2625, 2775, 2895, 2995
  usage:   .space 48
  cnt:     .word 0, 0, 0, 0     # M?ng cnt 4 ph?n t? kh?i t?o b?ng 0

.text
.globl main

main:
  # PH?N 1: T?NH ?I?N N?NG, T?NG, V? T?M TH?NG CAO NH?T (B??c 3.2 & 3.3)
  la   $s0, reading
  la   $s1, usage
  addi $s2, $zero, 0    # i = 0
  addi $s3, $zero, 12   # n = 12

  addi $s4, $zero, 0    # $s4 = Tong
  addi $s5, $zero, -1   # $s5 = Max kWh
  addi $s6, $zero, 0    # $s6 = Thang Max

Loop:
  beq  $s2, $s3, DoneLoop1
  
  sll  $t1, $s2, 2
  add  $t1, $t1, $s0
  lw   $t3, 0($t1)      # reading[i]
  lw   $t4, 4($t1)      # reading[i+1]
  sub  $t5, $t4, $t3    # kWh thang i+1

  sll  $t2, $s2, 2
  add  $t2, $t2, $s1
  sw   $t5, 0($t2)      # Luu usage[i]

  add  $s4, $s4, $t5    # Cong don Tong

  slt  $t6, $s5, $t5
  beq  $t6, $zero, SkipMax
  add  $s5, $t5, $zero
  addi $s6, $s2, 1
SkipMax:

  # In: Thang i+1: kWh
  li   $v0, 4
  la   $a0, m1
  syscall
  li   $v0, 1
  addi $a0, $s2, 1
  syscall
  li   $v0, 4
  la   $a0, m2
  syscall
  li   $v0, 1
  add  $a0, $t5, $zero
  syscall
  li   $v0, 4
  la   $a0, nl
  syscall

  addi $s2, $s2, 1
  j    Loop

DoneLoop1:
  # In Tong va Thang max
  li   $v0, 4
  la   $a0, mt
  syscall
  li   $v0, 1
  add  $a0, $s4, $zero
  syscall
  li   $v0, 4
  la   $a0, nl
  syscall

  li   $v0, 4
  la   $a0, mm
  syscall
  li   $v0, 1
  add  $a0, $s6, $zero
  syscall
  li   $v0, 4
  la   $a0, lp
  syscall
  li   $v0, 1
  add  $a0, $s5, $zero
  syscall
  li   $v0, 4
  la   $a0, rp
  syscall
  li   $v0, 4
  la   $a0, nl
  syscall

  # PH?N 2: DUY?T M?NG USAGE V? ??M S? TH?NG THEO B?C (Ph?n M? R?ng)
  la   $s7, cnt         # $s7 = dia chi nen cnt
  addi $s2, $zero, 0    # i = 0 (reset index)
  
LoopCount:
  beq  $s2, $s3, PrintCount   # thoat neu i == 12

  sll  $t2, $s2, 2
  add  $t2, $t2, $s1
  lw   $t5, 0($t2)      # N?p $t5 = usage[i]

  # Kiem tra Bac 1 (<= 50)
  slti $t6, $t5, 51
  bne  $t6, $zero, IncBac1

  # Kiem tra Bac 2 (<= 100)
  slti $t6, $t5, 101
  bne  $t6, $zero, IncBac2

  # Kiem tra Bac 3 (<= 200)
  slti $t6, $t5, 201
  bne  $t6, $zero, IncBac3

  # else Bac 4
  j    IncBac4

IncBac1:
  addi $t7, $zero, 0    # Offset c?a cnt[0] (Bac 1)
  j    DoInc
IncBac2:
  addi $t7, $zero, 4    # Offset c?a cnt[1] (Bac 2)
  j    DoInc
IncBac3:
  addi $t7, $zero, 8    # Offset c?a cnt[2] (Bac 3)
  j    DoInc
IncBac4:
  addi $t7, $zero, 12   # Offset c?a cnt[3] (Bac 4)
  j    DoInc

DoInc:
  # Tang phan tu tuong ung them 1 bang lw, addi, sw
  add  $t8, $s7, $t7    # $t8 = dia chi cnt[k]
  lw   $t9, 0($t8)      # N?p gia tri cnt[k] hien tai
  addi $t9, $t9, 1      # cnt[k] = cnt[k] + 1
  sw   $t9, 0($t8)      # Luu lai vao cnt[k]

  addi $s2, $s2, 1      # i++
  j    LoopCount

PrintCount:
  # In 4 dong khao sat: "Bac <k>: <so thang>"
  addi $s2, $zero, 0    # i = 0
  addi $t0, $zero, 4    # So bac = 4
  
LoopPrintCnt:
  beq  $s2, $t0, EndProg
  
  li   $v0, 4
  la   $a0, mbac
  syscall               # In "Bac "
  
  li   $v0, 1
  addi $a0, $s2, 1
  syscall               # In so bac (i+1)
  
  li   $v0, 4
  la   $a0, m2
  syscall               # In ": "
  
  sll  $t2, $s2, 2
  add  $t2, $t2, $s7
  lw   $a0, 0($t2)      # Nap cnt[i]
  li   $v0, 1
  syscall               # In so thang
  
  li   $v0, 4
  la   $a0, nl
  syscall               # In xuong dong

  addi $s2, $s2, 1
  j    LoopPrintCnt

EndProg:
  li   $v0, 10
  syscall