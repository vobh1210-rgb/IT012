.data
m1:      .asciiz "Thang "
m2:      .asciiz ": "
mt:      .asciiz "Tong: "
mm:      .asciiz "Thang cao nhat: "
lp:      .asciiz " ("
rp:      .asciiz ")"
nl:      .asciiz "\n"
reading: .word 1000, 1095, 1205, 1345, 1510, 1715, 1955
         .word 2210, 2440, 2625, 2775, 2895, 2995
usage:   .space 48
# Ma nguon 8 ? dien nang tung thang
.text
.globl main
main:
  la   $s0, reading     # $s0 = dia chi nen reading
  la   $s1, usage       # $s1 = dia chi nen usage
  addi $s2, $zero, 0    # i = 0
  addi $s3, $zero, 12   # n = 12 thang
Loop:
  # >>> thoat neu i == n
  beq $s2, $s3, Done
  # >>> tinh dia chi reading[i]
  sll $t1, $s2, 2
  add $t1, $t1, $s0
  # >>> $t3 = reading[i], $t4 = reading[i+1]
  lw $t3, 0($t1)
  lw $t4, 4($t1)
  # >>> $t5 = $t4 - $t3 (dien nang thang i+1)
  sub $t5, $t4, $t3
  # >>> tinh dia chi usage[i], luu $t5 vao usage[i]
  sll $t2, $s2, 2
  add $t2, $t2, $s1
  sw $t5, 0($t2)
  
  add $s4, $s4, $t5
  
  slt  $t6, $s5, $t5
  beq  $t6, $zero, SkipUpdateMax
  
  add  $s5, $t5, $zero
  addi $s6, $s2, 1
  
SkipUpdateMax: 
  # >>> in gThang g, i+1, g: ", $t5, xuong dong
  li $v0, 4
  la $a0, m1
  syscall
  
  li $v0, 1
  addi $a0, $s2, 1
  syscall
  
  li $v0, 4
  la $a0, m2
  syscall
  
  li $v0, 1
  add $a0, $t5, $zero
  syscall
  
  li $v0, 4
  la $a0, nl
  syscall
  
  addi $s2, $s2, 1
  j Loop
  # >>> i = i + 1, quay lai Loop
Done:
  li   $v0, 4
  la   $a0, mt
  syscall               # In "Tong: "

  li   $v0, 1
  add  $a0, $s4, $zero
  syscall               # In gia tri tong

  li   $v0, 4
  la   $a0, nl
  syscall               # In xuong dong

  # In Thang cao nhat: <thang> (<dien nang>)
  li   $v0, 4
  la   $a0, mm
  syscall               # In "Thang cao nhat: "

  li   $v0, 1
  add  $a0, $s6, $zero
  syscall               # In so thang max

  li   $v0, 4
  la   $a0, lp
  syscall               # In " ("

  li   $v0, 1
  add  $a0, $s5, $zero
  syscall               # In dien nang max

  li   $v0, 4
  la   $a0, rp
  syscall               # In ")"

  li   $v0, 4
  la   $a0, nl
  syscall               # In xuong dong
 
  li  $v0, 10
  syscall
