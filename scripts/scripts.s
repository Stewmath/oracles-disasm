script45ef:
	scriptend
script45f0:
	initnpchitbox
script45f1:
	checkabutton
	showloadedtext
	jump2byte script45f1
script45f5:
	jumptable_memoryaddress $cc01
.dw script45fc
.dw script463c
script45fc:
	jumpifglobalflagset $14 script4602
	rungenericnpclowindex $01
script4602:
	initnpchitbox
script4603:
	enableinput
	checkabutton
	setlinkcantmoveto91
	showtextlowindex $02
	jumpifcba5eq $00 script461d
script460c:
	showtextlowindex $19
	jumpifcba5eq $00 script4616
	showtextlowindex $05
	jump2byte script4603
script4616:
	asm15 $4061
	showtextlowindex $1a
	jump2byte script4603
script461d:
	showpasswordscreen $ff
	asm15 $4000
	jumptable_interactionbyte $7f
.dw script460c
.dw script460c
.dw script460c
.dw script4634
.dw script4630
.dw script460c
script4630:
	showtextlowindex $0b
	jump2byte script460c
script4634:
	asm15 $4040
	delay $6
	showtextlowindex $04
	jump2byte script460c
script463c:
	initnpchitbox
	checkabutton
	setlinkcantmoveto91
	showtextlowindex $06
	jump2byte script464a
script4643:
	enableinput
	checkabutton
	disableinput
	jumpifglobalflagset $2c script467f
script464a:
	showtextlowindex $07
	jumpifcba5eq $00 script4654
	showtextlowindex $08
	jump2byte script4643
script4654:
	showpasswordscreen $ff
	asm15 $4000
	jumptable_interactionbyte $7f
.dw script4667
.dw script466b
.dw script4673
.dw script4667
.dw script4677
.dw script467b
script4667:
	showtextlowindex $05
	jump2byte script4643
script466b:
	asm15 $404d
	checkcfc0bit 1
	xorcfc0bit 1
	enableinput
	jump2byte script4643
script4673:
	showtextlowindex $0c
	jump2byte script4643
script4677:
	showtextlowindex $0b
	jump2byte script4643
script467b:
	showtextlowindex $1c
	jump2byte script4643
script467f:
	showtextlowindex $0a
	jump2byte script4643
script4683:
	stopifitemflagset
	checknoenemies
	spawnitem $3001
	scriptend
script4689:
	stopifitemflagset
	setcollisionradii $04 $06
	checknoenemies
	playsound $4d
	createpuff
	delay $6
	settilehere $f1
	setstate $ff
	scriptend
script4697:
	stopifroomflag80set
	checknoenemies
	orroomflags $80
	scriptend
script469c:
	initnpchitbox
script469d:
	enableinput
	checkabutton
	setlinkcantmoveto91
	showtext $551b
	jumpifcba5eq $00 script46aa
	delay $2
	jump2byte script469d
script46aa:
	asm15withparam $1ab0 $0a
	delay $2
	jump2byte script469d
script46b1:
	checknotcollidedwithlink_ignorez
	asm15 $4069
	retscript
script46b6:
	setstate $ff
	scriptend
script46b9:
	setcollisionradii $0a $08
	setmovingdirection $10
	jump2byte script46d3
script46c0:
	setcollisionradii $08 $0a
	setmovingdirection $12
	jump2byte script46d3
script46c7:
	setcollisionradii $0a $08
	setmovingdirection $14
	jump2byte script46d3
script46ce:
	setcollisionradii $08 $0a
	setmovingdirection $16
script46d3:
	callscript script46b1
script46d6:
	asm15 $40a0
	jumptable_memoryaddress $cfc1
.dw script46d6
.dw script46e2
.dw script46e8
script46e2:
	playsound $4d
	setstate $02
	jump2byte script46d6
script46e8:
	setstate $03
	jump2byte script46d6
script46ec:
	callscript script46b1
	jumpifnoenemies script46fa
	setstate $03
	checknoenemies
	playsound $4d
	delay $2
	setstate $ff
script46fa:
	scriptend
script46fb:
	setstate $02
	scriptend
script46fe:
	setcollisionradii $0a $08
	setmovingdirection $10
	jumpifnoenemies script46fb
	jump2byte script46ec
script4708:
	setcollisionradii $08 $0a
	setmovingdirection $12
	jumpifnoenemies script46fb
	jump2byte script46ec
script4712:
	setcollisionradii $0a $08
	setmovingdirection $14
	jumpifnoenemies script46fb
	jump2byte script46ec
script471c:
	setcollisionradii $08 $0a
	setmovingdirection $16
	jumpifnoenemies script46fb
	jump2byte script46ec
script4726:
	asm15 $40e1
	jumptable_memoryaddress $cfc1
.dw script4726
.dw script4730
script4730:
	setstate $ff
script4732:
	callscript script46b1
	setstate $03
	scriptend
script4738:
	asm15 $40f4
	jumptable_memoryaddress $cfc1
.dw script4726
.dw script4732
script4742:
	setcollisionradii $10 $08
	setmovingdirection $18
	jump2byte script4738
script4749:
	setcollisionradii $08 $0e
	setmovingdirection $1a
	jump2byte script4738
script4750:
	setcollisionradii $0f $08
	setmovingdirection $1c
	jump2byte script4738
script4757:
	setcollisionradii $08 $0f
	setmovingdirection $1e
	jump2byte script4738
script475e:
	callscript script46b1
	setstate $03
	xorcfc0bit 0
	scriptend
script4765:
	setcollisionradii $0c $08
	setmovingdirection $10
	jump2byte script475e
script476c:
	setcollisionradii $08 $0c
	setmovingdirection $12
	jump2byte script475e
script4773:
	setcollisionradii $0c $08
	setmovingdirection $14
	jump2byte script475e
script477a:
	setcollisionradii $08 $0c
	setmovingdirection $16
	jump2byte script475e
script4781:
	callscript script46b1
	setstate $03
script4786:
	asm15 $410b
	jumptable_memoryaddress $cec0
.dw script4786
.dw script4790
script4790:
	delay $6
	playsound $4d
	setstate $ff
	scriptend
script4796:
	setcollisionradii $0a $08
	setmovingdirection $10
	setspeed $02
	jump2byte script4781
script479f:
	setcollisionradii $08 $0a
	setmovingdirection $16
	setspeed $02
	jump2byte script4781
script47a8:
	setcollisionradii $0a $08
	setmovingdirection $14
	setspeed $01
	jump2byte script4781
script47b1:
	setcollisionradii $08 $0a
	setmovingdirection $16
	setspeed $01
	jump2byte script4781
script47ba:
	showtext $0000
	showtext $2000
	showtext $2600
	jumptable_interactionbyte $77
.dw script47f1
.dw script4805
.dw script4817
.dw script480b
.dw script4811
.dw script4821
.dw script482b
.dw script47f1
.dw script47f1
.dw script47f1
.dw script47f1
.dw script47f1
.dw script47f1
.dw script4835
.dw script483b
.dw script4845
.dw script484f
.dw script4859
.dw script485f
.dw script4865
.dw script47f1
.dw script486f
script47f1:
	jumpifsomething $2c script47fb
	showtextlowindex $0b
	writeinteractionbyte $7a $ff
	scriptend
script47fb:
	showtextnonexitablelowindex $09
	callscript script4879
	ormemory $c642 $01
	scriptend
script4805:
	showtextnonexitablelowindex $02
	callscript script4879
	scriptend
script480b:
	showtextnonexitablelowindex $03
	callscript script4879
	scriptend
script4811:
	showtextnonexitablelowindex $04
	callscript script4879
	scriptend
script4817:
	showtextnonexitablelowindex $1d
	callscript script4879
	ormemory $c642 $02
	scriptend
script4821:
	showtextnonexitablelowindex $25
	callscript script4879
	ormemory $c642 $08
	scriptend
script482b:
	showtextnonexitablelowindex $1d
	callscript script4879
	ormemory $c642 $04
	scriptend
script4835:
	showtextnonexitablelowindex $1b
	callscript script4879
	scriptend
script483b:
	showtextnonexitablelowindex $1d
	callscript script4879
	ormemory $c643 $01
	scriptend
script4845:
	showtextnonexitablelowindex $23
	callscript script4879
	ormemory $c643 $02
	scriptend
script484f:
	showtextnonexitablelowindex $25
	callscript script4879
	ormemory $c643 $04
	scriptend
script4859:
	showtextnonexitablelowindex $29
	callscript script4879
	scriptend
script485f:
	showtextnonexitablelowindex $2a
	callscript script4879
	scriptend
script4865:
	showtextnonexitablelowindex $1d
	callscript script4879
	ormemory $c642 $20
	scriptend
script486f:
	showtextnonexitablelowindex $01
	callscript script4879
	ormemory $c643 $40
	scriptend
script4879:
	jumpifcba5eq $00 script4889
	writememory $cbad $03
	writememory $cba0 $01
	writeinteractionbyte $7a $ff
	scriptend
script4889:
	jumpifmemoryeq $ccd5 $00 script489d
	showtextlowindex $06
script4891:
	writeinteractionbyte $7a $ff
	setlinkcantmoveto00
	scriptend
script4896:
	callscript script49a5
script4899:
	showtextlowindex $06
	jump2byte script4891
script489d:
	jumptable_interactionbyte $78
.dw script48a3
.dw script48ac
script48a3:
	writememory $cba0 $01
	writeinteractionbyte $7a $01
	disablemenu
	retscript
script48ac:
	writememory $cbad $02
	writememory $cba0 $01
	writeinteractionbyte $7a $ff
	scriptend
script48b8:
	setspeed $50
	playsound $50
	movenpcdown $10
	movenpcright $18
	showtextlowindex $07
	movenpcleft $18
	movenpcup $10
	setmovingdirectionandmore $08
	setlinkcantmoveto00
	scriptend
script48ca:
	setspeed $50
	movenpcup $10
	showtextlowindex $07
	setlinkcantmoveto11
	movenpcdown $10
	setmovingdirectionandmore $08
	setlinkcantmoveto00
	scriptend
script48d7:
	setspeed $50
	playsound $50
	movenpcdown $08
	movenpcleft $18
	showtextlowindex $07
	movenpcright $18
	movenpcup $08
	setmovingdirectionandmore $18
	setlinkcantmoveto00
	scriptend
script48e9:
	jumpifc6xxset $42 $80 script48f6
	showtextlowindex $0d
	ormemory $c642 $80
	jump2byte script48f8
script48f6:
	showtextlowindex $0e
script48f8:
	setlinkcantmoveto11
	jumpifcba5eq $00 script4901
	showtextlowindex $11
	setlinkcantmoveto00
	scriptend
script4901:
	jumpifmemoryeq $ccd5 $01 script4899
	asm15 $411c
	setspeed $50
	setcollisionradii $06 $06
	movenpcup $08
	movenpcright $19
	movenpcup $1a
	movenpcright $11
	movenpcdown $08
	jump2byte script491e
script491b:
	asm15 $411c
script491e:
	setmovingdirectionandmore $08
	writeinteractionbyte $45 $02
	writeinteractionbyte $44 $05
	delay $8
	setmovingdirectionandmore $18
	delay $8
	setmovingdirectionandmore $10
	writeinteractionbyte $7c $00
	showtextlowindex $10
	setlinkcantmoveto00
	ormemory $ccd3 $80
	writeinteractionbyte $45 $00
	writeinteractionbyte $44 $05
	setlinkcantmoveto11
	showtextlowindex $17
	jumpifcba5eq $01 script494b
	jumpifmemoryeq $ccd5 $01 script4896
	jump2byte script491b
script494b:
	callscript script49a5
	setlinkcantmoveto00
	scriptend
script4950:
	setlinkcantmoveto11
	jumptable_interactionbyte $7c
.dw script495f
.dw script495f
.dw script495f
.dw script4973
.dw script4983
.dw script4993
script495f:
	showtextlowindex $13
	setmovingdirectionandmore $08
	writeinteractionbyte $45 $02
	writeinteractionbyte $44 $05
	delay $8
	setmovingdirectionandmore $18
	delay $8
	setmovingdirectionandmore $10
	showtextlowindex $18
	setlinkcantmoveto00
	scriptend
script4973:
	showtextlowindex $12
	jumpifcba5eq $00 script495f
	showtextlowindex $14
	writeinteractionbyte $7f $03
	callscript script49a5
	setlinkcantmoveto00
	scriptend
script4983:
	showtextlowindex $15
	jumpifcba5eq $00 script495f
	showtextlowindex $14
	writeinteractionbyte $7f $02
	callscript script49a5
	setlinkcantmoveto00
	scriptend
script4993:
	showtextlowindex $16
	writeinteractionbyte $7f $01
	callscript script49a5
	setlinkcantmoveto00
	scriptend
script499d:
	showtextlowindex $1a
	writeinteractionbyte $45 $01
	writeinteractionbyte $44 $05
script49a5:
	movenpcup $08
	movenpcleft $11
	movenpcdown $1a
	movenpcleft $19
	movenpcdown $08
	setmovingdirectionandmore $08
	setcollisionradii $06 $14
	retscript
script49b5:
	showtextlowindex $28
	scriptend
script49b8:
	setcollisionradii $09 $09
	delay $6
	checkcollidedwithlink_onground
	ormemory $cc95 $80
	asm15 $2c43
	loadsprite $ff
	setstate $ff
	playsound $06
	asm15 $4248
	delay $b
	delay $b
	playsound $b4
	delay $5
	playsound $b4
	delay $5
	playsound $b4
	delay $7
	playsound $b4
	asm15 $4250
	scriptend
script49de:
	setcollisionradii $12 $06
	checksomething
script49e2:
	enableinput
	checkabutton
	disableinput
	jumpifglobalflagset $08 script4a40
	jumpifmemoryeq $cc01 $00 script4a08
	jumpifmemoryset $c615 $01 script49f7
	jump2byte script4a08
script49f7:
	showtextlowindex $3e
	jumpifinteractionbyteeq $76 $01 script4a04
	showtextlowindex $3b
	asm15 $4256
	delay $0
script4a04:
	setlinkcantmoveto11
	checktext
	jump2byte script4a37
script4a08:
	showtextnonexitablelowindex $00
script4a0a:
	jumpifcba5eq $00 script4a12
	showtextnonexitablelowindex $3a
	jump2byte script4a0a
script4a12:
	jumpifinteractionbyteeq $76 $01 script4a1f
	showtextlowindex $3b
	asm15 $4256
	delay $0
	setlinkcantmoveto11
	checktext
script4a1f:
	showtextlowindex $3f
	asm15 $42ed
	delay $0
	setlinkcantmoveto11
	checktext
	showtextlowindex $33
	asm15withparam $426e $00
	delay $3
	showtextlowindex $13
	asm15withparam $426e $01
	delay $3
	showtextlowindex $08
script4a37:
	setglobalflag $08
	ormemory $c615 $01
	enableinput
	jump2byte script49e2
script4a40:
	asm15 $42b2
	jumptable_interactionbyte $7b
.dw script4a4d
.dw script4a51
.dw script4a55
.dw script4a5d
script4a4d:
	showtextlowindex $36
	jump2byte script4a57
script4a51:
	showtextlowindex $37
	jump2byte script4a57
script4a55:
	showtextlowindex $39
script4a57:
	checktext
	asm15 $42f5
	jump2byte script49e2
script4a5d:
	showtextnonexitablelowindex $03
	jumpifcba5eq $00 script4a6c
	jumpifcba5eq $01 script4a77
	enableinput
	showtextlowindex $08
	jump2byte script49e2
script4a6c:
	jumpifinteractionbyteeq $77 $00 script4a94
	asm15withparam $426e $00
	jump2byte script4a80
script4a77:
	jumpifinteractionbyteeq $78 $00 script4a98
	asm15withparam $426e $01
script4a80:
	delay $3
	jumpifglobalflagset $09 script4a8a
	showtextlowindex $08
	enableinput
	jump2byte script49e2
script4a8a:
	showtextlowindex $38
	checktext
	setglobalflag $89
	asm15 $42f1
	jump2byte script49e2
script4a94:
	showtextlowindex $14
	jump2byte script49e2
script4a98:
	showtextlowindex $15
	jump2byte script49e2
script4a9c:
	showtextnonexitablelowindex $09
	jumpifcba5eq $00 script4aa8
	writememory $cba0 $01
	enableinput
	scriptend
script4aa8:
	delay $6
	showtextnonexitablelowindex $0a
	jumpifcba5eq $01 script4ab3
	showtextnonexitablelowindex $0b
	jump2byte script4ab5
script4ab3:
	showtextnonexitablelowindex $0c
script4ab5:
	jumpifcba5eq $00 script4aa8
	writememory $cba0 $01
	scriptend
script4abe:
	showtextnonexitablelowindex $1f
	jumpifcba5eq $01 script4ad2
	jump2byte script4acc
script4ac6:
	showtextnonexitablelowindex $24
	jumpifcba5eq $02 script4ad2
script4acc:
	setlinkcantmoveto11
	asm15 $428b
	delay $0
	scriptend
script4ad2:
	showtextlowindex $2e
	scriptend
script4ad5:
	showtextlowindex $0f
	scriptend
script4ad8:
	showtextlowindex $31
	scriptend
script4adb:
	showtextlowindex $2a
	scriptend
script4ade:
	showtextnonexitablelowindex $18
	jumpifcba5eq $02 script4b00
	jumpifcba5eq $00 script4af3
	asm15 $4280
script4aeb:
	showtextnonexitablelowindex $1d
	jumpifcba5eq $00 script4aeb
	jump2byte script4b00
script4af3:
	asm15 $427b
	delay $0
	jumpifmemoryeq $cc89 $00 script4b03
	showtextlowindex $1e
	scriptend
script4b00:
	showtextlowindex $10
	scriptend
script4b03:
	showtextlowindex $27
	scriptend
script4b06:
	setlinkcantmoveto11
	showtextlowindex $23
	asm15 $42f5
	delay $0
	checktext
	setlinkcantmoveto00
	scriptend
script4b10:
	showtextlowindex $27
	scriptend
script4b13:
	delay $6
	showtext $550d
	jumpifcba5eq $00 script4b24
	asm15 $42fe
	asm15 $9d8
	delay $6
	jump2byte script4b2c
script4b24:
	delay $6
	showtext $550e
	jumpifcba5eq $00 script4b13
script4b2c:
	writememory $cfde $01
	scriptend
script4b31:
	writememory $cba0 $01
script4b35:
	checkabutton
	showtextnonexitablelowindex $19
	jumpifcba5eq $01 script4b31
	showtextlowindex $1a
	jump2byte script4b35
script4b40:
	writememory $cba0 $01
	checkabutton
	showtextnonexitablelowindex $20
	jumpifcba5eq $01 script4b40
script4b4b:
	showtextnonexitablelowindex $25
	jumpifcba5eq $01 script4b5d
	jumpifcba5eq $02 script4b40
	showtextnonexitablelowindex $3d
	jumpifcba5eq $01 script4b40
	jump2byte script4b4b
script4b5d:
	showtextnonexitablelowindex $26
	jumpifcba5eq $01 script4b40
	jump2byte script4b4b
script4b65:
	stopifitemflagset
	checkflagset $00 $cca0
	jump2byte script4b71
script4b6c:
	stopifitemflagset
	checkmemoryeq $cca0 $01
script4b71:
	playsound $4d
	createpuff
	delay $4
	settilehere $f1
	scriptend
script4b78:
	stopifroomflag80set
	delay $6
	checknoenemies
	playsound $4d
	orroomflags $80
	createpuff
	delay $4
	settilehere $45
	scriptend
script4b84:
	stopifitemflagset
	spawnitem $280c
	scriptend
script4b89:
	stopifitemflagset
	checkmemoryeq $cc8f $01
	spawnitem $3001
	scriptend
script4b92:
	stopifitemflagset
	checkmemoryeq $cc8f $02
	orroomflags $80
	playsound $4d
	createpuff
	delay $4
	settilehere $46
	scriptend
script4ba0:
	checkflagset $01 $cca0
	setcoords $48 $78
	asm15 $24c1
	setcoords $58 $78
	asm15 $24c1
	delay $6
	spawninteraction $7909 $50 $78
	playsound $4d
	scriptend
script4bb9:
	stopifitemflagset
	spawnitem $1600
	scriptend
script4bbe:
	stopifroomflag80set
	checknoenemies
	orroomflags $80
	delay $5
	spawninteraction $7e00 $00 $00
script4bc8:
	writememory $cbca $00
	scriptend
script4bcd:
	jumpifroomflagset $80 script4bd4
	checknoenemies
	orroomflags $80
script4bd4:
	stopifitemflagset
	setcoords $58 $78
script4bd8:
	spawnitem $2a00
	jump2byte script4bc8
script4bdd:
	jumpifroomflagset $80 script4bf0
	checknoenemies
	orroomflags $80
	setcoords $a8 $48
	createpuff
	settilehere $19
	setcoords $a8 $a8
	createpuff
	settilehere $19
script4bf0:
	stopifitemflagset
	setcoords $98 $78
	jump2byte script4bd8
script4bf6:
	stopifroomflag80set
	asm15 $4f4b
	checkmemoryeq $cc8f $02
	orroomflags $80
	playsound $4d
	asm15 $24c1
	settilehere $45
	scriptend
script4c08:
	stopifitemflagset
	spawnitem $1700
	scriptend
script4c0d:
	stopifitemflagset
	spawnitem $280c
	scriptend
script4c12:
	stopifitemflagset
	checkmemoryeq $cc8f $02
	jump2byte script4b71
script4c19:
	stopifitemflagset
	checkflagset $00 $cdd2
	jump2byte script4b71
script4c20:
	stopifitemflagset
	checkflagset $01 $cdd2
	jump2byte script4b71
script4c27:
	stopifitemflagset
	checkmemoryeq $cca0 $07
	jump2byte script4b71
script4c2e:
	stopifroomflag40set
	checkflagset $00 $cdd2
	asm15 $4f77
	scriptend
script4c37:
	delay $0
	asm15 $4f3b
	jump2byte script4c37
script4c3d:
	stopifroomflag40set
	checkmemoryeq $cca0 $01
	settilehere $50
script4c44:
	orroomflags $40
	asm15 $24c1
	playsound $4d
	scriptend
script4c4c:
	stopifroomflag40set
	checkmemoryeq $cca0 $01
	settilehere $52
	jump2byte script4c44
script4c55:
	stopifroomflag40set
	checkmemoryeq $cca0 $01
	disableinput
	delay $6
	asm15 $4f9b
	scriptend
script4c60:
	stopifroomflag80set
	delay $6
	checknoenemies
	playsound $4d
	asm15 $24c1
	settilehere $45
	orroomflags $80
	scriptend
script4c6d:
	checkmemoryeq $cc8f $01
	settilehere $6a
	playsound $4d
	createpuff
	scriptend
script4c77:
	stopifitemflagset
	checkmemoryeq $cca0 $0f
	jump2byte script4b71
script4c7e:
	stopifroomflag40set
	checkflagset $01 $cca0
	asm15 $4f89
	scriptend
script4c87:
	stopifitemflagset
	checknoenemies
	settilehere $52
	playsound $4d
	scriptend
script4c8e:
	disableinput
	delay $6
	playsound $f1
	shakescreen $b4
	playsound $b8
	delay $b
	showtext $1200
	orroomflags $40
	setstate $ff
	delay $6
	shakescreen $64
	playsound $79
	delay $9
	playsound $4d
	delay $6
	showtext $1201
	setglobalflag $0f
	enableinput
	asm15 $4fa3
	scriptend
script4cb1:
	setcollisionradii $06 $06
	checksomething
script4cb5:
	checkabutton
	jumpifmemoryeq $c60f $00 script4cc1
	showtext $4301
	jump2byte script4cb5
script4cc1:
	showtext $4300
	jump2byte script4cb5
script4cc6:
	initnpchitbox
script4cc7:
	checkabutton
	setlinkcantmoveto91
	loadsprite $02
	asm15 $4fb1
	delay $6
	callscript script4cde
	setlinkcantmoveto00
	jump2byte script4cc7
script4cd5:
	initnpchitbox
script4cd6:
	checkabutton
	setlinkcantmoveto91
	asm15 $4fb1
	setlinkcantmoveto00
	jump2byte script4cd6
script4cde:
	writeinteractionbyte $73 $43
	getrandombits $72 $07
	addinteractionbyte $72 $09
	showloadedtext
	loadsprite $03
	retscript
script4ceb:
	loadscript $15 $4fc7
script4cef:
	initnpchitbox
	jumptable_interactionbyte $78
.dw script4cfc
.dw script4d02
.dw script4d08
.dw script4d0e
.dw script4d14
script4cfc:
	checkabutton
	showtext $3710
	orroomflags $40
script4d02:
	checkabutton
	showtext $3711
	jump2byte script4d02
script4d08:
	checkabutton
	showtext $3712
	jump2byte script4d08
script4d0e:
	checkabutton
	showtext $3716
	jump2byte script4d0e
script4d14:
	checkabutton
	showtext $3713
	jump2byte script4d14
script4d1a:
	checksomething
script4d1b:
	checkabutton
	showloadedtext
	jump2byte script4d1b
script4d1f:
	initnpchitbox
	asm15withparam $4fec $00
	jumpifinteractionbyteeq $7b $01 script4d56
script4d29:
	checkabutton
	setlinkcantmoveto91
	showtextlowindex $00
script4d2d:
	asm15 $5022
	delay $6
	jumptable_memoryaddress $cc89
.dw script4d3d
.dw script4d38
script4d38:
	showtextlowindex $0a
	enableinput
	jump2byte script4d29
script4d3d:
	showtextlowindex $07
	disableinput
	jumptable_memoryaddress $cba5
.dw script4d47
.dw script4d2d
script4d47:
	asm15 $5008
	asm15withparam $4fe6 $00
	asm15withparam $4fe1 $01
	delay $6
	showtextlowindex $08
	enableinput
script4d56:
	checkabutton
	showtextlowindex $09
	jump2byte script4d56
script4d5b:
	initnpchitbox
	asm15withparam $4fec $01
	jumpifinteractionbyteeq $7b $01 script4e02
script4d65:
	checkabutton
	setlinkcantmoveto91
	showtextlowindex $0b
	jumptable_memoryaddress $cba5
.dw script4d70
.dw script4dfc
script4d70:
	delay $6
	showtextlowindex $0c
	jumptable_memoryaddress $cba5
.dw script4d7e
.dw script4d9d
.dw script4dbc
.dw script4ddb
script4d7e:
	asm15withparam $4ffb $0f
	jumpifinteractionbyteeq $7c $01 script4df6
	asm15withparam $1778 $0f
	asm15withparam $5002 $08
	asm15withparam $4fe6 $01
	asm15withparam $4fe1 $02
	setlinkcantmoveto00
script4d98:
	showtextlowindex $0d
	checkabutton
	jump2byte script4d98
script4d9d:
	asm15withparam $4ffb $0b
	jumpifinteractionbyteeq $7c $01 script4df6
	asm15withparam $1778 $0b
	asm15withparam $5002 $05
	asm15withparam $4fe6 $01
	asm15withparam $4fe1 $02
	setlinkcantmoveto00
script4db7:
	showtextlowindex $0e
	checkabutton
	jump2byte script4db7
script4dbc:
	asm15withparam $4ffb $04
	jumpifinteractionbyteeq $7c $01 script4df6
	asm15withparam $1778 $04
	asm15withparam $5002 $02
	asm15withparam $4fe6 $01
	asm15withparam $4fe1 $02
	setlinkcantmoveto00
script4dd6:
	showtextlowindex $0f
	checkabutton
	jump2byte script4dd6
script4ddb:
	asm15withparam $4ffb $01
	jumpifinteractionbyteeq $7c $01 script4df6
	asm15withparam $1778 $01
	asm15withparam $4fe6 $01
	asm15withparam $4fe1 $02
	setlinkcantmoveto00
script4df1:
	showtextlowindex $10
	checkabutton
	jump2byte script4df1
script4df6:
	delay $6
	showtextlowindex $32
	setlinkcantmoveto00
	jump2byte script4d65
script4dfc:
	delay $6
	showtextlowindex $11
	setlinkcantmoveto00
	jump2byte script4d65
script4e02:
	checkabutton
	showtextlowindex $31
	jump2byte script4e02
script4e07:
	initnpchitbox
script4e08:
	checkabutton
	setlinkcantmoveto91
	showtextlowindex $12
	asm15withparam $4fe1 $03
	setlinkcantmoveto00
	jump2byte script4e08
script4e13:
	initnpchitbox
	asm15withparam $4fec $02
	jumpifinteractionbyteeq $7b $01 script4e3e
	checkabutton
	setlinkcantmoveto91
	showtextlowindex $13
	asm15withparam $4fe6 $02
	asm15withparam $4fe1 $04
	jumptable_memoryaddress $cba5
.dw script4e30
.dw script4e36
script4e30:
	delay $6
	showtextlowindex $14
	setlinkcantmoveto00
	jump2byte script4e3e
script4e36:
	delay $6
	showtextlowindex $15
	asm15withparam $5002 $0a
	setlinkcantmoveto00
script4e3e:
	checkabutton
	showtextlowindex $16
	jump2byte script4e3e
script4e43:
	rungenericnpclowindex $17
script4e45:
	rungenericnpclowindex $18
script4e47:
	initnpchitbox
	asm15withparam $4fec $03
	jumptable_interactionbyte $43
.dw script4e54
.dw script4e6b
.dw script4e82
script4e54:
	jumpifinteractionbyteeq $7b $01 script4e66
script4e59:
	checkabutton
	setlinkcantmoveto91
	showtextlowindex $19
	callscript script4e99
	setlinkcantmoveto00
	jumpifinteractionbyteeq $7a $00 script4e59
script4e66:
	checkabutton
	showtextlowindex $22
	jump2byte script4e66
script4e6b:
	jumpifinteractionbyteeq $7b $01 script4e7d
script4e70:
	checkabutton
	setlinkcantmoveto91
	showtextlowindex $1a
	callscript script4e99
	setlinkcantmoveto00
	jumpifinteractionbyteeq $7a $00 script4e70
script4e7d:
	checkabutton
	showtextlowindex $23
	jump2byte script4e7d
script4e82:
	jumpifinteractionbyteeq $7b $01 script4e94
script4e87:
	checkabutton
	setlinkcantmoveto91
	showtextlowindex $1b
	callscript script4e99
	setlinkcantmoveto00
	jumpifinteractionbyteeq $7a $00 script4e87
script4e94:
	checkabutton
	showtextlowindex $24
	jump2byte script4e94
script4e99:
	jumptable_memoryaddress $cba5
.dw script4ea0
.dw script4eaf
script4ea0:
	delay $6
	showtextlowindex $1c
	asm15withparam $4fe6 $03
	writeinteractionbyte $7a $01
	asm15withparam $5002 $08
	retscript
script4eaf:
	delay $6
	showtextlowindex $1d
	jumptable_memoryaddress $cba5
.dw script4eb9
.dw script4ec8
script4eb9:
	delay $6
	showtextlowindex $1e
	asm15withparam $4fe6 $03
	writeinteractionbyte $7a $01
	asm15withparam $5002 $05
	retscript
script4ec8:
	delay $6
	showtextlowindex $1f
	jumptable_memoryaddress $cba5
.dw script4ed2
.dw script4ee1
script4ed2:
	delay $6
	showtextlowindex $20
	asm15withparam $4fe6 $03
	writeinteractionbyte $7a $01
	asm15withparam $5002 $01
	retscript
script4ee1:
	delay $6
	showtextlowindex $21
	delay $6
	retscript
script4ee6:
	jumptable_interactionbyte $43
.dw script4ef0
.dw script4ef2
.dw script4ef4
.dw script4ef6
script4ef0:
	rungenericnpclowindex $25
script4ef2:
	rungenericnpclowindex $26
script4ef4:
	rungenericnpclowindex $27
script4ef6:
	rungenericnpclowindex $28
script4ef8:
	jumptable_interactionbyte $43
.dw script4f02
.dw script4f04
.dw script4f06
.dw script4f08
script4f02:
	rungenericnpclowindex $29
script4f04:
	rungenericnpclowindex $2a
script4f06:
	rungenericnpclowindex $2b
script4f08:
	rungenericnpclowindex $2c
script4f0a:
	jumptable_interactionbyte $43
.dw script4f14
.dw script4f16
.dw script4f18
.dw script4f1a
script4f14:
	rungenericnpclowindex $2d
script4f16:
	rungenericnpclowindex $2e
script4f18:
	rungenericnpclowindex $2f
script4f1a:
	rungenericnpclowindex $30
script4f1c:
	loadscript $15 $5027
script4f20:
	initnpchitbox
	jumpifroomflagset $40 script4f31
	checkabutton
	disableinput
	showtextlowindex $18
	asm15 $5050
	delay $2
	checkrupeedisplayupdated
	orroomflags $40
	enableinput
script4f31:
	checkabutton
	showtextlowindex $19
	jump2byte script4f31
script4f36:
	initnpchitbox
	jumpifroomflagset $40 script4f4c
	checkabutton
	disableinput
	showtextlowindex $15
	asm15 $5039
	jumpifinteractionbyteeq $7f $00 script4f51
	delay $2
	checkrupeedisplayupdated
	orroomflags $40
	enableinput
script4f4c:
	checkabutton
	showtextlowindex $16
	jump2byte script4f4c
script4f51:
	delay $6
	showtextlowindex $17
	enableinput
	jump2byte script4f4c
script4f57:
	setcollisionradii $06 $16
	checksomething
script4f5b:
	checkabutton
	disableinput
	showtext $0800
	delay $6
	jumpifcba5eq $00 script4f7a
script4f65:
	showtext $0802
	enableinput
	delay $6
	writeinteractionbyte $71 $00
	jump2byte script4f5b
script4f6f:
	disableinput
	showtext $081a
	delay $6
	jumpifcba5eq $00 script4f7a
	jump2byte script4f65
script4f7a:
	asm15withparam $5115 $04
	jumpifmemoryset $cddb $80 script4f8b
script4f84:
	showtext $0803
	enableinput
	checkabutton
	jump2byte script4f84
script4f8b:
	asm15withparam $1778 $04
	showtext $0801
	delay $6
	jumpifcba5eq $00 script4fa1
script4f97:
	showtext $0804
	delay $6
	jumpifcba5eq $00 script4fa1
	jump2byte script4f97
script4fa1:
	showtext $0805
script4fa4:
	delay $7
	asm15 $326c
	checkpalettefadedone
	asm15 $509d
	asm15 $19ad
	asm15 $515c
	asm15withparam $50fe $02
	delay $5
	asm15 $3299
	checkpalettefadedone
script4fbb:
	setmusic $02
	delay $7
	delay $6
	asm15 $505f
	setlinkcantmoveto00
	scriptend
script4fc4:
	setcollisionradii $06 $16
	checksomething
script4fc8:
	checkabutton
	jumpifmemoryeq $cfdc $01 script4fc8
	disableinput
	jumpifroomflagset $20 script4fe6
	showtext $24d4
	delay $6
	jumpifcba5eq $00 script5003
	showtext $24d5
	enableinput
	delay $6
	writeinteractionbyte $71 $00
	jump2byte script4fc8
script4fe6:
	showtext $24cf
	delay $6
	jumpifcba5eq $00 script5003
script4fee:
	showtext $24d0
	enableinput
	delay $6
	writeinteractionbyte $71 $00
	jump2byte script4fc8
script4ff8:
	disableinput
	showtext $24df
	delay $6
	jumpifcba5eq $00 script5003
	jump2byte script4fee
script5003:
	asm15withparam $5115 $05
	jumpifmemoryset $cddb $80 script5014
script500d:
	showtext $24d2
	enableinput
	checkabutton
	jump2byte script500d
script5014:
	disableinput
	asm15withparam $1778 $05
	showtext $24d1
	delay $6
	jumpifcba5eq $00 script502b
script5021:
	showtext $24d3
	delay $6
	jumpifcba5eq $00 script502b
	jump2byte script5021
script502b:
	showtext $24d6
	jump2byte script4fa4
script5030:
	initnpchitbox
	jumpifglobalflagset $76 script5072
	jumpifglobalflagset $6c script5065
script5039:
	checkabutton
	jumpifmemoryeq $cfdc $01 script5039
	disableinput
	showtext $3130
	delay $6
	jumpifcba5eq $00 script504f
	showtext $3131
	enableinput
	jump2byte script5039
script504f:
	showpasswordscreen $08
	delay $6
	jumpifmemoryeq $cc89 $00 script505e
	showtext $3133
	enableinput
	jump2byte script5039
script505e:
	setglobalflag $6c
	showtext $3132
	jump2byte script5080
script5065:
	checkabutton
	jumpifmemoryeq $cfdc $01 script5065
	disableinput
	showtext $313c
	jump2byte script5080
script5072:
	checkabutton
	jumpifmemoryeq $cfdc $01 script5072
	showpasswordscreen $18
	showtext $313e
	jump2byte script5072
script5080:
	delay $6
	jumpifcba5eq $00 script508b
	showtext $3134
	enableinput
	jump2byte script5065
script508b:
	showtext $3135
	delay $6
	jumpifcba5eq $00 script509b
script5093:
	showtext $3136
	delay $6
	jumpifcba5eq $01 script5093
script509b:
	showtext $3137
	delay $7
	asm15 $326c
	checkpalettefadedone
	asm15 $50b5
	asm15 $19ad
	asm15 $515c
	asm15withparam $50fe $02
	delay $5
	asm15 $3299
	checkpalettefadedone
	jump2byte script4fbb
script50b7:
	showtext $0807
	jump2byte script50fb
script50bc:
	showtext $0808
	jump2byte script50fb
script50c1:
	showtext $0809
	jump2byte script50fb
script50c6:
	showtext $080a
	jump2byte script50fb
script50cb:
	showtext $080b
	jump2byte script50fb
script50d0:
	showtext $080c
	jump2byte script50fb
script50d5:
	showtext $080e
	jump2byte script50fb
script50da:
	showtext $080d
	jump2byte script50fb
script50df:
	showtext $080f
	jump2byte script50fb
script50e4:
	showtext $0810
	jump2byte script50fb
script50e9:
	showtext $0811
	jump2byte script50fb
script50ee:
	showtext $0812
	jump2byte script50fb
script50f3:
	showtext $0806
	jump2byte script50fb
script50f8:
	showtext $081c
script50fb:
	delay $4
	jumpifinteractionbyteeq $7f $0a script5106
	showtext $0813
	setlinkcantmoveto00
	scriptend
script5106:
	jumpifinteractionbyteeq $42 $01 script5110
	showtext $0814
	setlinkcantmoveto00
	scriptend
script5110:
	showtext $24d7
	setlinkcantmoveto00
	scriptend
script5115:
	loadscript $15 $51b1
script5119:
	loadscript $15 $524f
script511d:
	disableinput
	delay $7
	asm15 $326c
	checkpalettefadedone
	asm15 $50d3
	asm15withparam $50fe $00
	asm15 $50f6
	asm15 $19ad
	asm15 $516a
	delay $5
	asm15 $3299
	checkpalettefadedone
	setmusic $ff
	delay $7
	asm15withparam $506e $08
	jumpifmemoryset $cddb $80 script5178
	showtext $3138
	delay $6
	jumpifcba5eq $00 script518a
	showtext $3139
	enableinput
script5151:
	checkabutton
	jumpifmemoryeq $cfdc $01 script5065
	disableinput
	showtext $313c
	delay $6
	jumpifcba5eq $00 script5167
	showtext $3134
	enableinput
	jump2byte script5151
script5167:
	showtext $3135
	delay $6
	jumpifcba5eq $00 script5177
script516f:
	showtext $3136
	delay $6
	jumpifcba5eq $01 script516f
script5177:
	scriptend
script5178:
	showtext $313a
	delay $6
	giveitem $0c00
	delay $6
	setglobalflag $76
	showpasswordscreen $18
	showtext $313b
	enableinput
	jump2byte script5072
script518a:
	scriptend
script518b:
	asm15 $50f1
	delay $6
	asm15 $50e4
	delay $3
	playsound $b4
	asm15 $326c
	delay $5
	playsound $b4
	asm15 $326c
	delay $5
	playsound $b4
	asm15 $326c
	checkpalettefadedone
	delay $5
	asm15withparam $3284 $04
	checkpalettefadedone
	retscript
script51ac:
	asm15 $5191
script51af:
	asm15 $519e
	jumpifmemoryset $cddb $80 script51ba
	jump2byte script51af
script51ba:
	retscript
script51bb:
	checkmemoryeq $cfd0 $01
	setcounter1 $d2
	showtextdifferentforlinked $01 $02 $03
	delay $6
	setspeed $14
	movenpcdown $20
	orroomflags $40
	scriptend
script51cd:
	checkmemoryeq $cfd0 $03
	loadsprite $02
	delay $3
	showtext $0106
	delay $6
	loadsprite $01
	setmovingdirection $18
	setspeed $14
	checkcounter2iszero $21
	delay $6
	showtext $0107
	delay $6
	checkcounter2iszero $21
	delay $6
	showtext $0108
	delay $6
	writememory $cfd0 $04
	scriptend
script51f1:
	rungenericnpc $010b
script51f4:
	loadscript $15 $5312
script51f8:
	loadsprite $02
	checkmemoryeq $cfd0 $0d
	delay $6
	playsound $fa
	delay $6
	setspeed $28
	movenpcright $20
	delay $2
	movenpcup $10
	delay $6
	playsound $2f
	loadsprite $04
	delay $c
	showtext $5600
	writememory $cfd0 $0e
	delay $8
	loadsprite $00
	delay $8
	showtext $5606
	delay $3
	loadsprite $07
	setmovingdirection $16
	setspeed $14
	checkcounter2iszero $48
	writememory $cfd0 $0f
	scriptend
script522b:
	delay $a
	loadsprite $02
	asm15 $5300
	delay $8
	loadsprite $03
	setcounter1 $32
	loadsprite $01
	delay $6
	loadsprite $03
	delay $3
	loadsprite $01
	delay $8
	showtext $0110
	delay $6
	loadsprite $03
	delay $6
	showtextdifferentforlinked $01 $12 $13
	delay $6
	loadsprite $01
	showtextdifferentforlinked $01 $15 $16
	delay $6
	jumpifmemoryeq $cc01 $01 script525d
	giveitem $0500
	jump2byte script5260
script525d:
	giveitem $0100
script5260:
	delay $6
	asm15withparam $5155 $03
	delay $6
	showtext $0117
	delay $6
	setspeed $28
	movenpcright $41
	delay $2
	movenpcdown $21
	delay $6
	setmusic $ff
	delay $6
	enableinput
	setglobalflag $0a
	scriptend
script5279:
	checkpalettefadedone
	delay $9
	setspeed $50
	movenpcup $20
	addinteractionbyte $78 $1e
	addinteractionbyte $45 $01
	checkmemoryeq $cfc0 $05
	loadsprite $08
	checkinteractionbyteeq $61 $01
	writememory $cfc0 $06
	scriptend
script5293:
	checkmemoryeq $cfc0 $05
	setspeed $28
	movenpcleft $10
	loadsprite $02
	setcounter1 $06
	movenpcdown $10
	loadsprite $03
	setcounter1 $06
	movenpcleft $12
	loadsprite $00
	delay $6
	showtext $3d08
	setcounter1 $80
	writememory $cfc0 $06
	scriptend
script52b4:
	loadscript $15 $5344
script52b8:
	loadscript $15 $536e
script52bc:
	checkpalettefadedone
	delay $8
	setspeed $14
	movenpcdown $61
	setspeed $1e
	checkmemoryeq $cfd1 $01
	delay $2
	movenpcdown $2b
	scriptend
script52cc:
	loadscript $15 $53ae
script52d0:
	checkcfc0bit 0
	delay $6
	asm15withparam $5854 $1e
	checkcfc0bit 3
	setspeed $50
	loadsprite $03
	setmovingdirection $13
	checkcounter2iszero $31
	xorcfc0bit 4
	scriptend
script52e1:
	checkmemoryeq $cfd0 $11
	playsound $f0
	showtext $0130
	writeinteractionbyte $78 $01
	delay $8
	setspeed $3c
	movenpcleft $30
	delay $1
	loadsprite $02
	delay $2
	callscript script51ac
	delay $3
	asm15withparam $5155 $00
	delay $3
	asm15 $530c
	writememory $cfd0 $12
	scriptend
script5307:
	scriptend
script5308:
	initnpchitbox
script5309:
	checkabutton
	jumpifglobalflagset $20 script5314
	showtextlowindex $06
	setglobalflag $20
	jump2byte script5309
script5314:
	jumpifsomething $51 script531c
	showtextlowindex $07
	jump2byte script5309
script531c:
	setlinkcantmoveto11
	disablemenu
	showtextlowindex $08
	asm15 $543a
	delay $8
	scriptend
script5325:
	scriptend
script5326:
	initnpchitbox
script5327:
	checkabutton
	showtext $4700
	jump2byte script5327
script532d:
	initnpchitbox
script532e:
	checkabutton
	showtext $4200
	jump2byte script532e
script5334:
	initnpchitbox
script5335:
	checkabutton
	showtext $4900
	jump2byte script5335
script533b:
	initnpchitbox
script533c:
	checkabutton
	showtext $4701
	asm15withparam $4fe1 $06
	jump2byte script533c
script5346:
	initnpchitbox
script5347:
	checkabutton
	showtext $4201
	asm15withparam $4fe1 $06
	jump2byte script5347
script5351:
	initnpchitbox
script5352:
	checkabutton
	showtext $4901
	asm15withparam $4fe1 $06
	jump2byte script5352
script535c:
	initnpchitbox
	asm15withparam $4fec $04
	jumpifinteractionbyteeq $7b $01 script538a
	checkabutton
	disableinput
	showtext $4702
	asm15withparam $4fe6 $04
	asm15withparam $4fe1 $07
	jumptable_memoryaddress $cba5
.dw script537a
.dw script5385
script537a:
	delay $6
	showtext $4703
	asm15withparam $5457 $04
	enableinput
	jump2byte script538a
script5385:
	delay $6
	showtext $4704
	enableinput
script538a:
	checkabutton
	showtext $4705
	jump2byte script538a
script5390:
	initnpchitbox
	asm15withparam $4fec $04
	jumpifinteractionbyteeq $7b $01 script53be
	checkabutton
	disableinput
	showtext $4202
	asm15withparam $4fe6 $04
	asm15withparam $4fe1 $07
	jumptable_memoryaddress $cba5
.dw script53ae
.dw script53b9
script53ae:
	delay $6
	showtext $4203
	asm15withparam $5457 $04
	enableinput
	jump2byte script53be
script53b9:
	delay $6
	showtext $4204
	enableinput
script53be:
	checkabutton
	showtext $4205
	jump2byte script53be
script53c4:
	initnpchitbox
	asm15withparam $4fec $04
	jumpifinteractionbyteeq $7b $01 script53f2
	checkabutton
	disableinput
	showtext $4902
	asm15withparam $4fe6 $04
	asm15withparam $4fe1 $07
	jumptable_memoryaddress $cba5
.dw script53e2
.dw script53ed
script53e2:
	delay $6
	showtext $4903
	asm15withparam $5457 $04
	enableinput
	jump2byte script53f2
script53ed:
	delay $6
	showtext $4904
	enableinput
script53f2:
	checkabutton
	showtext $4905
	jump2byte script53f2
script53f8:
	initnpchitbox
script53f9:
	checkabutton
	showtext $4b00
	asm15withparam $4fe1 $08
	jump2byte script53f9
script5403:
	initnpchitbox
script5404:
	checkabutton
	showtext $4a00
	asm15withparam $4fe1 $08
	jump2byte script5404
script540e:
	initnpchitbox
script540f:
	checkabutton
	showtext $4800
	asm15withparam $4fe1 $08
	jump2byte script540f
script5419:
	initnpchitbox
script541a:
	checkabutton
	showtext $4600
	asm15withparam $4fe1 $08
	jump2byte script541a
script5424:
	initnpchitbox
	asm15withparam $4fec $05
	jumpifinteractionbyteeq $7b $01 script54db
script542e:
	checkabutton
	disableinput
	showtext $4b01
	jumptable_memoryaddress $cba5
.dw script543a
.dw script54d4
script543a:
	delay $6
	showtext $4b02
	jumptable_memoryaddress $cba5
.dw script5449
.dw script546a
.dw script548b
.dw script54ac
script5449:
	asm15withparam $545d $0c
	jumpifinteractionbyteeq $7c $01 script54cd
	asm15withparam $1778 $0c
	asm15withparam $5468 $00
	asm15withparam $4fe6 $05
	asm15withparam $4fe1 $09
	delay $6
	enableinput
script5464:
	showtext $4b04
	checkabutton
	jump2byte script5464
script546a:
	asm15withparam $545d $0b
	jumpifinteractionbyteeq $7c $01 script54cd
	asm15withparam $1778 $0b
	asm15withparam $5468 $01
	asm15withparam $4fe6 $05
	asm15withparam $4fe1 $09
	delay $6
	enableinput
script5485:
	showtext $4b05
	checkabutton
	jump2byte script5485
script548b:
	asm15withparam $545d $04
	jumpifinteractionbyteeq $7c $01 script54cd
	asm15withparam $1778 $04
	asm15withparam $5468 $02
	asm15withparam $4fe6 $05
	asm15withparam $4fe1 $09
	delay $6
	enableinput
script54a6:
	showtext $4b06
	checkabutton
	jump2byte script54a6
script54ac:
	asm15withparam $545d $01
	jumpifinteractionbyteeq $7c $01 script54cd
	asm15withparam $1778 $01
	asm15withparam $5468 $03
	asm15withparam $4fe6 $05
	asm15withparam $4fe1 $09
	delay $6
	enableinput
script54c7:
	showtext $4b07
	checkabutton
	jump2byte script54c7
script54cd:
	delay $6
	showtext $4b08
	enableinput
	jump2byte script542e
script54d4:
	delay $6
	showtext $4b03
	enableinput
	jump2byte script542e
script54db:
	checkabutton
	showtext $4b09
	jump2byte script54db
script54e1:
	initnpchitbox
	asm15withparam $4fec $05
	jumpifinteractionbyteeq $7b $01 script553f
	checkabutton
	disableinput
	showtext $4a01
	jumptable_memoryaddress $cba5
.dw script5521
.dw script54f7
script54f7:
	delay $6
	showtext $4a02
	jumptable_memoryaddress $cba5
.dw script5527
.dw script5502
script5502:
	delay $6
	showtext $4a03
	jumptable_memoryaddress $cba5
.dw script552d
.dw script550d
script550d:
	asm15withparam $5468 $03
	asm15withparam $4fe6 $05
	asm15withparam $4fe1 $09
	delay $6
	showtext $4a04
	enableinput
	delay $6
	jump2byte script553f
script5521:
	asm15withparam $5468 $00
	jump2byte script5531
script5527:
	asm15withparam $5468 $01
	jump2byte script5531
script552d:
	asm15withparam $5468 $02
script5531:
	asm15withparam $4fe6 $05
	asm15withparam $4fe1 $09
	delay $6
	showtext $4a05
	delay $6
	enableinput
script553f:
	checkabutton
	showtext $4a08
	jump2byte script553f
script5545:
	initnpchitbox
	asm15withparam $4fec $05
	jumpifinteractionbyteeq $7b $01 script5565
	checkabutton
	disableinput
	showtext $4801
	giveitem $3403
	asm15withparam $4fe6 $05
	asm15withparam $4fe1 $09
	delay $6
	showtext $4802
	delay $6
	enableinput
script5565:
	checkabutton
	showtext $4803
	jump2byte script5565
script556b:
	initnpchitbox
	asm15withparam $4fec $05
	jumpifinteractionbyteeq $7b $01 script558a
	checkabutton
	disableinput
	showtext $4601
	asm15withparam $5464 $00
	asm15withparam $4fe6 $05
	asm15withparam $4fe1 $09
	delay $6
	enableinput
	jump2byte script558b
script558a:
	checkabutton
script558b:
	showtext $4602
	jump2byte script558a
script5590:
	initnpchitbox
	asm15withparam $4fec $06
	jumpifinteractionbyteeq $7b $01 script55cc
	checkabutton
	disableinput
	showtext $4b0a
	asm15withparam $4fe6 $06
	delay $6
	jumptable_memoryaddress $c6e3
.dw script55af
.dw script55b7
.dw script55c0
.dw script55c5
script55af:
	asm15 $180c
	showtext $0052
	jump2byte script55c8
script55b7:
	asm15withparam $5487 $0d
	showtext $0009
	jump2byte script55c8
script55c0:
	giveitem $3403
	jump2byte script55c8
script55c5:
	giveitem $0302
script55c8:
	delay $6
	enableinput
	jump2byte script55cd
script55cc:
	checkabutton
script55cd:
	showtext $4b0b
	jump2byte script55cc
script55d2:
	initnpchitbox
	asm15withparam $4fec $06
	jumpifinteractionbyteeq $7b $01 script561a
	checkabutton
	disableinput
	showtext $4a06
	delay $6
	showtext $4a07
	asm15withparam $4fe6 $06
	delay $6
	jumptable_memoryaddress $c6e3
.dw script55f5
.dw script55fe
.dw script5607
.dw script560f
script55f5:
	asm15withparam $5487 $0c
	showtext $0007
	jump2byte script5616
script55fe:
	asm15withparam $5480 $01
	showtext $0051
	jump2byte script5616
script5607:
	asm15 $547c
	showtext $0053
	jump2byte script5616
script560f:
	asm15withparam $5487 $01
	showtext $0001
script5616:
	delay $6
	enableinput
	jump2byte script561b
script561a:
	checkabutton
script561b:
	showtext $4a08
	jump2byte script561a
script5620:
	initnpchitbox
script5621:
	checkabutton
	disableinput
	showtext $4804
	delay $6
	callscript script562d
	enableinput
	jump2byte script5621
script562d:
	writeinteractionbyte $73 $48
	getrandombits $72 $07
	addinteractionbyte $72 $05
	showloadedtext
	retscript
script5638:
	initnpchitbox
script5639:
	checkabutton
	disableinput
	showtext $4603
	jumptable_memoryaddress $cba5
.dw script5645
.dw script5653
script5645:
	asm15 $546c
	asm15 $547c
	delay $6
	enableinput
script564d:
	showtext $4604
	checkabutton
	jump2byte script564d
script5653:
	delay $6
	showtext $4605
	enableinput
	jump2byte script5639
script565a:
	loadsprite $02
	checkmemoryeq $cfd0 $0a
	delay $3
	setspeed $0a
	movenpcdown $20
	delay $6
	showtext $1d00
	delay $6
	writememory $cfd0 $0b
	checkmemoryeq $cfd0 $0c
	asm15withparam $5632 $00
	delay $7
	showtext $1d22
	delay $6
	writememory $cfd0 $0d
	checkmemoryeq $cfd0 $0f
	loadsprite $02
	checkmemoryeq $cfd0 $13
	setspeed $0a
	setmovingdirection $00
	checkcounter2iszero $20
	checkmemoryeq $cfd0 $15
	delay $a
	writememory $cfd0 $16
	delay $6
	setmovingdirection $10
	setspeed $05
	checkcounter2iszero $81
	setcoords $28 $78
	setcounter1 $d2
	loadsprite $05
	writeinteractionbyte $5c $06
	playsound $ab
	delay $8
	loadsprite $02
	writememory $cfd0 $17
	orroomflags $40
	scriptend
script56b5:
	loadsprite $02
	checkmemoryeq $cfd0 $1c
	delay $7
	showtext $5605
	delay $8
	setspeed $28
	movenpcup $11
	writeinteractionbyte $7d $01
	playsound $95
	delay $a
	writememory $cfd0 $1d
	scriptend
script56cf:
	loadscript $15 $548d
script56d3:
	checkmemoryeq $cfd0 $01
	asm15 $1e45
	checkpalettefadedone
	delay $6
	loadsprite $02
	delay $9
	showtext $1d06
	delay $6
	writememory $cfd0 $02
	scriptend
script56e8:
	loadscript $15 $54ce
script56ec:
	delay $0
	asm15withparam $5615 $03
	jumpifmemoryeq $cfd0 $09 script56f9
	jump2byte script56ec
script56f9:
	delay $8
	loadsprite $02
	checkmemoryeq $cfd0 $0a
	delay $8
	asm15withparam $5155 $00
	delay $7
	showtext $1d08
	delay $5
	setspeed $1e
	movenpcright $14
	delay $2
	movenpcdown $4c
	asm15withparam $5155 $02
	writememory $cfd0 $0b
	scriptend
script571a:
	loadscript $15 $54fd
script571e:
	checkpalettefadedone
	delay $6
	setspeed $28
	movenpcup $19
	setspeed $14
	movenpcup $21
	setspeed $28
	movenpcup $1a
	delay $1
	movenpcleft $11
	delay $1
	loadsprite $00
	checkmemoryeq $cfd0 $06
	movenpcup $10
	delay $b
	writememory $cfd0 $07
	scriptend
script573e:
	checkmemoryeq $cfd0 $0f
	loadsprite $01
	delay $5
	showtext $1d0d
	delay $a
	writememory $cfd0 $10
	scriptend
script574e:
	checkmemoryeq $cfc0 $01
	asm15 $1e69
	checkpalettefadedone
	delay $8
	loadsprite $02
	checkmemoryeq $cfc0 $05
	loadsprite $03
	scriptend
script5760:
	loadscript $15 $553b
script5764:
	checkmemoryeq $cfc0 $03
	setmovingdirection $18
	setspeed $28
	checkcounter2iszero $20
	setcounter1 $06
	loadsprite $00
	delay $6
	showtext $3d0a
	delay $6
	loadsprite $01
	setcounter1 $06
	movenpcright $20
	delay $3
	loadsprite $03
	writememory $cfc0 $04
	setcounter1 $80
	scriptend
script5787:
	delay $3
	setspeed $28
	movenpcdown $39
	checkcfc0bit 1
	setspeed $14
	movenpcdown $11
	showtext $1d12
	setcounter1 $10
	xorcfc0bit 2
	checkcfc0bit 3
	delay $2
	showtext $1d13
	xorcfc0bit 4
	delay $6
	setspeed $28
	movenpcup $41
	scriptend
script57a3:
	checkmemoryeq $cfd0 $01
	loadsprite $00
	checkmemoryeq $cfd0 $02
	loadsprite $01
	checkmemoryeq $cfd0 $03
	loadsprite $02
	checkmemoryeq $cfd0 $05
	loadsprite $00
	checkmemoryeq $cfd0 $06
	setspeed $28
	movenpcup $11
	loadsprite $01
	writememory $d008 $03
	showtext $1d12
	delay $2
	writememory $cfd0 $07
	checkmemoryeq $cfd0 $08
	writememory $d008 $00
	movenpcup $11
	movenpcright $11
	movenpcup $41
	scriptend
script57e0:
	loadscript $15 $5575
script57e4:
	loadscript $15 $55e5
script57e8:
	loadscript $15 $55fa
script57ec:
	delay $6
	callscript script51ac
	delay $6
	showtext $2a00
	delay $6
	writememory $cfd0 $0a
	checkmemoryeq $cfd0 $0b
	asm15withparam $5632 $01
	callscript script51ac
	delay $3
	showtext $2a22
	delay $6
	writememory $cfd0 $0c
	checkmemoryeq $cfd0 $0f
	loadsprite $02
	writeinteractionbyte $48 $02
	checkmemoryeq $cfd0 $11
	setspeed $3c
	playsound $75
	movenpcdown $16
	playsound $75
script5822:
	delay $0
	asm15 $5613
	jumpifmemoryeq $cfd0 $15 script582e
	jump2byte script5822
script582e:
	loadsprite $00
	setcounter1 $dc
	setspeed $05
	setmovingdirection $10
	checkcounter2iszero $81
	checkmemoryeq $cfd0 $17
	delay $a
	setspeed $28
	movenpcleft $10
	setcounter1 $06
	asm15 $563a
	movenpcup $18
	delay $6
	loadsprite $04
	playsound $74
	delay $8
	showtext $2a01
	delay $6
	showtext $5603
	delay $8
	loadsprite $00
	writeinteractionbyte $7f $ff
	writememory $cc1e $31
	writememory $cc18 $01
	setspeed $05
	setmovingdirection $10
	checkcounter2iszero $81
	delay $6
	showtext $5604
	delay $8
	writememory $cfd0 $18
	checkmemoryeq $cfd2 $ff
	loadsprite $03
	checkmemoryeq $cfd0 $1b
	delay $5
	setspeed $28
	movenpcup $30
	setcounter1 $06
	movenpcleft $31
	writememory $cfd0 $1c
	checkmemoryeq $cfd0 $1d
	delay $a
	scriptend
script588f:
	loadscript $15 $56c9
script5893:
	setmusic $35
	setspeed $50
	loadsprite $03
	delay $7
	movenpcleft $1d
	writeinteractionbyte $7f $01
	delay $7
	callscript script51ac
	delay $7
	showtext $2a08
	delay $7
	writeinteractionbyte $7f $00
	setspeed $50
	movenpcleft $45
	writememory $cfc0 $01
	setmusic $ff
	scriptend
script58b6:
	loadscript $15 $5716
script58ba:
	checkmemoryeq $cfd0 $01
	asm15 $1e45
	writeinteractionbyte $60 $7f
	checkpalettefadedone
	delay $6
	loadsprite $01
	scriptend
script58c9:
	checkmemoryeq $cfd0 $04
	setspeed $28
	movenpcdown $13
	setcounter1 $06
	movenpcright $0a
	asm15withparam $5155 $03
	delay $6
	showtext $2a0e
	delay $6
	asm15withparam $5155 $00
	loadsprite $00
	writememory $cfd0 $05
	scriptend
script58e9:
	delay $0
	asm15withparam $5615 $03
	jumpifmemoryeq $cfd0 $09 script58f6
	jump2byte script58e9
script58f6:
	delay $8
	setmusic $ff
	delay $8
	loadsprite $01
	asm15withparam $5155 $03
	delay $5
	showtextdifferentforlinked $2a $0f $10
	delay $5
	setspeed $50
	movenpcdown $18
	asm15withparam $5155 $02
	writememory $cfd0 $0a
	scriptend
script5913:
	setcounter1 $07
	loadsprite $03
	setspeed $14
	setmovingdirection $08
	checkcounter2iszero $20
	checkinteractionbyteeq $7e $01
	delay $3
	movenpcleft $10
	asm15withparam $5155 $01
	delay $3
	showtext $2a11
	delay $5
	writememory $cfd0 $03
	checkmemoryeq $cfd0 $04
	setcounter1 $32
	setspeed $28
	movenpcleft $10
	setcounter1 $06
	movenpcdown $28
	delay $8
	writememory $cfd0 $05
	scriptend
script5944:
	checkpalettefadedone
	delay $6
	setspeed $28
	movenpcup $37
	setspeed $14
	movenpcup $21
	delay $5
	setspeed $50
	movenpcup $15
	delay $6
	showtext $2a12
	delay $6
	writememory $cfd0 $06
	checkinteractionbyteeq $7e $01
	delay $3
	showtext $2a13
	delay $8
	writememory $cfd0 $09
	scriptend
script5969:
	checkpalettefadedone
	delay $8
	loadsprite $01
	delay $3
	asm15withparam $5155 $03
	delay $3
	showtext $2a14
	delay $8
	jumpifmemoryeq $cc01 $01 script59a1
	delay $5
	loadsprite $00
	asm15withparam $5155 $00
	delay $5
	writememory $cfd0 $0c
	checkmemoryeq $cfd0 $0d
	showtext $2a15
	delay $3
	writememory $cfd0 $0e
	checkmemoryeq $cfd0 $0f
	delay $3
	loadsprite $03
	asm15withparam $5155 $03
	scriptend
script59a1:
	writememory $cfd0 $11
	scriptend
script59a6:
	checkmemoryeq $cfc0 $01
	asm15 $1e69
	checkmemoryeq $cfc0 $02
	delay $7
	loadsprite $00
	delay $5
	asm15withparam $5656 $28
	delay $8
	writememory $cfc0 $03
	setspeed $3c
	setmovingdirection $05
	checkcounter2iszero $1e
	delay $8
	loadsprite $02
	delay $6
	addinteractionbyte $45 $01
	checkinteractionbyteeq $7e $01
	delay $8
	writememory $cfc0 $05
	scriptend
script59d4:
	checkpalettefadedone
	setcounter1 $49
	loadsprite $07
	setcounter1 $2d
	loadsprite $03
	delay $9
	loadsprite $05
	delay $5
	loadsprite $06
	setcounter1 $aa
	loadsprite $0b
	delay $7
	scriptend
script59e9:
	delay $6
	asm15 $5647
	delay $6
	showtext $2a16
	delay $4
	showtext $2a17
	delay $6
	showtext $2a18
	movenpcup $28
	asm15withparam $31f9 $32
	setmusic $ff
	scriptend
script5a02:
	delay $2
	showtext $2a19
	setcounter1 $10
	writememory $d008 $02
	movenpcdown $18
	asm15withparam $31f9 $45
	scriptend
script5a13:
	asm15withparam $5656 $1e
	delay $6
	writememory $cfd0 $01
	setspeed $28
	movenpcup $29
	checkinteractionbyteeq $45 $03
	delay $2
	showtext $2a19
	delay $2
	movenpcdown $29
	writememory $cfd0 $02
	loadsprite $03
	setcounter1 $2d
	loadsprite $02
	delay $6
	writememory $cfd0 $03
	setspeed $3c
	movenpcdown $29
	delay $6
	writememory $cfd0 $04
	scriptend
script5a43:
	loadscript $15 $5731
script5a47:
	loadscript $15 $5758
script5a4b:
	loadscript $15 $577e
script5a4f:
	jumpifglobalflagset $40 script45ef
	disableinput
	delay $7
	showtext $2a1e
	delay $6
	loadsprite $01
	setspeed $28
	setmovingdirection $08
	checkcounter2iszero $11
	loadsprite $09
	writeinteractionbyte $7f $2d
	playsound $7b
script5a68:
	asm15 $56bd
	asm15 $56c2
	jumpifmemoryset $cddb $80 script5a76
	jump2byte script5a68
script5a76:
	setglobalflag $40
	asm15 $5671
	enableinput
	scriptend
script5a7d:
	checkpalettefadedone
	setcounter1 $46
	setspeed $28
	movenpcup $50
	checkmemoryeq $cbb5 $01
	movenpcup $10
	showtext $2a1f
	writememory $cbb5 $02
	checkmemoryeq $cbb5 $03
	movenpcdown $40
	writeinteractionbyte $4b $08
	writeinteractionbyte $4d $80
	checkmemoryeq $cbb5 $05
	checkpalettefadedone
	movenpcdown $70
	checkmemoryeq $cbb5 $07
	delay $5
	setspeed $50
	movenpcdown $18
	scriptend
script5aae:
	initnpchitbox
script5aaf:
	checkabutton
	disableinput
	delay $5
	writeinteractionbyte $79 $01
	asm15 $5ca8
	setcounter1 $06
	showtext $2a21
	setcounter1 $06
	writeinteractionbyte $79 $00
	loadsprite $03
	enableinput
	jump2byte script5aaf
script5ac7:
	rungenericnpc $2a23
script5aca:
	rungenericnpclowindex $00
script5acc:
	rungenericnpclowindex $03
script5ace:
	rungenericnpclowindex $04
script5ad0:
	jumpifmemoryeq $cc01 $01 script5ad8
	rungenericnpclowindex $05
script5ad8:
	rungenericnpclowindex $08
script5ada:
	rungenericnpclowindex $09
script5adc:
	rungenericnpclowindex $07
script5ade:
	initnpchitbox
script5adf:
	checkabutton
	ormemory $cfde $08
	cplinkx $48
	loadsprite $fe $48
	showtext $04f5
	loadsprite $02
	jump2byte script5adf
script5af0:
	rungenericnpclowindex $00
script5af2:
	rungenericnpclowindex $01
script5af4:
	initnpchitbox
script5af5:
	enableinput
	checkabutton
	disableinput
script5af8:
	jumpifinteractionbyteeq $4f $00 script5b00
	delay $0
	jump2byte script5af8
script5b00:
	asm15 $5800
	showloadedtext
	jump2byte script5af5
script5b06:
	jumpifglobalflagset $14 script5b0c
	rungenericnpclowindex $07
script5b0c:
	rungenericnpclowindex $0c
script5b0e:
	initnpchitbox
script5b0f:
	checkabutton
	asm15 $5817
	showtextlowindex $15
	asm15 $5826
	jump2byte script5b0f
script5b1a:
	initnpchitbox
script5b1b:
	checkabutton
	asm15 $5817
	showtextlowindex $16
	asm15 $5826
	jump2byte script5b1b
script5b26:
	initnpchitbox
script5b27:
	checkabutton
	asm15 $5817
	showtextlowindex $19
	asm15 $5826
	jump2byte script5b27
script5b32:
	initnpchitbox
script5b33:
	checkabutton
	asm15 $5817
	showtextlowindex $1a
	asm15 $5826
	jump2byte script5b33
script5b3e:
	initnpchitbox
	settextid $1440
	jump2byte script5b4a
script5b44:
	setcollisionradii $06 $06
	settextid $1441
script5b4a:
	checkabutton
	asm15 $5ca8
	showloadedtext
	delay $3
	loadsprite $02
	jump2byte script5b4a
script5b54:
	disableinput
	setspeed $28
	jumpifinteractionbyteeq $48 $00 script5b60
	movenpcleft $10
	jump2byte script5b62
script5b60:
	movenpcright $10
script5b62:
	asm15 $582c
	delay $3
	enableinput
	scriptend
script5b68:
	rungenericnpc $1420
script5b6b:
	rungenericnpc $1421
script5b6e:
	rungenericnpc $1422
script5b71:
	rungenericnpc $1423
script5b74:
	rungenericnpc $1424
script5b77:
	rungenericnpc $1425
script5b7a:
	rungenericnpc $1430
script5b7d:
	rungenericnpc $1431
script5b80:
	rungenericnpc $1434
script5b83:
	rungenericnpc $1435
script5b86:
	rungenericnpc $1400
script5b89:
	rungenericnpc $1401
script5b8c:
	rungenericnpc $1402
script5b8f:
	jumpifmemoryeq $cc01 $01 script5b98
	rungenericnpc $1403
script5b98:
	rungenericnpc $1408
script5b9b:
	rungenericnpc $1404
script5b9e:
	rungenericnpc $1405
script5ba1:
	rungenericnpc $1406
script5ba4:
	rungenericnpc $1407
script5ba7:
	rungenericnpc $1414
script5baa:
	rungenericnpc $1415
script5bad:
	rungenericnpc $1418
script5bb0:
	rungenericnpc $1417
script5bb3:
	initnpchitbox
script5bb4:
	delay $8
	loadsprite $01
	delay $6
script5bb8:
	asm15withparam $5862 $01
	delay $6
	jump2byte script5bb4
script5bbf:
	scriptend
script5bc0:
	checkmemoryeq $cfd1 $02
	delay $3
	setspeed $3c
	movenpcleft $2c
	asm15 $5834
	delay $6
	loadsprite $0b
	setmovingdirection $08
	checkcounter2iszero $2c
	writeinteractionbyte $79 $01
	delay $9
	writeinteractionbyte $7b $01
	asm15 $5847
	jump2byte script5bb8
script5bdf:
	jumpifglobalflagset $41 script45ef
	setlinkcantmoveto11
	setcounter1 $64
	disableinput
	delay $7
	callscript script51ac
	delay $6
	showtext $1622
	delay $6
	setspeed $28
	movenpcdown $11
	movenpcright $11
	movenpcdown $09
	setspeed $14
	checkcounter2iszero $21
	setspeed $28
	checkcounter2iszero $39
	setglobalflag $41
	enableinput
	scriptend
script5c04:
	delay $9
	setspeed $28
	loadsprite $00
	delay $6
	movenpcup $80
	scriptend
script5c0d:
	initnpchitbox
script5c0e:
	checkabutton
	command8a
	showloadedtext
	loadsprite $00
	jump2byte script5c0e
script5c15:
	rungenericnpc $1520
script5c18:
	rungenericnpc $1521
script5c1b:
	rungenericnpc $1522
script5c1e:
	rungenericnpc $1523
script5c21:
	rungenericnpc $1524
script5c24:
	rungenericnpc $1525
script5c27:
	rungenericnpc $1500
script5c2a:
	rungenericnpc $1501
script5c2d:
	rungenericnpc $1502
script5c30:
	rungenericnpc $1503
script5c33:
	rungenericnpc $1504
script5c36:
	rungenericnpc $1505
script5c39:
	rungenericnpc $1508
script5c3c:
	rungenericnpc $1507
script5c3f:
	rungenericnpc $1510
script5c42:
	rungenericnpc $1511
script5c45:
	rungenericnpc $1512
script5c48:
	rungenericnpc $1513
script5c4b:
	rungenericnpc $1515
script5c4e:
	rungenericnpc $1518
script5c51:
	initnpchitbox
script5c52:
	checkabutton
	asm15 $5ca8
	ormemory $cfde $04
	showtext $2510
	delay $3
	loadsprite $00
	jump2byte script5c52
script5c62:
	setspeed $28
	movenpcleft $50
	delay $2
	movenpcright $50
	delay $2
	movenpcleft $30
	asm15withparam $5854 $3c
	setcounter1 $32
	writememory $cfd1 $01
	delay $9
	writememory $cfd1 $02
	setspeed $0a
	checkcounter2iszero $40
	delay $6
	writememory $cfd1 $03
	scriptend
script5c85:
	rungenericnpc $2500
script5c88:
	rungenericnpc $2501
script5c8b:
	rungenericnpc $2502
script5c8e:
	rungenericnpc $2503
script5c91:
	rungenericnpc $2504
script5c94:
	rungenericnpc $2505
script5c97:
	checkmemoryeq $cfd1 $02
	writeinteractionbyte $79 $01
	setcounter1 $20
	showtext $2512
	delay $6
	loadsprite $03
	setcounter1 $20
	showtext $2513
	delay $6
	loadsprite $00
	setcounter1 $20
	showtext $2514
	delay $8
	writememory $cfd1 $03
script5cb8:
	writeinteractionbyte $79 $01
	writeinteractionbyte $78 $78
script5cbe:
	asm15 $585a
	addinteractionbyte $78 $ff
	jumpifinteractionbyteeq $78 $00 script5ccc
	delay $0
	jump2byte script5cbe
script5ccc:
	playsound $51
	writeinteractionbyte $79 $00
	setspeed $50
	movenpcright $38
	scriptend
script5cd6:
	delay $6
	showtext $2511
	delay $6
	writememory $cfd1 $01
	checkmemoryeq $cfd1 $03
	jump2byte script5cb8
script5ce5:
	delay $6
	setspeed $3c
	movenpcleft $0a
script5cea:
	setcounter1 $03
	movenpcup $21
	setcounter1 $03
	movenpcright $20
	setcounter1 $03
	movenpcdown $36
	setcounter1 $03
	movenpcright $16
	setcounter1 $03
	movenpcup $16
	setcounter1 $03
	movenpcleft $35
	jump2byte script5cea
script5d04:
	delay $6
	jumpifinteractionbyteeq $78 $00 script5d13
	asm15withparam $5862 $02
	delay $9
	loadsprite $03
	jump2byte script5d04
script5d13:
	writememory $cfd1 $01
	asm15withparam $5862 $03
	delay $9
	asm15withparam $5870 $00
	delay $5
	asm15withparam $5870 $01
	delay $5
	asm15 $326c
	checkpalettefadedone
	delay $3
	writememory $cfd1 $02
	loadsprite $03
	asm15 $3299
	checkpalettefadedone
	delay $6
	asm15withparam $5854 $28
	delay $7
	addinteractionbyte $45 $01
	setspeed $3c
	movenpcleft $21
	delay $6
	writememory $cfdf $ff
	scriptend
script5d48:
	loadscript $15 $58d3
script5d4c:
	checkmemoryeq $cfd1 $02
	loadsprite $01
	delay $6
	showtext $251b
	delay $6
	writememory $cfd1 $03
	scriptend
script5d5c:
	initnpchitbox
script5d5d:
	checkabutton
	command8a
	showloadedtext
	loadsprite $00
	jump2byte script5d5d
script5d64:
	setspeed $50
	movenpcright $19
	delay $2
	loadsprite $03
	writeinteractionbyte $79 $01
	setcounter1 $25
script5d70:
	loadsprite $03
script5d72:
	delay $6
	asm15withparam $5862 $02
	delay $9
	jump2byte script5d70
script5d7a:
	rungenericnpc $251c
script5d7d:
	initnpchitbox
	jump2byte script5d72
script5d80:
	checkcfc0bit 0
	delay $8
	asm15withparam $5854 $1e
	checkcfc0bit 2
	setspeed $50
	loadsprite $01
	setmovingdirection $0c
	checkcounter2iszero $31
	scriptend
script5d90:
	jumpifglobalflagset $11 script5d97
	rungenericnpc $3800
script5d97:
	rungenericnpc $3801
script5d9a:
	checkmemoryeq $cfd1 $03
	setspeed $64
	movenpcdown $0e
	delay $1
	movenpcleft $0d
	setcounter1 $10
	scriptend
script5da8:
	rungenericnpc $1809
script5dab:
	setspeed $3c
	movenpcleft $16
	jump2byte script5cea
script5db1:
	loadscript $15 $5946
script5db5:
	setcoords $24 $78
	delay $6
	setmovingdirection $00
	setspeed $0a
	checkcounter2iszero $45
	checkmemoryeq $cfd2 $ff
	delay $8
	setmovingdirection $10
	setspeed $14
	checkcounter2iszero $23
	delay $3
	writememory $cfd0 $1a
	scriptend
script5dd0:
	checkmemoryeq $cc93 $00
	delay $2
	showtext $1315
	delay $2
	checkcounter2iszero $0c
	xorcfc0bit 0
	scriptend
script5ddd:
	rungenericnpclowindex $10
script5ddf:
	rungenericnpclowindex $03
script5de1:
	delay $6
	showtextlowindex $11
	writememory $cfd1 $02
	checkmemoryeq $cfd1 $03
	jump2byte script5cb8
script5dee:
	jumpifglobalflagset $0b script5df5
	rungenericnpc $5900
script5df5:
	rungenericnpc $5901
script5df8:
	jumpifglobalflagset $0b script5dff
	rungenericnpc $5902
script5dff:
	rungenericnpc $5901
script5e02:
	loadscript $15 $5a6d
script5e06:
	jumpifinteractionbyteeq $4b $28 script5e1e
	checkmemoryeq $d00b $60
	setspeed $28
	jumpifinteractionbyteeq $4d $48 script5e1a
	setmovingdirection $08
	jump2byte script5e1c
script5e1a:
	setmovingdirection $18
script5e1c:
	checkcounter2iszero $10
script5e1e:
	scriptend
script5e1f:
	checkmemoryeq $cfd1 $02
	loadsprite $01
	delay $6
	setspeed $28
	movenpcup $21
	setcounter1 $06
	movenpcright $11
	setcounter1 $06
	movenpcup $34
	delay $b
	movenpcdown $34
	setcounter1 $06
	movenpcleft $11
	setcounter1 $06
	movenpcdown $21
	delay $8
	showtext $1303
	delay $6
	movenpcdown $31
	setcounter1 $06
	loadsprite $01
	asm15withparam $5155 $03
	delay $8
	setspeed $14
	setmovingdirection $08
	checkcounter2iszero $15
	delay $8
	setmovingdirection $18
	checkcounter2iszero $15
	delay $6
	giveitem $0302
	setlinkcantmoveto11
	delay $6
	asm15withparam $5155 $00
	setspeed $28
	movenpcup $31
	setcounter1 $06
	loadsprite $02
	delay $6
	showtext $1304
	delay $6
	writememory $cfd1 $03
	checkmemoryeq $cfd1 $04
	playsound $fb
	delay $b
	showtext $1305
	delay $7
	movenpcdown $21
	delay $1
	movenpcright $11
	delay $1
	movenpcdown $11
	delay $8
	showtext $5907
	writememory $cfd1 $05
	scriptend
script5e8f:
	movenpcup $84
	scriptend
script5e92:
	setspeed $28
	movenpcup $10
	delay $8
	movenpcright $18
	delay $6
	loadsprite $03
	delay $8
	showtext $5905
	delay $6
	showtext $1300
	delay $6
	movenpcleft $18
	delay $2
	loadsprite $02
	delay $7
	writememory $c6bd $00
	asm15 $5a28
	delay $5
	loadsprite $00
	delay $3
	movenpcup $24
	delay $7
	playsound $5e
	delay $5
	setspeed $14
	setmovingdirection $10
	checkcounter2iszero $48
	loadsprite $03
	setmovingdirection $08
	checkcounter2iszero $30
	writememory $cfd1 $01
	checkmemoryeq $cfd1 $03
	setspeed $28
	movenpcleft $18
	loadsprite $00
	delay $6
	showtext $5906
	delay $6
	loadsprite $02
	delay $6
	showtext $590c
	delay $6
	writememory $cd00 $00
	asm15withparam $59f3 $01
	setlinkcantmoveto00
	movenpcdown $34
	writememory $cfd1 $04
	setglobalflag $0b
	scriptend
script5ef4:
	delay $8
	showtext $5908
	delay $6
	writememory $cbc3 $00
	asm15 $5a2f
	enableinput
	rungenericnpc $5909
script5f04:
	jumpifglobalflagset $0b script5f0b
	rungenericnpc $5903
script5f0b:
	rungenericnpc $5909
script5f0e:
	loadscript $15 $5aa2
script5f12:
	initnpchitbox
script5f13:
	checkabutton
	asm15 $5a37
	showloadedtext
	jump2byte script5f13
script5f1a:
	asm15 $5fb9
	asm15 $5a4d
	initnpchitbox
	jumptable_interactionbyte $7b
.dw script5f2b
.dw script5f2f
.dw script5f64
.dw script5f99
script5f2b:
	checkabutton
	showloadedtext
	jump2byte script5f2b
script5f2f:
	checkmemoryeq $cde0 $00
	asm15 $2504
script5f36:
	asm15withparam $5fc3 $02
	asm15withparam $5fd2 $60
	callscript script5fb8
	asm15withparam $5fc3 $03
	asm15withparam $5fd2 $60
	callscript script5fb8
	asm15withparam $5fc3 $00
	asm15withparam $5fd2 $60
	callscript script5fb8
	asm15withparam $5fc3 $01
	asm15withparam $5fd2 $60
	callscript script5fb8
	jump2byte script5f36
script5f64:
	checkmemoryeq $cde0 $00
	asm15 $2504
script5f6b:
	asm15withparam $5fc3 $02
	asm15withparam $5fd2 $80
	callscript script5fb8
	asm15withparam $5fc3 $01
	asm15withparam $5fd2 $20
	callscript script5fb8
	asm15withparam $5fc3 $00
	asm15withparam $5fd2 $80
	callscript script5fb8
	asm15withparam $5fc3 $03
	asm15withparam $5fd2 $20
	callscript script5fb8
	jump2byte script5f6b
script5f99:
	checkmemoryeq $cde0 $00
	asm15 $2504
script5fa0:
	asm15withparam $5fc3 $02
	asm15withparam $5fd2 $c0
	callscript script5fb8
	asm15withparam $5fc3 $00
	asm15withparam $5fd2 $c0
	callscript script5fb8
	jump2byte script5fa0
script5fb8:
	jumpifinteractionbyteeq $71 $01 script5fcd
	asm15 $5fdc
	jumpifmemoryset $cddb $80 script5fcb
	asm15 $201d
	jump2byte script5fb8
script5fcb:
	delay $5
	retscript
script5fcd:
	disableinput
	writeinteractionbyte $71 $00
	asm15 $5ca8
	showloadedtext
	delay $6
	asm15 $5fd6
	enableinput
	jump2byte script5fb8
script5fdc:
	rungenericnpclowindex $06
script5fde:
	rungenericnpclowindex $00
script5fe0:
	rungenericnpclowindex $01
script5fe2:
	rungenericnpclowindex $02
script5fe4:
	rungenericnpclowindex $03
script5fe6:
	rungenericnpclowindex $04
script5fe8:
	rungenericnpclowindex $05
script5fea:
	jumpifglobalflagset $0b script5ff0
	rungenericnpclowindex $00
script5ff0:
	rungenericnpclowindex $01
script5ff2:
	jumpifglobalflagset $0b script5ff8
	rungenericnpclowindex $10
script5ff8:
	rungenericnpclowindex $11
script5ffa:
	rungenericnpclowindex $01
script5ffc:
	rungenericnpclowindex $02
script5ffe:
	rungenericnpclowindex $03
script6000:
	rungenericnpclowindex $04
script6002:
	rungenericnpclowindex $07
script6004:
	checkmemoryeq $cfd1 $02
	writeinteractionbyte $5c $06
	scriptend
script600c:
	writeinteractionbyte $5c $02
	rungenericnpclowindex $12
script6011:
	jumpifglobalflagset $0b script6018
	rungenericnpc $1620
script6018:
	rungenericnpc $1621
script601b:
	checkmemoryeq $cfd1 $04
	asm15 $1e69
	delay $c
	writememory $cfdf $ff
	callscript script51ac
	scriptend
script602b:
	rungenericnpc $1610
script602e:
	rungenericnpc $1611
script6031:
	rungenericnpc $1612
script6034:
	rungenericnpc $1613
script6037:
	rungenericnpc $1614
script603a:
	rungenericnpc $1615
script603d:
	rungenericnpc $1600
script6040:
	jumpifmemoryeq $cc01 $01 script6049
	rungenericnpc $1601
script6049:
	rungenericnpc $1608
script604c:
	rungenericnpc $1602
script604f:
	rungenericnpc $1604
script6052:
	rungenericnpc $1605
script6055:
	rungenericnpc $1609
script6058:
	jumpifmemoryeq $cc01 $01 script6061
	rungenericnpc $1607
script6061:
	rungenericnpc $160a
script6064:
	rungenericnpclowindex $0a
script6066:
	rungenericnpclowindex $00
script6068:
	rungenericnpclowindex $01
script606a:
	rungenericnpclowindex $02
script606c:
	rungenericnpclowindex $03
script606e:
	delay $c
	loadsprite $00
script6071:
	setmovingdirection $10
	setspeed $50
	checkcounter2iszero $10
	delay $6
	setmovingdirection $08
	setspeed $14
	checkcounter2iszero $20
	writeinteractionbyte $79 $01
	delay $8
	writeinteractionbyte $79 $00
	checkcounter2iszero $20
	writeinteractionbyte $79 $01
	delay $8
	scriptend
script608c:
	disablemenu
	delay $c
	asm15 $5b23
	loadsprite $00
	playsound $a6
	writememory $cfd1 $01
	jump2byte script6071
script609b:
	loadscript $15 $5c66
script609f:
	jumptable_interactionbyte $7c
.dw script60a7
.dw script60ba
.dw script60bc
script60a7:
	initnpchitbox
	checkabutton
	disableinput
	showloadedtext
	delay $6
	loadsprite $02
	writeinteractionbyte $7b $01
	asm15 $5b4b
	delay $6
	showtextlowindex $0c
	orroomflags $40
	enableinput
script60ba:
	rungenericnpclowindex $0c
script60bc:
	rungenericnpclowindex $0d
script60be:
	checkmemoryeq $d00b $50
	disableinput
	delay $6
	showtextlowindex $0e
	setspeed $3c
	movenpcup $11
	delay $6
	loadsprite $02
	delay $6
	setzspeed $fe40
	playsound $53
script60d3:
	asm15withparam $1f45 $20
	jumpifinteractionbyteeq $4f $00 script60df
	delay $0
	jump2byte script60d3
script60df:
	delay $5
	showtextlowindex $0f
	delay $6
	movenpcup $39
	setcounter1 $06
	movenpcleft $2b
	enableinput
	orroomflags $80
	scriptend
script60ed:
	initnpchitbox
	jumpifroomflagset $40 script6151
script60f2:
	jumpifsomething $16 script60fb
script60f6:
	checkabutton
	showtextlowindex $1c
	jump2byte script60f6
script60fb:
	asm15 $5ad8
	checkabutton
	showtextlowindex $10
	disableinput
	delay $3
	asm15withparam $5b0a $06
	writeinteractionbyte $60 $7f
	playsound $5e
	delay $7
	settextid $0a13
	jumpifmemoryeq $c6ea $00 script6119
	settextid $0a11
script6119:
	showloadedtext
	jumpifcba5eq $00 script612b
	settextid $0a1a
script6121:
	delay $5
	loadsprite $02
	writeinteractionbyte $7b $01
	showloadedtext
	enableinput
	jump2byte script60fb
script612b:
	jumpifinteractionbyteeq $7d $00 script6135
script6130:
	settextid $0a1b
	jump2byte script6121
script6135:
	asm15withparam $1778 $04
	delay $5
	loadsprite $02
	writeinteractionbyte $7b $01
	showtextlowindex $14
	jumpifcba5eq $00 script614c
script6145:
	delay $5
	showtextlowindex $26
	jumpifcba5eq $01 script6145
script614c:
	delay $5
	showtextlowindex $15
	delay $5
	scriptend
script6151:
	asm15 $5acc
	disableinput
	jumpifmemoryeq $cfde $ff script6162
	delay $6
	asm15 $5b7e
	delay $6
	jump2byte script6176
script6162:
	asm15 $5aed
	showtextlowindex $19
	jumpifcba5eq $01 script6176
	jumpifinteractionbyteeq $7d $01 script6130
	asm15withparam $1778 $04
	jump2byte script614c
script6176:
	enableinput
	jump2byte script60f2
script6179:
	checksomething
script617a:
	checkabutton
	asm15 $5bc5
	jumpifinteractionbyteeq $7f $00 script6187
	showtextlowindex $37
	jump2byte script617a
script6187:
	showtextlowindex $38
	jump2byte script617a
script618b:
	disableinput
	jumpifmemoryset $c647 $01 script619a
	setmovingdirectionandmore $10
	showtextlowindex $1d
	ormemory $d13e $01
script619a:
	checksomething
script619b:
	setmovingdirectionandmore $08
	enableinput
	checkabutton
	disableinput
	asm15 $5bee
	showtextlowindex $1f
	asm15 $5bd1
	jumpifinteractionbyteeq $7f $00 script619b
	showtextlowindex $20
	jumptable_memoryaddress $cba5
.dw script61ba
.dw script61b6
script61b6:
	showtextlowindex $22
	jump2byte script619b
script61ba:
	showtextlowindex $23
	asm15 $5bdf
	ormemory $d13e $04
	spawninteraction $8f00 $48 $18
	spawninteraction $8f00 $58 $38
	delay $6
	showtextlowindex $24
	delay $8
	showtextlowindex $25
	ormemory $d13e $08
	movenpcleft $10
	enablemenu
	scriptend
script61db:
	jumpifmemoryset $c647 $01 script61f4
	jumpifmemoryset $d13e $01 script61e9
	jump2byte script61db
script61e9:
	disableinput
	delay $6
	setmovingdirectionandmore $10
	showtextlowindex $1e
	ormemory $d13e $02
	enableinput
script61f4:
	checksomething
script61f5:
	setmovingdirectionandmore $00
script61f7:
	jumpifinteractionbyteeq $71 $00 script6206
	asm15 $5bee
	showtextlowindex $1e
	writeinteractionbyte $71 $00
	jump2byte script61f5
script6206:
	jumpifmemoryset $d13e $04 script620e
	jump2byte script61f7
script620e:
	setmovingdirectionandmore $10
script6210:
	jumpifmemoryset $d13e $08 script6219
	delay $0
	jump2byte script6210
script6219:
	movenpcleft $20
	ormemory $c647 $02
	setlinkcantmoveto00
	scriptend
script6221:
	checksomething
script6222:
	setmovingdirectionandmore $10
	checkabutton
	asm15 $5bee
	jumpifroomflagset $80 script6257
	jumpifsomething $4d script6234
	showtextlowindex $40
	jump2byte script6222
script6234:
	disableinput
	showtextlowindex $40
	delay $6
	showtextlowindex $41
	asm15 $5bfe
	setspeed $28
	checkcounter2iszero $10
	asm15 $5bfe
	asm15 $5c06
	spawninteraction $8004 $38 $48
	playsound $5e
	delay $a
	asm15 $5bee
	showtextlowindex $42
	enableinput
	jump2byte script6222
script6257:
	jumpifsomething $21 script625f
	showtextlowindex $43
	jump2byte script6222
script625f:
	showtextlowindex $44
	jump2byte script6222
script6263:
	jumpifglobalflagset $14 script6269
	rungenericnpclowindex $67
script6269:
	initnpchitbox
	jumpifroomflagset $40 script62bf
	jumpifglobalflagset $73 script62da
	jumpifglobalflagset $69 script6299
script6276:
	checkabutton
	disableinput
	showtextlowindex $45
	delay $5
	jumpifcba5eq $00 script6285
	delay $6
	showtextlowindex $46
	enableinput
	jump2byte script6276
script6285:
	showpasswordscreen $05
	delay $5
	jumpifmemoryeq $cc89 $00 script6293
	showtextlowindex $48
	enableinput
	jump2byte script6276
script6293:
	setglobalflag $69
	showtextlowindex $47
	jump2byte script629d
script6299:
	checkabutton
	disableinput
	showtextlowindex $51
script629d:
	setcounter1 $02
	jumpifcba5eq $00 script62a9
	delay $5
	showtextlowindex $52
	enableinput
	jump2byte script6299
script62a9:
	delay $5
	showtextlowindex $4a
	setcounter1 $02
	jumpifcba5eq $00 script62ba
script62b2:
	delay $5
	showtextlowindex $4b
	delay $5
	jumpifcba5eq $01 script62b2
script62ba:
	delay $5
	showtextlowindex $4c
	delay $7
	scriptend
script62bf:
	asm15 $5acc
	disableinput
	jumpifmemoryeq $cfde $ff script62e1
	showtextlowindex $4f
	delay $6
	asm15 $5c13
	giveitem $6100
	delay $6
	setglobalflag $73
	showpasswordscreen $15
	showtextlowindex $50
	enableinput
script62da:
	checkabutton
	showpasswordscreen $15
	showtextlowindex $53
	jump2byte script62da
script62e1:
	showtextlowindex $4d
	delay $5
	jumpifcba5eq $00 script62ba
	showtextlowindex $4e
	enableinput
	jump2byte script6299
script62ed:
	loadscript $15 $5c26
script62f1:
	loadscript $15 $5c40
script62f5:
	checksomething
script62f6:
	checkabutton
	showtext $1108
	jump2byte script62f6
script62fc:
	checksomething
script62fd:
	checkabutton
	showtext $1109
	jump2byte script62fd
script6303:
	setcollisionradii $04 $04
	checksomething
script6307:
	checkabutton
	showloadedtext
	jump2byte script6307
script630b:
	setcollisionradii $04 $04
	checksomething
script630f:
	checkabutton
	disableinput
	jumpifglobalflagset $6f script6343
	showtext $1148
	delay $6
	jumpifcba5eq $00 script6322
	showtext $1149
	jump2byte script6348
script6322:
	showpasswordscreen $01
	delay $6
	jumpifmemoryeq $cc89 $00 script6330
	showtext $114b
	jump2byte script6348
script6330:
	setglobalflag $65
	showtext $114a
	delay $6
	giveitem $2a02
	delay $6
	showpasswordscreen $11
	setglobalflag $6f
	showtext $114c
	jump2byte script6348
script6343:
	showpasswordscreen $11
	showtext $114d
script6348:
	enableinput
	jump2byte script630f
script634b:
	initnpchitbox
script634c:
	checkabutton
	asm15 $5ca8
	ormemory $cfde $02
	showtext $5705
	delay $3
	loadsprite $00
	jump2byte script634c
script635c:
	delay $6
	loadsprite $02
	delay $9
	loadsprite $03
	scriptend
script6363:
	rungenericnpc $5717
script6366:
	rungenericnpc $5718
script6369:
	initnpchitbox
script636a:
	checkabutton
	setlinkcantmoveto11
	asm15 $2701
	writeinteractionbyte $77 $01
	cplinkx $48
	addinteractionbyte $48 $02
	loadsprite $fe $48
	ormemory $cfde $01
	showtext $3214
	writeinteractionbyte $77 $00
	writeinteractionbyte $4f $00
	delay $3
	setlinkcantmoveto00
	loadsprite $01
	asm15 $277b
	jump2byte script636a
script6390:
	initnpchitbox
	jumpifglobalflagset $3c script639f
script6395:
	checkabutton
	loadsprite $02
	showtext $3216
	loadsprite $00
	jump2byte script6395
script639f:
	checkmemoryeq $cfd0 $05
	loadsprite $02
	delay $6
	showtext $3217
	loadsprite $00
	writememory $cfd0 $06
	checkmemoryeq $cfd0 $07
	loadsprite $02
	setspeed $28
	setmovingdirection $18
	checkcounter2iszero $10
	setmovingdirection $00
	checkcounter2iszero $60
	scriptend
script63c0:
	checkmemoryeq $cfd1 $01
	delay $6
	showtext $1301
	delay $6
	loadsprite $03
	delay $5
	showtext $1302
	writememory $cfd1 $02
	delay $3
	loadsprite $02
	checkmemoryeq $cfd1 $06
	setcounter1 $96
	setspeed $14
	movenpcup $60
	writememory $cfd1 $07
	scriptend
script63e5:
	checkmemoryeq $cfd0 $07
	playsound $f0
	showtext $130e
	playsound $4a
	delay $3
	writememory $cfd0 $08
	checkmemoryeq $cfd0 $09
	showtext $130f
	delay $8
	writememory $cfd0 $0a
	scriptend
script6402:
	checkmemoryeq $cfd0 $0c
	showtext $1310
	delay $6
	writememory $cfd0 $0d
	checkinteractionbyteeq $7e $01
	delay $3
	showtext $1311
	delay $a
	writememory $cfd0 $0f
	scriptend
script641b:
	delay $b
	asm15 $326c
	checkpalettefadedone
	writememory $cfc0 $01
	delay $6
	asm15 $3299
	setspeed $0a
	setmovingdirection $10
	checkmemoryeq $cfc0 $04
	scriptend
script6431:
	delay $8
	setspeed $14
	movenpcdown $64
	setspeed $0a
	movenpcdown $40
	setspeed $14
	movenpcdown $2c
	delay $8
	loadsprite $0a
	showtext $130b
	delay $5
	writememory $cfc0 $01
	checkmemoryeq $cfc0 $02
	delay $6
	showtext $130c
	writememory $cc04 $10
	scriptend
script6456:
	loadsprite $0a
	checkpalettefadedone
	delay $8
	showtext $130d
	setcounter1 $06
	orroomflags $40
	scriptend
script6462:
	setspeed $14
	setmovingdirection $10
	checkcfc0bit 0
	delay $2
	checkcounter2iszero $11
	delay $5
	checkcounter2iszero $11
	delay $5
	checkcounter2iszero $11
	checkcfc0bit 2
	writeinteractionbyte $7f $2d
	playsound $fb
	playsound $8d
script6478:
	asm15 $5cb1
	asm15 $5cb6
	jumpifmemoryset $cddb $80 script6486
	jump2byte script6478
script6486:
	playsound $6b
script6488:
	asm15 $5cbd
	jumpifmemoryset $cddb $10 script6496
	asm15 $5cb1
	jump2byte script6488
script6496:
	xorcfc0bit 3
	scriptend
script6498:
	disableinput
	checkcfc0bit 0
	spawnenemyhere $0161
	delay $0
	enableinput
	scriptend
script64a0:
	showtext $1318
	setcounter1 $10
	showtext $1319
	writememory $cc4f $09
	setspeed $3c
	movenpcdown $3c
	spawninteraction $3e02 $00 $28
	scriptend
script64b6:
	checkpalettefadedone
	delay $8
	showtext $1316
	delay $8
	asm15 $326c
	checkpalettefadedone
	scriptend
script64c1:
	rungenericnpc $131a
script64c4:
	rungenericnpclowindex $05
script64c6:
	rungenericnpclowindex $07
script64c8:
	asm15 $5180
	jumpifmemoryset $cddb $80 script45ef
	rungenericnpclowindex $14
script64d3:
	asm15 $5180
	jumpifmemoryset $cddb $80 script45ef
	writeinteractionbyte $5c $02
	rungenericnpclowindex $15
script64e1:
	initnpchitbox
script64e2:
	checkabutton
	command8a
	writeinteractionbyte $48 $ff
	showloadedtext
	loadsprite $00
	jump2byte script64e2
script64ec:
	loadscript $15 $5cc8
script64f0:
	loadscript $15 $5d50
script64f4:
	loadscript $15 $5d9b
script64f8:
	loadscript $15 $5dc5
script64fc:
	checksomething
script64fd:
	checkabutton
	command8a
	showloadedtext
	asm15 $5d4a
	jump2byte script64fd
script6505:
	loadscript $15 $5df4
script6509:
	asm15 $5eb5
script650c:
	asm15 $5ee0
	jumpifmemoryset $cddb $80 script651d
	asm15 $5ed4
	asm15 $5e94
	jump2byte script650c
script651d:
	asm15 $5ec5
	asm15 $5eaa
	delay $b
	asm15 $5eaa
	jump2byte script6509
script6529:
	loadscript $15 $5ee7
script652d:
	initnpchitbox
script652e:
	asm15withparam $262e $02
	checkabutton
	asm15withparam $262e $03
	showtextlowindex $00
	jump2byte script652e
script653b:
	loadsprite $05
	addinteractionbyte $60 $08
	setspeed $14
script6542:
	loadsprite $06
	setmovingdirection $10
	checkcounter2iszero $10
	delay $2
	asm15 $5f15
	loadsprite $05
	loadsprite $06
	setmovingdirection $00
	checkcounter2iszero $10
	delay $2
	asm15 $5f15
	loadsprite $05
	jump2byte script6542
script655c:
	loadsprite $04
	addinteractionbyte $60 $08
	setspeed $14
script6563:
	loadsprite $06
	setmovingdirection $00
	checkcounter2iszero $10
	delay $2
	asm15 $5f15
	loadsprite $04
	loadsprite $06
	setmovingdirection $10
	checkcounter2iszero $10
	delay $2
	asm15 $5f15
	loadsprite $04
	jump2byte script6563
script657d:
	loadscript $15 $5f4f
script6581:
	writeinteractionbyte $7f $01
	checkpalettefadedone
	delay $8
	writememory $cfc0 $07
	delay $9
	writeinteractionbyte $7f $00
	setmovingdirection $18
	checkcounter2iszero $40
	delay $a
	writememory $cfdf $ff
	scriptend
script6598:
	setcoords $55 $62
	loadsprite $07
	asm15 $1e72
	delay $8
	setspeed $0a
	setmovingdirection $00
	checkcounter2iszero $14
	delay $3
	setmovingdirection $18
	checkcounter2iszero $30
	writeinteractionbyte $7f $01
	checkmemoryeq $cfc0 $04
	setmovingdirection $10
	scriptend
script65b6:
	writeinteractionbyte $7f $01
	checkpalettefadedone
	setcounter1 $96
	writeinteractionbyte $7f $00
	setmovingdirection $18
	checkcounter2iszero $60
	scriptend
script65c4:
	asm15 $5f22
	initnpchitbox
script65c8:
	checkabutton
	asm15 $5f35
	showloadedtext
	jump2byte script65c8
script65cf:
	initnpchitbox
script65d0:
	checkabutton
	disableinput
	asm15 $5ca8
	jumptable_interactionbyte $43
.dw script65db
.dw script65ea
script65db:
	jumpifroomflagset $20 script65e6
	showtextlowindex $01
	delay $6
	giveitem $1500
	delay $6
script65e6:
	showtextlowindex $02
	jump2byte script65ec
script65ea:
	showtextlowindex $00
script65ec:
	loadsprite $04
	enableinput
	jump2byte script65d0
script65f1:
	jumptable_interactionbyte $43
.dw script65f7
.dw script6603
script65f7:
	asm15 $6001
	jumpifmemoryset $cddb $80 script6601
	scriptend
script6601:
	rungenericnpclowindex $07
script6603:
	asm15 $6007
	jumpifmemoryset $cddb $80 script660d
	scriptend
script660d:
	rungenericnpclowindex $08
script660f:
	loadscript $15 $600f
script6613:
	loadscript $15 $604e
script6617:
	jumpifinteractionbyteeq $71 $01 script662c
	asm15 $5fdc
	jumpifmemoryset $cddb $80 script662a
	asm15 $201d
	jump2byte script6617
script662a:
	delay $5
	retscript
script662c:
	disableinput
	writeinteractionbyte $71 $00
	asm15 $5ca8
	showloadedtext
	delay $6
	asm15 $5fd6
	enableinput
	jump2byte script6617
script663b:
	loadscript $15 $6147
script663f:
	loadscript $15 $618c
script6643:
	asm15 $1e7b
	initnpchitbox
script6647:
	writeinteractionbyte $71 $00
script664a:
	delay $0
	asm15 $61b9
	jumpifmemoryset $cddb $10 script664a
	callscript script66be
script6657:
	jumpifinteractionbyteeq $71 $01 script6679
	asm15 $61b9
	jumpifmemoryset $cddb $10 script6667
	jump2byte script6657
script6667:
	callscript script66cf
	jump2byte script6647
script666c:
	asm15 $61b9
	jumpifmemoryset $cddb $10 script6677
	jump2byte script666c
script6677:
	jump2byte script6647
script6679:
	disableinput
	writeinteractionbyte $71 $00
	jumpifroomflagset $20 script66b5
	showtextlowindex $07
	jumpifsomething2 $02 script668d
	callscript script66ce
	enableinput
	jump2byte script666c
script668d:
	delay $6
	showtextlowindex $08
	delay $6
	jumpifcba5eq $00 script669d
	showtextlowindex $0a
	callscript script66ce
	enableinput
	jump2byte script666c
script669d:
	showtextlowindex $09
	callscript script66ce
	delay $6
	showtextlowindex $0b
	callscript script66bd
	delay $6
	showtextlowindex $0c
	delay $6
	giveitem $4102
	callscript script66ce
	enableinput
	jump2byte script666c
script66b5:
	showtextlowindex $09
	callscript script66ce
	enableinput
	jump2byte script666c
script66bd:
	delay $6
script66be:
	writeinteractionbyte $71 $00
	asm15 $1e84
	asm15 $61ec
	checkinteractionbyteeq $61 $ff
	asm15 $61e8
	retscript
script66ce:
	delay $6
script66cf:
	asm15 $61e4
script66d2:
	checkinteractionbyteeq $61 $ff
	asm15 $1e7b
	retscript
script66d9:
	asm15 $61f4
	jumpifmemoryset $cddb $07 script66e5
	delay $9
	jump2byte script66ed
script66e5:
	asm15 $61de
	callscript script66d2
	setcounter1 $2d
script66ed:
	jumptable_interactionbyte $78
.dw script6702
.dw script66ff
.dw script670e
.dw script6711
.dw script6714
.dw script6717
.dw script671a
.dw script671d
script66ff:
	showtextlowindex $26
	delay $6
script6702:
	asm15withparam $24bb $3c
	asm15withparam $c98 $6f
	delay $8
	showtextlowindex $25
	scriptend
script670e:
	showtextlowindex $27
	scriptend
script6711:
	showtextlowindex $28
	scriptend
script6714:
	showtextlowindex $29
	scriptend
script6717:
	showtextlowindex $2a
	scriptend
script671a:
	showtextlowindex $2b
	scriptend
script671d:
	showtextlowindex $0a
	scriptend
script6720:
	loadscript $15 $61fb
script6724:
	initnpchitbox
	jumpifroomflagset $80 script674d
script6729:
	checkabutton
	ormemory $cfde $10
	jumpifmemoryeq $cfde $1f script6739
	showtext $5702
	jump2byte script6729
script6739:
	setlinkcantmoveto11
	loadsprite $01
	delay $5
	setmovingdirection $00
	setspeed $14
	checkcounter2iszero $20
	delay $5
	loadsprite $00
	delay $6
	orroomflags $80
	setlinkcantmoveto00
script674a:
	showtext $5703
script674d:
	checkabutton
	jump2byte script674a
script6750:
	delay $a
	showtext $5706
	delay $6
	writememory $cc04 $06
	scriptend
script675a:
	initnpchitbox
script675b:
	checkabutton
	showloadedtext
	jump2byte script675b
script675f:
	spawninteraction $470b $28 $44
	spawninteraction $4707 $28 $4c
	spawninteraction $4708 $28 $74
	scriptend
script676f:
	showtext $0d00
	scriptend
script6773:
	showtext $0d0b
	scriptend
script6777:
	jumptable_interactionbyte $77
.dw script6783
.dw script6788
.dw script6783
.dw script6788
.dw script678d
script6783:
	showtextnonexitable $0d01
	jump2byte script6790
script6788:
	showtextnonexitable $0d05
	jump2byte script6790
script678d:
	showtextnonexitable $0d0a
script6790:
	jumpifcba5eq $00 script67a0
	writeinteractionbyte $7a $ff
	writememory $cbad $03
	writememory $cba0 $01
	scriptend
script67a0:
	jumpifmemoryeq $ccd5 $00 script67b2
	writeinteractionbyte $7a $ff
	writememory $cbad $01
	writememory $cba0 $01
	scriptend
script67b2:
	jumptable_interactionbyte $78
.dw script67b8
.dw script48ac
script67b8:
	writeinteractionbyte $7a $01
	writememory $cbad $00
	writememory $cba0 $01
	scriptend
script67c4:
	loadscript $15 $62a0
script67c8:
	setcollisionradii $0a $0c
	checksomething
script67cc:
	checkabutton
	disableinput
	asm15 $6320
	jumpifmemoryset $cddb $80 script67df
	jumpifsomething $44 script67ee
	jumpifsomething $59 script67f9
script67df:
	jumpifsomething $5b script67ee
	asm15withparam $6398 $00
	delay $6
	jumpifcba5eq $00 script6809
	jump2byte script6801
script67ee:
	asm15withparam $6398 $01
	delay $6
	jumpifcba5eq $00 script6809
	jump2byte script6801
script67f9:
	showtext $2419
	delay $6
	jumpifcba5eq $00 script6809
script6801:
	asm15withparam $6398 $03
	delay $0
	enableinput
	jump2byte script67cc
script6809:
	callscript script68d8
	jumpifmemoryset $cddb $80 script681a
script6812:
	asm15withparam $6398 $09
	enableinput
	checkabutton
	jump2byte script6812
script681a:
	disableinput
	callscript script68eb
	asm15withparam $6398 $02
	delay $6
	jumpifcba5eq $00 script6848
script6827:
	asm15withparam $6398 $04
	delay $6
	playsound $cd
	loadsprite $03
	delay $6
	asm15withparam $6398 $05
	delay $6
	playsound $c8
	loadsprite $06
	delay $6
	asm15withparam $6398 $06
	delay $6
	loadsprite $02
	jumpifcba5eq $00 script6848
	jump2byte script6827
script6848:
	asm15 $6320
	jumpifmemoryset $cddb $80 script6859
	jumpifsomething $44 script6872
	jumpifsomething $59 script685d
script6859:
	jumpifsomething $5b script6872
script685d:
	asm15 $6320
	jumpifmemoryset $cddb $80 script686c
	writememory $cfdd $02
	jump2byte script687b
script686c:
	writememory $cfdd $03
	jump2byte script687b
script6872:
	asm15withparam $6398 $0b
	delay $6
	callscript script6899
	delay $6
script687b:
	asm15withparam $6398 $07
	delay $7
	asm15 $326c
	checkpalettefadedone
	asm15 $19ad
	asm15 $6331
	delay $7
	asm15 $3299
	checkpalettefadedone
	asm15 $cb2
	delay $7
	asm15withparam $6398 $08
	delay $7
	scriptend
script6899:
	asm15 $6320
	jumpifmemoryset $cddb $80 script68ab
	jumptable_memoryaddress $cba5
.dw script68b4
.dw script68bd
.dw script68c6
script68ab:
	jumptable_memoryaddress $cba5
.dw script68bd
.dw script68c6
.dw script68cf
script68b4:
	writememory $cfdd $00
	asm15withparam $6398 $0c
	retscript
script68bd:
	writememory $cfdd $01
	asm15withparam $6398 $0d
	retscript
script68c6:
	writememory $cfdd $02
	asm15withparam $6398 $0e
	retscript
script68cf:
	writememory $cfdd $03
	asm15withparam $6398 $0f
	retscript
script68d8:
	asm15 $6320
	jumpifmemoryset $cddb $80 script68e6
	asm15withparam $5115 $05
	retscript
script68e6:
	asm15withparam $5115 $04
	retscript
script68eb:
	asm15 $6320
	jumpifmemoryset $cddb $80 script68f9
	asm15withparam $1778 $05
	retscript
script68f9:
	asm15withparam $1778 $04
	retscript
script68fe:
	callscript script6959
	delay $6
	jumptable_memoryaddress $cfdb
.dw script690d
.dw script690d
.dw script6913
.dw script6919
script690d:
	asm15withparam $6398 $16
	delay $6
	scriptend
script6913:
	asm15withparam $6398 $17
	delay $6
	scriptend
script6919:
	setmusic $ff
	asm15withparam $6398 $18
	delay $6
	asm15withparam $6398 $15
	delay $6
	jumpifcba5eq $00 script6934
	asm15withparam $6398 $03
	delay $0
	asm15 $62ef
	enableinput
	jump2byte script67cc
script6934:
	callscript script68d8
	jumpifmemoryset $cddb $80 script6946
script693d:
	asm15withparam $6398 $09
	delay $0
	enableinput
	checkabutton
	jump2byte script693d
script6946:
	asm15 $cb2
	callscript script68eb
	asm15withparam $6398 $07
	delay $6
	asm15withparam $6398 $08
	asm15 $630a
	scriptend
script6959:
	jumptable_memoryaddress $cfd1
.dw script6962
.dw script6966
.dw script696a
script6962:
	showtext $313f
	retscript
script6966:
	showtext $3140
	retscript
script696a:
	showtext $3141
	retscript
script696e:
	delay $6
	setmusic $ff
	asm15 $6320
	jumpifmemoryset $cddb $80 script6982
	jumpifsomething $44 script69ac
	jumpifsomething $59 script699a
script6982:
	jumpifsomething $5b script69ac
	asm15withparam $6398 $10
	delay $6
	giveitem $5b00
	delay $6
	asm15withparam $6398 $11
	delay $6
	asm15 $62ef
	enableinput
	jump2byte script67cc
script699a:
	showtext $241a
	delay $6
	giveitem $4400
	delay $6
	showtext $241b
	delay $6
	asm15 $62ef
	enableinput
	jump2byte script67cc
script69ac:
	asm15 $635b
	jumpifmemoryset $cddb $80 script69c0
	asm15withparam $6398 $13
	delay $0
	callscript script69d4
	delay $6
	jump2byte script69c9
script69c0:
	asm15withparam $6398 $12
	delay $0
	callscript script69f3
	delay $6
script69c9:
	asm15withparam $6398 $14
	delay $6
	asm15 $62ef
	enableinput
	jump2byte script67cc
script69d4:
	jumptable_memoryaddress $cfdd
.dw script69df
.dw script69df
.dw script69e3
.dw script69eb
script69df:
	giveitem $3400
	retscript
script69e3:
	asm15withparam $511f $0b
	showtext $0006
	retscript
script69eb:
	asm15withparam $511f $07
	showtext $0005
	retscript
script69f3:
	jumptable_memoryaddress $cfdd
.dw script69fe
.dw script69fe
.dw script6a02
.dw script6a06
script69fe:
	asm15 $6370
	retscript
script6a02:
	giveitem $3400
	retscript
script6a06:
	asm15withparam $511f $0c
	showtext $0007
	retscript
script6a0e:
	initnpchitbox
script6a0f:
	checkabutton
	callscript script6a15
	jump2byte script6a0f
script6a15:
	jumptable_interactionbyte $43
.dw script6a25
.dw script6a2a
.dw script6a2f
.dw script6a34
.dw script6a39
.dw script6a3e
.dw script6a43
script6a25:
	asm15withparam $63ab $40
	retscript
script6a2a:
	asm15withparam $63ab $41
	retscript
script6a2f:
	asm15withparam $63ab $42
	retscript
script6a34:
	asm15withparam $63ab $43
	retscript
script6a39:
	asm15withparam $63ab $44
	retscript
script6a3e:
	asm15withparam $63ab $45
	retscript
script6a43:
	asm15withparam $63ab $46
	retscript
script6a48:
	disableinput
	setcoords $58 $a8
	playsound $6f
	asm15withparam $24bb $06
	delay $5
	asm15withparam $24bb $06
	delay $5
	asm15withparam $24bb $06
	delay $8
	setspeed $50
	movenpcleft $11
	loadsprite $00
	delay $6
	showtext $2470
	delay $6
	showtext $2471
	delay $6
	movenpcright $11
	enableinput
	scriptend
script6a70:
	asm15withparam $6269 $04
	jumpifmemoryset $cddb $80 script45ef
script6a7a:
	asm15 $6523
	initnpchitbox
script6a7e:
	jumpifinteractionbyteeq $71 $01 script6a96
	asm15 $65bd
	jumpifmemoryset $cddb $80 script6a91
	asm15 $201d
	jump2byte script6a7e
script6a91:
	asm15 $653f
	jump2byte script6a7e
script6a96:
	jumpifinteractionbyteeq $42 $0d script70b0
	disableinput
	writeinteractionbyte $71 $00
	asm15 $5ca8
	asm15 $63e3
	delay $6
	asm15 $6556
	enableinput
	jump2byte script6a7e
script6aac:
	asm15withparam $6269 $04
	jumpifmemoryset $cddb $80 script45ef
	jump2byte script6ac2
script6ab8:
	asm15withparam $6271 $04
	jumpifmemoryset $cddb $80 script45ef
script6ac2:
	initnpchitbox
script6ac3:
	asm15 $64f6
	jumpifmemoryset $cddb $10 script6ace
	jump2byte script6ae0
script6ace:
	asm15withparam $651b $04
script6ad2:
	asm15 $64f6
	jumpifmemoryset $cddb $10 script6add
	jump2byte script6ae0
script6add:
	delay $0
	jump2byte script6ad2
script6ae0:
	asm15 $6509
script6ae3:
	jumpifinteractionbyteeq $71 $01 script6af5
	asm15 $64f6
	jumpifmemoryset $cddb $10 script6af3
	jump2byte script6ae3
script6af3:
	jump2byte script6ace
script6af5:
	jumpifinteractionbyteeq $42 $07 script6d1b
	jumpifinteractionbyteeq $42 $08 script6d71
	jumpifinteractionbyteeq $42 $0a script6eb0
	jumpifinteractionbyteeq $42 $0b script6f0d
	jumpifinteractionbyteeq $42 $0e script70c9
	disableinput
	writeinteractionbyte $71 $00
	asm15 $63f5
	delay $0
	enableinput
	jump2byte script6ae3
script6b19:
	asm15withparam $6269 $04
	jumpifmemoryset $cddb $80 script45ef
	initnpchitbox
	jumpifglobalflagset $2f script6b5f
script6b28:
	asm15withparam $651b $08
script6b2c:
	jumpifinteractionbyteeq $61 $01 script6b44
	jumpifinteractionbyteeq $61 $02 script6b49
script6b36:
	jumpifmemoryeq $cfdd $01 script6b72
	jumpifinteractionbyteeq $71 $01 script6b4e
	delay $0
	jump2byte script6b2c
script6b44:
	asm15 $661a
	jump2byte script6b36
script6b49:
	asm15 $661f
	jump2byte script6b36
script6b4e:
	disableinput
	asm15 $6509
	writeinteractionbyte $71 $00
	showtext $247b
	delay $6
	enableinput
	jump2byte script6b28
script6b5c:
	asm15 $6509
script6b5f:
	asm15withparam $6271 $04
	jumpifmemoryset $cddb $80 script6b6c
	setcoords $88 $28
script6b6c:
	checkabutton
	showtext $247c
	jump2byte script6b6c
script6b72:
	asm15withparam $651b $00
script6b76:
	jumpifmemoryeq $cfc0 $01 script6b5c
	delay $0
	jump2byte script6b76
script6b7f:
	asm15withparam $6269 $04
	jumpifmemoryset $cddb $80 script45ef
	initnpchitbox
	jumpifglobalflagset $2f script6c9c
script6b8e:
	asm15withparam $651b $08
script6b92:
	jumpifinteractionbyteeq $61 $01 script6bac
	jumpifinteractionbyteeq $61 $02 script6bb1
script6b9c:
	jumpifinteractionbyteeq $71 $01 script6c8e
	asm15 $658b
	jumpifmemoryset $cddb $10 script6bb6
	jump2byte script6b92
script6bac:
	asm15 $661a
	jump2byte script6b9c
script6bb1:
	asm15 $661f
	jump2byte script6b9c
script6bb6:
	disableinput
	asm15 $6355
	asm15withparam $5155 $03
	asm15 $655c
script6bc1:
	asm15 $201d
	asm15 $656a
	jumpifmemoryset $cddb $80 script6bcf
	jump2byte script6bc1
script6bcf:
	loadsprite $01
	setmovingdirection $08
script6bd3:
	asm15 $201d
	asm15 $657a
	jumpifmemoryset $cddb $80 script6be1
	jump2byte script6bd3
script6be1:
	delay $6
	asm15withparam $5854 $28
	delay $8
	showtext $247e
	delay $6
	jumpifcba5eq $00 script6bf9
script6bef:
	showtext $247f
	delay $6
	jumpifcba5eq $00 script6bf9
	jump2byte script6bef
script6bf9:
	showtext $2480
	delay $6
	writeinteractionbyte $50 $28
	loadsprite $03
	setmovingdirection $18
script6c04:
	asm15 $201d
	asm15 $6582
	jumpifmemoryset $cddb $80 script6c12
	jump2byte script6c04
script6c12:
	loadsprite $00
	setmovingdirection $00
script6c16:
	asm15 $201d
	asm15 $6571
	jumpifmemoryset $cddb $80 script6c24
	jump2byte script6c16
script6c24:
	writememory $cfdd $01
	asm15withparam $651b $03
	delay $5
	asm15 $6914
	setcounter1 $32
	asm15 $674e
	asm15withparam $6986 $00
	setcounter1 $16
	writeinteractionbyte $7a $01
	writeinteractionbyte $7b $ff
	asm15 $65c6
script6c44:
	asm15 $6929
	asm15 $65d3
	asm15 $65bd
	jumpifmemoryset $cddb $80 script6c55
	jump2byte script6c44
script6c55:
	playsound $79
	asm15withparam $3257 $04
script6c5b:
	asm15 $6929
	asm15 $65d3
	jumpifmemoryeq $c4ab $00 script6c6a
	delay $0
	jump2byte script6c5b
script6c6a:
	delay $6
	writememory $cfde $00
	spawninteraction $8b00 $50 $38
	writememory $cfc0 $01
	asm15 $6509
	asm15 $65e9
	delay $3
	asm15 $3299
	checkpalettefadedone
	asm15 $65e4
	setcounter1 $4b
	writememory $cfdf $01
	jump2byte script6ca1
script6c8e:
	disableinput
	asm15 $6509
	writeinteractionbyte $71 $00
	showtext $247d
	delay $6
	enableinput
	jump2byte script6b8e
script6c9c:
	spawninteraction $8b00 $50 $38
script6ca1:
	checkabutton
	showtext $2481
	jump2byte script6ca1
script6ca7:
	initnpchitbox
	jumpifroomflagset $80 script6d16
	jumpifroomflagset $40 script6cb5
	asm15 $6692
	jump2byte script6cbe
script6cb5:
	asm15 $6689
	jumpifmemoryset $cddb $80 script6d14
script6cbe:
	asm15withparam $651b $08
script6cc2:
	jumpifinteractionbyteeq $61 $01 script6cd4
	jumpifinteractionbyteeq $61 $02 script6cd9
script6ccc:
	jumpifinteractionbyteeq $71 $01 script6cde
	delay $0
	jump2byte script6cc2
script6cd4:
	asm15 $661a
	jump2byte script6ccc
script6cd9:
	asm15 $661f
	jump2byte script6ccc
script6cde:
	disableinput
	asm15 $6509
	writeinteractionbyte $71 $00
	jumpifroomflagset $40 script6d0f
	showtext $2472
	delay $6
	jumpifcba5eq $00 script6cf6
	showtext $2473
	jump2byte script6d0b
script6cf6:
	asm15 $6652
	jumpifmemoryset $cddb $80 script6d04
	showtext $2474
	jump2byte script6d0b
script6d04:
	playsound $5e
	showtext $2475
	orroomflags $40
script6d0b:
	delay $6
	enableinput
	jump2byte script6cbe
script6d0f:
	showtext $2476
	jump2byte script6d0b
script6d14:
	orroomflags $80
script6d16:
	setcoords $38 $58
	jump2byte script6ace
script6d1b:
	disableinput
	writeinteractionbyte $71 $00
	jumpifroomflagset $20 script6d5e
	jumpifmemoryeq $cfc0 $01 script6d5e
	setspeed $28
	showtext $2477
	delay $6
	jumpifcba5eq $00 script6d45
	asm15withparam $651b $00
	setmovingdirection $00
	checkcounter2iszero $11
	asm15withparam $651b $03
	loadsprite $03
	setmovingdirection $18
	jump2byte script6d55
script6d45:
	asm15withparam $651b $00
	setmovingdirection $00
	checkcounter2iszero $11
	asm15withparam $651b $01
	loadsprite $01
	setmovingdirection $08
script6d55:
	checkcounter2iszero $11
	writememory $cfc0 $01
	enableinput
	jump2byte script6ae0
script6d5e:
	showtext $2478
	delay $6
	enableinput
	jump2byte script6ae3
script6d65:
	initnpchitbox
	jumpifroomflagset $80 script6d6c
	jump2byte script6ace
script6d6c:
	setcoords $58 $78
	jump2byte script6ace
script6d71:
	loadscript $15 $6a85
script6d75:
	initnpchitbox
script6d76:
	jumpifinteractionbyteeq $71 $01 script6d84
	jumpifmemoryeq $cfdb $01 script6d96
	delay $0
	jump2byte script6d76
script6d84:
	disableinput
	writeinteractionbyte $71 $00
	showtext $24a8
	delay $6
	jumpifcba5eq $00 script6d96
	showtext $24a9
	enableinput
	jump2byte script6d76
script6d96:
	asm15withparam $5115 $04
	jumpifmemoryset $cddb $80 script6da7
script6da0:
	showtext $24aa
	enableinput
	checkabutton
	jump2byte script6da0
script6da7:
	asm15withparam $1778 $04
	showtext $24ab
	delay $6
	showtext $24ac
	delay $6
	asm15 $6698
	delay $9
	asm15 $326c
	checkpalettefadedone
	asm15 $677d
	asm15 $674e
	asm15 $19ad
	asm15 $6338
	asm15 $67eb
	spawninteraction $1600 $78 $38
	delay $5
	asm15 $6839
	delay $5
	asm15 $3299
	checkpalettefadedone
	delay $7
	setmusic $02
	showtext $24ad
	delay $6
	asm15 $679e
	setlinkcantmoveto00
	jump2byte script6d76
script6de5:
	initnpchitbox
	jumpifroomflagset $80 script6dfc
script6dea:
	jumpifinteractionbyteeq $71 $01 script6df2
	delay $0
	jump2byte script6dea
script6df2:
	disableinput
	writeinteractionbyte $71 $00
	showtext $24ae
	enableinput
	jump2byte script6dea
script6dfc:
	asm15 $67bd
	jumpifmemoryset $cddb $80 script6e07
	jump2byte script6e0a
script6e07:
	delay $0
	jump2byte script6dfc
script6e0a:
	asm15 $67bd
	jumpifmemoryset $cddb $80 script6e15
	jump2byte script6e0a
script6e15:
	disableinput
	asm15withparam $5176 $03
	writememory $ccd5 $01
	delay $7
	asm15 $67ae
	asm15 $67cc
	showtext $24af
	delay $6
	asm15 $326c
	checkpalettefadedone
	asm15 $19ad
	asm15 $633f
	asm15 $6820
	asm15 $6758
	delay $7
	asm15 $3299
	checkpalettefadedone
	setmusic $ff
	delay $7
	asm15 $67da
	jumpifmemoryset $cddb $80 script6e59
	asm15 $67e2
	jumpifmemoryset $cddb $10 script6e8c
	showtext $24b2
	delay $6
	jump2byte script6e97
script6e59:
	showtext $24b0
	delay $6
	callscript script6e63
	delay $6
	jump2byte script6e97
script6e63:
	jumptable_memoryaddress $cfd6
.dw script6e70
.dw script6e74
.dw script6e7c
.dw script6e84
.dw script6e88
script6e70:
	giveitem $5e00
	retscript
script6e74:
	asm15withparam $511f $0b
	showtext $0006
	retscript
script6e7c:
	asm15withparam $511f $0c
	showtext $0007
	retscript
script6e84:
	giveitem $3400
	retscript
script6e88:
	giveitem $0602
	retscript
script6e8c:
	showtext $24b1
	asm15withparam $511f $05
	showtext $0004
	delay $6
script6e97:
	showtext $24b3
	delay $6
	jumpifcba5eq $00 script6ea7
	jump2byte script6ea1
script6ea1:
	showtext $24b4
	enableinput
	jump2byte script6dea
script6ea7:
	writememory $cfdb $01
	jump2byte script6dea
script6ead:
	initnpchitbox
	jump2byte script6ace
script6eb0:
	disableinput
	writeinteractionbyte $71 $00
	jumpifinteractionbyteeq $7c $01 script6eff
	showtext $24c4
	delay $6
	jumpifroomflagset $40 script6f04
	asm15 $686d
	jumptable_interactionbyte $7e
.dw script6ecc
.dw script6ef5
.dw script6efa
script6ecc:
	showtext $24c6
	delay $6
	showtext $24c7
	delay $6
	showtext $24c8
	delay $6
	jumpifcba5eq $00 script6ee1
	showtext $24cb
	jump2byte script6f07
script6ee1:
	asm15withparam $1733 $5a
	showtext $24c9
	giveitem $5900
	orroomflags $40
	showtext $24ca
	writeinteractionbyte $7c $01
	jump2byte script6f07
script6ef5:
	showtext $24cd
	jump2byte script6f07
script6efa:
	showtext $24ce
	jump2byte script6f07
script6eff:
	showtext $24cc
	jump2byte script6f07
script6f04:
	showtext $24c5
script6f07:
	enableinput
	jump2byte script6ac3
script6f0a:
	initnpchitbox
	jump2byte script6ace
script6f0d:
	disableinput
	writeinteractionbyte $71 $00
	jumpifroomflagset $40 script6f42
	showtext $24b5
	delay $6
	jumpifsomething $5d script6f22
	showtext $24b6
	jump2byte script6f07
script6f22:
	showtext $24b7
	delay $6
	jumpifcba5eq $00 script6f2f
	showtext $24b8
	jump2byte script6f07
script6f2f:
	asm15withparam $1733 $5d
	orroomflags $40
	showtext $24b9
	delay $6
	jumpifcba5eq $00 script6f62
	showtext $24ba
	jump2byte script6f07
script6f42:
	showtext $24bf
	delay $6
	jumpifcba5eq $00 script6f4f
script6f4a:
	showtext $24c0
	jump2byte script6f07
script6f4f:
	asm15withparam $5115 $04
	jumpifmemoryset $cddb $80 script6f5e
script6f59:
	showtext $24c1
	jump2byte script6f07
script6f5e:
	asm15withparam $1778 $04
script6f62:
	showtext $24bb
	delay $6
	jumpifcba5eq $00 script6f74
script6f6a:
	showtext $24bd
	delay $6
	jumpifcba5eq $00 script6f74
	jump2byte script6f6a
script6f74:
	showtext $24bc
	delay $6
	asm15 $66f2
	delay $8
	showtext $24be
	delay $6
	asm15 $326c
	checkpalettefadedone
	asm15 $68e3
	asm15 $19ad
	asm15 $6346
	asm15 $674e
	asm15withparam $6a6a $04
	delay $2
	callscript script7052
	setcounter1 $18
	asm15 $3299
	checkpalettefadedone
	setmusic $02
	delay $7
	playsound $cc
	delay $8
	writememory $cfc0 $00
	asm15 $690a
	enableinput
script6fac:
	jumpifmemoryeq $cfc0 $01 script6fe2
	asm15 $68fe
	jumpifmemoryset $cddb $80 script6fbd
	jump2byte script6fac
script6fbd:
	asm15 $67c5
	jumpifmemoryset $cddb $80 script6fc8
	jump2byte script6fbd
script6fc8:
	disableinput
	writeinteractionbyte $71 $00
	playsound $65
	asm15withparam $5176 $02
	setcounter1 $02
	writememory $cc50 $02
	setcounter1 $50
	showtext $24e1
	callscript script702b
	jump2byte script700f
script6fe2:
	asm15 $67c5
	jumpifmemoryset $cddb $80 script6fed
	jump2byte script6fe2
script6fed:
	disableinput
	playsound $cc
	writeinteractionbyte $71 $00
	delay $8
	asm15withparam $5176 $02
	setcounter1 $02
	playsound $ab
	writememory $cc50 $08
	delay $8
	showtext $24e0
	callscript script702b
	showtext $24c3
	delay $6
	callscript script706a
	delay $6
script700f:
	showtext $24c2
	delay $6
	jumpifcba5eq $00 script7019
	jump2byte script6f4a
script7019:
	asm15withparam $5115 $04
	jumpifmemoryset $cddb $80 script7025
	jump2byte script6f59
script7025:
	asm15withparam $1778 $04
	jump2byte script6f74
script702b:
	delay $6
	asm15 $326c
	checkpalettefadedone
	asm15 $68f0
	asm15 $19ad
	asm15 $6346
	asm15 $3605
	asm15withparam $6a6a $00
	delay $2
	asm15 $69c8
	delay $2
	asm15 $69cf
	setcounter1 $18
	asm15 $3299
	checkpalettefadedone
	setmusic $ff
	delay $7
	retscript
script7052:
	getrandombits $7d $01
	jumpifinteractionbyteeq $7d $01 script7062
	asm15 $69ac
	delay $2
	asm15 $69b3
	retscript
script7062:
	asm15 $69ba
	delay $2
	asm15 $69c1
	retscript
script706a:
	jumptable_memoryaddress $cfd6
.dw script7079
.dw script707d
.dw script7085
.dw script708d
.dw script7091
.dw script7095
script7079:
	giveitem $4500
	retscript
script707d:
	asm15withparam $511f $0c
	showtext $0007
	retscript
script7085:
	asm15withparam $511f $07
	showtext $0005
	retscript
script708d:
	giveitem $3400
	retscript
script7091:
	giveitem $2d14
	retscript
script7095:
	giveitem $2d15
	retscript
script7099:
	asm15 $6423
	jumpifinteractionbyteeq $72 $ff script45ef
	initnpchitbox
script70a2:
	checkabutton
	showloadedtext
	jump2byte script70a2
script70a6:
	asm15 $6423
	jumpifinteractionbyteeq $72 $ff script45ef
	jump2byte script6a7a
script70b0:
	disableinput
	writeinteractionbyte $71 $00
	asm15 $5ca8
	showloadedtext
	asm15 $6556
	enableinput
	jump2byte script6a7e
script70be:
	asm15 $6423
	jumpifinteractionbyteeq $72 $ff script45ef
	initnpchitbox
	jump2byte script6ace
script70c9:
	disableinput
	writeinteractionbyte $71 $00
	showloadedtext
	enableinput
	jump2byte script6ae3
script70d1:
	initnpchitbox
	writeinteractionbyte $5c $00
script70d5:
	checkabutton
	disableinput
	asm15 $6888
	delay $0
	enableinput
	jump2byte script70d5
script70de:
	initnpchitbox
	checkabutton
	disableinput
	asm15 $5ca8
	showtextlowindex $10
	delay $6
	setspeed $05
	movenpcright $30
	delay $5
	writeinteractionbyte $7e $09
	delay $5
	writeinteractionbyte $7e $f7
	writeinteractionbyte $48 $01
	loadsprite $03
	delay $6
	showtextlowindex $11
	delay $6
	writeinteractionbyte $7e $ff
	giveitem $1501
	delay $6
	orroomflags $40
	enableinput
	jump2byte script7109
script7108:
	initnpchitbox
script7109:
	checkabutton
	showtextlowindex $12
	jump2byte script7109
script710e:
	asm15 $5180
	jumpifmemoryset $cddb $80 script45ef
	rungenericnpclowindex $13
script7119:
	initnpchitbox
	jumptable_interactionbyte $78
.dw script7126
.dw script7133
.dw script713f
.dw script7169
.dw script716e
script7126:
	settextid $2700
script7129:
	checkabutton
	asm15 $5ca8
script712d:
	showloadedtext
	enableinput
	loadsprite $02
	jump2byte script7129
script7133:
	checkabutton
	callscript script717f
	showtextlowindex $00
	delay $5
	settextid $2701
	jump2byte script712d
script713f:
	checkabutton
	callscript script717f
	delay $5
	asm15withparam $5854 $3c
	delay $6
	showtextlowindex $02
	delay $6
script714c:
	showtextlowindex $03
	jumpifcba5eq $00 script715e
	delay $5
	showtextlowindex $04
	enableinput
	loadsprite $02
	checkabutton
	callscript script717f
	jump2byte script714c
script715e:
	asm15withparam $1733 $52
	delay $5
	showtextlowindex $05
	delay $5
	setglobalflag $15
	enableinput
script7169:
	settextid $2706
	jump2byte script7129
script716e:
	disableinput
	setcounter1 $64
	writeinteractionbyte $60 $7f
	showtextlowindex $07
	delay $6
	setspeed $28
	movenpcright $40
	setglobalflag $26
	enableinput
	scriptend
script717f:
	disableinput
	asm15 $5ca8
	writeinteractionbyte $60 $7f
	retscript
script7187:
	loadscript $15 $6b3d
script718b:
	initnpchitbox
	setcollisionradii $0c $06
	jumpifsomething $52 script719b
script7193:
	checkabutton
	showtextlowindex $0c
	asm15 $6b7f
	jump2byte script7193
script719b:
	checkabutton
	showtextlowindex $0d
	asm15 $6b7f
	jump2byte script719b
script71a3:
	scriptend
script71a4:
	jumpifroomflagset $40 script71c7
	asm15 $6bc0
	jumpifmemoryset $cddb $80 script71c7
	setcollisionradii $04 $18
	checkcollidedwithlink_ignorez
	disableinput
	asm15 $517a
	delay $7
	spawninteraction $3701 $50 $b0
	checkmemoryeq $cfc0 $01
	delay $7
	orroomflags $40
	enableinput
script71c7:
	scriptend
script71c8:
	loadscript $15 $6be7
script71cc:
	asm15 $cb2
	delay $a
	playsound $21
	writeinteractionbyte $78 $04
script71d5:
	asm15 $3315
	checkpalettefadedone
	delay $2
	asm15 $3350
	checkpalettefadedone
	delay $2
	addinteractionbyte $78 $ff
	jumpifinteractionbyteeq $78 $00 script71e9
	jump2byte script71d5
script71e9:
	delay $6
	writememory $cfd1 $02
	delay $9
	writeinteractionbyte $78 $0a
script71f2:
	asm15withparam $330a $04
	checkpalettefadedone
	delay $1
	asm15withparam $334c $04
	checkpalettefadedone
	delay $1
	addinteractionbyte $78 $ff
	jumpifinteractionbyteeq $78 $00 script7208
	jump2byte script71f2
script7208:
	asm15withparam $330a $02
	checkpalettefadedone
	scriptend
script720e:
	setcollisionradii $02 $02
script7211:
	asm15 $6bc8
	delay $0
	jumpifinteractionbyteeq $78 $00 script7211
	disableinput
	asm15 $1e7b
	writeinteractionbyte $45 $01
	jumptable_interactionbyte $43
.dw script7229
.dw script7231
.dw script723a
script7229:
	asm15 $6be1
	giveitem $0304
	delay $6
	scriptend
script7231:
	giveitem $5200
	writememory $cc24 $00
	delay $6
	scriptend
script723a:
	giveitem $2e00
	delay $6
	scriptend
	.db $03
	.db $68
	.db $9e
	.db $01
	.db $28
	.db $02
	.db $70
	.db $04
	.db $43
	.db $fa
	.db $1d
	.db $03
	.db $04
	.db $45
	.db $fa
	.db $1d
	.db $01
	.db $04
	.db $53
	.db $f4
	.db $1e
	.db $03
	.db $04
	.db $55
	.db $f4
	.db $1e
	.db $01
	.db $01
	.db $28
	.db $02
	.db $70
	.db $03
	.db $43
	.db $1d
	.db $03
	.db $45
	.db $1d
	.db $03
	.db $53
	.db $1e
	.db $03
	.db $55
	.db $1e
	.db $01
	.db $28
	.db $02
	.db $70
	.db $03
	.db $44
	.db $1d
	.db $03
	.db $54
	.db $1e
	.db $01
	.db $28
	.db $02
	.db $4d
	.db $00
	checkmemoryeq $cfc0 $01
	loadsprite $04
	checkmemoryeq $cfc0 $03
	delay $8
	writememory $cfc0 $04
	setspeed $0a
	setmovingdirection $10
	scriptend
script728d:
	loadscript $15 $6cd7
script7291:
	loadscript $15 $6d03
script7295:
	loadscript $15 $6d14
script7299:
	asm15 $6d38
	delay $6
	loadsprite $03
	setcounter1 $10
	loadsprite $02
	setcounter1 $10
	showtext $5608
	asm15 $6d27
	setcounter1 $0c
	showtext $5609
	delay $2
	writeinteractionbyte $77 $01
	checkinteractionbyteeq $77 $00
	scriptend
script72b8:
	asm15withparam $c98 $98
	checkcounter2iszero $1e
	delay $6
	showtext $560a
	delay $4
	writeinteractionbyte $49 $10
	checkcounter2iszero $14
	delay $2
	scriptend
script72ca:
	delay $6
	spawninteraction $6e01 $b0 $78
	checkmemoryeq $cfd0 $02
	delay $6
	loadsprite $02
	showtext $1d04
	writememory $cfd0 $01
	checkmemoryeq $cfd0 $02
	delay $8
	checkcounter2iszero $1e
	checkmemoryeq $cfd0 $06
	loadsprite $03
	delay $2
	showtext $1d05
	delay $6
	writememory $cfd0 $01
	checkmemoryeq $cfd0 $02
	loadsprite $02
	delay $8
	loadsprite $0b
	asm15 $6d45
	delay $8
	scriptend
script7302:
	delay $6
	showtext $1308
	asm15withparam $c98 $1f
	loadsprite $04
	checkcounter2iszero $30
	writememory $cfd0 $02
	checkmemoryeq $cfd0 $01
	asm15withparam $6d5e $00
	delay $5
	showtext $1309
	writememory $cfd0 $02
	spawninteraction $6e02 $00 $34
	scriptend
script7328:
	delay $8
	loadsprite $04
	delay $6
	showtext $560d
	writememory $cfd0 $02
	delay $4
	asm15withparam $6d51 $00
	asm15withparam $6d51 $01
	asm15withparam $6d51 $02
	asm15withparam $6d51 $03
	asm15withparam $6d51 $04
	asm15withparam $6d51 $05
	checkmemoryeq $cfd0 $08
	delay $6
	spawninteraction $6e03 $b0 $78
	checkmemoryeq $cfd0 $03
	loadsprite $06
	checkmemoryeq $cfd0 $04
	loadsprite $07
	checkmemoryeq $cfd0 $05
	loadsprite $04
	checkmemoryeq $cfd0 $01
	delay $6
	writememory $d008 $02
	asm15withparam $6d5e $01
	delay $0
	asm15withparam $6d5e $01
	delay $4
	showtext $130a
	delay $4
	writememory $cfd0 $02
script7383:
	delay $c
	jump2byte script7383
script7386:
	showtext $2a0c
	writememory $cfd0 $03
	loadsprite $10
	checkcounter2iszero $10
	asm15withparam $6d6e $00
	checkcounter2iszero $08
	writememory $cfd0 $04
	asm15withparam $6d6e $01
	checkcounter2iszero $13
	writememory $d008 $03
	writememory $cfd0 $05
	checkcounter2iszero $10
	loadsprite $11
	writememory $d008 $00
	setcounter1 $10
	writememory $cfd0 $06
	setcounter1 $02
	showtext $2a0d
	jump2byte script7383
script73be:
	checkcounter2iszero $10
	asm15withparam $6d6e $04
	checkcounter2iszero $20
	asm15withparam $6d6e $02
	checkcounter2iszero $42
	asm15withparam $6d6e $03
	checkcounter2iszero $15
	loadsprite $0e
script73d4:
	checkmemoryeq $cfd0 $03
	loadsprite $0e
	checkmemoryeq $cfd0 $04
	asm15 $6d9e
	checkmemoryeq $cfd0 $05
	asm15 $6d84
	checkmemoryeq $cfd0 $01
	checkmemoryeq $cfd0 $02
script73f0:
	checkcounter2iszero $08
	delay $6
	jump2byte script73f0
script73f5:
	setcounter1 $2d
	checkcounter2iszero $10
	asm15withparam $6d6e $03
	checkcounter2iszero $20
	asm15withparam $6d6e $02
	checkcounter2iszero $42
	asm15withparam $6d6e $04
	checkcounter2iszero $15
	loadsprite $0e
	jump2byte script73d4
script740f:
	delay $9
	checkcounter2iszero $10
	asm15withparam $6d6e $04
	checkcounter2iszero $20
	asm15withparam $6d6e $02
	checkcounter2iszero $23
	asm15withparam $6d6e $03
	checkcounter2iszero $0a
	jump2byte script73d4
script7426:
	setcounter1 $87
	checkcounter2iszero $10
	asm15withparam $6d6e $03
	checkcounter2iszero $20
	asm15withparam $6d6e $02
	checkcounter2iszero $23
	asm15withparam $6d6e $04
	checkcounter2iszero $0a
	jump2byte script73d4
script743e:
	delay $b
	checkcounter2iszero $10
	asm15withparam $6d6e $04
	checkcounter2iszero $12
	asm15withparam $6d6e $02
	checkcounter2iszero $0f
	jump2byte script73d4
script744f:
	setcounter1 $e1
	checkcounter2iszero $10
	asm15withparam $6d6e $03
	checkcounter2iszero $12
	asm15withparam $6d6e $02
	checkcounter2iszero $0f
	writememory $cfd0 $08
	jump2byte script73d4
script7465:
	jumpifmemoryset $d13e $02 script746d
	jump2byte script7465
script746d:
	writeinteractionbyte $7a $3c
	callscript script74d6
	showtext $2200
	ormemory $d13e $04
script747a:
	jumpifmemoryset $d13e $10 script7482
	jump2byte script747a
script7482:
	checkmemoryeq $cdd1 $00
	playsound $c8
	delay $5
	playsound $c8
	delay $5
	playsound $c8
	asm15 $6dcc
	writememory $d103 $02
	checkmemoryeq $d13d $01
	writeinteractionbyte $7a $3c
	callscript script74d6
	showtext $2201
	writememory $d103 $03
	asm15 $6db6
	setlinkcantmoveto11
	asm15 $6dbe
	delay $8
	jumpifmemoryeq $cc01 $00 script74c1
	jumpifmemoryeq $c610 $0d script74bc
	jump2byte script74c1
script74bc:
	showtext $2204
	jump2byte script74c4
script74c1:
	showtext $2203
script74c4:
	ormemory $c648 $20
	setlinkcantmoveto00
	checkmemoryeq $cc2c $d1
	showtext $2205
	writememory $cc91 $00
	enablemenu
	scriptend
script74d6:
	jumpifinteractionbyteeq $7a $00 script74de
	delay $0
	jump2byte script74d6
script74de:
	retscript
script74df:
	loadscript $15 $6e73
script74e3:
	loadscript $15 $6e01
script74e7:
	checkmemoryeq $cc2c $d0
	checkmemoryeq $cc5c $00
	writememory $cbc3 $00
	disablemenu
	setlinkcantmoveto11
	command8a
	showtext $2104
	writememory $d103 $03
	writememory $cc91 $00
	scriptend
script7502:
	loadscript $15 $6e4b
script7506:
	loadscript $15 $6eef
script750a:
	loadscript $15 $6eb6
script750e:
	loadscript $15 $6df0
script7512:
	setcounter1 $46
	showtext $2f1b
	delay $0
	writememory $cfd0 $01
	loadsprite $00
script751e:
	checkcounter2iszero $40
	scriptend
script7521:
	checkmemoryeq $cfd0 $01
	loadsprite $02
	jump2byte script751e
script7529:
	delay $6
	checkcounter2iszero $10
	delay $5
	setspeed $28
	checkcounter2iszero $18
	checkmemoryeq $cfd0 $02
	asm15withparam $6f13 $02
	checkcounter2iszero $30
	scriptend
script753c:
	delay $8
	checkcounter2iszero $10
	delay $5
	setspeed $28
	checkcounter2iszero $10
	checkmemoryeq $cfd0 $02
	asm15withparam $6f13 $01
	checkcounter2iszero $18
	scriptend
script754f:
	delay $9
	checkcounter2iszero $10
	delay $5
	setspeed $28
	checkcounter2iszero $18
	asm15withparam $6f13 $03
	checkcounter2iszero $18
	loadsprite $04
	checkmemoryeq $cfd0 $02
	asm15withparam $6f13 $01
	checkcounter2iszero $18
	asm15withparam $6f13 $02
	checkcounter2iszero $20
	scriptend
script7570:
	delay $a
	checkcounter2iszero $10
	delay $5
	setspeed $28
	checkcounter2iszero $28
	delay $8
	showtext $3128
	giveitem $4900
	delay $6
	showtext $3129
	writememory $cfd0 $02
	asm15withparam $6f13 $02
	checkcounter2iszero $30
	asm15 $6f27
	scriptend
script7591:
	setlinkcantmoveto11
	asm15 $6f32
script7595:
	jumpifinteractionbyteeq $50 $00 script759d
	delay $0
	jump2byte script7595
script759d:
	showtext $1204
	ormemory $d13e $01
script75a4:
	jumpifmemoryset $d13e $10 script75ac
	jump2byte script75a4
script75ac:
	setlinkcantmoveto00
	spawnenemyhere $0017
	scriptend
script75b1:
	jumpifmemoryset $d13e $01 script75b9
	jump2byte script75b1
script75b9:
	asm15 $6f32
script75bc:
	jumpifinteractionbyteeq $50 $00 script75c4
	delay $0
	jump2byte script75bc
script75c4:
	showtext $1205
	ormemory $d13e $02
script75cb:
	jumpifmemoryset $d13e $08 script75d3
	jump2byte script75cb
script75d3:
	asm15 $6f32
script75d6:
	jumpifinteractionbyteeq $50 $00 script75de
	delay $0
	jump2byte script75d6
script75de:
	showtext $1207
	playsound $c8
	setmusic $2d
	ormemory $d13e $10
	spawnenemyhere $0017
	scriptend
script75ed:
	jumpifmemoryset $d13e $04 script75f5
	jump2byte script75ed
script75f5:
	asm15 $6f32
script75f8:
	jumpifinteractionbyteeq $50 $00 script7600
	delay $0
	jump2byte script75f8
script7600:
	showtext $1206
	ormemory $d13e $08
script7607:
	jumpifmemoryset $d13e $10 script760f
	jump2byte script7607
script760f:
	spawnenemyhere $0017
	scriptend
script7613:
	enableinput
	delay $0
	checktext
	checkabutton
	disableinput
	jumptable_interactionbyte $42
.dw script7628
.dw script766c
.dw script76b4
.dw script76c4
.dw script76dc
.dw script76dc
.dw script76dc
script7628:
	jumpifinteractionbyteeq $79 $00 script7649
	showtextlowindex $2b
	jumptable_memoryaddress $cba5
.dw script7636
.dw script76d4
script7636:
	jumpifinteractionbyteeq $78 $00 script7645
	asm15 $6f8e
	asm15 $6f75
	setglobalflag $36
	enableinput
	scriptend
script7645:
	showtextlowindex $2e
	jump2byte script7613
script7649:
	jumpifinteractionbyteeq $7a $00 script765c
	showtextlowindex $2c
	jumptable_memoryaddress $cba5
.dw script7657
.dw script76d4
script7657:
	asm15 $6f3d
	jump2byte script7613
script765c:
	showtextlowindex $27
	jumptable_memoryaddress $cba5
.dw script7665
.dw script76d8
script7665:
	showtextlowindex $28
	asm15 $6f4d
	jump2byte script7613
script766c:
	jumpifinteractionbyteeq $79 $00 script7691
	showtextlowindex $32
	jumptable_memoryaddress $cba5
.dw script767a
.dw script76d4
script767a:
	jumpifinteractionbyteeq $78 $00 script768d
	asm15 $6f8a
	asm15 $6f71
	setglobalflag $37
	delay $0
	checktext
	showtextlowindex $3b
	enableinput
	scriptend
script768d:
	showtextlowindex $34
	jump2byte script7613
script7691:
	jumpifinteractionbyteeq $7a $00 script76a4
	showtextlowindex $33
	jumptable_memoryaddress $cba5
.dw script769f
.dw script76d4
script769f:
	asm15 $6f43
	jump2byte script7613
script76a4:
	showtextlowindex $30
	jumptable_memoryaddress $cba5
.dw script76ad
.dw script76d8
script76ad:
	showtextlowindex $28
	asm15 $6f49
	jump2byte script7613
script76b4:
	showtextlowindex $36
	jumptable_memoryaddress $cba5
.dw script76bd
.dw script76d8
script76bd:
	showtextlowindex $28
	asm15 $6f49
	jump2byte script7613
script76c4:
	showtextlowindex $35
	jumptable_memoryaddress $cba5
.dw script76cd
.dw script76d8
script76cd:
	showtextlowindex $28
	asm15 $6f4d
	jump2byte script7613
script76d4:
	showtextlowindex $2d
	jump2byte script7613
script76d8:
	showtextlowindex $29
	jump2byte script7613
script76dc:
	showtextlowindex $39
	jumptable_memoryaddress $cba5
.dw script76e5
.dw script76d4
script76e5:
	jumpifinteractionbyteeq $7d $00 script76ee
	showtextlowindex $3a
	jump2byte script7613
script76ee:
	jumpifinteractionbyteeq $78 $00 script76fb
	asm15 $6f8a
	asm15 $6f64
	enableinput
	scriptend
script76fb:
	showtextlowindex $34
	jump2byte script7613
script76ff:
	loadscript $15 $6ff7
script7703:
	loadscript $15 $7139
script7707:
	loadscript $15 $71bd
script770b:
	loadscript $15 $71ef
script770f:
	jumpifmemoryeq $cfd0 $03 script771d
	checkmemoryeq $cfd0 $01
	checkpalettefadedone
	loadsprite $01
	scriptend
script771d:
	checkpalettefadedone
	delay $7
	loadsprite $04
	showtextlowindex $53
	delay $6
	writememory $cfd0 $04
	checkmemoryeq $cfd0 $05
	loadsprite $00
	checkmemoryeq $cfd0 $06
	loadsprite $03
	checkmemoryeq $cfd0 $07
	loadsprite $02
	checkmemoryeq $cfd0 $0b
	setcounter1 $50
	asm15withparam $5155 $00
	delay $7
	jumpifmemoryeq $cc01 $00 script774f
	showtextlowindex $57
	jump2byte script7751
script774f:
	showtextlowindex $54
script7751:
	setcounter1 $50
	loadsprite $00
	delay $7
	setcollisionradii $08 $08
	checksomething
script775a:
	showtextlowindex $55
	delay $5
	loadsprite $04
	delay $5
	showtextlowindex $56
	writememory $c6e6 $56
	delay $5
	loadsprite $00
	writememory $cfd0 $63
	enableinput
	checkabutton
	disableinput
	jump2byte script775a
script7772:
	checkmemoryeq $cfc0 $06
	delay $5
	loadsprite $02
	scriptend
script777a:
	checkmemoryeq $cfc0 $01
	loadsprite $03
	checkmemoryeq $cfc0 $02
	showtextlowindex $52
	delay $8
	writememory $cfc0 $03
	checkmemoryeq $cfc0 $08
	setcounter1 $96
	loadsprite $02
	scriptend
script7794:
	loadscript $15 $7287
script7798:
	loadscript $15 $72a4
script779c:
	jumpifmemoryeq $cc01 $01 script77a4
	rungenericnpclowindex $5c
script77a4:
	rungenericnpclowindex $60
script77a6:
	loadscript $15 $72d0
script77aa:
	jumpifglobalflagset $12 script77d1
	spawninteraction $6b04 $40 $50
	loadsprite $02
	setcollisionradii $08 $08
	checkmemoryeq $cfc0 $09
	setcounter1 $02
script77be:
	jumptable_memoryaddress $cdd1
.dw script77ce
.dw script77c7
.dw script77be
script77c7:
	loadsprite $01
	delay $9
	loadsprite $00
	delay $8
	checknoenemies
script77ce:
	loadsprite $01
	delay $9
script77d1:
	loadsprite $00
	setcollisionradii $08 $08
	checksomething
script77d7:
	checkabutton
	showtextlowindex $d5
	jump2byte script77d7
script77dc:
	disableinput
	writememory $cbae $04
	setmusic $1e
	delay $7
	writememory $cbe7 $77
	asm15 $1aa0
	asm15withparam $7318 $02
	checkpalettefadedone
	jumpifinteractionbyteeq $42 $01 script77fe
	spawninteraction $6200 $00 $00
	delay $c
	delay $b
	jump2byte script7805
script77fe:
	spawninteraction $6201 $00 $00
	delay $c
	delay $8
script7805:
	asm15withparam $7082 $00
	delay $0
	asm15 $1aa4
	asm15 $2d5f
	asm15 $7333
	asm15withparam $3284 $02
	checkpalettefadedone
	setmusic $ff
	orroomflags $40
	asm15 $3e53
	jumpifinteractionbyteeq $43 $07 script7826
	enableinput
	scriptend
script7826:
	spawninteraction $6603 $58 $a8
	scriptend
script782c:
	loadscript $15 $7355
script7830:
	loadscript $15 $7397
script7834:
	loadscript $15 $73ac
script7838:
	loadscript $15 $73c9
script783c:
	checkcfc0bit 0
	setmusic $f0
	delay $8
	asm15 $73d5
	delay $6
	asm15 $73d9
	delay $6
	asm15 $73dd
	delay $6
	settilehere $ee
script784e:
	setcounter1 $2d
	setmusic $ff
	playsound $4d
	enableinput
	scriptend
script7856:
	checkcfc0bit 0
	setmusic $f0
	delay $8
	playsound $70
	settilehere $af
	jump2byte script784e
script7860:
	checkcfc0bit 0
	setmusic $f0
	delay $8
	playsound $70
	settile $22 $ee
	settile $23 $ef
	jump2byte script784e
script786e:
	loadscript $15 $742b
script7872:
	loadscript $15 $746b
script7876:
	loadscript $15 $747b
script787a:
	loadscript $15 $7490
script787e:
	loadscript $15 $7501
script7882:
	loadscript $15 $7541
script7886:
	initnpchitbox
script7887:
	checkabutton
	showtext $5811
	jump2byte script7887
script788d:
	movenpcup $14
	delay $2
	movenpcright $32
	delay $0
	loadsprite $03
	delay $6
	scriptend
script7897:
	loadscript $15 $7567
script789b:
	delay $2
	loadsprite $06
script789e:
	checkabutton
	showtext $580b
	jump2byte script789e
script78a4:
	delay $6
	asm15withparam $3257 $02
	delay $0
	loadsprite $02
	asm15 $74d4
	setcounter1 $03
	asm15withparam $3284 $02
	delay $6
	asm15 $74b0
	showtext $580d
	loadsprite $04
	writememory $cfd3 $01
	delay $8
	asm15 $74f1
	delay $1
	showtext $580e
	callscript script78d5
	delay $8
	showtext $580f
	asm15 $74b7
	scriptend
script78d5:
	jumptable_memoryaddress $cfd0
.dw script78dc
.dw script78e0
script78dc:
	giveitem $4c01
	retscript
script78e0:
	jumptable_memoryaddress $cfd1
.dw script78ef
.dw script78e7
script78e7:
	giveitem $0501
	giveitem $0504
	jump2byte script78f5
script78ef:
	giveitem $0502
	giveitem $0505
script78f5:
	asm15withparam $1733 $41
	retscript
script78fa:
	asm15 $74d4
	asm15 $74f1
	asm15withparam $3284 $04
	delay $a
	asm15 $74b0
	showtext $580c
	asm15 $74b7
	loadsprite $02
	scriptend
script7911:
	initnpchitbox
script7912:
	checkabutton
	showtext $580f
	jump2byte script7912
script7918:
	loadsprite $03
	checkmemoryeq $cfc0 $01
	writeinteractionbyte $7f $01
	callscript script51ac
	writeinteractionbyte $7f $00
	writememory $cfc0 $02
	checkmemoryeq $cfc0 $05
script792f:
	writeinteractionbyte $7f $01
	callscript script51ac
	writeinteractionbyte $7f $00
	jumpifmemoryeq $cfc0 $06 script7941
	delay $6
	jump2byte script792f
script7941:
	asm15 $5ca8
	asm15withparam $51a6 $01
	checkmemoryeq $ccd4 $02
	asm15withparam $51ab $01
	checkmemoryeq $cfc0 $09
	asm15 $7592
	delay $0
	scriptend
script7959:
	loadsprite $01
	checkmemoryeq $cfc0 $03
	writeinteractionbyte $7f $01
	callscript script51ac
	writeinteractionbyte $7f $00
	writememory $cfc0 $04
	checkmemoryeq $cfc0 $05
	delay $6
	jump2byte script792f
script7973:
	loadscript $15 $75b3
script7977:
	checksomething
script7978:
	loadsprite $02
	checkabutton
	jumpifinteractionbyteeq $7f $00 script7982
	jump2byte script7abe
script7982:
	jumpifmemoryeq $cfd0 $01 script79b6
	showtextlowindex $0c
	jump2byte script7978
script798c:
	checksomething
script798d:
	loadsprite $02
	checkabutton
	jumpifinteractionbyteeq $7f $00 script7997
	jump2byte script7abe
script7997:
	jumpifmemoryeq $cfd0 $01 script79b6
	showtextlowindex $0d
	jump2byte script798d
script79a1:
	checksomething
script79a2:
	loadsprite $02
	checkabutton
	jumpifinteractionbyteeq $7f $00 script79ac
	jump2byte script7abe
script79ac:
	jumpifmemoryeq $cfd0 $01 script79b6
	showtextlowindex $0e
	jump2byte script79a2
script79b6:
	disableinput
	showtextlowindex $0f
	loadsprite $03
	writeinteractionbyte $44 $02
	scriptend
script79bf:
	disableinput
	callscript script7aa6
	showtextlowindex $0a
	writememory $cfd0 $02
	checkmemoryeq $cfd0 $03
	loadsprite $04
	checkmemoryeq $cfd0 $07
	loadsprite $05
	checkmemoryeq $cfd0 $08
	callscript script7aa6
	showtextlowindex $0b
	writememory $cfd0 $09
	checkmemoryeq $cfd0 $0a
	loadsprite $04
	delay $3
	writememory $cfd0 $0b
	setspeed $28
	writeinteractionbyte $49 $10
	checkcounter2iszero $30
	scriptend
script79f5:
	checkmemoryeq $cfd0 $02
	callscript script7aa6
	showtextlowindex $11
	writememory $cfd0 $03
	setspeed $28
	movenpcdown $10
	movenpcleft $30
	delay $9
	asm15withparam $759b $52
	movenpcleft $10
	delay $9
	asm15withparam $759b $51
	movenpcleft $10
	delay $9
	asm15withparam $759b $50
	movenpcright $50
	movenpcup $10
	writememory $cfd0 $07
	loadsprite $03
	callscript script7aa6
	delay $3
	showtextlowindex $12
	writememory $cfd0 $08
	checkmemoryeq $cfd0 $09
	showtextlowindex $11
	writememory $cfd0 $0a
	delay $9
	movenpcdown $30
	scriptend
script7a3d:
	callscript script7a74
	setspeed $28
	movenpcdown $10
	movenpcleft $20
	callscript script7a82
	movenpcright $40
	movenpcup $10
	loadsprite $02
	callscript script7a93
	delay $b
	movenpcdown $40
	scriptend
script7a56:
	callscript script7a74
	setspeed $28
	movenpcdown $28
	movenpcleft $10
	callscript script7a82
	movenpcright $30
	movenpcup $28
	loadsprite $02
	callscript script7a93
	delay $b
	delay $9
	movenpcdown $50
	setlinkcantmoveto00
	setglobalflag $25
	enablemenu
	scriptend
script7a74:
	checkmemoryeq $cfd0 $02
	setzspeed $fe00
	delay $5
	retscript
script7a7d:
	checkmemoryeq $cfd0 $03
	retscript
script7a82:
	checkmemoryeq $cfd0 $04
	movenpcleft $10
	checkmemoryeq $cfd0 $05
	movenpcleft $10
	checkmemoryeq $cfd0 $06
	retscript
script7a93:
	setzspeed $fe00
	delay $5
	retscript
script7a98:
	checkmemoryeq $cfd0 $09
	setzspeed $fe00
	delay $5
	retscript
script7aa1:
	checkmemoryeq $cfd0 $0a
	retscript
script7aa6:
	setzspeed $fe00
	playsound $53
	delay $5
	retscript
script7aad:
	initnpchitbox
script7aae:
	loadsprite $00
	checkabutton
	command8a
	jumpifglobalflagset $30 script7aba
	showtextlowindex $13
	jump2byte script7aae
script7aba:
	showtextlowindex $14
	jump2byte script7aae
script7abe:
	command8a
	showtextlowindex $10
	loadsprite $02
	checkabutton
	jump2byte script7abe
script7ac6:
	loadscript $15 $75e7
script7aca:
	checkabutton
	showtextnonexitable $3408
	jumpifcba5eq $00 script7adf
	orroomflags $40
script7ad4:
	showtext $340a
	checkabutton
	showtextnonexitable $3409
	jumpifcba5eq $01 script7ad4
script7adf:
	disableinput
	showtext $340b
	giveitem $4600
	delay $8
	showtext $340c
	enableinput
script7aeb:
	checkabutton
	showtext $340c
	jump2byte script7aeb
script7af1:
	checkabutton
	showtext $340d
	asm15withparam $31f9 $31
script7af9:
	checkabutton
	showtext $340e
	jump2byte script7af9
script7aff:
	checkabutton
	showtext $340f
	jump2byte script7aff
script7b05:
	checkabutton
	disableinput
	jumpifglobalflagset $6e script7b3d
	showtext $3435
	delay $6
	jumpifcba5eq $00 script7b18
	showtext $3436
	jump2byte script7b42
script7b18:
	showpasswordscreen $00
	delay $6
	jumpifmemoryeq $cc89 $00 script7b26
	showtext $3438
	jump2byte script7b42
script7b26:
	setglobalflag $64
	showtext $3437
	delay $6
	callscript script518b
	delay $6
	callscript script7b45
	delay $6
	showpasswordscreen $10
	setglobalflag $6e
	showtext $3439
	jump2byte script7b42
script7b3d:
	showpasswordscreen $10
	showtext $343a
script7b42:
	enableinput
	jump2byte script7b05
script7b45:
	jumptable_interactionbyte $43
.dw script7b52
.dw script7b4b
script7b4b:
	giveitem $0501
	giveitem $0504
	retscript
script7b52:
	giveitem $0502
	giveitem $0505
	retscript
script7b59:
	checkabutton
	showtext $3400
	jump2byte script7b59
script7b5f:
	checkabutton
	showtext $3401
	jumpifcba5eq $01 script7b5f
	disableinput
	delay $2
	spawninteraction $9c02 $34 $78
	asm15withparam $1733 $2f
	asm15withparam $c98 $00
	delay $6
	showtext $3402
	delay $2
	asm15withparam $c98 $00
	showtext $3403
	delay $8
	showtext $3404
	asm15withparam $31f9 $27
	enableinput
script7b8b:
	checkabutton
	showtext $3405
	jump2byte script7b8b
script7b91:
	checkabutton
	showtext $3406
	jump2byte script7b91
script7b97:
	checkabutton
	showtext $3407
	jump2byte script7b97
script7b9d:
	initnpchitbox
	setcollisionradii $14 $06
	jumpifroomflagset $40 script7bae
	checkabutton
	setlinkcantmoveto91
	showtextlowindex $00
	disableinput
	xorcfc0bit 0
	enableinput
	rungenericnpclowindex $01
script7bae:
	rungenericnpclowindex $04
script7bb0:
	disableinput
	loadscript $15 $766e
script7bb5:
	movenpcright $20
	delay $4
	movenpcleft $20
	delay $4
	asm15 $7654
	movenpcright $20
	delay $4
	asm15 $7654
	movenpcleft $20
	delay $4
	retscript
script7bc8:
	movenpcleft $10
	loadsprite $02
	delay $4
	movenpcleft $10
	loadsprite $02
	delay $4
	movenpcright $10
	loadsprite $02
	delay $4
	movenpcright $10
	loadsprite $02
	delay $4
	retscript
script7bdd:
	loadsprite $05
	setcollisionradii $08 $04
	checksomething
	checkabutton
	setlinkcantmoveto11
	loadsprite $06
	setcounter1 $dc
	showtext $3d05
	delay $8
	writememory $cc04 $0f
	scriptend
script7bf2:
	delay $8
	loadsprite $03
	delay $6
	loadsprite $01
	delay $6
	asm15 $76de
	loadsprite $02
	delay $5
	asm15 $76e6
	delay $2
	movenpcdown $11
	movenpcright $17
script7c07:
	delay $6
	xorcfc0bit 7
	scriptend
script7c0a:
	delay $8
	loadsprite $01
	delay $6
	loadsprite $03
	delay $6
	asm15 $76de
	loadsprite $02
	delay $5
	asm15 $76e6
	delay $2
	movenpcup $11
	movenpcleft $17
	jump2byte script7c07
script7c21:
	initnpchitbox
script7c22:
	checkabutton
	command8a
	showloadedtext
	loadsprite $00
	jump2byte script7c22
script7c29:
	asm15 $7700
	jumptable_memoryaddress $cfc1
.dw script7c29
.dw script7c33
script7c33:
	disableinput
	asm15 $76ec
	delay $6
	setspeed $28
	setmovingdirection $18
	asm15 $76f4
	delay $0
	movenpcup $20
	delay $6
	showtext $3430
	delay $6
	giveitem $4e00
	movenpcdown $80
	enableinput
	scriptend
script7c4e:
	initnpchitbox
	jumpifsomething $4e script7c56
	rungenericnpc $3431
script7c56:
	checkabutton
	disableinput
	showtext $3431
	delay $6
	asm15 $771a
	delay $8
	showtext $3432
	delay $6
	setstate $ff
	setspeed $50
	asm15 $770e
	jumptable_memoryaddress $cfc1
.dw script7c72
.dw script7c7b
script7c72:
	movenpcleft $18
	asm15 $7727
	movenpcup $30
	jump2byte script7c82
script7c7b:
	movenpcdown $10
	asm15 $772b
	movenpcright $40
script7c82:
	orroomflags $40
	enableinput
	scriptend
script7c86:
	loadsprite $05
	setcollisionradii $08 $04
	checksomething
	checkabutton
	setlinkcantmoveto11
	loadsprite $06
	setcounter1 $dc
	showtext $3d05
	delay $8
	writememory $cc04 $0f
	scriptend
script7c9b:
	loadscript $15 $775b
script7c9f:
	loadscript $15 $7781
script7ca3:
	loadscript $15 $7793
script7ca7:
	checkmemoryeq $cfd0 $01
	loadsprite $03
	checkcounter2iszero $11
	checkmemoryeq $cfd0 $02
	loadsprite $03
	checkmemoryeq $cfd0 $03
	loadsprite $02
	checkmemoryeq $cfd0 $05
	loadsprite $03
	checkmemoryeq $cfd0 $07
	writememory $d008 $01
	showtext $0607
	delay $6
	writememory $cfd0 $08
	setcounter1 $2d
	writememory $d008 $01
	movenpcup $11
	writememory $d008 $00
	movenpcleft $11
	movenpcup $41
	scriptend
script7ce2:
	loadscript $15 $77b3
script7ce6:
	checkmemoryeq $cfd0 $01
	setspeed $28
	movenpcup $24
	movenpcleft $08
	loadsprite $00
	writememory $cfd0 $02
	checkmemoryeq $cfd0 $03
	loadsprite $01
	writememory $cfd0 $04
	checkmemoryeq $cfd0 $06
	loadsprite $00
	checkmemoryeq $cfd0 $08
	movenpcup $38
	delay $6
	movenpcdown $08
	delay $6
	showtext $0608
	movenpcup $48
	enableinput
	scriptend
script7d17:
	checkcfc0bit 0
	asm15withparam $5854 $1e
	delay $a
	xorcfc0bit 1
	checkcfc0bit 5
	setspeed $14
	setmovingdirection $00
	checkcounter2iszero $31
	checkcfc0bit 6
	loadsprite $03
	delay $4
	loadsprite $01
	delay $4
	loadsprite $02
	checkcfc0bit 7
	asm15withparam $5854 $1e
	scriptend
script7d34:
	loadscript $15 $77de
script7d38:
	checkabutton
	jumpifsomething $55 script7d41
	showtextlowindex $11
	jump2byte script7d38
script7d41:
	showtextlowindex $12
	jumpifcba5eq $01 script7d38
	orroomflags $40
	scriptend
script7d4a:
	showtext $2f27
	delay $1
	checkcounter2iszero $19
	setcounter1 $10
	orroomflags $40
	setmusic $ff
	scriptend
script7d57:
	setmovingdirection $10
	checkcounter2iszero $21
	delay $2
	showtext $2f28
	delay $2
	asm15 $77e6
	setmovingdirection $00
	checkcounter2iszero $21
	orroomflags $40
	scriptend
script7d6a:
	settile $34 $01
	asm15withparam $c98 $70
	delay $6
	showtext $2f29
	delay $1
	checkcounter2iszero $11
	orroomflags $40
	scriptend
script7d7b:
	setspeed $14
	delay $b
script7d7e:
	setmovingdirection $18
	checkcounter2iszero $18
	setcounter1 $06
	setmovingdirection $08
	checkcounter2iszero $14
	delay $a
	jump2byte script7d7e
script7d8b:
	rungenericnpc $5711
script7d8e:
	jump2byte script7d8b
script7d90:
	delay $c
	loadsprite $01
	delay $6
	showtext $5601
	delay $6
	loadsprite $00
	delay $8
	writememory $cfd1 $02
	delay $b
	scriptend
script7da1:
	rungenericnpclowindex $0c
script7da3:
	rungenericnpclowindex $19
script7da5:
	rungenericnpclowindex $23
script7da7:
	loadscript $15 $78df
script7dab:
	loadscript $15 $7849
script7daf:
	rungenericnpclowindex $18
script7db1:
	jumpifglobalflagset $29 script7dbd
	rungenericnpclowindex $20
script7db7:
	jumpifglobalflagset $29 script7dbd
	rungenericnpclowindex $21
script7dbd:
	rungenericnpclowindex $22
script7dbf:
	rungenericnpclowindex $2c
script7dc1:
	loadscript $15 $7948
script7dc5:
	rungenericnpc $3608
script7dc8:
	rungenericnpc $3609
script7dcb:
	rungenericnpc $360a
script7dce:
	rungenericnpc $360b
script7dd1:
	initnpchitbox
	jumpifsomething $4f script7dd9
	rungenericnpc $360d
script7dd9:
	checkabutton
	disableinput
	playsound $f0
	orroomflags $80
	spawninteraction $8006 $52 $6a
	playsound $6c
	delay $8
	playsound $b0
	shakescreen $a0
	delay $a
	setcoords $58 $58
	asm15 $7972
	delay $8
	playsound $4d
	setmusic $ff
	asm15withparam $1733 $4f
	enableinput
	scriptend
script7dfd:
	enableinput
script7dfe:
	checkabutton
	jumpifsomething $54 script7e35
	jumpifglobalflagset $1b script7e0d
	setglobalflag $1b
	showtextnonexitablelowindex $00
	jump2byte script7e0f
script7e0d:
	showtextnonexitablelowindex $01
script7e0f:
	setlinkcantmoveto11
	jumptable_memoryaddress $cba5
.dw script7e1b
.dw script7e17
script7e17:
	showtextlowindex $03
	jump2byte script7e49
script7e1b:
	disableinput
	showtextlowindex $02
	checktext
	giveitem $5400
	delay $0
	checktext
	showtextlowindex $04
	callscript script7ebc
	delay $8
	writememory $d103 $02
	setlinkcantmoveto11
	writememory $d104 $0a
	jump2byte script7dfe
script7e35:
	disableinput
	jumpifinteractionbyteeq $7e $00 script7e47
	jumptable_interactionbyte $7d
.dw script7e50
.dw script7e88
.dw script7eae
script7e43:
	showtextlowindex $08
	jump2byte script7e49
script7e47:
	showtextlowindex $04
script7e49:
	checktext
	callscript script7ebc
	setlinkcantmoveto00
	jump2byte script7dfd
script7e50:
	jumpifglobalflagset $46 script7e43
	showtextnonexitablelowindex $06
	jumptable_memoryaddress $cba5
.dw script7e61
.dw script7e5d
script7e5d:
	showtextlowindex $03
	jump2byte script7e49
script7e61:
	setglobalflag $46
	showtextlowindex $07
script7e65:
	writeinteractionbyte $7f $01
	loadsprite $03
	showtextlowindex $0c
	checktext
script7e6d:
	jumpifinteractionbyteeq $7f $00 script7e75
	delay $0
	jump2byte script7e6d
script7e75:
	asm15 $7990
	delay $a
	giveitem $1904
	checktext
	asm15 $180c
	jumpifinteractionbyteeq $7d $02 script7eae
	setlinkcantmoveto00
	jump2byte script7dfd
script7e88:
	jumpifglobalflagset $14 script7e8e
	jump2byte script7e50
script7e8e:
	showtextlowindex $09
	jumptable_memoryaddress $cba5
.dw script7e9b
.dw script7e97
script7e97:
	showtextlowindex $0a
	jump2byte script7e49
script7e9b:
	showpasswordscreen $07
	delay $6
	jumpifmemoryeq $cc89 $00 script7ea8
	showtextlowindex $0d
	jump2byte script7e49
script7ea8:
	showtextlowindex $0e
	setglobalflag $6b
	jump2byte script7e65
script7eae:
	jumpifglobalflagset $14 script7eb4
	jump2byte script7e43
script7eb4:
	showpasswordscreen $17
	setglobalflag $75
	showtextlowindex $0f
	jump2byte script7e49
script7ebc:
	writeinteractionbyte $7f $01
	loadsprite $03
	showtextlowindex $05
	checktext
script7ec4:
	jumpifinteractionbyteeq $7f $00 script7ecc
	delay $0
	jump2byte script7ec4
script7ecc:
	retscript
script7ecd:
	showtext $0d09
	scriptend
script7ed1:
	loadscript $15 $79b2
script7ed5:
	loadscript $15 $7a38
script7ed9:
	asm15 $7a54
	jumpifmemoryset $cddb $80 script45ef
	initnpchitbox
	asm15 $7ab8
script7ee6:
	asm15withparam $7abd $00
	checkabutton
	disableinput
	showloadedtext
	delay $5
	jumpifcba5eq $00 script7ef9
	addinteractionbyte $72 $01
	showloadedtext
	enableinput
	jump2byte script7ee6
script7ef9:
	asm15 $7a8c
	jumpifmemoryset $cddb $80 script7f0c
script7f02:
	asm15withparam $7abd $02
	showloadedtext
	delay $5
	jumpifcba5eq $01 script7f02
script7f0c:
	asm15 $7aa2
	asm15withparam $7abd $03
script7f13:
	showloadedtext
	delay $5
	jumpifcba5eq $01 script7f13
	asm15withparam $7abd $04
	showloadedtext
	enableinput
	asm15 $7a8c
	jumpifmemoryset $cddb $80 script7ee6
	checkabutton
	disableinput
	jump2byte script7ef9
script7f2c:
	loadscript $15 $7acc
script7f30:
	asm15 $7a54
	jumpifmemoryset $cddb $80 script45ef
	asm15 $1e7b
	writeinteractionbyte $7e $01
script7f3f:
	asm15 $7b14
	jumpifmemoryset $cddb $80 script7f4b
	delay $0
	jump2byte script7f3f
script7f4b:
	playsound $73
	createpuff
	setcounter1 $20
	setmusic $0f
	asm15 $1e84
	writeinteractionbyte $7e $00
	jump2byte script7ed9
script7f5a:
	rungenericnpc $5111
script7f5d:
	asm15 $7b2f
	enableinput
	scriptend
script7f62:
	checkcfc0bit 0
	setmusic $f0
	delay $8
	asm15 $7b73
	setcounter1 $2d
	asm15 $7bb1
	delay $8
	setmusic $ff
	playsound $4d
	enableinput
	scriptend
script7f75:
	setcollisionradii $08 $08
	checksomething
script7f79:
	checkabutton
	setlinkcantmoveto91
	cplinkx $48
	writeinteractionbyte $77 $01
	showloadedtext
	jumpifcba5eq $01 script7f8d
	delay $6
	addinteractionbyte $72 $0a
	showloadedtext
	addinteractionbyte $72 $f6
script7f8d:
	setlinkcantmoveto00
	writeinteractionbyte $77 $00
	jump2byte script7f79

