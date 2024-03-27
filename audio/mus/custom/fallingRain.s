musFallingRainStart:
    tempo 135


.macro m_musFallingRainChannel1Measure1
    vol HI_VOL
    env $1 $00
    vibrato $e1
    beat \1 Q+Q+R1+R2
    vibrato $01
    vol LO_VOL
    env $0 $00
    beat \1 R3
.endm

musFallingRainChannel1:
    .redefine HI_VOL $6
    .redefine LO_VOL $4

; Measure 1
    vol $0
    beat gs3 Q
    duty $02
    m_musFallingRainChannel1Measure1 g4
; Measure 2
    rest Q
    m_musFallingRainChannel1Measure1 gs4
; Measure 3
    rest Q
    m_musFallingRainChannel1Measure1 a4
; Measure 4
    rest Q
    m_musFallingRainChannel1Measure1 as4
; Measure 5
    rest Q
    m_musFallingRainChannel1Measure1 c4
; Measure 6
    rest Q
    m_musFallingRainChannel1Measure1 cs4
; Measure 7
    rest Q
    m_musFallingRainChannel1Measure1 d4
; Measure 8
    rest Q
    m_musFallingRainChannel1Measure1 ds4

musFallingRainChannel1Measure9Loop:
    vibrato $e1
.rept 2
; Measure 9,17
    vol HI_VOL
    env $1 $00
    duty $02
    octave 4
    ;beat b HF+Q
    beat b HF+R1+R2
    vol LO_VOL
    env $0 $00
    beat b R3
    vol HI_VOL
    env $1 $00
    beat a E1 g E2
; Measure 10,18
    ;beat a W
    beat a HF+Q+R1+R2
    vol LO_VOL
    env $0 $00
    beat a R3
; Measure 11,19
    vol HI_VOL
    env $1 $00
    octaveu
    ;beat d HF+Q
    beat d HF+R1+R2
    vol LO_VOL
    env $0 $00
    beat d R3
    vol HI_VOL
    env $1 $00    
    beat c E1 od as E2
; Measure 12,20
    octaveu
   ;beat c W
    beat c HF+Q+R1+R2
    vol LO_VOL
    env $0 $00
    beat c R3
; Measure 13-14,21-22
    vol HI_VOL
    env $1 $00
.rept 2
    octave 5
    ;beat c HF+Q
    beat c HF+R1+R2
    vol LO_VOL
    env $0 $00
    beat c R3
    vol HI_VOL
    env $1 $00    
    octaved
    beat b E1 a E2
.endr
; Measure 15-16,23-24
    ;beat b W+W
    beat b W+Q+R1
    vol LO_VOL
    env $0 $00
    beat b R2+R3+Q+R1+R2 r R3
.endr


.macro m_musFallingRainChannel1Measure25
; Measure 25-26
    vol HI_VOL
    env $1 $00
.rept 2
    octave 4
    beat a HF ou d Q
.endr
; Measure 27
    beat c HF od b E1 ou c E2
; Measure 28
    octaved
    ;beat a HF+Q
    beat a HF+E1+Y4+Y5
    vol LO_VOL
    env $0 $0
    beat a Y6
    vol HI_VOL
    env $1 $00
.endm
; Measure 25-28
    m_musFallingRainChannel1Measure25
; Measure 29
    beat f HF as Q
; Measure 30
    beat f Q e Q as Q
; Measure 31-32
    ;beat a HF+Q+Q+HF
    beat a HF+Q+Q+R1
    vol LO_VOL
    env $0 $00
    beat a R2+R3+R1+R2 r R3
; Measure 33-36
    m_musFallingRainChannel1Measure25
; Measure 37
    octave 4
    beat g HF ou c Q
; Measure 38
    octaved
    beat g Q f Q g Q
; Measure 39
    ;beat a HF+Q
    beat a HF+R1
    vol LO_VOL
    env $0 $00
    beat a R2+R3
; Measure 40
    vol HI_VOL
    env $1 $00
    ;beat b HF+Q
    beat b HF+R1
    vol LO_VOL
    env $0 $00
    beat b R2+R3

    goto musFallingRainChannel1Measure9Loop
    cmdff

.macro m_musFallingRainChannel0Trill4
.rept 4
    beat \1 T1 \2 T2 \1 T3 \2 T4
    beat \1 T5 \2 T6 \1 T7 \2 T8
.endr
.endm
.macro m_musFallingRainChannel0Trill3
.rept 3
    beat \1 T1 \2 T2 \1 T3 \2 T4
    beat \1 T5 \2 T6 \1 T7 \2 T8
.endr
.endm

musFallingRainChannel0:
    .redefine HI_VOL $5
    .redefine LO_VOL $3

; Measure 1
    vol $0
    beat gs3 Q
    duty $03
    m_musFallingRainChannel1Measure1 c4
; Measure 2
    rest Q
    m_musFallingRainChannel1Measure1 cs4
; Measure 3
    rest Q
    m_musFallingRainChannel1Measure1 d4
; Measure 4
    rest Q
    m_musFallingRainChannel1Measure1 ds4
; Measure 5
    vol LO_VOL-1
    vibrato $00
    env $0 $00
    m_musFallingRainChannel0Trill4 g4 d4
; Measure 6
    m_musFallingRainChannel0Trill4 gs4 ds4
; Measure 7
    m_musFallingRainChannel0Trill4 a4 e4
; Measure 8
    m_musFallingRainChannel0Trill4 as4 f4

musFallingRainChannel0Measure9Loop:
.rept 2
; Measure 9,17
    m_musFallingRainChannel0Trill4 g4 e4
; Measure 10,18
    m_musFallingRainChannel0Trill4 f4 c4
; Measure 11,19
    m_musFallingRainChannel0Trill4 as4 g4
; Measure 12,20
    m_musFallingRainChannel0Trill4 gs4 ds4
; Measure 13,21
    m_musFallingRainChannel0Trill4 a4 e4
; Measure 14,22
    m_musFallingRainChannel0Trill4 fs4 e4
; Measure 15-16,23-24
.rept 2
    m_musFallingRainChannel0Trill4 fs4 d4
.endr
.endr
; Measure 25-26
.rept 2
    m_musFallingRainChannel0Trill3 f4 d4
.endr
; Measure 27-28
.rept 2
    m_musFallingRainChannel0Trill3 e4 c4
.endr
; Measure 29-30
.rept 2
    m_musFallingRainChannel0Trill3 d4 as3
.endr
; Measure 31-32
.rept 2
    m_musFallingRainChannel0Trill3 c4 a3
.endr  
; Measure 33-34
.rept 2
    m_musFallingRainChannel0Trill3 f4 d4 
.endr
; Measure 35-36
.rept 2
    m_musFallingRainChannel0Trill3 e4 c4
.endr
; Measure 37-38
.rept 2
    m_musFallingRainChannel0Trill3 ds4 c4 
.endr
; Measure 39
    m_musFallingRainChannel0Trill3 fs4 d4
; Measure 40
    m_musFallingRainChannel0Trill3 g4 e4

    goto musFallingRainChannel0Measure9Loop
    cmdff

.macro m_musFallingRainChannel4Arpeggio3
    duty HI_VOL
    beat \1 E1 \2 E2
    beat \3 Q+E1+Y4
    duty LO_VOL
    beat \3 Y5+Y6
.endm
.macro m_musFallingRainChannel4Arpeggio4
    duty HI_VOL
    beat \1 E1 \2 E2
    beat \3 Q+Q+E1+Y4
    duty LO_VOL
    beat \3 Y5+Y6
.endm

musFallingRainChannel4:
    .redefine HI_VOL $0e
    .redefine LO_VOL $0f

; Measure 1-8
.rept 8
    m_musFallingRainChannel4Arpeggio4 c2 g2 c3
.endr

musFallingRainChannel4Measure9Loop:
; Measure 9,17
.rept 2
    m_musFallingRainChannel4Arpeggio4 f2 c3 f3
; Measure 10,18
    m_musFallingRainChannel4Arpeggio4 as2 f3 as3
; Measure 11,19
    m_musFallingRainChannel4Arpeggio4 ds2 as2 ds3
; Measure 12,20
    m_musFallingRainChannel4Arpeggio4 gs2 ds3 gs3
; Measure 13,21
    m_musFallingRainChannel4Arpeggio4 a2 e3 a3
; Measure 14,22
    m_musFallingRainChannel4Arpeggio4 d2 a2 d3
; Measure 15-16,23-24
.rept 2
    m_musFallingRainChannel4Arpeggio4 g2 d3 g3
.endr
.endr
; Measure 25-26 
.rept 2
    m_musFallingRainChannel4Arpeggio3 as2 f3 as3
.endr
; Measure 27-28
.rept 2
    m_musFallingRainChannel4Arpeggio3 a2 e3 a3
.endr  
; Measure 29
    m_musFallingRainChannel4Arpeggio3 g2 d3 g3
; Measure 30
    m_musFallingRainChannel4Arpeggio3 c2 g2 c3
; Measure 31-32
.rept 2
    m_musFallingRainChannel4Arpeggio3 f2 c3 f3
.endr
; Measure 33-34
.rept 2
    m_musFallingRainChannel4Arpeggio3 as2 f3 as3
.endr
; Measure 35-36
.rept 2
    m_musFallingRainChannel4Arpeggio3 a2 e3 a3
.endr
; Measure 37-38
.rept 2
    m_musFallingRainChannel4Arpeggio3 gs2 ds3 gs3
.endr
; Measure 39
    m_musFallingRainChannel4Arpeggio3 g2 d3 g3
; Measure 40
    m_musFallingRainChannel4Arpeggio3 fs2 cs3 fs3

    goto musFallingRainChannel4Measure9Loop
    cmdff

.define musFallingRainChannel6 MUSIC_CHANNEL_FALLBACK EXPORT