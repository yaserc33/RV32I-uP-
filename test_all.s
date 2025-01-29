    .section .text
    .globl  _start

_start:
    ############################################
    # 1) Test LUI, AUIPC
    ############################################
    lui     x1, 0x12345        # x1 = 0x12345 << 12
    auipc   x2, 0              # x2 = PC + 0
    addi    x2, x2, 16         # small offset just to do something

    ############################################
    # 2) Test Immediate Arithmetic
    ############################################
    addi    x3, x1, 0x10       # x3 = x1 + 0x10
    slli    x4, x3, 2          # x4 = x3 << 2
    srli    x5, x4, 1          # x5 = x4 >> 1 (logical)
    srai    x6, x5, 1          # x6 = x5 >> 1 (arithmetic)
    xori    x7, x6, 0x55       # x7 = x6 ^ 0x55
    ori     x8, x7, 0xFF       # x8 = x7 | 0xFF
    andi    x9, x8, -1      # x9 = x8 & 0xFFF
    slti    x10, x9, 100       # x10 = (x9 < 100) ? 1 : 0
    sltiu   x11, x9, 100       # x11 = unsigned compare vs 100

    ############################################
    # 3) Test R-Type ALU
    ############################################
    add     x12, x3, x4        # x12 = x3 + x4
    sub     x13, x4, x3        # x13 = x4 - x3
    sll     x14, x4, x7        # x14 = x4 << (x7 mod 32)
    srl     x15, x8, x3        # x15 = x8 >> (x3 mod 32) (logical)
    sra     x16, x8, x3        # x16 = x8 >> (x3 mod 32) (arith)
    xor     x17, x1, x2        # x17 = x1 ^ x2
    or      x18, x1, x2        # x18 = x1 | x2
    and     x19, x1, x2        # x19 = x1 & x2
    slt     x20, x1, x2        # x20 = (signed(x1) < signed(x2)) ? 1 : 0
    sltu    x21, x2, x1        # x21 = (unsigned(x2) < unsigned(x1)) ? 1 : 0

    ############################################
    # 4) Simple Data Section to Test Loads/Stores
    ############################################
    la      x22, my_data       # x22 = address of my_data
    lw      x23, 0(x22)        # test LW
    lb      x24, 1(x22)        # test LB
    lh      x25, 2(x22)        # test LH
    lbu     x26, 1(x22)        # test LBU
    lhu     x27, 2(x22)        # test LHU

    sb      x24, 5(x22)        # test SB  (store byte)
    sh      x25, 6(x22)        # test SH  (store halfword)
    sw      x23, 8(x22)        # test SW  (store word)

    ############################################
    # 5) Test Branches
    ############################################
    beq     x23, x23, label_eq   # test BEQ (always taken)
    j       fail

label_eq:
    bne     x23, x23, fail       # test BNE (not taken)

    addi    x28, x0, 10
    blt     x0, x28, label_blt   # test BLT (taken)
    j       fail

label_blt:
    bge     x28, x0, label_bge   # test BGE (taken)
    j       fail

label_bge:
    bltu    x0, x28, label_bltu  # test BLTU (taken)
    j       fail

label_bltu:
    bgeu    x28, x0, label_bgeu  # test BGEU (taken)
    j       fail

label_bgeu:
    ############################################
    # 6) Test JAL + JALR
    ############################################
    # We'll jump to `jal_target` and then use JALR to get back
    jal     x1, jal_target

    # If we reach here without jumping, fail
    j       fail

return_point:
    # If we come back here via JALR, all is good
    j       done

jal_target:
    # Jump back using x1 as the return address
    jalr    x0, 0(x1)   # x0 discards the link, x1 was set by JAL

fail:
    # If we ever land here, we consider it "failure"
    lui    x31 , 0xDEAD
done:
    lui    x31 , 0xAEEE



    # Simulation can stop here or spin
1:  j 1b

    ############################################
    # 7) Data Section (aligned)
    ############################################
    .section .data
    .align 4
my_data:
    # We'll store an example word, then a byte, then a half, etc.
    .word 0x12345678   # 4 bytes
    .byte 0xAB         # single byte
    .half 0xCDEF       # 2 bytes
    .byte 0x55
    .byte 0x66
    .word 0xDEADBEEF
