include 'assembler.asm'

; Get input for A (must be 1 or 0)
ADD A  <- IN

; RS := -16
ADD RS <- RN
ADD RS <- RS
ADD RS <- RS
ADD RS <- RS
ADD RS <- RS

; A -= 0x30
ADD A <- RS
ADD A <- RS
ADD A <- RS

; RS := 8
ADD RS <- R1
ADD RS <- R1
ADD RS <- R1
ADD RS <- R1
ADD RS <- R1
ADD RS <- R1
ADD RS <- R1
ADD RS <- R1
ADD RS <- R1
ADD RS <- R1
ADD RS <- R1
ADD RS <- R1
ADD RS <- R1
ADD RS <- R1
ADD RS <- R1
ADD RS <- R1
ADD RS <- R1
ADD RS <- RS
ADD RS <- RS
ADD RS <- RS

ADD  B <-  A
ADD  B <-  B
ADD  B <-  B
ADD  B <-  B

ADD IP <-  B
; IF B = 0
    ADD  A <- R1
    ADD  B <- RS ; B := 8
    NOP
    ADD IP <-  B
; ELSE
    ADD  A <- RN
    NOP
    NOP
    NOP
; END

; RS := -16
ADD RS <- RN
ADD RS <- RN
ADD RS <- RN
ADD RS <- RN
ADD RS <- RN
ADD RS <- RN
ADD RS <- RN
ADD RS <- RN
ADD RS <- RN
ADD RS <- RS
ADD RS <- RS
ADD RS <- RS
ADD RS <- RS

; B := 16
ADD  B <-  B

; A += 0x30
ADD  A <-  B
ADD  A <-  B
ADD  A <-  B

; PUTCHAR(A)
ADD OT <-  A

; A -= 0x30
ADD  A <- RS
ADD  A <- RS
ADD  A <- RS
; B := 0
ADD  B <- RS
; RS := 0
ADD RS <- R1
ADD RS <- R1
ADD RS <- R1
ADD RS <- R1
ADD RS <- R1
ADD RS <- R1
ADD RS <- R1
ADD RS <- R1
ADD RS <- R1
ADD RS <- R1
ADD RS <- R1
ADD RS <- R1
ADD RS <- R1
ADD RS <- R1
ADD RS <- R1
ADD RS <- R1
ADD EX <- R1

LABEL A
DATA 0x00
LABEL B
DATA 0x00
