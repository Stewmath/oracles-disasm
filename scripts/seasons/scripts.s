stubScript:
	scriptend
genericNpcScript:
	initcollisions
script45da:
	checkabutton
	showloadedtext
	jump2byte script45da
script45de:
	jumptable_memoryaddress $cc01
	.dw script45e5
	.dw script4625
script45e5:
	jumpifglobalflagset $28 script45eb
	rungenericnpclowindex $01
script45eb:
	initcollisions
script45ec:
	enableinput
	checkabutton
	setdisabledobjectsto91
	showtextlowindex $02
	jumpiftextoptioneq $00 script4606
script45f5:
	showtextlowindex $19
	jumpiftextoptioneq $00 script45ff
	showtextlowindex $05
	jump2byte script45ec
script45ff:
	asm15 $457f
	showtextlowindex $1a
	jump2byte script45ec
script4606:
	generateoraskforsecret $ff
	asm15 $451e
	jumptable_objectbyte $7f
	.dw script45f5
	.dw script45f5
	.dw script45f5
	.dw script461d
	.dw script4619
	.dw script45f5
script4619:
	showtextlowindex $0b
	jump2byte script45f5
script461d:
	asm15 $455e
	wait 30
	showtextlowindex $04
	jump2byte script45f5
script4625:
	initcollisions
	checkabutton
	setdisabledobjectsto91
	showtextlowindex $06
	jump2byte script4633
script462c:
	enableinput
	checkabutton
	disableinput
	jumpifglobalflagset $2c script4668
script4633:
	showtextlowindex $07
	jumpiftextoptioneq $00 script463d
	showtextlowindex $08
	jump2byte script462c
script463d:
	generateoraskforsecret $ff
	asm15 $451e
	jumptable_objectbyte $7f
	.dw script4650
	.dw script4654
	.dw script465c
	.dw script4650
	.dw script4660
	.dw script4664
script4650:
	showtextlowindex $05
	jump2byte script462c
script4654:
	asm15 $456b
	checkcfc0bit 1
	xorcfc0bit 1
	enableinput
	jump2byte script462c
script465c:
	showtextlowindex $0c
	jump2byte script462c
script4660:
	showtextlowindex $0b
	jump2byte script462c
script4664:
	showtextlowindex $1c
	jump2byte script462c
script4668:
	showtextlowindex $0a
	jump2byte script462c
script466c:
	stopifitemflagset
	checknoenemies
	spawnitem $3001
	scriptend
script4672:
	stopifitemflagset
	setcollisionradii $04 $06
	checknoenemies
	playsound $4d
	createpuff
	wait 30
	settilehere $f1
	setstate $ff
	scriptend
script4680:
	stopifroomflag80set
	checknoenemies
	orroomflag $80
	scriptend
script4685:
	initcollisions
script4686:
	enableinput
	checkabutton
	setdisabledobjectsto91
	showtext $551b
	jumpiftextoptioneq $00 script4693
	wait 8
	jump2byte script4686
script4693:
	asm15 $1a76 $0a
	wait 8
	jump2byte script4686
script469a:
	checknotcollidedwithlink_ignorez
	asm15 $4587
	retscript
script469f:
	setstate $ff
	scriptend
script46a2:
	setcollisionradii $0a $08
	setangle $10
	jump2byte script46bc
script46a9:
	setcollisionradii $08 $0a
	setangle $12
	jump2byte script46bc
script46b0:
	setcollisionradii $0a $08
	setangle $14
	jump2byte script46bc
script46b7:
	setcollisionradii $08 $0a
	setangle $16
script46bc:
	callscript script469a
script46bf:
	asm15 $45be
	jumptable_memoryaddress $cfc1
	.dw script46bf
	.dw script46cb
	.dw script46d1
script46cb:
	playsound $4d
	setstate $02
	jump2byte script46bf
script46d1:
	setstate $03
	jump2byte script46bf
script46d5:
	callscript script469a
	jumpifnoenemies script46e3
	setstate $03
	checknoenemies
	playsound $4d
	wait 8
	setstate $ff
script46e3:
	scriptend
script46e4:
	setstate $02
	scriptend
script46e7:
	setcollisionradii $0a $08
	setangle $10
	jumpifnoenemies script46e4
	jump2byte script46d5
script46f1:
	setcollisionradii $08 $0a
	setangle $12
	jumpifnoenemies script46e4
	jump2byte script46d5
script46fb:
	setcollisionradii $0a $08
	setangle $14
	jumpifnoenemies script46e4
	jump2byte script46d5
script4705:
	setcollisionradii $08 $0a
	setangle $16
	jumpifnoenemies script46e4
	jump2byte script46d5
script470f:
	asm15 $45ff
	jumptable_memoryaddress $cfc1
	.dw script470f
	.dw script4719
script4719:
	setstate $ff
script471b:
	callscript script469a
	setstate $03
	scriptend
script4721:
	asm15 $4612
	jumptable_memoryaddress $cfc1
	.dw script470f
	.dw script471b
script472b:
	setcollisionradii $10 $08
	setangle $18
	jump2byte script4721
script4732:
	setcollisionradii $08 $0e
	setangle $1a
	jump2byte script4721
script4739:
	setcollisionradii $0f $08
	setangle $1c
	jump2byte script4721
script4740:
	setcollisionradii $08 $0f
	setangle $1e
	jump2byte script4721
script4747:
	callscript script469a
	setstate $03
	xorcfc0bit 0
	scriptend
script474e:
	setcollisionradii $0c $08
	setangle $10
	jump2byte script4747
script4755:
	setcollisionradii $08 $0c
	setangle $12
	jump2byte script4747
script475c:
	setcollisionradii $0c $08
	setangle $14
	jump2byte script4747
script4763:
	setcollisionradii $08 $0c
	setangle $16
	jump2byte script4747
script476a:
	callscript script469a
	setstate $03
script476f:
	asm15 $4629
	jumptable_memoryaddress $cec0
	.dw script476f
	.dw script4779
script4779:
	wait 30
	playsound $4d
	setstate $ff
	scriptend
script477f:
	setcollisionradii $0a $08
	setangle $10
	setspeed $02
	jump2byte script476a
script4788:
	setcollisionradii $08 $0a
	setangle $16
	setspeed $02
	jump2byte script476a
script4791:
	setspeed SPEED_200
	setdisabledobjectsto11
	playsound $50
	movedown $10
	setangleandanimation $08
	jumptable_objectbyte $7e
	.dw script47a7
	.dw script47a0
script47a0:
	showtextlowindex $0c
	writeobjectbyte $7d $01
	jump2byte script47a9
script47a7:
	showtextlowindex $01
script47a9:
	moveup $10
	setangleandanimation $08
	enableallobjects
	scriptend
script47af:
	showtextlowindex $00
	scriptend
script47b2:
	showtextlowindex $20
	scriptend
script47b5:
	showtextlowindex $26
	scriptend
script47b8:
	jumptable_objectbyte $77
	.dw script47e2
	.dw script47ec
	.dw script47fe
	.dw script47f2
	.dw script47f8
	.dw script4808
	.dw script4814
	.dw script47e2
	.dw script47e2
	.dw script47e2
	.dw script47e2
	.dw script47e2
	.dw script47e2
	.dw script481e
	.dw script4828
	.dw script4832
	.dw script483c
	.dw script4846
	.dw script484c
	.dw script4852
script47e2:
	showtextnonexitablelowindex $1c
	callscript script485c
	ormemory $c63f $01
	scriptend
script47ec:
	showtextnonexitablelowindex $02
	callscript script485c
	scriptend
script47f2:
	showtextnonexitablelowindex $03
	callscript script485c
	scriptend
script47f8:
	showtextnonexitablelowindex $04
	callscript script485c
	scriptend
script47fe:
	showtextnonexitablelowindex $1d
	callscript script485c
	ormemory $c63f $02
	scriptend
script4808:
	showtextnonexitablelowindex $1e
	callscript script485c
	ormemory $c63f $08
	showtextlowindex $27
	scriptend
script4814:
	showtextnonexitablelowindex $1d
	callscript script485c
	ormemory $c63f $04
	scriptend
script481e:
	showtextnonexitablelowindex $1b
	callscript script485c
	ormemory $c643 $20
	scriptend
script4828:
	showtextnonexitablelowindex $1d
	callscript script485c
	ormemory $c640 $01
	scriptend
script4832:
	showtextnonexitablelowindex $23
	callscript script485c
	ormemory $c640 $02
	scriptend
script483c:
	showtextnonexitablelowindex $25
	callscript script485c
	ormemory $c640 $04
	scriptend
script4846:
	showtextnonexitablelowindex $29
	callscript script485c
	scriptend
script484c:
	showtextnonexitablelowindex $2a
	callscript script485c
	scriptend
script4852:
	showtextnonexitablelowindex $1d
	callscript script485c
	ormemory $c63f $20
	scriptend
script485c:
	jumpiftextoptioneq $00 script486c
	writememory $cbad $03
	writememory $cba0 $01
	writeobjectbyte $7a $ff
	scriptend
script486c:
	jumpifmemoryeq $ccec $00 script4880
	showtextlowindex $06
script4874:
	writeobjectbyte $7a $ff
	enableallobjects
	scriptend
script4879:
	callscript script4976
script487c:
	showtextlowindex $06
	jump2byte script4874
script4880:
	jumptable_objectbyte $78
	.dw script4886
	.dw script488f
script4886:
	writememory $cba0 $01
	writeobjectbyte $7a $01
	disablemenu
	retscript
script488f:
	writememory $cbad $02
	writememory $cba0 $01
	writeobjectbyte $7a $ff
	scriptend
script489b:
	setspeed SPEED_200
	playsound $50
	movedown $10
	moveright $18
	showtextlowindex $07
	moveleft $18
	moveup $10
	setangleandanimation $08
	enableallobjects
	scriptend
script48ad:
	setspeed SPEED_200
	moveup $10
	showtextlowindex $07
	setdisabledobjectsto11
	movedown $10
	setangleandanimation $08
	enableallobjects
	scriptend
script48ba:
	jumpifc6xxset $3f $80 script48c7
	showtextlowindex $0d
	ormemory $c63f $80
	jump2byte script48c9
script48c7:
	showtextlowindex $0e
script48c9:
	setdisabledobjectsto11
	jumpiftextoptioneq $00 script48d2
	showtextlowindex $11
	enableallobjects
	scriptend
script48d2:
	jumpifmemoryeq $ccec $01 script487c
	asm15 $463a
	setspeed SPEED_200
	setcollisionradii $06 $06
	moveup $08
	moveright $19
	moveup $1a
	moveright $11
	movedown $08
	jump2byte script48ef
script48ec:
	asm15 $463a
script48ef:
	setangleandanimation $08
	writeobjectbyte $45 $02
	writeobjectbyte $44 $05
	wait 60
	setangleandanimation $18
	wait 60
	setangleandanimation $10
	writeobjectbyte $7c $00
	showtextlowindex $10
	enableallobjects
	ormemory $ccea $80
	writeobjectbyte $45 $00
	writeobjectbyte $44 $05
	setdisabledobjectsto11
	showtextlowindex $17
	jumpiftextoptioneq $01 script491c
	jumpifmemoryeq $ccec $01 script4879
	jump2byte script48ec
script491c:
	callscript script4976
	enableallobjects
	scriptend
script4921:
	setdisabledobjectsto11
	jumptable_objectbyte $7c
	.dw script4930
	.dw script4930
	.dw script4930
	.dw script4944
	.dw script4954
	.dw script4964
script4930:
	showtextlowindex $13
	setangleandanimation $08
	writeobjectbyte $45 $02
	writeobjectbyte $44 $05
	wait 60
	setangleandanimation $18
	wait 60
	setangleandanimation $10
	showtextlowindex $18
	enableallobjects
	scriptend
script4944:
	showtextlowindex $12
	jumpiftextoptioneq $00 script4930
	showtextlowindex $14
	writeobjectbyte $7f $03
	callscript script4976
	enableallobjects
	scriptend
script4954:
	showtextlowindex $15
	jumpiftextoptioneq $00 script4930
	showtextlowindex $14
	writeobjectbyte $7f $02
	callscript script4976
	enableallobjects
	scriptend
script4964:
	showtextlowindex $16
	writeobjectbyte $7f $01
	callscript script4976
	enableallobjects
	scriptend
script496e:
	showtextlowindex $1a
	writeobjectbyte $45 $01
	writeobjectbyte $44 $05
script4976:
	moveup $08
	moveleft $11
	movedown $1a
	moveleft $19
	movedown $08
	setangleandanimation $08
	setcollisionradii $06 $14
	retscript
script4986:
	showtextlowindex $28
	scriptend
script4989:
	wait 60
	setstate $ff
	wait 10
	playsound $b4
	asm15 $3144
	wait 20
	playsound $b4
	asm15 $3144
	shakescreen 120
	asm15 $4677
	wait 20
	playsound $b4
	asm15 $3144
	checkpalettefadedone
	setdisabledobjectsto11
	settilehere $e1
	settileat $32 $e1
	settileat $34 $e1
	setstate $ff
	wait 60
	asm15 $3171
	checkpalettefadedone
	orroomflag $80
	setglobalflag $0d
	playsound $4d
	xorcfc0bit 0
	scriptend
script49bc:
	setcollisionradii $09 $09
	wait 30
	checkcollidedwithlink_onground
	ormemory $ccaf $80
	asm15 $2b8a
	setanimationfromangle
	setstate $ff
	playsound $06
	asm15 $4901
	wait 180
	wait 180
	playsound $b4
	wait 20
	playsound $b4
	wait 20
	playsound $b4
	wait 40
	playsound $b4
	asm15 $4909
	scriptend
script49e2:
	setcollisionradii $12 $06
	makeabuttonsensitive
script49e6:
	enableinput
	checkabutton
	disableinput
	jumpifglobalflagset $08 script4a44
	jumpifmemoryeq $cc01 $00 script4a0c
	jumpifmemoryset $c615 $01 script49fb
	jump2byte script4a0c
script49fb:
	showtextlowindex $3e
	jumpifobjectbyteeq $76 $01 script4a08
	showtextlowindex $3b
	asm15 $490f
	wait 1
script4a08:
	setdisabledobjectsto11
	checktext
	jump2byte script4a3b
script4a0c:
	showtextnonexitablelowindex $00
script4a0e:
	jumpiftextoptioneq $00 script4a16
	showtextnonexitablelowindex $3a
	jump2byte script4a0e
script4a16:
	jumpifobjectbyteeq $76 $01 script4a23
	showtextlowindex $3b
	asm15 $490f
	wait 1
	setdisabledobjectsto11
	checktext
script4a23:
	showtextlowindex $3f
	asm15 $49a6
	wait 1
	setdisabledobjectsto11
	checktext
	showtextlowindex $33
	asm15 $4927 $00
	wait 10
	showtextlowindex $13
	asm15 $4927 $01
	wait 10
	showtextlowindex $08
script4a3b:
	setglobalflag $08
	ormemory $c615 $01
	enableinput
	jump2byte script49e6
script4a44:
	asm15 $496b
	jumptable_objectbyte $7b
	.dw script4a51
	.dw script4a55
	.dw script4a59
	.dw script4a61
script4a51:
	showtextlowindex $36
	jump2byte script4a5b
script4a55:
	showtextlowindex $37
	jump2byte script4a5b
script4a59:
	showtextlowindex $39
script4a5b:
	checktext
	asm15 $49ae
	jump2byte script49e6
script4a61:
	showtextnonexitablelowindex $03
	jumpiftextoptioneq $00 script4a70
	jumpiftextoptioneq $01 script4a7b
	enableinput
	showtextlowindex $08
	jump2byte script49e6
script4a70:
	jumpifobjectbyteeq $77 $00 script4a98
	asm15 $4927 $00
	jump2byte script4a84
script4a7b:
	jumpifobjectbyteeq $78 $00 script4a9c
	asm15 $4927 $01
script4a84:
	wait 10
	jumpifglobalflagset $09 script4a8e
	showtextlowindex $08
	enableinput
	jump2byte script49e6
script4a8e:
	showtextlowindex $38
	checktext
	setglobalflag $89
	asm15 $49aa
	jump2byte script49e6
script4a98:
	showtextlowindex $14
	jump2byte script49e6
script4a9c:
	showtextlowindex $15
	jump2byte script49e6
script4aa0:
	showtextnonexitablelowindex $09
	jumpiftextoptioneq $00 script4aac
	writememory $cba0 $01
	enableinput
	scriptend
script4aac:
	wait 30
	showtextnonexitablelowindex $0a
	jumpiftextoptioneq $01 script4ab7
	showtextnonexitablelowindex $0b
	jump2byte script4ab9
script4ab7:
	showtextnonexitablelowindex $0c
script4ab9:
	jumpiftextoptioneq $00 script4aac
	writememory $cba0 $01
	scriptend
script4ac2:
	showtextnonexitablelowindex $1f
	jumpiftextoptioneq $01 script4ad6
	jump2byte script4ad0
script4aca:
	showtextnonexitablelowindex $24
	jumpiftextoptioneq $02 script4ad6
script4ad0:
	setdisabledobjectsto11
	asm15 $4944
	wait 1
	scriptend
script4ad6:
	showtextlowindex $2e
	scriptend
script4ad9:
	showtextlowindex $0f
	scriptend
script4adc:
	showtextlowindex $31
	scriptend
script4adf:
	showtextlowindex $2a
	scriptend
script4ae2:
	showtextnonexitablelowindex $18
	jumpiftextoptioneq $02 script4b04
	jumpiftextoptioneq $00 script4af7
	asm15 $4939
script4aef:
	showtextnonexitablelowindex $1d
	jumpiftextoptioneq $00 script4aef
	jump2byte script4b04
script4af7:
	asm15 $4934
	wait 1
	jumpifmemoryeq $cca3 $00 script4b07
	showtextlowindex $1e
	scriptend
script4b04:
	showtextlowindex $10
	scriptend
script4b07:
	showtextlowindex $27
	scriptend
script4b0a:
	setdisabledobjectsto11
	showtextlowindex $23
	asm15 $49ae
	wait 1
	checktext
	enableallobjects
	scriptend
script4b14:
	showtextlowindex $27
	scriptend
script4b17:
	wait 30
	showtext $550d
	jumpiftextoptioneq $00 script4b28
	asm15 $49b7
	asm15 $09b4
	wait 30
	jump2byte script4b30
script4b28:
	wait 30
	showtext $550e
	jumpiftextoptioneq $00 script4b17
script4b30:
	writememory $cfde $01
	scriptend
script4b35:
	writememory $cba0 $01
script4b39:
	checkabutton
	showtextnonexitablelowindex $19
	jumpiftextoptioneq $01 script4b35
	showtextlowindex $1a
	jump2byte script4b39
script4b44:
	writememory $cba0 $01
	checkabutton
	showtextnonexitablelowindex $20
	jumpiftextoptioneq $01 script4b44
script4b4f:
	showtextnonexitablelowindex $25
	jumpiftextoptioneq $01 script4b61
	jumpiftextoptioneq $02 script4b44
	showtextnonexitablelowindex $3d
	jumpiftextoptioneq $01 script4b44
	jump2byte script4b4f
script4b61:
	showtextnonexitablelowindex $26
	jumpiftextoptioneq $01 script4b44
	jump2byte script4b4f
script4b69:
	stopifroomflag80set
	checknoenemies
	orroomflag $80
	wait 20
	spawninteraction $7e00 $00 $00
script4b73:
	writememory $cbca $00
script4b77:
	scriptend
script4b78:
	stopifitemflagset
	checkmemoryeq $ccba $01
script4b7d:
	playsound $4d
	createpuff
	wait 15
	settilehere $f1
	scriptend
script4b84:
	jumpifroomflagset $80 script4b8b
	checknoenemies
	orroomflag $80
script4b8b:
	stopifitemflagset
	setcoords $58 $78
	spawnitem $2a00
	writememory $cbca $00
	scriptend
script4b97:
	stopifitemflagset
	wait 240
	wait 240
	wait 240
	wait 240
	wait 240
	wait 240
	wait 240
	stopifitemflagset
	playsound $98
	createpuff
	settilehere $a0
	scriptend
script4ba6:
	jumpifroomflagset $80 script4bad
	checknoenemies
	orroomflag $80
script4bad:
	stopifitemflagset
	setcoords $88 $78
script4bb1:
	spawnitem $2a00
	writememory $cbca $00
	scriptend
script4bb9:
	asm15 $5481
	checkmemoryeq $ccba $01
	asm15 $550c
	scriptend
script4bc4:
	asm15 $5487
	wait 1
	jump2byte script4bc4
script4bca:
	stopifroomflag80set
	checknoenemies
	orroomflag $80
	wait 20
	createpuff
	settilehere $44
	spawninteraction $7e00 $00 $00
	jump2byte script4b73
script4bd9:
	jumpifroomflagset $80 script4be2
	checknoenemies
	wait 60
	createpuff
	settilehere $45
script4be2:
	stopifitemflagset
	setcoords $20 $78
	jump2byte script4bb1
script4be8:
	asm15 $5512
	scriptend
script4bec:
	stopifroomflag80set
	checknoenemies
	orroomflag $80
	spawninteraction $0500 $38 $98
	wait 8
	settilehere $50
	playsound $4d
	scriptend
script4bfb:
	jumpifroomflagset $80 script4c06
	checkmemoryeq $cca9 $03
	orroomflag $80
	wait 8
script4c06:
	stopifitemflagset
	jump2byte script4b7d
script4c09:
	stopifitemflagset
	spawnitem $3102
	scriptend
script4c0e:
	stopifitemflagset
	checkmemoryeq $ccba $ff
	spawnitem $3001
	scriptend
script4c17:
	stopifroomflag80set
	checkmemoryeq $cca9 $02
	asm15 $54c7
	scriptend
script4c20:
	stopifitemflagset
	spawnitem $3100
	scriptend
script4c25:
	stopifroomflag80set
	wait 30
	checknoenemies
	orroomflag $80
	scriptend
script4c2b:
	stopifitemflagset
	checkmemoryeq $ccba $01
	spawnitem $3001
	scriptend
script4c34:
	stopifroomflag80set
	checkflagset $00 $cc31
	setangle $bc
script4c3b:
	asm15 $552a
	playsound $4d
	orroomflag $80
	createpuff
	wait 8
	settilehere $46
	scriptend
script4c47:
	stopifroomflag80set
	checkmemoryeq $ccba $01
	setangle $be
	jump2byte script4c3b
script4c50:
	setangle $02
script4c52:
	asm15 $56c5
	wait 8
	jump2byte script4c52
script4c58:
	stopifroomflag80set
	checkmemoryeq $cca9 $05
	setcounter1 $2d
	setangle $c4
	jump2byte script4c3b
script4c63:
	checkmemoryeq $ccba $01
	asm15 $5692
	scriptend
script4c6b:
	setangle $04
	jump2byte script4c52
script4c6f:
	asm15 $553d
	jumptable_memoryaddress $cfc1
	.dw script4c6f
	.dw script4c7b
	.dw script4c85
script4c7b:
	playsound $4d
	createpuff
	wait 30
	settilehere $44
	asm15 $5530
	scriptend
script4c85:
	wait 60
	playsound $5a
	wait 60
	asm15 $5692
	wait 60
	checknoenemies
	jump2byte script4c6f
script4c90:
	setangle $38
	jump2byte script4c52
script4c94:
	stopifroomflag80set
	checkflagset $06 $cc31
	asm15 $5534
	orroomflag $80
	playsound $4d
	createpuff
	wait 30
	settilehere $45
	scriptend
script4ca5:
	jumpifroomflagset $80 script4b8b
	checknoenemies
	orroomflag $80
	setcoords $08 $78
	createpuff
	wait 30
	settilehere $46
	jump2byte script4b8b
script4cb5:
	checkmemoryeq $ccba $01
	asm15 $5551
	stopifroomflag80set
	orroomflag $80
	scriptend
script4cc0:
	stopifitemflagset
	spawnitem $280a
script4cc4:
	jumpifroomflagset $20 script4ccb
	wait 8
	jump2byte script4cc4
script4ccb:
	loadscript $14 $4801
script4ccf:
	asm15 $5562
	scriptend
script4cd3:
	stopifroomflag40set
	checkmemoryeq $ccba $01
	asm15 $55d0
	scriptend
script4cdc:
	stopifitemflagset
	jumpifroomflagset $80 script4ce2
	scriptend
script4ce2:
	spawnitem $3001
	scriptend
script4ce6:
	setangle $01
script4ce8:
	jumpifroomflagset $40 script4cfe
	checkmemoryeq $ccba $01
	jump2byte script4cfa
script4cf2:
	asm15 $26ac
	jumpifroomflagset $40 script4cfe
	checknoenemies
script4cfa:
	orroomflag $40
	playsound $4d
script4cfe:
	wait 8
	createpuff
	wait 15
	asm15 $56d7
	scriptend
script4d05:
	stopifitemflagset
	jumpifroomflagset $40 script4b7d
	checkmemoryeq $ccba $01
	orroomflag $40
	jump2byte script4b7d
script4d12:
	asm15 $5578
	scriptend
script4d16:
	stopifitemflagset
	jumptable_memoryaddress $ccba
	.dw script4d1e
	.dw script4d23
script4d1e:
	asm15 $55ab
	jump2byte script4d16
script4d23:
	asm15 $55b9
	jump2byte script4d16
script4d28:
	loadscript $14 $47d4
script4d2c:
	loadscript $14 $47eb
script4d30:
	stopifroomflag40set
	asm15 $55ed
	jumptable_memoryaddress $cfc1
	.dw script4d3b
	.dw script4d3f
script4d3b:
	loadscript $14 $4770
script4d3f:
	playsound $4d
	orroomflag $40
	scriptend
script4d44:
	stopifroomflag40set
	asm15 $55fd
	jumptable_memoryaddress $cfc1
	.dw script4d4f
	.dw script4d3f
script4d4f:
	loadscript $14 $47a2
script4d53:
	stopifroomflag80set
	checknoenemies
	orroomflag $80
	asm15 $54d2
	scriptend
script4d5b:
	stopifroomflag80set
	checkmemoryeq $cc31 $01
	asm15 $54df
	scriptend
script4d64:
	stopifroomflag80set
	checkmemoryeq $ccba $01
	asm15 $54ea
	scriptend
script4d6d:
	stopifroomflag80set
	writeobjectbyte $48 $96
script4d71:
	asm15 $5601
	jumptable_objectbyte $49
	.dw script4d71
	.dw stubScript
script4d7a:
	asm15 $56ee $a0
	stopifroomflag80set
	checkmemoryeq $cca9 $07
script4d83:
	orroomflag $80
	createpuff
	wait 30
	settilehere $44
	playsound $4d
	scriptend
script4d8c:
	stopifroomflag40set
	asm15 $5635
script4d90:
	wait 240
	asm15 $5641
	jump2byte script4d90
script4d96:
	stopifroomflag80set
script4d97:
	wait 8
	asm15 $5678
	jumptable_memoryaddress $cfc1
	.dw script4d97
	.dw script4da2
script4da2:
	orroomflag $80
	playsound $4d
	createpuff
	wait 20
	settilehere $45
	scriptend
script4dab:
	stopifroomflag80set
	checkmemoryeq $ccba $01
	asm15 $54f5
	scriptend
script4db4:
	stopifroomflag80set
	checkmemoryeq $ccba $07
	jump2byte script4d83
script4dbb:
	stopifitemflagset
	checkmemoryeq $ccba $07
	jump2byte script4b7d
script4dc2:
	stopifroomflag40set
	checknoenemies
	orroomflag $40
	playsound $4d
	scriptend
script4dc9:
	asm15 $56e0
	scriptend
script4dcd:
	stopifitemflagset
	checkmemoryeq $cca9 $01
	jump2byte script4b7d
script4dd4:
	stopifitemflagset
	checkmemoryeq $cca9 $02
	jump2byte script4b7d
script4ddb:
	setangle $3f
	jump2byte script4c52
script4ddf:
	stopifitemflagset
	checkmemoryeq $ccba $ff
	wait 60
	checknoenemies
	spawnitem $3001
	scriptend
script4dea:
	checkcfc0bit 0
	disableinput
	setmusic $f0
	wait 60
	shakescreen 120
	wait 60
	orroomflag $80
	setstate $ff
	scriptend
script4df7:
	disableinput
	orroomflag $40
	writememory $cbae $04
	setmusic $1e
	wait 40
	asm15 $1a66
	asm15 $571a $02
	checkpalettefadedone
	spawninteraction $4800 $40 $50
	wait 240
	wait 60
	callscript script4e25
	asm15 $1a6a
	asm15 $2ca6
	asm15 $315c $02
	checkpalettefadedone
	setmusic $ff
	enableinput
	asm15 $576c
	scriptend
script4e25:
	jumptable_objectbyte $42
	.dw script4e3d
	.dw script4e42
	.dw script4e47
	.dw script4e4c
	.dw script4e5e
	.dw script4e70
	.dw script4e75
	.dw script4e7a
	.dw script4e7f
	.dw script4e83
	.dw script4e7a
script4e3d:
	asm15 $5735 $04
	retscript
script4e42:
	asm15 $5735 $07
	retscript
script4e47:
	asm15 $5735 $09
	retscript
script4e4c:
	asm15 $5744
	jumpifobjectbyteeq $7f $01 script4e59
	asm15 $5735 $0b
	retscript
script4e59:
	asm15 $5735 $10
	retscript
script4e5e:
	asm15 $5748
	jumpifobjectbyteeq $7f $01 script4e6b
	asm15 $5735 $0d
	retscript
script4e6b:
	asm15 $5735 $0f
	retscript
script4e70:
	asm15 $5735 $12
	retscript
script4e75:
	asm15 $5735 $14
	retscript
script4e7a:
	asm15 $5735 $16
	retscript
script4e7f:
	showtext $1736
	retscript
script4e83:
	showtext $5007
	retscript
script4e87:
	setcollisionradii $14 $20
script4e8a:
	asm15 $5757
	jumptable_memoryaddress $cfc0
	.dw script4e8a
	.dw script4e94
script4e94:
	giveitem $0503
	disableinput
	wait 60
	setstate $ff
	orroomflag $80
	checkobjectbyteeq $44 $01
	playsound $4d
	wait 60
	enableinput
	scriptend
script4ea5:
	loadscript $14 $4830
script4ea9:
	loadscript $14 $4849
script4ead:
	jumpifroomflagset $40 script4f1b
	jumpifitemobtained $7 script4ed2
	setcoords $28 $70
	setcollisionradii $04 $10
	makeabuttonsensitive
script4ebc:
	checkabutton
	disableinput
	writememory $cfc0 $00
	asm15 $579b
	xorcfc0bit 0
	playsound $c9
	checkcfc0bit 1
	wait 40
	showtextlowindex $11
	wait 8
	xorcfc0bit 2
	wait 30
	enableinput
	jump2byte script4ebc
script4ed2:
	setcollisionradii $08 $04
	checkcollidedwithlink_onground
	disableinput
	asm15 $5797
	xorcfc0bit 0
	playsound $c9
	checkcfc0bit 1
	callscript script4f90
	asm15 $5788
	wait 10
	playsound $b4
	asm15 $3144
	wait 20
	playsound $b4
	asm15 $3144
	wait 20
	playsound $b4
	asm15 $3144
	checkpalettefadedone
	xorcfc0bit 2
	wait 20
	asm15 $315c $04
	checkpalettefadedone
	callscript script4faa
	asm15 $57b6
	jumptable_objectbyte $7f
	.dw script4f18
	.dw script4f0c
	.dw script4f11
script4f0c:
	wait 30
	showtextlowindex $0e
	jump2byte script4f18
script4f11:
	wait 30
	writememory $cbae $10
	showtextlowindex $0f
script4f18:
	orroomflag $40
	enableinput
script4f1b:
	setcoords $28 $70
	setcollisionradii $04 $10
	makeabuttonsensitive
script4f22:
	checkabutton
	disableinput
	writememory $cfc0 $00
	asm15 $579b
	xorcfc0bit 0
	playsound $c9
	checkcfc0bit 1
	wait 40
	callscript script4f39
	wait 8
	xorcfc0bit 2
	wait 30
	enableinput
	jump2byte script4f22
script4f39:
	jumpifglobalflagset $28 script4f5c
	jumpifobjectbyteeq $7e $01 script4f76
	jumptable_objectbyte $43
	.dw script4f4c
	.dw script4f4f
	.dw script4f52
	.dw script4f59
script4f4c:
	showtextlowindex $09
	retscript
script4f4f:
	showtextlowindex $07
	retscript
script4f52:
	writememory $cbae $10
	showtextlowindex $0b
	retscript
script4f59:
	showtextlowindex $05
	retscript
script4f5c:
	jumptable_objectbyte $43
	.dw script4f66
	.dw script4f69
	.dw script4f6c
	.dw script4f73
script4f66:
	showtextlowindex $18
	retscript
script4f69:
	showtextlowindex $19
	retscript
script4f6c:
	writememory $cbae $10
	showtextlowindex $1a
	retscript
script4f73:
	showtextlowindex $1b
	retscript
script4f76:
	jumptable_objectbyte $43
	.dw script4f80
	.dw script4f83
	.dw script4f86
	.dw script4f8d
script4f80:
	showtextlowindex $14
	retscript
script4f83:
	showtextlowindex $15
	retscript
script4f86:
	writememory $cbae $10
	showtextlowindex $16
	retscript
script4f8d:
	showtextlowindex $17
	retscript
script4f90:
	jumptable_objectbyte $43
	.dw script4f9a
	.dw script4f9d
	.dw script4fa0
	.dw script4fa7
script4f9a:
	showtextlowindex $08
	retscript
script4f9d:
	showtextlowindex $06
	retscript
script4fa0:
	writememory $cbae $10
	showtextlowindex $0a
	retscript
script4fa7:
	showtextlowindex $04
	retscript
script4faa:
	jumptable_objectbyte $43
	.dw script4fb4
	.dw script4fb8
	.dw script4fbc
	.dw script4fc4
script4fb4:
	giveitem $0702
	retscript
script4fb8:
	giveitem $0703
	retscript
script4fbc:
	writememory $cbae $10
	giveitem $0704
	retscript
script4fc4:
	giveitem $0705
	retscript
script4fc8:
	initcollisions
script4fc9:
	enableinput
	checkabutton
	disableinput
	jumpifroomflagset $20 script4fd9
	showtext $310b
	wait 20
	giveitem $3404
	jump2byte script4fde
script4fd9:
	showtextlowindex $31
	scriptend
script4fdc:
	jump2byte script4fc9
script4fde:
	wait 20
	showtext $310c
	jump2byte script4fc9
script4fe4:
	initcollisions
script4fe5:
	enableinput
	checkabutton
	disableinput
	jumpifglobalflagset $63 script5030
	showtext $3102
	jumpiftextoptioneq $00 script4fff
	wait 20
	showtext $3103
	jump2byte script4fe5
script4ff9:
	wait 20
	showtext $3104
	jump2byte script4fe5
script4fff:
	generateoraskforsecret $29
	wait 20
	jumptable_memoryaddress $cca3
	.dw script5009
	.dw script4ff9
script5009:
	showtext $3105
	wait 20
	jumpifitemobtained $2c script501a
	showtext $3109
	wait 20
	giveitem $2c03
	jump2byte script502f
script501a:
	showtext $3108
	wait 20
	asm15 $59c4
	jumpifmemoryeq $cba8 $05 script502c
	giveitem $2c01
	jump2byte script502f
script502c:
	giveitem $2c02
script502f:
	wait 20
script5030:
	generateoraskforsecret $39
script5032:
	showtext $3106
	wait 20
	jumpiftextoptioneq $01 script5032
	setglobalflag $63
	showtext $3107
	jump2byte script4fe5
script5041:
	initcollisions
	jumpifroomflagset $40 script506c
script5046:
	checkabutton
	showtext $0b1a
	jumpiftradeitemeq $02 script5050
	jump2byte script5046
script5050:
	disableinput
	wait 30
script5052:
	showtext $0b1b
	jumpiftextoptioneq $00 script5062
	wait 30
	showtext $0b1e
	enableinput
	checkabutton
	disableinput
	jump2byte script5052
script5062:
	wait 30
	showtext $0b1c
	giveitem $4103
	orroomflag $40
	enableinput
script506c:
	checkabutton
	showtext $0b1d
	jump2byte script506c
script5072:
	setcollisionradii $0a $06
	makeabuttonsensitive
	jumpifroomflagset $40 script5099
script507a:
	jumptable_memoryaddress $cca9
	.dw script5081
	.dw script508e
script5081:
	jumpifobjectbyteeq $71 $00 script507a
	writeobjectbyte $71 $00
	showtext $0b00
	jump2byte script507a
script508e:
	disableinput
	wait 40
	showtext $0b01
	giveitem $4100
	orroomflag $40
	enableinput
script5099:
	checkabutton
	disableinput
	writeobjectbyte $73 $0b
	getrandombits $72 $0f
	addobjectbyte $72 $02
	showloadedtext
	enableinput
	jump2byte script5099
script50a8:
	rungenericnpc $1600
script50ab:
	rungenericnpc $1602
script50ae:
	rungenericnpc $1603
script50b1:
	rungenericnpc $1604
script50b4:
	rungenericnpc $1605
script50b7:
	rungenericnpc $1606
script50ba:
	rungenericnpc $1607
script50bd:
	initcollisions
	jumpifroomflagset $40 script50e8
script50c2:
	checkabutton
	showtext $0b12
	jumpiftradeitemeq $00 script50cc
	jump2byte script50c2
script50cc:
	disableinput
	wait 30
script50ce:
	showtext $0b13
	jumpiftextoptioneq $00 script50de
	wait 30
	showtext $0b16
	enableinput
	checkabutton
	disableinput
	jump2byte script50ce
script50de:
	wait 30
	showtext $0b14
	giveitem $4101
	orroomflag $40
	enableinput
script50e8:
	asm15 $57ce
	jumptable_objectbyte $7c
	.dw script50f1
	.dw script50f7
script50f1:
	checkabutton
	showtext $0b15
	jump2byte script50f1
script50f7:
	spawninteraction $4501 $68 $78
script50fc:
	checkabutton
	showtext $0b17
	jump2byte script50fc
script5102:
	writeobjectbyte $5c $01
	rungenericnpc $3e05
script5108:
	wait 240
	jump2byte script5108
script510b:
	writeobjectbyte $5c $01
script510e:
	wait 240
	jump2byte script510e
script5111:
	rungenericnpc $3e07
script5114:
	settextid $1903
	jumpifglobalflagset $16 script511e
	settextid $1900
script511e:
	initcollisions
script511f:
	checkabutton
	setdisabledobjectsto11
	cplinkx $49
	setanimationfromobjectbyte $49
	showloadedtext
	enableallobjects
	jump2byte script511f
script512a:
	jumpifglobalflagset $16 script5134
	initcollisions
script512f:
	settextid $1901
	jump2byte script511f
script5134:
	setcoords $58 $38
	initcollisions
	settextid $1903
	checkabutton
	setdisabledobjectsto11
	cplinkx $49
	setanimationfromobjectbyte $49
	showloadedtext
	enableallobjects
	jump2byte script512f
script5146:
	settextid $1902
	jump2byte script511e
script514b:
	settextid $1904
	jump2byte script511e
script5150:
	settextid $1905
	jump2byte script511e
script5155:
	rungenericnpc $0f00
script5158:
	rungenericnpc $0f01
script515b:
	rungenericnpc $0f03
script515e:
	rungenericnpc $0f02
script5161:
	rungenericnpc $0f04
script5164:
	rungenericnpc $0f05
script5167:
	rungenericnpc $0f06
script516a:
	rungenericnpc $0f07
script516d:
	rungenericnpc $0f08
script5170:
	writeobjectbyte $5c $02
	rungenericnpc $0e21
script5176:
	initcollisions
script5177:
	checkabutton
	showloadedtext
	asm15 $57e0
	jump2byte script5177
script517e:
	rungenericnpc $1b00
script5181:
	rungenericnpc $1b01
script5184:
	rungenericnpc $1b02
script5187:
	rungenericnpc $1b03
script518a:
	rungenericnpc $1200
script518d:
	initcollisions
script518e:
	checkabutton
	setdisabledobjectsto91
	showtext $1201
	jumpiftextoptioneq $01 script519d
	wait 30
	showtext $1202
	jump2byte script51a1
script519d:
	wait 30
	showtext $1203
script51a1:
	enableallobjects
	jump2byte script518e
script51a4:
	rungenericnpc $1204
script51a7:
	rungenericnpc $1205
script51aa:
	rungenericnpc $1206
script51ad:
	rungenericnpc $1206
script51b0:
	rungenericnpc $1208
script51b3:
	settextid $1000
	jumpifmemoryeq $cc01 $01 script51c4
script51bc:
	setcollisionradii $03 $0b
	makeabuttonsensitive
script51c0:
	checkabutton
	showloadedtext
	jump2byte script51c0
script51c4:
	settextid $1001
	jump2byte script51bc
script51c9:
	settextid $1002
	jump2byte script51bc
script51ce:
	settextid $1003
	jump2byte script51bc
script51d3:
	settextid $1004
	jump2byte script51bc
script51d8:
	settextid $1005
	jump2byte script51bc
script51dd:
	settextid $1006
	jump2byte script51bc
script51e2:
	settextid $1007
	jump2byte script51bc
script51e7:
	settextid $1008
	jump2byte script51bc
script51ec:
	settextid $1009
	jump2byte script51bc
script51f1:
	setcollisionradii $0f $06
	makeabuttonsensitive
	jumpifroomflagset $40 script521f
script51f9:
	checkabutton
	showtext $0b43
	jumpiftradeitemeq $09 script5203
	jump2byte script51f9
script5203:
	disableinput
	wait 30
script5205:
	showtext $0b44
	jumpiftextoptioneq $00 script5215
	wait 30
	showtext $0b47
	enableinput
	checkabutton
	disableinput
	jump2byte script5205
script5215:
	wait 30
	showtext $0b45
	giveitem $410a
	orroomflag $40
	enableinput
script521f:
	checkabutton
	showtext $0b46
	jump2byte script521f
script5225:
	rungenericnpclowindex $34
script5227:
	initcollisions
	jumpifroomflagset $40 script5268
script522c:
	checkabutton
	disableinput
	showtextlowindex $31
	jumpiftradeitemeq $06 script5237
	enableinput
	jump2byte script522c
script5237:
	wait 30
script5238:
	showtextlowindex $32
	jumpiftextoptioneq $00 script5246
	wait 30
	showtextlowindex $37
	enableinput
	checkabutton
	disableinput
	jump2byte script5238
script5246:
	wait 30
	writememory $cfde $00
	spawninteraction $5d06 $44 $68
	showtextlowindex $33
	ormemory $cceb $01
	showtextlowindex $34
	setcounter1 $20
	setanimation $02
	writememory $cfde $40
	showtextlowindex $35
	giveitem $4107
	orroomflag $40
	enableinput
script5268:
	checkabutton
	showtextlowindex $36
	jump2byte script5268
script526d:
	initcollisions
	jumpifitemobtained $7 script52e3
	jumpifroomflagset $40 script52d3
script5276:
	wait 1
	jumpifobjectbyteeq $77 $01 script528b
	jumpifobjectbyteeq $71 $00 script5286
	writeobjectbyte $71 $00
	showtextlowindex $02
script5286:
	asm15 $3d30
	jump2byte script5276
script528b:
	disableinput
	asm15 $57e5
	playsound $50
	setcounter1 $40
	setcollisionradii $00 $00
	setanimation $06
	setspeed SPEED_100
	setangle $18
	applyspeed $10
	wait 10
	setangle $10
script52a1:
	wait 1
	asm15 $57f3
	jumpifobjectbyteeq $76 $00 script52a1
	wait 20
	writememory $d008 $00
	showtextlowindex $00
	wait 20
	setangle $00
	setanimation $07
script52b6:
	wait 1
	asm15 $5812 $28
	jumpifobjectbyteeq $76 $01 script52b6
	setangle $08
	applyspeed $10
	orroomflag $40
	setcollisionradii $06 $06
	setanimation $06
	wait 20
	setanimation $04
	wait 30
	enableinput
	wait 30
	setanimation $00
script52d3:
	wait 1
	asm15 $3d30
	jumpifobjectbyteeq $71 $00 script52d3
	writeobjectbyte $71 $00
	showtextlowindex $02
	jump2byte script52d3
script52e3:
	setanimation $02
	writeobjectbyte $43 $01
	asm15 $5821
	jumptable_memoryaddress $cfc0
	.dw script52f4
	.dw script52f6
	.dw script52f8
script52f4:
	rungenericnpclowindex $01
script52f6:
	rungenericnpclowindex $03
script52f8:
	rungenericnpclowindex $0a
script52fa:
	jumpifobjectbyteeq $77 $01 script5305
	wait 1
	asm15 $3d30
	jump2byte script52fa
script5305:
	disableinput
	asm15 $57e5
	playsound $50
	setcounter1 $40
	showtextlowindex $04
	wait 40
	setanimation $06
	setspeed SPEED_100
	setangle $10
script5316:
	wait 1
	asm15 $5838
	jumpifobjectbyteeq $4f $00 script5321
	jump2byte script5316
script5321:
	wait 30
	setangle $18
	applyspeed $24
	wait 10
	asm15 $5840
script532a:
	wait 1
	asm15 $5802
	jumpifobjectbyteeq $76 $00 script532a
	wait 20
	writememory $d008 $01
	showtextlowindex $05
script533a:
	wait 20
	showtextlowindex $06
	jumpiftextoptioneq $01 script533a
	wait 20
	showtextlowindex $07
	setangle $10
	setanimation $06
	setspeed SPEED_100
script534a:
	wait 1
	asm15 $5812 $88
	jumpifobjectbyteeq $76 $01 script534a
	enableinput
	orroomflag $40
	scriptend
script5358:
	initcollisions
	settextid $5208
	checkabutton
	disableinput
	callscript script536c
	settextid $5209
script5364:
	enableinput
	checkabutton
	disableinput
	callscript script536c
	jump2byte script5364
script536c:
	cplinkx $48
	addobjectbyte $48 $08
	setanimationfromobjectbyte $48
	wait 60
	showloadedtext
	wait 30
	addobjectbyte $48 $f8
	setanimationfromobjectbyte $48
	retscript
script537e:
	setcollisionradii $06 $06
	makeabuttonsensitive
script5382:
	checkabutton
	jumpifmemoryeq $c60f $00 script538e
	showtext $4301
	jump2byte script5382
script538e:
	showtext $4300
	jump2byte script5382
script5393:
	initcollisions
script5394:
	checkabutton
	setdisabledobjectsto91
	setanimation $02
	asm15 $5850
	wait 30
	callscript script53ab
	enableallobjects
	jump2byte script5394
script53a2:
	initcollisions
script53a3:
	checkabutton
	setdisabledobjectsto91
	asm15 $5850
	enableallobjects
	jump2byte script53a3
script53ab:
	writeobjectbyte $73 $43
	getrandombits $72 $07
	addobjectbyte $72 $09
	showloadedtext
	setanimation $03
	retscript
script53b8:
	setcollisionradii $08 $08
	makeabuttonsensitive
script53bc:
	checkabutton
	setdisabledobjectsto91
	cplinkx $48
	writeobjectbyte $77 $01
	showloadedtext
	jumpiftextoptioneq $01 script53d0
	wait 30
	addobjectbyte $72 $0a
	showloadedtext
	addobjectbyte $72 $f6
script53d0:
	enableallobjects
	writeobjectbyte $77 $00
	jump2byte script53bc
script53d6:
	setcollisionradii $06 $06
	makeabuttonsensitive
script53da:
	checkabutton
	setdisabledobjectsto11
	cplinkx $48
	writeobjectbyte $77 $01
	showtext $0503
	writeobjectbyte $77 $00
	enableallobjects
	jump2byte script53da
script53ea:
	initcollisions
	asm15 $5871 $00
	jumpifobjectbyteeq $7b $01 script5421
script53f4:
	checkabutton
	setdisabledobjectsto91
	showtextlowindex $00
script53f8:
	asm15 $58a7
	wait 30
	jumptable_memoryaddress $cca3
	.dw script5408
	.dw script5403
script5403:
	showtextlowindex $0a
	enableinput
	jump2byte script53f4
script5408:
	showtextlowindex $07
	disableinput
	jumptable_memoryaddress $cba5
	.dw script5412
	.dw script53f8
script5412:
	asm15 $588d
	asm15 $586b $00
	asm15 $5866 $01
	wait 30
	showtextlowindex $08
	enableinput
script5421:
	checkabutton
	showtextlowindex $09
	jump2byte script5421
script5426:
	initcollisions
	asm15 $5871 $01
	jumpifobjectbyteeq $7b $01 script54cd
script5430:
	checkabutton
	setdisabledobjectsto91
	showtextlowindex $0b
	jumptable_memoryaddress $cba5
	.dw script543b
	.dw script54c7
script543b:
	wait 30
	showtextlowindex $0c
	jumptable_memoryaddress $cba5
	.dw script5449
	.dw script5468
	.dw script5487
	.dw script54a6
script5449:
	asm15 $5880 $0f
	jumpifobjectbyteeq $7c $01 script54c1
	asm15 $1751 $0f
	asm15 $5887 $08
	asm15 $586b $01
	asm15 $5866 $02
	enableallobjects
script5463:
	showtextlowindex $0d
	checkabutton
	jump2byte script5463
script5468:
	asm15 $5880 $0b
	jumpifobjectbyteeq $7c $01 script54c1
	asm15 $1751 $0b
	asm15 $5887 $05
	asm15 $586b $01
	asm15 $5866 $02
	enableallobjects
script5482:
	showtextlowindex $0e
	checkabutton
	jump2byte script5482
script5487:
	asm15 $5880 $04
	jumpifobjectbyteeq $7c $01 script54c1
	asm15 $1751 $04
	asm15 $5887 $02
	asm15 $586b $01
	asm15 $5866 $02
	enableallobjects
script54a1:
	showtextlowindex $0f
	checkabutton
	jump2byte script54a1
script54a6:
	asm15 $5880 $01
	jumpifobjectbyteeq $7c $01 script54c1
	asm15 $1751 $01
	asm15 $586b $01
	asm15 $5866 $02
	enableallobjects
script54bc:
	showtextlowindex $10
	checkabutton
	jump2byte script54bc
script54c1:
	wait 30
	showtextlowindex $32
	enableallobjects
	jump2byte script5430
script54c7:
	wait 30
	showtextlowindex $11
	enableallobjects
	jump2byte script5430
script54cd:
	checkabutton
	showtextlowindex $31
	jump2byte script54cd
script54d2:
	initcollisions
script54d3:
	checkabutton
	setdisabledobjectsto91
	showtextlowindex $12
	asm15 $5866 $03
	enableallobjects
	jump2byte script54d3
script54de:
	initcollisions
	asm15 $5871 $02
	jumpifobjectbyteeq $7b $01 script5509
	checkabutton
	setdisabledobjectsto91
	showtextlowindex $13
	asm15 $586b $02
	asm15 $5866 $04
	jumptable_memoryaddress $cba5
	.dw script54fb
	.dw script5501
script54fb:
	wait 30
	showtextlowindex $14
	enableallobjects
	jump2byte script5509
script5501:
	wait 30
	showtextlowindex $15
	asm15 $5887 $0a
	enableallobjects
script5509:
	checkabutton
	showtextlowindex $16
	jump2byte script5509
script550e:
	rungenericnpclowindex $17
script5510:
	rungenericnpclowindex $18
script5512:
	initcollisions
	asm15 $5871 $03
	jumptable_objectbyte $43
	.dw script551f
	.dw script5536
	.dw script554d
script551f:
	jumpifobjectbyteeq $7b $01 script5531
script5524:
	checkabutton
	setdisabledobjectsto91
	showtextlowindex $19
	callscript script5564
	enableallobjects
	jumpifobjectbyteeq $7a $00 script5524
script5531:
	checkabutton
	showtextlowindex $22
	jump2byte script5531
script5536:
	jumpifobjectbyteeq $7b $01 script5548
script553b:
	checkabutton
	setdisabledobjectsto91
	showtextlowindex $1a
	callscript script5564
	enableallobjects
	jumpifobjectbyteeq $7a $00 script553b
script5548:
	checkabutton
	showtextlowindex $23
	jump2byte script5548
script554d:
	jumpifobjectbyteeq $7b $01 script555f
script5552:
	checkabutton
	setdisabledobjectsto91
	showtextlowindex $1b
	callscript script5564
	enableallobjects
	jumpifobjectbyteeq $7a $00 script5552
script555f:
	checkabutton
	showtextlowindex $24
	jump2byte script555f
script5564:
	jumptable_memoryaddress $cba5
	.dw script556b
	.dw script557a
script556b:
	wait 30
	showtextlowindex $1c
	asm15 $586b $03
	writeobjectbyte $7a $01
	asm15 $5887 $08
	retscript
script557a:
	wait 30
	showtextlowindex $1d
	jumptable_memoryaddress $cba5
	.dw script5584
	.dw script5593
script5584:
	wait 30
	showtextlowindex $1e
	asm15 $586b $03
	writeobjectbyte $7a $01
	asm15 $5887 $05
	retscript
script5593:
	wait 30
	showtextlowindex $1f
	jumptable_memoryaddress $cba5
	.dw script559d
	.dw script55ac
script559d:
	wait 30
	showtextlowindex $20
	asm15 $586b $03
	writeobjectbyte $7a $01
	asm15 $5887 $01
	retscript
script55ac:
	wait 30
	showtextlowindex $21
	wait 30
	retscript
script55b1:
	jumptable_objectbyte $43
	.dw script55bb
	.dw script55bd
	.dw script55bf
	.dw script55c1
script55bb:
	rungenericnpclowindex $25
script55bd:
	rungenericnpclowindex $26
script55bf:
	rungenericnpclowindex $27
script55c1:
	rungenericnpclowindex $28
script55c3:
	jumptable_objectbyte $43
	.dw script55cd
	.dw script55cf
	.dw script55d1
	.dw script55d3
script55cd:
	rungenericnpclowindex $29
script55cf:
	rungenericnpclowindex $2a
script55d1:
	rungenericnpclowindex $2b
script55d3:
	rungenericnpclowindex $2c
script55d5:
	jumptable_objectbyte $43
	.dw script55df
	.dw script55e1
	.dw script55e3
	.dw script55e5
script55df:
	rungenericnpclowindex $2d
script55e1:
	rungenericnpclowindex $2e
script55e3:
	rungenericnpclowindex $2f
script55e5:
	rungenericnpclowindex $30
script55e7:
	rungenericnpc $1c00
script55ea:
	initcollisions
script55eb:
	checkabutton
	showtext $1c01
	checkabutton
	showtext $1c02
	jump2byte script55eb
script55f5:
	rungenericnpc $1c03
script55f8:
	stopifroomflag80set
	asm15 $58ac
	rungenericnpc $2705
script55ff:
	jumpifglobalflagset $0d script5606
	rungenericnpc $2700
script5606:
	rungenericnpc $270b
script5609:
	rungenericnpc $2701
script560c:
	asm15 $58ac
	rungenericnpc $2702
script5612:
	asm15 $58b1
	rungenericnpc $2703
script5618:
	jumpifglobalflagset $0b script5626
	jumpifglobalflagset $0c script5623
	rungenericnpc $290c
script5623:
	rungenericnpc $2912
script5626:
	settextid $2917
	jump2byte script5674
script562b:
	jumpifglobalflagset $0b script5639
	jumpifglobalflagset $0c script5636
	rungenericnpc $290d
script5636:
	rungenericnpc $2913
script5639:
	settextid $2918
	jump2byte script5674
script563e:
	jumpifglobalflagset $0b script5646
	jumpifglobalflagset $0c script5649
script5646:
	rungenericnpc $290e
script5649:
	rungenericnpc $2914
script564c:
	jumpifglobalflagset $0b script5654
	jumpifglobalflagset $0c script5657
script5654:
	rungenericnpc $290f
script5657:
	rungenericnpc $2915
script565a:
	jumpifglobalflagset $0b script5662
	jumpifglobalflagset $0c script5665
script5662:
	rungenericnpc $2910
script5665:
	rungenericnpc $2916
script5668:
	jumpifglobalflagset $0b script566f
	rungenericnpc $2911
script566f:
	settextid $2919
	jump2byte script5674
script5674:
	initcollisions
script5675:
	checkabutton
	setdisabledobjectsto11
	setzspeed -$01c0
	wait 60
	showloadedtext
	enableallobjects
	jump2byte script5675
script567f:
	writememory $ccea $05
	initcollisions
script5684:
	checkabutton
	jumpifmemoryeq $ccea $00 script5690
	showtext $2b0f
	jump2byte script5684
script5690:
	showtext $2b11
script5693:
	checkabutton
	showtext $2b11
	jump2byte script5693
script5699:
	jumpifitemobtained $17 script56a0
	rungenericnpc $2807
script56a0:
	rungenericnpc $280a
script56a3:
	jumpifitemobtained $17 script56aa
	rungenericnpc $2808
script56aa:
	rungenericnpc $280b
script56ad:
	rungenericnpc $2809
script56b0:
	stopifroomflag40set
	writeobjectbyte $5c $02
	callscript script56eb
	checkcfc0bit 0
	orroomflag $40
	asm15 $58c4
	applyspeed $68
	checkcfc0bit 2
	setspeed SPEED_100
	setangle $08
	asm15 $58d4
	setanimation $01
	setcounter1 $10
	showtext $2800
	wait 30
	xorcfc0bit 3
	setzspeed -$0300
	wait 8
	xorcfc0bit 7
	playsound $5e
	checkcfc0bit 4
	updatelinkrespawnposition
	asm15 $10ce
	setanimation $03
	setspeed SPEED_200
	setangle $18
	asm15 $5968
	wait 4
	scriptend
script56e7:
	loadscript $14 $4861
script56eb:
	writeobjectbyte $40 $81
	setstate $02
	setcollisionradii $06 $06
	setspeed SPEED_200
	setangleandanimation $18
	retscript
script56f8:
	loadscript $14 $489a
script56fc:
	jumpifglobalflagset $0f stubScript
	writeobjectbyte $5c $01
	callscript script56eb
	checkcfc0bit 0
	setzspeed -$0300
	showtext $2802
	xorcfc0bit 1
	setcounter1 $02
	applyspeed $40
	setglobalflag $0f
	enableallobjects
	scriptend
script5716:
	writeobjectbyte $5c $01
	rungenericnpc $3e00
script571c:
	jumpifglobalflagset $28 stubScript
	rungenericnpc $3e01
script5723:
	jumpifglobalflagset $28 stubScript
	writeobjectbyte $5c $01
	rungenericnpc $3e02
script572d:
	rungenericnpc $3e03
script5730:
	rungenericnpc $3e04
script5733:
	jumpifglobalflagset $28 stubScript
	writeobjectbyte $5c $01
	rungenericnpc $3e08
script573d:
	rungenericnpc $3e0a
script5740:
	rungenericnpc $3e0b
script5743:
	writeobjectbyte $5c $02
	rungenericnpc $3e0d
script5749:
	writeobjectbyte $5c $01
	rungenericnpc $3e10
script574f:
	writeobjectbyte $5c $01
	rungenericnpc $3e11
script5755:
	rungenericnpc $3e13
script5758:
	writeobjectbyte $5c $01
	rungenericnpc $3e14
script575e:
	writeobjectbyte $5c $01
	jumpifmemoryset $c860 $20 script576a
	rungenericnpc $3e29
script576a:
	rungenericnpc $3e16
script576d:
	rungenericnpc $3e17
script5770:
	rungenericnpc $3e0c
script5773:
	rungenericnpc $3e19
script5776:
	writeobjectbyte $5c $03
	initcollisions
	asm15 $58f0
	jumpifobjectbyteeq $7f $01 script57b5
script5782:
	enableinput
	asm15 $5916 $00
	checkabutton
	disableinput
	showloadedtext
	wait 20
	jumpiftextoptioneq $00 script5795
	addobjectbyte $72 $04
	showloadedtext
	jump2byte script5782
script5795:
	addobjectbyte $72 $01
script5798:
	showloadedtext
	asm15 $5916 $05
	wait 20
	jumpiftextoptioneq $01 script5798
	asm15 $5900
	asm15 $591d $02
script57a9:
	showloadedtext
	wait 20
	jumpiftextoptioneq $01 script57a9
	asm15 $591d $03
	showloadedtext
	enableinput
script57b5:
	checkabutton
	disableinput
	asm15 $5916 $05
	jump2byte script5798
script57bd:
	initcollisions
	jumpifroomflagset $20 script580c
	asm15 $592c
	jumptable_memoryaddress $cfc0
	.dw script57d4
	.dw script57db
	.dw script57e2
	.dw script57e9
	.dw script57f0
	.dw script57f7
script57d4:
	checkabutton
	showtext $3e23
	rungenericnpc $3e1b
script57db:
	checkabutton
	showtext $3e24
	rungenericnpc $3e1c
script57e2:
	checkabutton
	showtext $3e25
	rungenericnpc $3e1d
script57e9:
	checkabutton
	showtext $3e26
	rungenericnpc $3e1e
script57f0:
	checkabutton
	showtext $3e27
	rungenericnpc $3e1f
script57f7:
	checkabutton
	disableinput
	showtext $3e20
	wait 30
	asm15 $5963
	wait 10
	checkpalettefadedone
	showtext $3e21
	wait 30
	asm15 $595d
	enableinput
	jump2byte script5810
script580c:
	checkabutton
	showtext $3e28
script5810:
	rungenericnpc $3e22
script5813:
	initcollisions
	jumpifglobalflagset $0c script5840
	jumpifitemobtained $46 script581e
	rungenericnpclowindex $00
script581e:
	checkabutton
	showtextlowindex $01
	jumpiftextoptioneq $00 script5829
	showtextlowindex $02
	jump2byte script581e
script5829:
	disableinput
	setglobalflag $0c
	showtextlowindex $03
	wait 10
	playsound $5e
	asm15 $5973
	setanimation $02
	wait 60
	showtextlowindex $04
	setglobalflag $0b
	asm15 $597c
	enableinput
	scriptend
script5840:
	checkabutton
	showtextlowindex $05
	jumpiftextoptioneq $00 script584b
	showtextlowindex $07
	jump2byte script5840
script584b:
	disableinput
	setglobalflag $0b
	showtextlowindex $06
	asm15 $597c
	enableinput
	scriptend
script5855:
	setspeed SPEED_100
	movedown $20
	setanimation $00
	wait 30
	showtextlowindex $1a
	setanimation $02
	scriptend
script5861:
	rungenericnpc $2706
script5864:
	jumpifglobalflagset $28 stubScript
	rungenericnpc $3e06
script586b:
	writeobjectbyte $5c $01
	rungenericnpc $3e09
script5871:
	rungenericnpc $3e0f
script5874:
	rungenericnpc $3e12
script5877:
	rungenericnpc $3e15
script587a:
	scriptend
script587b:
	initcollisions
script587c:
	checkabutton
	showtext $4700
	jump2byte script587c
script5882:
	initcollisions
script5883:
	checkabutton
	showtext $4200
	jump2byte script5883
script5889:
	initcollisions
script588a:
	checkabutton
	showtext $4900
	jump2byte script588a
script5890:
	initcollisions
script5891:
	checkabutton
	showtext $4701
	asm15 $5866 $06
	jump2byte script5891
script589b:
	initcollisions
script589c:
	checkabutton
	showtext $4201
	asm15 $5866 $06
	jump2byte script589c
script58a6:
	initcollisions
script58a7:
	checkabutton
	showtext $4901
	asm15 $5866 $06
	jump2byte script58a7
script58b1:
	initcollisions
	asm15 $5871 $04
	jumpifobjectbyteeq $7b $01 script58df
	checkabutton
	disableinput
	showtext $4702
	asm15 $586b $04
	asm15 $5866 $07
	jumptable_memoryaddress $cba5
	.dw script58cf
	.dw script58da
script58cf:
	wait 30
	showtext $4703
	asm15 $598e $04
	enableinput
	jump2byte script58df
script58da:
	wait 30
	showtext $4704
	enableinput
script58df:
	checkabutton
	showtext $4705
	jump2byte script58df
script58e5:
	initcollisions
	asm15 $5871 $04
	jumpifobjectbyteeq $7b $01 script5913
	checkabutton
	disableinput
	showtext $4202
	asm15 $586b $04
	asm15 $5866 $07
	jumptable_memoryaddress $cba5
	.dw script5903
	.dw script590e
script5903:
	wait 30
	showtext $4203
	asm15 $598e $04
	enableinput
	jump2byte script5913
script590e:
	wait 30
	showtext $4204
	enableinput
script5913:
	checkabutton
	showtext $4205
	jump2byte script5913
script5919:
	initcollisions
	asm15 $5871 $04
	jumpifobjectbyteeq $7b $01 script5947
	checkabutton
	disableinput
	showtext $4902
	asm15 $586b $04
	asm15 $5866 $07
	jumptable_memoryaddress $cba5
	.dw script5937
	.dw script5942
script5937:
	wait 30
	showtext $4903
	asm15 $598e $04
	enableinput
	jump2byte script5947
script5942:
	wait 30
	showtext $4904
	enableinput
script5947:
	checkabutton
	showtext $4905
	jump2byte script5947
script594d:
	initcollisions
script594e:
	checkabutton
	showtext $4b00
	asm15 $5866 $08
	jump2byte script594e
script5958:
	initcollisions
script5959:
	checkabutton
	showtext $4a00
	asm15 $5866 $08
	jump2byte script5959
script5963:
	initcollisions
script5964:
	checkabutton
	showtext $4800
	asm15 $5866 $08
	jump2byte script5964
script596e:
	initcollisions
script596f:
	checkabutton
	showtext $4600
	asm15 $5866 $08
	jump2byte script596f
script5979:
	initcollisions
	asm15 $5871 $05
	jumpifobjectbyteeq $7b $01 script5a30
script5983:
	checkabutton
	disableinput
	showtext $4b01
	jumptable_memoryaddress $cba5
	.dw script598f
	.dw script5a29
script598f:
	wait 30
	showtext $4b02
	jumptable_memoryaddress $cba5
	.dw script599e
	.dw script59bf
	.dw script59e0
	.dw script5a01
script599e:
	asm15 $5994 $0c
	jumpifobjectbyteeq $7c $01 script5a22
	asm15 $1751 $0c
	asm15 $599f $00
	asm15 $586b $05
	asm15 $5866 $09
	wait 30
	enableinput
script59b9:
	showtext $4b04
	checkabutton
	jump2byte script59b9
script59bf:
	asm15 $5994 $0b
	jumpifobjectbyteeq $7c $01 script5a22
	asm15 $1751 $0b
	asm15 $599f $01
	asm15 $586b $05
	asm15 $5866 $09
	wait 30
	enableinput
script59da:
	showtext $4b05
	checkabutton
	jump2byte script59da
script59e0:
	asm15 $5994 $04
	jumpifobjectbyteeq $7c $01 script5a22
	asm15 $1751 $04
	asm15 $599f $02
	asm15 $586b $05
	asm15 $5866 $09
	wait 30
	enableinput
script59fb:
	showtext $4b06
	checkabutton
	jump2byte script59fb
script5a01:
	asm15 $5994 $01
	jumpifobjectbyteeq $7c $01 script5a22
	asm15 $1751 $01
	asm15 $599f $03
	asm15 $586b $05
	asm15 $5866 $09
	wait 30
	enableinput
script5a1c:
	showtext $4b07
	checkabutton
	jump2byte script5a1c
script5a22:
	wait 30
	showtext $4b08
	enableinput
	jump2byte script5983
script5a29:
	wait 30
	showtext $4b03
	enableinput
	jump2byte script5983
script5a30:
	checkabutton
	showtext $4b09
	jump2byte script5a30
script5a36:
	initcollisions
	asm15 $5871 $05
	jumpifobjectbyteeq $7b $01 script5a94
	checkabutton
	disableinput
	showtext $4a01
	jumptable_memoryaddress $cba5
	.dw script5a76
	.dw script5a4c
script5a4c:
	wait 30
	showtext $4a02
	jumptable_memoryaddress $cba5
	.dw script5a7c
	.dw script5a57
script5a57:
	wait 30
	showtext $4a03
	jumptable_memoryaddress $cba5
	.dw script5a82
	.dw script5a62
script5a62:
	asm15 $599f $03
	asm15 $586b $05
	asm15 $5866 $09
	wait 30
	showtext $4a04
	enableinput
	wait 30
	jump2byte script5a94
script5a76:
	asm15 $599f $00
	jump2byte script5a86
script5a7c:
	asm15 $599f $01
	jump2byte script5a86
script5a82:
	asm15 $599f $02
script5a86:
	asm15 $586b $05
	asm15 $5866 $09
	wait 30
	showtext $4a05
	wait 30
	enableinput
script5a94:
	checkabutton
	showtext $4a08
	jump2byte script5a94
script5a9a:
	initcollisions
	asm15 $5871 $05
	jumpifobjectbyteeq $7b $01 script5aba
	checkabutton
	disableinput
	showtext $4801
	giveitem $3403
	asm15 $586b $05
	asm15 $5866 $09
	wait 30
	showtext $4802
	wait 30
	enableinput
script5aba:
	checkabutton
	showtext $4803
	jump2byte script5aba
script5ac0:
	initcollisions
	asm15 $5871 $05
	jumpifobjectbyteeq $7b $01 script5adf
	checkabutton
	disableinput
	showtext $4601
	asm15 $599b $00
	asm15 $586b $05
	asm15 $5866 $09
	wait 30
	enableinput
	jump2byte script5ae0
script5adf:
	checkabutton
script5ae0:
	showtext $4602
	jump2byte script5adf
script5ae5:
	initcollisions
	asm15 $5871 $06
	jumpifobjectbyteeq $7b $01 script5b21
	checkabutton
	disableinput
	showtext $4b0a
	asm15 $586b $06
	wait 30
	jumptable_memoryaddress $c6dd
	.dw script5b04
	.dw script5b0c
	.dw script5b15
	.dw script5b1a
script5b04:
	asm15 $17e5
	showtext $0052
	jump2byte script5b1d
script5b0c:
	asm15 $59be $0d
	showtext $0009
	jump2byte script5b1d
script5b15:
	giveitem $3403
	jump2byte script5b1d
script5b1a:
	giveitem $0302
script5b1d:
	wait 30
	enableinput
	jump2byte script5b22
script5b21:
	checkabutton
script5b22:
	showtext $4b0b
	jump2byte script5b21
script5b27:
	initcollisions
	asm15 $5871 $06
	jumpifobjectbyteeq $7b $01 script5b6f
	checkabutton
	disableinput
	showtext $4a06
	wait 30
	showtext $4a07
	asm15 $586b $06
	wait 30
	jumptable_memoryaddress $c6dd
	.dw script5b4a
	.dw script5b53
	.dw script5b5c
	.dw script5b64
script5b4a:
	asm15 $59be $0c
	showtext $0007
	jump2byte script5b6b
script5b53:
	asm15 $59b7 $01
	showtext $0051
	jump2byte script5b6b
script5b5c:
	asm15 $59b3
	showtext $0053
	jump2byte script5b6b
script5b64:
	asm15 $59be $01
	showtext $0001
script5b6b:
	wait 30
	enableinput
	jump2byte script5b70
script5b6f:
	checkabutton
script5b70:
	showtext $4a08
	jump2byte script5b6f
script5b75:
	initcollisions
script5b76:
	checkabutton
	disableinput
	showtext $4804
	wait 30
	callscript script5b82
	enableinput
	jump2byte script5b76
script5b82:
	writeobjectbyte $73 $48
	getrandombits $72 $07
	addobjectbyte $72 $05
	showloadedtext
	retscript
script5b8d:
	initcollisions
script5b8e:
	checkabutton
	disableinput
	showtext $4603
	jumptable_memoryaddress $cba5
	.dw script5b9a
	.dw script5ba8
script5b9a:
	asm15 $59a3
	asm15 $59b3
	wait 30
	enableinput
script5ba2:
	showtext $4604
	checkabutton
	jump2byte script5ba2
script5ba8:
	wait 30
	showtext $4605
	enableinput
	jump2byte script5b8e
script5baf:
	initcollisions
	setspeed SPEED_080
	writeobjectbyte $76 $03
	setangle $18
	setanimationfromangle
	applyspeed $a0
	wait 20
script5bbc:
	writeobjectbyte $76 $01
	setangle $08
	setanimationfromangle
	applyspeed $e0
	wait 20
	writeobjectbyte $76 $03
	setangle $18
	setanimationfromangle
	applyspeed $e0
	wait 20
	jump2byte script5bbc
script5bd2:
	rungenericnpclowindex $01
script5bd4:
	rungenericnpclowindex $06
script5bd6:
	jumpifglobalflagset $28 script5bdc
	rungenericnpclowindex $02
script5bdc:
	rungenericnpclowindex $0e
script5bde:
	jumpifglobalflagset $28 script5bea
	rungenericnpclowindex $03
script5be4:
	jumpifglobalflagset $28 script5bea
	rungenericnpclowindex $07
script5bea:
	rungenericnpclowindex $0f
script5bec:
	rungenericnpclowindex $04
script5bee:
	rungenericnpclowindex $08
script5bf0:
	rungenericnpclowindex $05
script5bf2:
	initcollisions
	jumpifroomflagset $40 script5c20
	checkabutton
	setdisabledobjectsto91
	showtextlowindex $09
	jumpiftextoptioneq $01 script5c22
	jumpifitemobtained $2c script5c09
	wait 30
	showtextlowindex $0d
	enableallobjects
	rungenericnpclowindex $0d
script5c09:
	wait 30
	showtextlowindex $0a
	asm15 $59c4
	jumpifmemoryeq $cba8 $05 script5c1a
	giveitem $2c01
	jump2byte script5c1d
script5c1a:
	giveitem $2c02
script5c1d:
	orroomflag $40
	enableallobjects
script5c20:
	rungenericnpclowindex $0b
script5c22:
	wait 30
	showtextlowindex $0c
	enableallobjects
	rungenericnpclowindex $0c
script5c28:
	initcollisions
script5c29:
	enableinput
	checkabutton
	disableinput
	showtextlowindex $30
	wait 20
	jumpiftextoptioneq $00 script5c37
	showtextlowindex $35
	jump2byte script5c29
script5c37:
	setglobalflag $6c
	generateoraskforsecret $08
script5c3b:
	showtextlowindex $33
	wait 20
	jumpiftextoptioneq $01 script5c3b
	showtextlowindex $34
	jump2byte script5c29
script5c46:
	rungenericnpc $1500
script5c49:
	initcollisions
script5c4a:
	checkabutton
	showtext $1501
	checkabutton
	showtext $1502
	jump2byte script5c4a
script5c54:
	rungenericnpc $1406
script5c57:
	rungenericnpc $1503
script5c5a:
	rungenericnpc $1504
script5c5d:
	rungenericnpc $1505
script5c60:
	rungenericnpc $1506
script5c63:
	initcollisions
script5c64:
	checkabutton
	showtext $1400
	checkabutton
	showtext $1401
	jump2byte script5c64
script5c6e:
	initcollisions
script5c6f:
	checkabutton
	setdisabledobjectsto91
	showtext $1402
	jumpiftextoptioneq $01 script5c7e
	wait 30
	showtext $1403
	jump2byte script5c82
script5c7e:
	wait 30
	showtext $1404
script5c82:
	enableallobjects
	jump2byte script5c6f
script5c85:
	rungenericnpc $1405
script5c88:
	rungenericnpc $1406
script5c8b:
	setanimation $00
	settextid $1407
	writeobjectbyte $7b $00
script5c93:
	initcollisions
script5c94:
	checkabutton
	asm15 $63b8
	showloadedtext
	wait 10
	setanimationfromobjectbyte $7b
	jump2byte script5c94
script5c9f:
	setanimation $02
	settextid $1408
	writeobjectbyte $7b $02
	jump2byte script5c93
script5ca9:
	initcollisions
script5caa:
	checkabutton
	showtext $1409
	writeobjectbyte $45 $00
	jump2byte script5caa
script5cb3:
	jumptable_memoryaddress $cc4e
	.dw script5cbc
	.dw script5cbf
	.dw script5cc2
script5cbc:
	rungenericnpc $1300
script5cbf:
	rungenericnpc $1301
script5cc2:
	rungenericnpc $1302
script5cc5:
	rungenericnpc $1303
script5cc8:
	rungenericnpc $1304
script5ccb:
	jumpifglobalflagset $16 script5ce3
	rungenericnpc $1a00
script5cd2:
	jumpifglobalflagset $16 script5cd8
	jump2byte script5ce6
script5cd8:
	initcollisions
	checkabutton
	showtext $1a02
	checkabutton
	showtext $1a01
	jump2byte script5cd8
script5ce3:
	rungenericnpc $1a02
script5ce6:
	rungenericnpc $1a01
script5ce9:
	rungenericnpc $1a03
script5cec:
	initcollisions
	jumpifobjectbyteeq $7a $01 script5cfd
	checkabutton
	showtextlowindex $17
	disableinput
	wait 30
	enableinput
script5cf8:
	checkabutton
	showtextlowindex $18
	jump2byte script5cf8
script5cfd:
	jumptable_objectbyte $7b
	.dw script5d05
	.dw script5d14
	.dw script5d23
script5d05:
	checkabutton
	showtextlowindex $19
	disableinput
	writememory $c6e4 $01
	wait 30
	enableinput
script5d0f:
	checkabutton
	showtextlowindex $1a
	jump2byte script5d0f
script5d14:
	checkabutton
	showtextlowindex $1c
	disableinput
	writememory $c6e4 $02
	wait 30
	enableinput
script5d1e:
	checkabutton
	showtextlowindex $1d
	jump2byte script5d1e
script5d23:
	checkabutton
	disableinput
	showtextlowindex $1e
	wait 30
	showtextlowindex $1f
	wait 30
	writememory $c6e4 $02
	jumptable_memoryaddress $cc01
	.dw script5d36
	.dw script5d44
script5d36:
	showtextlowindex $14
	wait 30
	xorcfc0bit 0
	setcounter1 $64
	enableinput
	asm15 $5a0c
script5d40:
	setcounter1 $ff
	jump2byte script5d40
script5d44:
	wait 60
	showtextlowindex $26
	asm15 $5a33
	checkcfc0bit 1
	wait 30
	showtextlowindex $27
	wait 30
	writeobjectbyte $7c $01
	setspeed SPEED_100
	asm15 $5a70
	jumptable_objectbyte $79
	.dw script5d7f
	.dw script5d5f
	.dw script5d6f
script5d5f:
	setanimation $02
	setangle $18
	applyspeed $0d
	movedown $21
	setanimation $02
	setangle $08
	applyspeed $0d
	jump2byte script5d81
script5d6f:
	setanimation $02
	setangle $08
	applyspeed $0d
	movedown $21
	setanimation $02
	setangle $18
	applyspeed $0d
	jump2byte script5d81
script5d7f:
	movedown $21
script5d81:
	loadscript $14 $48b5
script5d85:
	initcollisions
script5d86:
	jumptable_memoryaddress $c6e4
	.dw script5d8f
	.dw script5d8f
	.dw script5d9e
script5d8f:
	jumpifobjectbyteeq $71 $00 script5d86
	writeobjectbyte $71 $00
	asm15 $59d7 $00
	wait 1
	jump2byte script5d86
script5d9e:
	jumpifobjectbyteeq $71 $01 script5dab
	jumpifmemoryset $cfc0 $01 script5db5
	jump2byte script5d9e
script5dab:
	writeobjectbyte $71 $00
	asm15 $59d7 $01
	wait 1
	jump2byte script5d9e
script5db5:
	callscript script5f0a
script5db8:
	setcounter1 $ff
	jump2byte script5db8
script5dbc:
	initcollisions
script5dbd:
	jumpifobjectbyteeq $71 $01 script5dca
	jumpifmemoryset $cfc0 $01 script5dd6
	jump2byte script5dbd
script5dca:
	setdisabledobjectsto91
	writeobjectbyte $71 $00
	asm15 $59d7 $00
	wait 1
	enableallobjects
	jump2byte script5dbd
script5dd6:
	callscript script5f0a
script5dd9:
	setcounter1 $ff
	jump2byte script5dd9
script5ddd:
	initcollisions
	jumpifglobalflagset $28 script5df0
	jumpifglobalflagset $13 script5deb
script5de6:
	checkabutton
	showtextlowindex $0a
	jump2byte script5de6
script5deb:
	checkabutton
	showtextlowindex $0b
	jump2byte script5deb
script5df0:
	jumpifglobalflagset $5f script5e47
	jumpifglobalflagset $55 script5e18
script5df8:
	checkabutton
	disableinput
	showtextlowindex $2c
	jumpiftextoptioneq $00 script5e06
	wait 30
	showtextlowindex $2d
	enableinput
	jump2byte script5df8
script5e06:
	wait 30
	showtextlowindex $2e
	generateoraskforsecret $25
	wait 30
	jumptable_memoryaddress $cca3
	.dw script5e1a
	.dw script5e13
script5e13:
	showtextlowindex $2d
	enableinput
	jump2byte script5df8
script5e18:
	checkabutton
	disableinput
script5e1a:
	setglobalflag $55
	showtextlowindex $2f
	wait 30
	asm15 $5a8e
	jumpifobjectbyteeq $79 $01 script5e2e
script5e27:
	showtextlowindex $31
	enableinput
	checkabutton
	disableinput
	jump2byte script5e27
script5e2e:
	showtextlowindex $32
	asm15 $5aa1
	giveitem $6100
	wait 60
	setglobalflag $5f
script5e39:
	generateoraskforsecret $35
script5e3b:
	showtextlowindex $33
	wait 30
	jumpiftextoptioneq $00 script5e44
	jump2byte script5e3b
script5e44:
	showtextlowindex $34
	enableinput
script5e47:
	checkabutton
	disableinput
	jump2byte script5e39
script5e4b:
	initcollisions
	jumpifglobalflagset $13 script5e54
	loadscript $14 $48dc
script5e54:
	checkabutton
	showtextlowindex $0e
	jump2byte script5e54
script5e59:
	setspeed SPEED_100
	moveup $07
	asm15 $59ff $db
	playsound $70
	wait 10
	asm15 $59ff $d9
	playsound $70
	setanimation $00
	setangle $10
	applyspeed $07
	setspeed SPEED_200
	wait 4
	retscript
script5e74:
	rungenericnpclowindex $0f
script5e76:
	initcollisions
	jumptable_memoryaddress $c6e4
	.dw script5e80
	.dw script5e85
	.dw script5e85
script5e80:
	checkabutton
	showtextlowindex $12
	jump2byte script5e80
script5e85:
	checkabutton
	showtextlowindex $13
	wait 40
	writeobjectbyte $7c $01
	setspeed SPEED_200
	moveleft $39
	orroomflag $40
	scriptend
script5e93:
	loadscript $14 $4930
script5e97:
	writeobjectbyte $7c $01
	asm15 $1e15
	setspeed SPEED_080
	movedown $03
	wait 20
	applyspeed $03
	wait 20
	setspeed SPEED_100
	applyspeed $0f
	applyspeed $21
	setspeed SPEED_100
	moveleft $41
	wait 4
	setspeed SPEED_080
	moveup $11
	wait 30
	showtextlowindex $15
	wait 30
	xorcfc0bit 0
	checkcfc0bit 1
	setcounter1 $40
	setspeed SPEED_100
	moveright $41
	wait 4
	setspeed SPEED_100
	moveup $27
	callscript script5f01
	scriptend
script5ec9:
	checkcfc0bit 1
	wait 20
	setcounter1 $6a
	setcounter1 $44
	writeobjectbyte $7c $01
	asm15 $1e15
	setspeed SPEED_100
	movedown $0f
	wait 4
	moveright $21
	setspeed SPEED_080
	moveup $03
	wait 20
	applyspeed $03
	wait 20
	scriptend
script5ee5:
	checkcfc0bit 1
	wait 4
	setcounter1 $6a
	setcounter1 $44
	setcounter1 $32
	setcounter1 $44
	xorcfc0bit 2
	writeobjectbyte $7c $01
	asm15 $1e15
	setspeed SPEED_100
	moveright $11
	wait 4
	moveup $0f
	callscript script5f01
	scriptend
script5f01:
	setspeed SPEED_080
	moveup $03
	wait 20
	applyspeed $03
	wait 20
	retscript
script5f0a:
	writeobjectbyte $50 $28
	setzspeed -$0200
	playsound $53
script5f12:
	asm15 $59f3
	wait 1
	jumpifobjectbyteeq $7d $00 script5f12
	retscript
script5f1c:
	rungenericnpc $3a10
script5f1f:
	rungenericnpc $3a11
script5f22:
	checkabutton
	showtext $0b3e
	jumpiftradeitemeq $08 script5f2c
	jump2byte script5f22
script5f2c:
	setdisabledobjectsto91
	wait 30
script5f2e:
	showtext $0b3f
	jumpiftextoptioneq $00 script5f3e
	wait 30
	showtext $0b42
	enableallobjects
	checkabutton
	setdisabledobjectsto91
	jump2byte script5f2e
script5f3e:
	wait 30
	disableinput
	giveitem $4109
	wait 30
	showtext $0b40
	orroomflag $40
	enableinput
script5f4a:
	checkabutton
	showtext $0b41
	jump2byte script5f4a
script5f50:
	spawninteraction $470b $28 $44
	spawninteraction $4707 $28 $4c
	spawninteraction $4708 $28 $74
	scriptend
script5f60:
	showtext $0d00
	scriptend
script5f64:
	showtext $0d0b
	scriptend
script5f68:
	jumptable_objectbyte $78
	.dw script5f74
	.dw script5f79
	.dw script5f74
	.dw script5f79
	.dw script5f7e
script5f74:
	showtextnonexitable $0d01
	jump2byte script5f83
script5f79:
	showtextnonexitable $0d05
	jump2byte script5f83
script5f7e:
	showtextnonexitable $0d0a
	jump2byte script5f83
script5f83:
	jumpiftextoptioneq $00 script5f93
	writeobjectbyte $7b $ff
	writememory $cbad $03
	writememory $cba0 $01
	scriptend
script5f93:
	jumptable_objectbyte $79
	.dw script5fa5
	.dw script5f99
script5f99:
	writeobjectbyte $7b $ff
	writememory $cbad $01
	writememory $cba0 $01
	scriptend
script5fa5:
	jumptable_objectbyte $7a
	.dw script5fab
	.dw script5fb7
script5fab:
	writeobjectbyte $7b $01
	writememory $cbad $00
	writememory $cba0 $01
	scriptend
script5fb7:
	writeobjectbyte $7b $ff
	writememory $cbad $02
	writememory $cba0 $01
	scriptend
script5fc3:
	setcollisionradii $08 $04
	makeabuttonsensitive
	checkabutton
	setdisabledobjectsto11
	writememory $cc1d $b0
	writememory $cc17 $01
	setanimation $06
	setcounter1 $dc
	showtext $3d05
	wait 60
	writememory $cc04 $0f
	scriptend
script5fde:
	loadscript $14 $4973
script5fe2:
	loadscript $14 $4999
script5fe6:
	loadscript $14 $49b6
script5fea:
	loadscript $14 $49c8
script5fee:
	checkmemoryeq $cfc0 $01
	setanimation $02
	checkmemoryeq $cfc0 $02
	setspeed SPEED_100
	movedown $45
	setanimation $00
	checkmemoryeq $cfc0 $07
	setcoords $8c $40
	moveup $45
	setanimation $01
	checkmemoryeq $cfc0 $09
	setanimation $02
	checkmemoryeq $cfc0 $0a
	setanimation $01
	checkmemoryeq $cfc0 $0b
	movedown $49
	scriptend
script601c:
	rungenericnpc $5010
script601f:
	jumpifglobalflagset $26 script6048
	setdisabledobjectsto11
	setspeed SPEED_100
	setangleandanimation $00
	wait 60
	applyspeed $29
	wait 10
	setspeed SPEED_060
	setangleandanimation $18
	wait 60
	applyspeed $20
	wait 30
	asm15 $63d1 $01
	showtext $0607
	asm15 $59b3
	checkheartdisplayupdated
	wait 30
	setangle $08
	applyspeed $20
	wait 20
	setglobalflag $26
	enableinput
script6048:
	setcoords $68 $68
	initcollisions
script604c:
	checkabutton
	showtext $0608
	asm15 $59b3
	checkheartdisplayupdated
	jump2byte script604c
script6056:
	initcollisions
	checkabutton
	asm15 $5aac
	jumpifobjectbyteeq $7f $01 script606b
	showtext $050c
	disableinput
	asm15 $59b3
	checkheartdisplayupdated
	enableinput
	jump2byte script606e
script606b:
	showtext $050d
script606e:
	wait 30
script606f:
	checkabutton
	showtext $050e
	jump2byte script606f
script6075:
	writememory $cfde $00
	writememory $cfdf $00
	spawninteraction $5d08 $68 $48
	initcollisions
script6083:
	checkabutton
	setdisabledobjectsto91
	showtextlowindex $38
	jumpiftradeitemeq $07 script6091
	wait 30
	showtextlowindex $39
	enableallobjects
	jump2byte script6083
script6091:
	wait 30
script6092:
	showtextlowindex $3a
	jumpiftextoptioneq $00 script60a0
	wait 30
	showtextlowindex $3c
	enableallobjects
	checkabutton
	setdisabledobjectsto91
	jump2byte script6092
script60a0:
	loadscript $14 $49db
script60a4:
	rungenericnpclowindex $18
script60a6:
	showtext $0b3d
	scriptend
script60aa:
	showtext $0d09
	scriptend
script60ae:
	initcollisions
	checkabutton
	jumpifitemobtained $4a script60c3
	jumpifroomflagset $40 script60be
	showtextlowindex $02
	orroomflag $40
	jump2byte script60c0
script60be:
	showtextlowindex $03
script60c0:
	setstate2 $ff
	scriptend
script60c3:
	showtextlowindex $05
	jump2byte script60c0
script60c7:
	initcollisions
	asm15 $5ae2 $00
script60cc:
	checkabutton
	showloadedtext
	ormemory $cfd3 $01
	jump2byte script60cc
script60d4:
	initcollisions
	asm15 $5ae2 $01
script60d9:
	checkabutton
	setdisabledobjectsto11
	cplinkx $48
	setanimationfromobjectbyte $48
	showloadedtext
	ormemory $cfd3 $02
	enableallobjects
	jump2byte script60d9
script60e8:
	initcollisions
	asm15 $5ae2 $02
script60ed:
	checkabutton
	showloadedtext
	ormemory $cfd3 $04
	jump2byte script60ed
script60f5:
	initcollisions
	asm15 $5ae2 $03
script60fa:
	checkabutton
	showloadedtext
	ormemory $cfd3 $08
	jump2byte script60fa
script6102:
	initcollisions
	asm15 $5ae2 $04
	checkabutton
	asm15 $5ad7
	showloadedtext
	ormemory $cfd3 $10
	asm15 $5ae2 $05
script6114:
	checkabutton
	asm15 $5ad7
	showloadedtext
	jump2byte script6114
script611b:
	setcollisionradii $12 $04
	makeabuttonsensitive
	asm15 $5ae2 $06
script6123:
	checkabutton
	setanimation $06
	showloadedtext
	ormemory $cfd3 $20
	jump2byte script6123
script612d:
	setcollisionradii $12 $04
	makeabuttonsensitive
	asm15 $5ae2 $07
script6135:
	checkabutton
	setdisabledobjectsto11
	setanimation $06
	showloadedtext
	ormemory $cfd3 $40
	orroomflag $40
	jump2byte script6135
script6142:
	loadscript $14 $4a0f
script6146:
	loadscript $14 $4a4b
script614a:
	initcollisions
	settextid $3d19
script614e:
	checkabutton
	setdisabledobjectsto11
	cplinkx $48
	setanimationfromobjectbyte $48
	showloadedtext
	wait 8
	writeobjectbyte $48 $01
	setanimationfromobjectbyte $48
	enableallobjects
	jump2byte script614e
script6160:
	setcoords $53 $82
	scriptend
script6164:
	loadscript $14 $4a6d
script6168:
	wait 60
	showtext $1e06
	wait 60
	writememory $cfd0 $0f
	scriptend
script6172:
	loadscript $14 $4a91
script6176:
	setcollisionradii $22 $20
	makeabuttonsensitive
	jumpifglobalflagset $28 script61ee
script617e:
	jumpifroomflagset $40 script61d7
	asm15 $5af5 $0b
script6186:
	checkabutton
	disableinput
	asm15 $5af5 $0d
	showtextlowindex $26
	asm15 $5af5 $0b
	jumpiftradeitemeq $04 script6199
	enableinput
	jump2byte script6186
script6199:
	wait 30
script619a:
	setanimation $02
	asm15 $5af5 $0d
	showtextlowindex $27
	asm15 $5af5 $0b
	jumpiftextoptioneq $00 script61bc
	wait 30
	setanimation $00
	asm15 $5af5 $0d
	showtextlowindex $2a
	asm15 $5af5 $0b
	enableinput
	checkabutton
	disableinput
	jump2byte script619a
script61bc:
	wait 30
	setanimation $03
	asm15 $5af5 $0b
	wait 60
	setanimation $02
	asm15 $5af5 $0c
	wait 60
	asm15 $5af5 $0d
	showtextlowindex $28
	disableinput
	giveitem $4105
	orroomflag $40
script61d7:
	disableinput
	setanimation $01
	asm15 $5af5 $0b
	enableinput
script61df:
	checkabutton
	disableinput
	asm15 $5af5 $0d
	showtextlowindex $29
	asm15 $5af5 $0b
	enableinput
	jump2byte script61df
script61ee:
	asm15 $5af8
	jumpifobjectbyteeq $7f $00 script617e
	setanimation $01
	asm15 $5af5 $0b
	jumpifglobalflagset $62 script6260
script6200:
	checkabutton
	disableinput
	asm15 $5af5 $0d
	showtextlowindex $52
	asm15 $5af5 $0b
	jumpiftextoptioneq $00 script621e
	wait 30
	asm15 $5af5 $0d
	showtextlowindex $53
	asm15 $5af5 $0b
	enableinput
	jump2byte script6200
script621e:
	wait 30
	asm15 $5af5 $0d
	showtextlowindex $54
	asm15 $5af5 $0b
	generateoraskforsecret $28
	wait 30
	jumptable_memoryaddress $cca3
	.dw script6240
	.dw script6233
script6233:
	asm15 $5af5 $0d
	showtextlowindex $56
	asm15 $5af5 $0b
	enableinput
	jump2byte script6200
script6240:
	loadscript $14 $4aa3
script6244:
	generateoraskforsecret $38
script6246:
	asm15 $5af5 $0d
	showtextlowindex $58
	asm15 $5af5 $0b
	wait 30
	jumpiftextoptioneq $00 script6246
	asm15 $5af5 $0d
	showtextlowindex $59
	asm15 $5af5 $0b
	enableinput
script6260:
	checkabutton
	disableinput
	jump2byte script6244
script6264:
	initcollisions
script6265:
	checkabutton
	disablemenu
	asm15 $5bcc
	jumpifitemobtained $49 script6277
	showtext $2707
	asm15 $5bd5
	enablemenu
	jump2byte script6265
script6277:
	loadscript $14 $4b4c
script627b:
	checkcfc0bit 0
	setstate $04
	setspeed SPEED_200
	moveleft $19
	moveup $11
	checkcfc0bit 1
	setangleandanimation $10
	checkcfc0bit 2
	movedown $21
	scriptend
script628b:
	jumpifroomflagset $40 script62ae
	jumpifitemobtained $51 script6296
script6293:
	rungenericnpc $270a
script6296:
	jumpifitemobtained $50 script629c
	jump2byte script6293
script629c:
	initcollisions
script629d:
	checkabutton
	showtext $2a00
	jumpiftextoptioneq $00 script62aa
	showtext $2a01
	jump2byte script629d
script62aa:
	loadscript $14 $4aea
script62ae:
	rungenericnpc $2a05
script62b1:
	xorcfc0bit 0
	wait 20
	xorcfc0bit 1
	wait 20
	xorcfc0bit 2
	wait 20
	xorcfc0bit 0
	wait 20
	xorcfc0bit 1
	wait 20
	xorcfc0bit 2
	wait 20
	xorcfc0bit 0
	setcounter1 $12
	xorcfc0bit 1
	setcounter1 $12
	xorcfc0bit 2
	setcounter1 $12
	xorcfc0bit 0
	wait 20
	retscript
script62c9:
	setspeed SPEED_100
	setstate $04
	moveup $31
	setangleandanimation $10
	setstate $05
	checkcfc0bit 7
	movedown $31
	setstate $01
	rungenericnpc $2702
script62db:
	setspeed SPEED_100
	setstate $04
	moveup $11
	moveright $21
	setangleandanimation $10
	setstate $05
	checkcfc0bit 7
	moveleft $21
	movedown $11
	setstate $01
	rungenericnpc $2703


; ==============================================================================
; INTERACID_SUBROSIAN_AT_D8
; ==============================================================================

subrosianAtD8Script_tossItemIntoHole:
	callscript @spin2win
	callscript @spin2win
	setspeed SPEED_200
	applyspeed $04
	asm15 $5bd8 ; TODO
	setangle $18
	applyspeed $04
	scriptend

@spin2win:
	setangleandanimation $00
	wait 4
	setangleandanimation $18
	wait 4
	setangleandanimation $10
	wait 4
	setangleandanimation $08
	wait 4
	retscript

subrosianAtD8Script:
	jumpifroomflagset $80, @alreadyBlewUpVolcano
	orroomflag $80
	disableinput
	playsound SND_SOLVEPUZZLE
	writememory w1Link.direction, $03
	wait 60
	showtext TX_3c01
	enableinput

@alreadyBlewUpVolcano:
	rungenericnpc TX_3c01


script6325:
	initcollisions
	jumpifroomflagset $40 script635d
script632a:
	checkabutton
	setdisabledobjectsto91
	setanimation $05
	showtextlowindex $2b
	setanimationfromangle
	jumpiftradeitemeq $05 script6339
	enableallobjects
	jump2byte script632a
script6339:
	wait 30
script633a:
	showtextlowindex $2c
	jumpiftextoptioneq $00 script6348
	wait 30
	showtextlowindex $2f
	enableallobjects
	checkabutton
	setdisabledobjectsto91
	jump2byte script633a
script6348:
	wait 30
	callscript script63a0
	showtextlowindex $51
	wait 30
	showtextlowindex $2d
	disableinput
	giveitem $4106
	spawninteraction $4c09 $08 $58
	orroomflag $40
	enableinput
script635d:
	checkabutton
	showtextlowindex $2e
	jump2byte script635d
script6362:
	writeobjectbyte $7e $01
	setspeed SPEED_200
	moveup $14
	wait 4
	moveleft $11
	writeobjectbyte $7e $00
	wait 10
	setanimation $05
	showtextlowindex $30
	writeobjectbyte $7e $01
	getrandombits $7f $01
	jumptable_objectbyte $7f
	.dw script6380
	.dw script638a
script6380:
	moveright $11
	wait 4
	movedown $14
	writeobjectbyte $7e $00
	enableinput
	scriptend
script638a:
	movedown $14
	wait 4
	moveleft $19
	wait 4
	movedown $11
	wait 4
	moveright $19
	wait 4
	moveup $11
	wait 4
	moveright $11
	writeobjectbyte $7e $00
	enableinput
	scriptend
script63a0:
	asm15 $5be3
script63a3:
	asm15 $5bf4
	wait 1
	jumpifobjectbyteeq $7d $00 script63a3
	retscript
script63ad:
	initcollisions
	jumpifroomflagset $40 script63f2
script63b2:
	checkabutton
	disableinput
	writeobjectbyte $7b $00
	showtextlowindex $48
	jumpiftradeitemeq $0a script63c3
	writeobjectbyte $7b $01
	enableinput
	jump2byte script63b2
script63c3:
	wait 30
script63c4:
	showtextlowindex $49
	jumpiftextoptioneq $00 script63d8
	wait 30
	showtextlowindex $4c
	writeobjectbyte $7b $01
	enableinput
	checkabutton
	disableinput
	writeobjectbyte $7b $00
	jump2byte script63c4
script63d8:
	wait 30
	showtextlowindex $4a
	disableinput
	cplinkx $48
	addobjectbyte $48 $06
	setanimationfromobjectbyte $48
	giveitem $410b
	orroomflag $40
	writeobjectbyte $79 $01
	setcounter1 $32
	writeobjectbyte $7b $01
	enableinput
script63f2:
	checkabutton
	disableinput
	writeobjectbyte $7b $00
	showtextlowindex $4b
	writeobjectbyte $7b $01
	enableinput
	jump2byte script63f2
script63ff:
	setcollisionradii $0c $06
	makeabuttonsensitive
	checkabutton
	disableinput
	asm15 $1e39
	xorcfc0bit 0
	callscript script6411
	orroomflag $40
	wait 90
	enableinput
	scriptend
script6411:
	jumptable_objectbyte $42
	.dw script6417
	.dw script641e
script6417:
	giveitem $0501
	giveitem $0504
	retscript
script641e:
	giveitem $0502
	giveitem $0505
	retscript
script6425:
	initcollisions
	asm15 $5c9b
script6429:
	asm15 $5c00
	asm15 $5c29
	jumpifroomflagset $40 script643d
	checkabutton
	setdisabledobjectsto91
	showtextlowindex $00
	jumpiftextoptioneq $00 script6455
	jump2byte script644f
script643d:
	checkabutton
	setdisabledobjectsto91
	showtextlowindex $0a
	jumpiftextoptioneq $00 script6455
	jump2byte script644f
script6447:
	checkabutton
	setdisabledobjectsto91
	showtextlowindex $01
	jumpiftextoptioneq $00 script6455
script644f:
	wait 30
	showtextlowindex $02
	enableallobjects
	jump2byte script6447
script6455:
	wait 30
script6456:
	jumpifobjectbyteeq $77 $00 script6461
script645b:
	showtextlowindex $04
	enableallobjects
	checkabutton
	jump2byte script645b
script6461:
	disableinput
script6462:
	jumpifobjectbyteeq $78 $05 script646b
	showtextlowindex $03
	jump2byte script646d
script646b:
	showtextlowindex $0d
script646d:
	jumpiftextoptioneq $00 script6474
	wait 30
	jump2byte script6462
script6474:
	asm15 $5c23
	asm15 $3144
	checkpalettefadedone
	setdisabledobjectsto11
	writememory $cced $01
	asm15 $5c3d
	asm15 $5c49
	asm15 $5c61
	asm15 $5cb0 $00
	wait 4
	asm15 $3171
	checkpalettefadedone
	showtextlowindex $05
	playsound $c8
	setmusic $2d
	enableinput
	scriptend
script649a:
	disableinput
	wait 20
	playsound $c8
	wait 20
	playsound $c8
	wait 20
	playsound $c8
	wait 90
	asm15 $3144
	checkpalettefadedone
	setdisabledobjectsto11
	asm15 $5c80
	asm15 $5c49
	wait 4
	asm15 $3171
	checkpalettefadedone
	setmusic $ff
	writeobjectbyte $71 $00
	jumptable_memoryaddress $ccec
	.dw script64c5
	.dw script64c5
	.dw script64dc
	.dw script64e4
script64c5:
	jumpifroomflagset $40 script64d3
	showtextlowindex $06
	giveitem $4800
	orroomflag $40
	enableinput
	jump2byte script64d9
script64d3:
	showtextlowindex $0b
	asm15 $5c36
	enableinput
script64d9:
	checkabutton
	jump2byte script6429
script64dc:
	showtextlowindex $08
	jumpiftextoptioneq $00 script64ee
	jump2byte script64f4
script64e4:
	setglobalflag $1a
script64e6:
	showtextlowindex $09
	jumpiftextoptioneq $00 script64ee
	jump2byte script64fd
script64ee:
	asm15 $5c00
	enableinput
	jump2byte script6456
script64f4:
	wait 30
	showtextlowindex $02
	wait 30
	enableinput
	checkabutton
	disableinput
	jump2byte script64dc
script64fd:
	wait 30
	showtextlowindex $02
	wait 30
	enableinput
	checkabutton
	disableinput
	jump2byte script64e6
script6506:
	setcollisionradii $20 $30
	checkcollidedwithlink_onground
	setdisabledobjectsto91
	setcollisionradii $06 $06
	writeobjectbyte $77 $01
	setanimation $01
	checkobjectbyteeq $61 $ff
	writeobjectbyte $77 $02
	jumpiftradeitemeq $0b script652c
	showtextlowindex $4d
script651f:
	writeobjectbyte $77 $03
	setanimation $03
	checkobjectbyteeq $61 $ff
	writeobjectbyte $77 $00
	enableallobjects
	scriptend
script652c:
	showtextlowindex $4e
	wait 30
	showtextlowindex $4f
	jumpiftextoptioneq $00 script6537
	jump2byte script651f
script6537:
	wait 30
	writeobjectbyte $77 $04
	setanimation $04
	writeobjectbyte $4f $ff
	showtextlowindex $50
	checkobjectbyteeq $61 $ff
	writeobjectbyte $4f $00
	jump2byte script651f
script654a:
	initcollisions
	jumpifroomflagset $40 script656c
script654f:
	checkabutton
	showtextlowindex $1f
	jumpiftradeitemeq $03 script6558
	jump2byte script654f
script6558:
	setdisabledobjectsto91
	wait 30
script655a:
	showtextlowindex $20
	jumpiftextoptioneq $00 script6568
	wait 30
	showtextlowindex $25
	enableallobjects
	checkabutton
	setdisabledobjectsto91
	jump2byte script655a
script6568:
	loadscript $14 $4b8e
script656c:
	checkabutton
	showtextlowindex $24
	jump2byte script656c
script6571:
	setspeed SPEED_080
	wait 30
	setangle $00
	applyspeed $40
	setangle $08
	applyspeed $20
	setangle $00
	applyspeed $20
	setangle $18
	applyspeed $60
	setangle $00
	applyspeed $a0
	setangle $08
	applyspeed $20
	setangle $10
	applyspeed $20
	setangle $08
	applyspeed $20
	setangle $00
	applyspeed $20
script6598:
	wait 30
	createpuff
	enableallobjects
	asm15 $12ae
	setstate $03
	scriptend
script65a1:
	setspeed SPEED_080
	wait 30
	setangle $00
	applyspeed $40
	setangle $08
	applyspeed $20
	setangle $00
	applyspeed $60
	setangle $18
	applyspeed $60
	setangle $00
	applyspeed $60
	setangle $08
	applyspeed $40
	jump2byte script6598
script65be:
	setspeed SPEED_080
	wait 30
	setangle $18
	applyspeed $40
	setangle $00
	applyspeed $20
	setangle $08
	applyspeed $60
	setangle $00
	applyspeed $20
	setangle $18
	applyspeed $60
	setangle $00
	applyspeed $a0
	setangle $08
	applyspeed $60
	setangle $00
	applyspeed $20
	setangle $18
	applyspeed $20
	jump2byte script6598
script65e7:
	setspeed SPEED_080
	wait 30
	setangle $00
	applyspeed $80
	setangle $18
	applyspeed $20
	setangle $10
	applyspeed $40
	setangle $08
	applyspeed $40
	setangle $00
	applyspeed $20
	setangle $18
	applyspeed $60
	setangle $00
	applyspeed $a0
	setangle $08
	applyspeed $40
	jump2byte script6598
script660c:
	setcoords $58 $b8
	spawnitem $3001
	scriptend
script6613:
	initcollisions
	jumpifroomflagset $80 script6623
	checkabutton
	showtext $0100
	jumpiftextoptioneq $00 script6630
	showtext $0103
script6623:
	checkabutton
	showtext $0101
	jumpiftextoptioneq $00 script6630
	showtext $0103
	jump2byte script6623
script6630:
	loadscript $14 $4be4
script6634:
	showtext $0115
	jumpiftextoptioneq $01 script6641
	asm15 $313b
	setstate2 $ff
	scriptend
script6641:
	loadscript $14 $4c06
script6645:
	giveitem $0600
	jump2byte script6657
script664a:
	giveitem $0e00
	jump2byte script6657
script664f:
	giveitem $3400
	jump2byte script6657
script6654:
	giveitem $3700
script6657:
	wait 30
	setmusic $ff
	enableinput
	setstate2 $ff
	initcollisions
script665e:
	checkabutton
	showloadedtext
	jump2byte script665e
script6662:
	rungenericnpc $3e03
script6665:
	initcollisions
	asm15 $5d54
	jumptable_memoryaddress $cfc1
	.dw script6674
	.dw script6686
	.dw script6690
	.dw script669b
script6674:
	jumpifroomflagset $20 script6678
script6678:
	checkabutton
	jumpifitemobtained $43 script6686
	setanimation $01
	showtext $2400
	setanimation $00
	jump2byte script6678
script6686:
	checkabutton
	setanimation $01
	showtext $2402
	setanimation $00
	jump2byte script6686
script6690:
	checkabutton
	orroomflag $80
	setanimation $01
	showtext $2403
	setanimation $00
	wait 30
script669b:
	checkabutton
	setanimation $01
	showtext $2404
	setanimation $00
	jump2byte script669b
script66a5:
	showtext $2401
	enableinput
	scriptend
script66aa:
	checkmemoryeq $cc32 $01
	asm15 $5d89
	wait 8
	disableinput
	wait 30
	playsound $c2
	asm15 $1e42
	wait 60
	asm15 $1e39
	orroomflag $40
	settilehere $aa
	playsound $f1
	playsound $4d
	asm15 $5d92
	enableinput
	scriptend
script66ca:
	checkcfc0bit 0
	disableinput
	wait 60
	playsound $f0
	shakescreen 120
	wait 60
	writememory $d008 $01
	orroomflag $80
	spawninteraction $6b14 $00 $00
	setstate $ff
	scriptend
script66e0:
	checkcfc0bit 0
	asm15 $5d74
	playsound $f0
	wait 60
	playsound $b8
	shakescreen 255
	wait 60
	writememory $d008 $02
	orroomflag $80
	scriptend
script66f3:
	disableinput
	playsound $4d
	settilehere $53
	createpuff
	orroomflag $40
	enableinput
	scriptend
script66fd:
	orroomflag $40
	wait 30
	playsound $4d
	wait 20
	setcoords $08 $28
	createpuff
	settilehere $d0
	settileat $01 $6b
	settileat $03 $45
	scriptend
script6710:
	wait 30
	showtext $4d08
	xorcfc0bit 0
	enableinput
	scriptend
script6717:
	jumpifroomflagset $40 script671f
	loadscript $14 $4e3f
script671f:
	loadscript $14 $4e56
script6723:
	xorcfc0bit 0
	asm15 $5db1
	setstate2 $03
	moveup $30
	enableinput
	scriptend
script672d:
	asm15 $5e4e
	setstate2 $04
	setspeed SPEED_100
	jumprandom script6739 script673d
script6739:
	loadscript $14 $4e62
script673d:
	loadscript $14 $4e79
script6741:
	asm15 $5e4e
	setstate2 $04
	setspeed SPEED_100
	jumprandom script674d script6751
script674d:
	loadscript $14 $4e97
script6751:
	loadscript $14 $4ec1
script6755:
	asm15 $5e4e
	setstate2 $04
	setspeed SPEED_100
	jumprandom script6761 script6765
script6761:
	loadscript $14 $4ee6
script6765:
	loadscript $14 $4f02
script6769:
	loadscript $14 $4f1b
script676d:
	loadscript $14 $4f26
script6771:
	loadscript $14 $4f44
script6775:
	wait 30
	setangleandanimation $10
	wait 30
	setangleandanimation $18
	wait 30
	setangleandanimation $08
	wait 30
	retscript
script6780:
	wait 30
	setangleandanimation $18
	wait 30
	setangleandanimation $00
	wait 30
	setangleandanimation $10
	wait 30
	retscript
script678b:
	wait 30
	setangleandanimation $00
	wait 30
	setangleandanimation $08
	wait 30
	setangleandanimation $18
	wait 30
	retscript
script6796:
	wait 30
	setangleandanimation $08
	wait 30
	setangleandanimation $10
	wait 30
	setangleandanimation $00
	wait 30
	retscript
script67a1:
	jumptable_memoryaddress $cfd0
	.dw script67a8
	.dw script67be
script67a8:
	setcoords $18 $48
	setangleandanimation $18
	callscript script67dd
	moveleft $30
	callscript script6a13
	movedown $60
	callscript script6a0b
	movedown $20
	xorcfc0bit 0
	scriptend
script67be:
	setcoords $48 $18
	setangleandanimation $00
	callscript script67dd
	moveup $30
	callscript script69fe
	moveright $30
	movedown $10
	moveright $10
	callscript script6a20
	movedown $50
	callscript script6a0b
	movedown $20
	xorcfc0bit 0
	scriptend
script67dd:
	jumpifglobalflagset $11 script67e9
script67e1:
	asm15 $5db1
	wait 60
	asm15 $5e4e
	retscript
script67e9:
	disableinput
	showtext $2805
	showtext $2806
	enableinput
	xorcfc0bit 0
	jump2byte script67e1
script67f4:
	jumpifglobalflagset $11 script67fa
	jump2byte script67e1
script67fa:
	checkcfc0bit 0
	jump2byte script67e1
script67fd:
	jumptable_memoryaddress $cfd0
	.dw script6804
	.dw script682a
script6804:
	setcoords $28 $78
	asm15 $5e4e
	setangleandanimation $10
	wait 60
	movedown $30
	callscript script6a0b
	wait 180
	moveleft $30
	moveup $30
	callscript script6a0b
	moveright $30
	movedown $30
	wait 120
	moveleft $10
	movedown $20
	callscript script6a0b
	movedown $20
	xorcfc0bit 0
	scriptend
script682a:
	setcoords $78 $28
	asm15 $5e4e
	setangleandanimation $18
	wait 60
	moveleft $10
	moveup $30
	setcounter1 $96
	moveright $20
	callscript script6a20
	moveup $30
	moveleft $20
	callscript script6a13
	wait 120
	moveright $30
	movedown $60
	callscript script6a0b
	movedown $20
	xorcfc0bit 0
	scriptend
script6851:
	jumptable_memoryaddress $cfd0
	.dw script6858
	.dw script687c
script6858:
	setcoords $38 $78
	asm15 $5e4e
	setangleandanimation $18
	wait 60
	moveleft $60
	callscript script6a13
	moveup $20
	callscript script69fe
	moveup $10
	moveright $40
	movedown $30
	callscript script6a0b
	moveleft $40
	movedown $10
	moveleft $30
	xorcfc0bit 0
	scriptend
script687c:
	setcoords $38 $48
	asm15 $5e4e
	setangleandanimation $18
	setcounter1 $7a
	setangleandanimation $10
	setcounter1 $3e
	setangleandanimation $08
	setcounter1 $3e
	setangleandanimation $00
	setcounter1 $3e
	moveleft $30
	movedown $10
	moveleft $30
	xorcfc0bit 0
	scriptend
script689a:
	jumptable_memoryaddress $cfd0
	.dw script68a1
	.dw script68be
script68a1:
	setcoords $38 $38
	asm15 $5e4e
	setangleandanimation $18
	wait 60
	moveleft $20
	callscript script6a13
	moveup $20
	moveright $30
	moveright $30
	moveup $10
	callscript script69fe
	moveup $20
	xorcfc0bit 0
	scriptend
script68be:
	setcoords $18 $18
	asm15 $5e4e
	setangleandanimation $10
	wait 60
	movedown $30
	callscript script6a0b
	moveright $50
	callscript script6a20
	moveup $10
	moveright $20
	callscript script6a20
	moveup $50
	xorcfc0bit 0
	scriptend
script68dc:
	jumptable_memoryaddress $cfd0
	.dw script68e3
	.dw script6905
script68e3:
	setcoords $08 $48
	asm15 $5e4e
	setangleandanimation $08
	wait 60
	moveright $40
	movedown $10
	callscript script6a0b
	movedown $20
	moveleft $60
	callscript script6a20
	moveup $30
	moveright $40
	callscript script6a13
	moveup $20
	xorcfc0bit 0
	scriptend
script6905:
	setcoords $08 $78
	asm15 $5e4e
	setangleandanimation $18
	wait 60
	movedown $60
	callscript script6a0b
	moveleft $30
	callscript script6a13
	moveup $30
	callscript script69fe
	moveright $40
	callscript script6a20
	moveup $50
	xorcfc0bit 0
	scriptend
script6926:
	jumptable_memoryaddress $cfd0
	.dw script692d
	.dw script694f
script692d:
	setcoords $18 $18
	asm15 $5e4e
	setangleandanimation $10
	wait 60
	movedown $60
	callscript script6a0b
	moveright $30
	callscript script6a20
	moveup $30
	moveleft $10
	moveup $30
	callscript script69fe
	moveleft $20
	movedown $80
	xorcfc0bit 0
	scriptend
script694f:
	setcoords $18 $18
	asm15 $5e4e
	setangleandanimation $10
	wait 60
	movedown $30
	moveright $30
	callscript script6a20
	movedown $30
	callscript script6a0b
	moveleft $30
	moveup $30
	moveright $30
	movedown $50
	xorcfc0bit 0
	scriptend
script696e:
	disableinput
	setcoords $48 $18
	setanimation $01
	playsound $4d
	checkflagset $00 $cd00
	asm15 $5d9a
	wait 60
	showtext $2803
	xorcfc0bit 0
	movedown $50
	setmusic $ff
	spawninteraction $6b16 $48 $28
	asm15 $5dc4
	enableinput
	scriptend
script6990:
	jumptable_memoryaddress $cfd0
	.dw script6997
	.dw script69a3
script6997:
	setcoords $28 $18
	setangleandanimation $10
	callscript script67f4
	loadscript $14 $4f51
script69a3:
	setcoords $48 $28
	setangleandanimation $00
	callscript script67f4
	loadscript $14 $4f64
script69af:
	jumptable_memoryaddress $cfd0
	.dw script69b6
	.dw script69ba
script69b6:
	loadscript $14 $4f7f
script69ba:
	loadscript $14 $4fa9
script69be:
	jumptable_memoryaddress $cfd0
	.dw script69c5
	.dw script69c9
script69c5:
	loadscript $14 $4fcb
script69c9:
	loadscript $14 $4fe9
script69cd:
	jumptable_memoryaddress $cfd0
	.dw script69d4
	.dw script69d8
script69d4:
	loadscript $14 $5013
script69d8:
	loadscript $14 $503a
script69dc:
	jumptable_memoryaddress $cfd0
	.dw script69e3
	.dw script69e7
script69e3:
	loadscript $14 $504f
script69e7:
	loadscript $14 $506d
script69eb:
	jumptable_memoryaddress $cfd0
	.dw script69f2
	.dw script69f6
script69f2:
	loadscript $14 $5089
script69f6:
	loadscript $14 $50ab
script69fa:
	loadscript $14 $50ca
script69fe:
	setangleandanimation $10
	wait 30
	setangleandanimation $00
	wait 30
script6a04:
	setangleandanimation $08
	wait 30
	setangleandanimation $18
	wait 30
	retscript
script6a0b:
	setangleandanimation $00
	wait 30
	setangleandanimation $10
	wait 30
	jump2byte script6a04
script6a13:
	setangleandanimation $08
	wait 30
	setangleandanimation $18
	wait 30
script6a19:
	setangleandanimation $00
	wait 30
	setangleandanimation $10
	wait 30
	retscript
script6a20:
	setangleandanimation $18
	wait 30
	setangleandanimation $08
	wait 30
	jump2byte script6a19
script6a28:
	setcollisionradii $12 $30
	checkcollidedwithlink_onground
	disableinput
	asm15 $5e6f
	playsound $cc
	wait 8
	playsound $cc
	wait 30
	writememory $d008 $03
	wait 30
	writememory $d008 $01
	setmusic $0b
	asm15 $5e75
	xorcfc0bit 0
	wait 20
	writememory $d008 $01
	checkcfc0bit 1
	playsound $85
	asm15 $5e5d
	setspeed SPEED_100
	setangle $04
	setstate $ff
	initcollisions
	wait 120
	setzspeed -$0100
	jumpifroomflagset $20 script6a6f
	jump2byte script6a66
script6a61:
	initcollisions
	jumpifroomflagset $20 script6a6f
script6a66:
	checkabutton
	showtext $2c00
	disableinput
	giveitem $1500
	enablemenu
script6a6f:
	enableallobjects
	checkabutton
	setdisabledobjectsto91
	jumpifglobalflagset $25 script6a7b
	showtext $2c01
	jump2byte script6a6f
script6a7b:
	showtext $2c02
	jump2byte script6a6f
script6a80:
	jumpifc6xxset $45 $02 script6ad9
	jumpifc6xxset $45 $01 script6ab8
	jumpifmemoryset $d13e $04 script6a92
	jump2byte script6a80
script6a92:
	disablemenu
	writeobjectbyte $5a $00
script6a96:
	jumpifmemoryset $d13e $20 script6a9e
	jump2byte script6a96
script6a9e:
	checkmemoryeq $d12b $00
	asm15 $5e91
	checkmemoryeq $d115 $00
	writememory $d106 $20
	checkmemoryeq $d106 $00
	asm15 $5ea6
	checkflagset $07 $d121
script6ab8:
	writememory $d103 $05
	writememory $d13f $03
	enablemenu
	checkmemoryeq $d13d $01
	disablemenu
	writememory $d13d $00
	jumpifmemoryeq $cc01 $00 script6ad5
	showtext $2214
	jump2byte script6ad9
script6ad5:
	disablemenu
	showtext $220a
script6ad9:
	disablemenu
	writememory $d13f $03
	writememory $d103 $06
	ormemory $c645 $02
	checkflagset $02 $c645
	writememory $d13f $03
	writememory $d103 $06
	writememory $d13d $00
	checkmemoryeq $d13d $01
	disablemenu
	jumpifmemoryeq $cc01 $00 script6b0c
	showtext $2215
	writeobjectbyte $44 $02
	showtext $003a
	jump2byte script6b15
script6b0c:
	showtext $220d
	writeobjectbyte $44 $02
	showtext $006a
script6b15:
	showtext $2213
	ormemory $c645 $20
	checkmemoryeq $cc48 $d1
	showtext $2212
	enablemenu
	enableallobjects
	scriptend
script6b26:
	checkmemoryeq $d13d $01
	disablemenu
	setdisabledobjectsto11
	jumpifitemobtained $48 script6b55
	enablemenu
	jumpifmemoryeq $cc01 $00 script6b47
	jumpifmemoryset $c643 $10 script6b42
	showtext $200a
	jump2byte script6b4a
script6b42:
	showtext $200b
	jump2byte script6b4a
script6b47:
	showtext $2000
script6b4a:
	writememory $d13d $00
	ormemory $c643 $10
	enableallobjects
	jump2byte script6b26
script6b55:
	jumpifmemoryeq $cc01 $00 script6b6b
	jumpifmemoryset $c643 $10 script6b66
	showtext $200a
	jump2byte script6b6e
script6b66:
	showtext $200b
	jump2byte script6b6e
script6b6b:
	showtext $2000
script6b6e:
	wait 30
	showtext $2001
	wait 30
	writememory $d13d $00
	jumpifmemoryeq $c610 $0b script6b85
	showtext $2002
	writeobjectbyte $44 $02
	jump2byte script6b9c
script6b85:
	jumpifmemoryeq $cc01 $00 script6b90
	showtext $200c
	jump2byte script6b93
script6b90:
	showtext $2006
script6b93:
	writeobjectbyte $44 $02
	showtext $0038
	showtext $2008
script6b9c:
	writememory $d103 $01
	checkmemoryeq $cc48 $d1
	showtext $2005
	enableallobjects
	scriptend
script6ba9:
	disablemenu
	writememory $d13f $01
	jumpifmemoryset $d13e $01 script6bb6
	jump2byte script6ba9
script6bb6:
	writememory $d108 $03
	setcounter1 $10
	writememory $d13f $08
	writememory $d103 $04
script6bc4:
	jumpifmemoryset $d13e $02 script6bcc
	jump2byte script6bc4
script6bcc:
	asm15 $5eb4
	enableallobjects
	checkmemoryeq $cc77 $00
	writememory $d008 $01
	setdisabledobjectsto11
	writememory $d103 $05
	setcounter1 $10
	showtext $2003
	setdisabledobjectsto11
	asm15 $5ec7
script6be6:
	jumpifmemoryset $d13e $04 script6bee
	jump2byte script6be6
script6bee:
	writememory $d108 $00
	writememory $d13f $18
	writememory $d103 $07
	setcounter1 $96
	writememory $d108 $02
	writememory $d13f $03
	writememory $d103 $06
	enablemenu
	scriptend
script6c0a:
	checkmemoryeq $d13d $01
	jumpifmemoryset $c644 $08 script6c1d
	showtext $2103
	writememory $d13d $00
	jump2byte script6c0a
script6c1d:
	disablemenu
	jumpifmemoryeq $cc01 $00 script6c2f
	showtext $2115
	writeobjectbyte $44 $02
	showtext $0039
	jump2byte script6c38
script6c2f:
	showtext $210b
	writeobjectbyte $44 $02
	showtext $0069
script6c38:
	showtext $211f
	writememory $d126 $06
	writememory $d127 $08
	ormemory $c644 $80
	checkmemoryeq $cc48 $d1
	showtext $211d
	enableallobjects
	enablemenu
	scriptend
script6c51:
	checkmemoryeq $d13d $01
	jumpifmemoryset $c644 $08 script6c64
	showtext $2103
	writememory $d13d $00
	jump2byte script6c51
script6c64:
	disablemenu
	showtext $2120
	jump2byte script6c38
script6c6a:
	writememory $d13f $14
	writememory $d108 $00
	checkpalettefadedone
	disablemenu
	writememory $d103 $09
script6c78:
	jumpifmemoryset $d13e $01 script6c80
	jump2byte script6c78
script6c80:
	writememory $d13f $16
	setcounter1 $20
	writememory $d13f $14
	setcounter1 $20
	writememory $d13f $16
	setcounter1 $20
	writememory $d13f $14
	setcounter1 $20
	writememory $d13f $16
	setcounter1 $20
	ormemory $d13e $02
	scriptend
script6ca3:
	checkmemoryeq $d13d $01
	jumptable_objectbyte $78
	.dw script6cd8
	.dw script6cad
script6cad:
	showtext $2211
	writeobjectbyte $44 $02
	asm15 $5ede
	jumptable_objectbyte $7b
	.dw script6cc1
	.dw script6cbc
script6cbc:
	showtext $2219
	jump2byte script6cc4
script6cc1:
	showtext $2216
script6cc4:
	writememory $c645 $80
	enableallobjects
	checkmemoryeq $cc48 $d1
	jumptable_objectbyte $7b
	.dw script6cd3
	.dw script6cd6
script6cd3:
	showtext $2212
script6cd6:
	enablemenu
	scriptend
script6cd8:
	showtext $2210
	writememory $d13d $00
	enableallobjects
	enablemenu
	jump2byte script6ca3
script6ce3:
	writememory $ccab $01
	makeabuttonsensitive
	jumpifc6xxset $44 $04 script6d15
	disablemenu
	setdisabledobjectsto11
	writememory $ccab $00
	callscript script6f43
script6cf6:
	jumptable_objectbyte $77
	.dw script6cf6
	.dw script6cfc
script6cfc:
	showtext $2100
	ormemory $c644 $01
	setangleandanimation $00
	checkabutton
	showtextnonexitable $2104
	jumpiftextoptioneq $00 script6d29
script6d0d:
	showtext $2107
	jump2byte script6d15
script6d12:
	showtext $211b
script6d15:
	writememory $ccab $00
	setangleandanimation $00
	jumpifglobalflagset $2b script6d2f
	checkabutton
	showtextnonexitable $2104
	jumpiftextoptioneq $00 script6d29
	jump2byte script6d0d
script6d29:
	jumptable_objectbyte $79
	.dw script6d12
	.dw script6d35
script6d2f:
	checkabutton
	showtextnonexitable $2106
	jump2byte script6d3d
script6d35:
	setglobalflag $2b
	writeobjectbyte $7a $0b
	showtextnonexitable $2106
script6d3d:
	jumpiftextoptioneq $00 script6d43
	jump2byte script6d0d
script6d43:
	jumptable_objectbyte $78
	.dw script6d12
	.dw script6d49
script6d49:
	writeobjectbyte $7a $07
	disablemenu
	showtext $2108
	setdisabledobjectsto11
	ormemory $c644 $08
	scriptend
script6d56:
	makeabuttonsensitive
script6d57:
	jumpifc6xxset $44 $04 script6d74
	jumpifc6xxset $44 $01 script6d63
	jump2byte script6d57
script6d63:
	callscript script6f43
script6d66:
	jumptable_objectbyte $77
	.dw script6d66
	.dw script6d6c
script6d6c:
	showtext $2101
	setdisabledobjectsto11
	ormemory $c644 $02
script6d74:
	setangleandanimation $18
	checkabutton
	showtext $210c
	jump2byte script6d74
script6d7c:
	makeabuttonsensitive
script6d7d:
	jumpifc6xxset $44 $04 script6d9b
	jumpifc6xxset $44 $02 script6d89
	jump2byte script6d7d
script6d89:
	callscript script6f43
script6d8c:
	jumptable_objectbyte $77
	.dw script6d8c
	.dw script6d92
script6d92:
	showtext $2102
	ormemory $c644 $04
	enablemenu
	enableallobjects
script6d9b:
	setangleandanimation $00
	checkabutton
	showtext $210d
	jump2byte script6d9b
script6da3:
	jumpifc6xxset $44 $20 script6daa
	jump2byte script6da3
script6daa:
	movedown $1c
	moveleft $1a
	movedown $18
	moveleft $1c
	movedown $20
	scriptend
script6db5:
	setangleandanimation $10
	callscript script6f43
script6dba:
	jumptable_objectbyte $77
	.dw script6dba
	.dw script6dc0
script6dc0:
	showtext $2109
	ormemory $c644 $10
script6dc7:
	jumpifc6xxset $44 $20 script6dce
	jump2byte script6dc7
script6dce:
	movedown $28
	moveleft $28
	movedown $18
	moveleft $19
	movedown $20
	enableallobjects
	enablemenu
	scriptend
script6ddb:
	jumpifc6xxset $44 $10 script6de2
	jump2byte script6ddb
script6de2:
	setangleandanimation $10
	callscript script6f43
script6de7:
	jumptable_objectbyte $77
	.dw script6de7
	.dw script6ded
script6ded:
	showtext $210a
	setdisabledobjectsto11
	ormemory $c644 $20
	movedown $1c
	moveleft $0f
	movedown $18
	moveleft $18
	movedown $20
	scriptend
script6e00:
	jumpifc6xxset $45 $02 script6e62
	jumpifc6xxset $45 $01 script6e5b
	setdisabledobjectsto11
	callscript script6f43
	jumptable_objectbyte $77
	.dw script6cf6
	.dw script6e14
script6e14:
	showtext $2200
	ormemory $d13e $01
	setangleandanimation $00
script6e1d:
	jumpifmemoryset $d13e $04 script6e25
	jump2byte script6e1d
script6e25:
	setcounter1 $20
	showtext $2203
	callscript script6f43
script6e2d:
	jumptable_objectbyte $77
	.dw script6e2d
	.dw script6e33
script6e33:
	showtext $2204
	setdisabledobjectsto11
	ormemory $d13e $10
script6e3b:
	jumpifmemoryset $d13e $40 script6e43
	jump2byte script6e3b
script6e43:
	playsound $70
	setangle $08
	setspeed SPEED_280
	applyspeed $30
	wait 30
	setspeed SPEED_140
	moveleft $30
	showtext $2209
	setdisabledobjectsto11
	ormemory $c645 $01
	moveright $30
	enableallobjects
script6e5b:
	jumpifc6xxset $45 $02 script6e6f
	jump2byte script6e5b
script6e62:
	setdisabledobjectsto11
	moveleft $30
	callscript script6e9d
	setcounter1 $70
	showtext $220e
	jump2byte script6e7a
script6e6f:
	setdisabledobjectsto11
	moveleft $30
	callscript script6e9d
	setcounter1 $70
	showtext $220b
script6e7a:
	jumpifc6xxset $45 $08 script6e81
	jump2byte script6e7a
script6e81:
	enablemenu
	enableallobjects
	ormemory $d13e $80
	moveright $30
script6e89:
	jumptable_objectbyte $7b
	.dw script6e8f
	.dw script6e89
script6e8f:
	setdisabledobjectsto11
	moveleft $30
	showtext $220c
	moveright $30
	enableallobjects
	ormemory $c645 $04
	scriptend
script6e9d:
	spawninteraction $7303 $88 $30
	spawninteraction $7304 $88 $50
	spawninteraction $7305 $18 $b0
	retscript
script6ead:
	jumpifc6xxset $45 $01 script6ef5
	jumpifmemoryset $d13e $01 script6eba
	jump2byte script6ead
script6eba:
	callscript script6f43
script6ebd:
	jumptable_objectbyte $77
	.dw script6ebd
	.dw script6ec3
script6ec3:
	showtext $2201
	setdisabledobjectsto11
	ormemory $d13e $02
	setangleandanimation $18
script6ecd:
	jumpifmemoryset $d13e $10 script6ed5
	jump2byte script6ecd
script6ed5:
	showtext $2205
	setdisabledobjectsto11
	applyspeed $10
	writememory $d12b $20
	setangle $08
	applyspeed $10
	ormemory $d13e $20
script6ee7:
	jumpifmemoryset $d13e $40 script6eef
	jump2byte script6ee7
script6eef:
	setspeed SPEED_280
	setangle $04
	applyspeed $20
script6ef5:
	scriptend
script6ef6:
	jumpifc6xxset $45 $01 script6f22
	jumpifmemoryset $d13e $02 script6f03
	jump2byte script6ef6
script6f03:
	callscript script6f43
script6f06:
	jumptable_objectbyte $77
	.dw script6f06
	.dw script6f0c
script6f0c:
	showtext $2202
	setdisabledobjectsto11
	ormemory $d13e $04
script6f14:
	jumpifmemoryset $d13e $40 script6f1c
	jump2byte script6f14
script6f1c:
	setspeed SPEED_280
	setangle $18
	applyspeed $20
script6f22:
	scriptend
script6f23:
	setangle $00
	applyspeed $30
	ormemory $c645 $08
script6f2b:
	jumpifmemoryset $d13e $80 script6f33
	jump2byte script6f2b
script6f33:
	spawnenemyhere $2000
	scriptend
script6f37:
	setangle $00
	applyspeed $2f
	jump2byte script6f2b
script6f3d:
	setangle $18
	applyspeed $2f
	jump2byte script6f2b
script6f43:
	setzspeed -$0300
	wait 8
	retscript
script6f48:
	setcoords $44 $50
	setcounter1 $c8
	setanimation $01
	setcounter1 $fa
	setcounter1 $60
	setanimation $02
	setcounter1 $de
	setanimation $03
	setcounter1 $7a
	scriptend
script6f5c:
	makeabuttonsensitive
	jumpifc6xxset $44 $04 script6f73
	disablemenu
	setdisabledobjectsto11
	callscript script6f43
script6f67:
	jumptable_objectbyte $77
	.dw script6f67
	.dw script6f6d
script6f6d:
	showtextlowindex $0e
	ormemory $c644 $01
script6f73:
	setangleandanimation $00
	checkabutton
	asm15 $5eec
	disablemenu
	showtextlowindex $11
	setdisabledobjectsto11
	jumptable_objectbyte $78
	.dw script6f90
	.dw script6f83
script6f83:
	wait 30
	showtextnonexitablelowindex $1c
	jumpiftextoptioneq $00 script6f95
script6f8a:
	showtextlowindex $14
	enablemenu
	enableallobjects
	jump2byte script6f73
script6f90:
	enablemenu
	enableallobjects
	wait 30
	jump2byte script6f73
script6f95:
	jumptable_objectbyte $78
	.dw script6f8a
	.dw script6f9b
script6f9b:
	writeobjectbyte $79 $01
	showtextlowindex $12
	setdisabledobjectsto11
	ormemory $c644 $08
	scriptend
script6fa6:
	makeabuttonsensitive
script6fa7:
	jumpifc6xxset $44 $04 script6fc2
	jumpifc6xxset $44 $01 script6fb3
	jump2byte script6fa7
script6fb3:
	callscript script6f43
script6fb6:
	jumptable_objectbyte $77
	.dw script6fb6
	.dw script6fbc
script6fbc:
	showtextlowindex $0f
	ormemory $c644 $02
script6fc2:
	setangleandanimation $00
	checkabutton
	asm15 $5eec
	showtextlowindex $16
	jump2byte script6fc2
script6fcc:
	makeabuttonsensitive
script6fcd:
	jumpifc6xxset $44 $04 script6fea
	jumpifc6xxset $44 $02 script6fd9
	jump2byte script6fcd
script6fd9:
	callscript script6f43
script6fdc:
	jumptable_objectbyte $77
	.dw script6fdc
	.dw script6fe2
script6fe2:
	showtextlowindex $10
	ormemory $c644 $04
	enablemenu
	enableallobjects
script6fea:
	setangleandanimation $08
	checkabutton
	asm15 $5eec
	showtextlowindex $17
	jump2byte script6fea
script6ff4:
	jumpifc6xxset $44 $10 script6ffb
	jump2byte script6ff4
script6ffb:
	setangle $04
	setanimationfromangle
	applyspeed $f0
	setangleandanimation $10
	callscript script6f43
script7006:
	jumpifc6xxset $44 $10 script700d
	jump2byte script7006
script700d:
	setangle $04
	setanimationfromangle
	applyspeed $f0
	setangleandanimation $10
	callscript script6f43
script7018:
	jumptable_objectbyte $77
	.dw script7018
	.dw script701e
script701e:
	showtextlowindex $13
	setdisabledobjectsto11
	ormemory $c644 $10
	setangle $04
	setanimationfromangle
	applyspeed $f0
	scriptend
script702c:
	makeabuttonsensitive
script702d:
	setangleandanimation $10
	checkabutton
	showtextlowindex $18
	jump2byte script702d
script7034:
	makeabuttonsensitive
script7035:
	setangleandanimation $10
	checkabutton
	showtextlowindex $19
	jump2byte script7035
script703c:
	makeabuttonsensitive
script703d:
	setangleandanimation $00
	checkabutton
	showtextlowindex $1a
	jump2byte script703d
script7044:
	rungenericnpc $1100
script7047:
	rungenericnpc $1101
script704a:
	rungenericnpc $1102
script704d:
	rungenericnpc $1103
script7050:
	rungenericnpc $1104
script7053:
	rungenericnpc $1105
script7056:
	showtextnonexitable $2b00
	callscript script70dc
	ormemory $c642 $01
	scriptend
script7061:
	showtextnonexitable $2b02
	callscript script70dc
	ormemory $c642 $04
	showtext $2b0d
	setdisabledobjectsto11
	scriptend
script7070:
	showtextnonexitable $2b04
	callscript script70dc
	ormemory $c642 $08
	scriptend
script707b:
	showtextnonexitable $2b01
	callscript script70dc
	ormemory $c642 $02
	scriptend
script7086:
	showtextnonexitable $2b03
	callscript script70dc
	ormemory $c642 $10
	scriptend
script7091:
	showtextnonexitable $2b03
	callscript script70dc
	ormemory $c642 $20
	scriptend
script709c:
	showtextnonexitable $2b03
	callscript script70dc
	ormemory $c642 $40
	scriptend
script70a7:
	showtextnonexitable $2b03
	callscript script70dc
	ormemory $c642 $80
	scriptend
script70b2:
	showtextnonexitable $2b09
	callscript script70dc
	scriptend
script70b9:
	showtextnonexitable $2b05
	callscript script70dc
	scriptend
script70c0:
	showtextnonexitable $2b0a
	callscript script70dc
	scriptend
script70c7:
	showtextnonexitable $2b06
	callscript script70dc
	scriptend
script70ce:
	showtextnonexitable $2b10
	callscript script70dc
	scriptend
script70d5:
	showtextnonexitable $2b08
	callscript script70dc
	scriptend
script70dc:
	jumpiftextoptioneq $00 script70e8
	writememory $cba0 $01
	writeobjectbyte $7d $ff
	scriptend
script70e8:
	jumptable_objectbyte $7b
	.dw script70ee
	.dw script70f7
script70ee:
	playsound $5a
	showtext $2b12
	writeobjectbyte $7d $ff
	scriptend
script70f7:
	jumptable_objectbyte $7c
	.dw script7102
script70fb:
	showtext $2b0c
	writeobjectbyte $7d $ff
	scriptend
script7102:
	writememory $cba0 $01
	setdisabledobjectsto11
	writeobjectbyte $7d $01
	retscript
script710b:
	jumptable_memoryaddress $cc01
	.dw script7112
	.dw script7133
script7112:
	jumptable_memoryaddress $cc39
	.dw script7154
	.dw script71a2
	.dw script71a2
	.dw script71a2
	.dw script71a2
	.dw script71a2
	.dw script71a2
	.dw script71b1
	.dw script71c8
	.dw script71a2
	.dw script71a2
	.dw script71a2
	.dw script71ff
	.dw script7223
	.dw script7242
script7133:
	jumptable_memoryaddress $cc39
	.dw script7154
	.dw script71a2
	.dw script71a2
	.dw script71b1
	.dw script71b1
	.dw script71b1
	.dw script71b1
	.dw script71b1
	.dw script71c8
	.dw script71a2
	.dw script71b1
	.dw script71b1
	.dw script71ff
	.dw script7223
	.dw script7242
script7154:
	asm15 $6123 $00
	asm15 $60e2 $03
	jumpifroomflagset $40 script7196
	callscript script727d
	disableinput
	jumpifglobalflagset $18 script717c
	setglobalflag $18
	asm15 $60f4 $00
	wait 30
script716f:
	asm15 $60f4 $01
	wait 1
	jumpiftextoptioneq $01 script717b
	wait 30
	jump2byte script716f
script717b:
	wait 30
script717c:
	asm15 $60f4 $02
	wait 1
	jumpifroomflagset $80 script718a
	orroomflag $80
	asm15 $6132
script718a:
	asm15 $6123 $02
	checkobjectbyteeq $61 $ff
	asm15 $6123 $00
	enableinput
script7196:
	callscript script727d
	asm15 $60ef $03
	callscript script729c
	jump2byte script7196
script71a2:
	asm15 $6123 $00
script71a6:
	callscript script727d
	asm15 $60ea
	callscript script729c
	jump2byte script71a6
script71b1:
	asm15 $6123 $04
	setcollisionradii $24 $10
	makeabuttonsensitive
script71b9:
	checkabutton
	asm15 $6123 $01
	asm15 $60ea
	wait 1
	asm15 $6123 $04
	jump2byte script71b9
script71c8:
	asm15 $6123 $04
	checkflagset $00 $cd00
	disableinput
	wait 30
	asm15 $6123 $01
	asm15 $60e7 $17
	wait 1
	asm15 $6123 $04
	asm15 $617e
	setcounter1 $61
	setcounter1 $61
	playsound $5e
	giveitem $3600
	wait 40
	asm15 $6123 $01
	asm15 $60ef $18
	wait 40
	asm15 $3183 $01
	asm15 $6184
	setcounter1 $ff
	scriptend
script71ff:
	asm15 $6123 $04
	asm15 $619a
	setmusic $1e
	asm15 $60e2 $18
	setcollisionradii $24 $10
	makeabuttonsensitive
	asm15 $618e
script7213:
	checkabutton
	asm15 $6123 $01
	asm15 $60ef $18
	wait 1
	asm15 $6123 $04
	jump2byte script7213
script7223:
	asm15 $6123 $04
	asm15 $619a
	setmusic $1e
	asm15 $60e2 $38
	setcollisionradii $24 $10
	makeabuttonsensitive
script7234:
	checkabutton
	asm15 $6123 $01
	showtext $1738
	asm15 $6123 $04
	jump2byte script7234
script7242:
	asm15 $6123 $00
	asm15 $60e2 $39
script724a:
	callscript script727d
	showtext $1739
	callscript script729c
	jump2byte script724a
script7255:
	asm15 $6123 $00
	checkcfc0bit 7
	playsound $98
	asm15 $6123 $03
	scriptend
script7261:
	asm15 $6123 $04
	checkmemoryeq $cfc0 $02
	asm15 $6123 $01
	showtext $3d07
	wait 1
	asm15 $6123 $04
	wait 60
	writememory $cfc0 $03
	setcounter1 $ff
	scriptend
script727d:
	checkcfc0bit 7
	disablemenu
	writememory $ccaf $80
	playsound $98
	asm15 $6123 $03
	checkmemoryeq $ccaf $ff
	setdisabledobjectsto11
	checkobjectbyteeq $61 $ff
	setdisabledobjectsto91
	writememory $ccaf $00
	asm15 $6123 $01
	enablemenu
	retscript
script729c:
	enableallobjects
	asm15 $6123 $02
	checkobjectbyteeq $61 $ff
	asm15 $6123 $00
	retscript
script72a9:
	initcollisions
script72aa:
	checkabutton
	showtext $1d00
	checkabutton
	showtext $1d01
	jump2byte script72aa
script72b4:
	rungenericnpc $1d02
script72b7:
	rungenericnpc $1d03
script72ba:
	rungenericnpc $1d04
script72bd:
	rungenericnpc $1d05
script72c0:
	initcollisions
	jumpifglobalflagset $16 script72e0
	jumpifitemobtained $2e script72dd
	rungenericnpc $1800
script72cc:
	initcollisions
	jumpifglobalflagset $16 script72d3
	jump2byte script72dd
script72d3:
	checkabutton
	showtext $1802
	checkabutton
	showtext $1801
	jump2byte script72d3
script72dd:
	rungenericnpc $1801
script72e0:
	rungenericnpc $1802
script72e3:
	rungenericnpc $1803
script72e6:
	rungenericnpc $1804
script72e9:
	rungenericnpc $1805
script72ec:
	initcollisions
script72ed:
	enableinput
	checkabutton
	disableinput
	jumpifitemobtained $2e script7311
	jumpifitemobtained $54 script72ff
	showtext $3400
	orroomflag $40
	jump2byte script72ed
script72ff:
	jumpifroomflagset $40 script7309
	showtext $3400
	orroomflag $40
	wait 30
script7309:
	showtext $3401
	wait 20
	giveitem $2e00
	wait 20
script7311:
	showtext $3404
	jump2byte script72ed
script7316:
	rungenericnpc $3402
script7319:
	rungenericnpc $3403
script731c:
	scriptend


; ==============================================================================
; INTERACID_OLD_MAN_WITH_JEWEL
; ==============================================================================

oldManWithJewelScript:
	initcollisions
	jumpifroomflagset $40, @alreadyGaveJewel
	jumptable_objectbyte Interaction.var38
	.dw @dontHaveEssences
	.dw @haveEssences

@dontHaveEssences:
	checkabutton
	showtextlowindex <TX_3601
	jump2byte @dontHaveEssences

@haveEssences:
	checkabutton
	showtextlowindex $02
	disableinput
	giveitem TREASURE_ROUND_JEWEL, $00
	orroomflag $40
	enableinput

@alreadyGaveJewel:
	checkabutton
	showtextlowindex <TX_3603
	jump2byte @alreadyGaveJewel


; ==============================================================================
; INTERACID_JEWEL_HELPER
; ==============================================================================

jewelHelperScript_insertedJewel:
	wait 60
	showtext $3600
	scriptend

jewelHelperScript_insertedAllJewels:
	wait 60
	orroomflag $80
	scriptend

script7345:
	stopifitemflagset
	jumptable_memoryaddress $cc01
	.dw script734d
	.dw script7357
script734d:
	spawnitem $4d00
script7350:
	jumpifitemobtained $4d script7356
	jump2byte script7350
script7356:
	scriptend
script7357:
	spawnitem $280c
	scriptend
script735b:
	jumpifroomflagset $40 script737a
	checkmemoryeq $cca9 $01
	orroomflag $40
	wait 40
	playsound $4d
	wait 60
	playsound $b1
	settileat $76 $a7
	setcounter1 $02
	settileat $66 $a7
	wait 10
	playsound $b1
	wait 15
	playsound $b1
	scriptend
script737a:
	settileat $77 $a1
	scriptend
script737e:
	loadscript $14 $50d3
script7382:
	stopifitemflagset
	jumptable_memoryaddress $cc01
	.dw script7392
	.dw script739e
script738a:
	stopifitemflagset
	jumptable_memoryaddress $cc01
	.dw script739e
	.dw script7392
script7392:
	writememory $ccbd $4e
	writememory $ccbe $00
	settileat $57 $f1
	scriptend
script739e:
	writememory $ccbd $28
	writememory $ccbe $06
	settileat $57 $f1
	scriptend
script73aa:
	scriptend
script73ab:
	setcollisionradii $11 $0e
	makeabuttonsensitive
script73af:
	checkabutton
	showtext $3802
	jump2byte script73af
script73b5:
	setcollisionradii $0b $0e
	makeabuttonsensitive
script73b9:
	checkabutton
	showtext $3803
	jump2byte script73b9
script73bf:
	setcollisionradii $0b $0e
	makeabuttonsensitive
script73c3:
	checkabutton
	showtext $3805
	jump2byte script73c3
script73c9:
	loadscript $14 $5190
script73cd:
	checkcfc0bit 0
	setspeed SPEED_200
	setanimation $05
	setangle $10
	applyspeed $21
	wait 40
	scriptend
script73d8:
	setspeed SPEED_100
	checkmemoryeq $cfc0 $02
	setangle $00
	applyspeed $25
	checkmemoryeq $cfc0 $05
	setangle $10
	applyspeed $25
	checkmemoryeq $cfc0 $06
	setangle $00
	applyspeed $25
	scriptend
script73f3:
	rungenericnpc $3800
script73f6:
	setcoords $40 $7e
	initcollisions
	setspeed SPEED_080
	setangle $1f
	setanimationfromangle
script7400:
	checkcfc0bit 0
	writeobjectbyte $5a $82
	applyspeed $10
	wait 20
	xorcfc0bit 1
	setangle $0f
	setanimationfromangle
	xorcfc0bit 0
	wait 10
	xorcfc0bit 2
	xorcfc0bit 1
	applyspeed $30
	wait 20
	xorcfc0bit 3
	xorcfc0bit 2
	wait 20
	setangle $1f
	setanimationfromangle
	applyspeed $20
	setcoords $40 $7e
	jump2byte script7400
script7421:
	checkcfc0bit 0
	wait 10
	setspeed SPEED_200
	callscript script7430
	wait 4
	setanimation $02
	setangle $10
	applyspeed $1a
	scriptend
script7430:
	jumpifobjectbyteeq $43 $01 script743c
	setanimation $01
	setangle $08
	applyspeed $09
	retscript
script743c:
	setanimation $03
	setangle $18
	applyspeed $09
	retscript
script7443:
	setspeed SPEED_100
	checkmemoryeq $cfc0 $01
	moveleft $29
	setanimation $09
	checkmemoryeq $cfc0 $03
	asm15 $6206
	wait 1
	scriptend
script7456:
	setspeed SPEED_100
	checkmemoryeq $cfc0 $01
	moveright $29
	setanimation $09
	checkmemoryeq $cfc0 $03
	asm15 $6206
	wait 1
	scriptend
script7469:
	checkmemoryeq $cfc0 $03
	asm15 $61fa
	wait 1
	scriptend
script7472:
	initcollisions
	jumpifroomflagset $40 script7483
	checkabutton
	disableinput
	showtextlowindex $03
	asm15 $6226
	wait 8
	checkrupeedisplayupdated
	orroomflag $40
	enableinput
script7483:
	checkabutton
	showtextlowindex $07
	jump2byte script7483
script7488:
	initcollisions
	jumpifroomflagset $40 script749e
	checkabutton
	disableinput
	showtextlowindex $00
	asm15 $620f
	jumpifobjectbyteeq $7f $00 script74a3
	wait 8
	checkrupeedisplayupdated
	orroomflag $40
	enableinput
script749e:
	checkabutton
	showtextlowindex $01
	jump2byte script749e
script74a3:
	wait 30
	showtextlowindex $02
	enableinput
	jump2byte script749e
script74a9:
	initcollisions
	jumpifroomflagset $40 script74ef
	disableinput
	setspeed SPEED_100
	wait 120
	setangleandanimation $10
	applyspeed $20
	setangleandanimation $08
	setcounter1 $06
	applyspeed $20
	writememory $cfd0 $01
	checkmemoryeq $cfd0 $02
	wait 30
	jumpifmemoryeq $cc01 $01 script74d0
	showtext $2500
	jump2byte script74d3
script74d0:
	showtext $2501
script74d3:
	setmusic $fa
	setangleandanimation $18
	setcounter1 $06
	applyspeed $30
	setmusic $03
	setangleandanimation $00
	setcounter1 $06
	applyspeed $20
	setanimation $02
	wait 30
	writememory $cfd0 $03
	orroomflag $40
	setglobalflag $0a
	enableinput
script74ef:
	jumpifglobalflagset $18 script74f6
	rungenericnpc $2503
script74f6:
	rungenericnpc $2505
script74f9:
	jumpifitemobtained $7 script7500
	rungenericnpc $2510
script7500:
	rungenericnpc $2506
script7503:
	rungenericnpc $2507
script7506:
	jumpifitemobtained $2e script750d
	rungenericnpc $2508
script750d:
	rungenericnpc $2509
script7510:
	rungenericnpc $250a
script7513:
	asm15 $623b
	jumptable_memoryaddress $cfc0
	.dw script751d
	.dw script750d
script751d:
	rungenericnpc $250b
script7520:
	rungenericnpc $250c
script7523:
	rungenericnpc $250d
script7526:
	rungenericnpc $250e
script7529:
	initcollisions
script752a:
	checkabutton
	asm15 $63b8
	showtext $0600
	wait 10
	setanimationfromobjectbyte $7b
	jump2byte script752a
script7537:
	jumpifglobalflagset $26 script7546
	setspeed SPEED_100
	setangleandanimation $00
	wait 60
	applyspeed $29
	wait 10
	setangleandanimation $18
	wait 60
script7546:
	setcoords $78 $68
	rungenericnpc $0609
script754c:
	loadscript $14 $51c5
script7550:
	rungenericnpc $0502
script7553:
	rungenericnpc $250f
script7556:
	playsound $b8
	callscript script756f
	setcounter1 $23
	callscript script756f
	setcounter1 $23
	playsound $b8
	callscript script756f
	setcounter1 $23
	callscript script756f
	setcounter1 $ff
	scriptend
script756f:
	playsound $73
	asm15 $624c
	setcounter1 $05
	playsound $73
	asm15 $624f
	setcounter1 $05
	playsound $73
	asm15 $624c
	setcounter1 $05
	playsound $73
	asm15 $624c
	retscript
script758a:
	setcollisionradii $12 $06
	makeabuttonsensitive
	jumptable_objectbyte $7f
	.dw script7598
	.dw script759d
	.dw script75c1
	.dw script75f0
script7598:
	checkabutton
	showtextlowindex $00
	jump2byte script7598
script759d:
	checkabutton
	disableinput
	callscript script7642
	showtextlowindex $03
	jumpiftextoptioneq $00 script75b8
	wait 30
	showtextlowindex $06
	setanimation $01
	wait 30
	showtextlowindex $07
	callscript script7650
	giveitem $4a02
	jump2byte script7675
script75b8:
	wait 30
	showtextlowindex $04
	enableinput
script75bc:
	checkabutton
	showtextlowindex $05
	jump2byte script75bc
script75c1:
	checkabutton
	disableinput
	callscript script7642
	jumpifitemobtained $1 script75cc
	jump2byte script75eb
script75cc:
	showtextlowindex $0a
	jumpiftextoptioneq $00 script75e2
	wait 30
	showtextlowindex $0c
	setanimation $01
	wait 30
	showtextlowindex $0d
	callscript script7650
	asm15 $62a2
	jump2byte script7675
script75e2:
	wait 30
	showtextlowindex $0b
	enableinput
script75e6:
	checkabutton
	showtextlowindex $05
	jump2byte script75e6
script75eb:
	showtextlowindex $13
	enableinput
	jump2byte script75e6
script75f0:
	jumpifglobalflagset $5e script763e
script75f4:
	checkabutton
	disableinput
	callscript script7642
	jumpifitemobtained $1 script7603
	enableinput
script75fe:
	showtextlowindex $18
	checkabutton
	jump2byte script75fe
script7603:
	showtextlowindex $0e
	jumpiftextoptioneq $00 script7611
	wait 30
	showtextlowindex $10
	enableinput
	checkabutton
	disableinput
	jump2byte script7603
script7611:
	wait 30
	showtextlowindex $0f
	generateoraskforsecret $24
	wait 30
	jumptable_memoryaddress $cca3
	.dw script7623
	.dw script761e
script761e:
	showtextlowindex $11
	enableinput
	jump2byte script75f4
script7623:
	setglobalflag $54
	showtextlowindex $12
	callscript script7650
	asm15 $62a7
	setglobalflag $5e
	wait 30
script7630:
	generateoraskforsecret $34
script7632:
	showtextlowindex $16
	wait 30
	jumpiftextoptioneq $00 script763b
	jump2byte script7632
script763b:
	showtextlowindex $17
	enableinput
script763e:
	checkabutton
	disableinput
	jump2byte script7630
script7642:
	showtextlowindex $00
	wait 30
	showtextlowindex $01
	setanimation $01
	wait 30
	showtextlowindex $02
	setanimation $02
	wait 30
	retscript
script7650:
	asm15 $3144
	checkpalettefadedone
	setcoords $50 $70
	setanimation $01
	wait 60
	asm15 $3171
	checkpalettefadedone
	wait 30
	setspeed SPEED_200
	setanimation $00
	setangle $00
	applyspeed $0d
	wait 4
	setanimation $03
	setangle $18
	applyspeed $21
	wait 4
	setanimation $02
	wait 30
	showtextlowindex $08
	retscript
script7675:
	wait 4
	enableinput
script7677:
	checkabutton
	showtextlowindex $09
	jump2byte script7677
script767c:
	loadscript $14 $51f0
script7680:
	loadscript $14 $520a
script7684:
	scriptend
script7685:
	initcollisions
script7686:
	checkabutton
	disableinput
	wait 10
	writeobjectbyte $78 $01
	asm15 $62ca
	wait 8
	showtext $3d18
	enableinput
	writeobjectbyte $78 $00
	setanimation $06
	jump2byte script7686
script769b:
	loadscript $14 $521b
script769f:
	checkmemoryeq $cfc0 $01
	setanimation $01
	checkobjectbyteeq $61 $01
	writememory $cfc0 $02
	scriptend
script76ad:
	checkmemoryeq $cfc0 $02
	asm15 $62d9
	setanimation $03
	scriptend
script76b7:
	checkmemoryeq $cfc0 $03
	setangle $18
	setspeed SPEED_100
	applyspeed $20
	setcounter1 $06
	setanimation $04
	wait 30
	showtext $3d0a
	wait 30
	setangle $08
	setanimation $05
	setcounter1 $06
	applyspeed $20
	wait 10
	setanimation $07
	writememory $cfc0 $04
	setcounter1 $80
	scriptend
script76dc:
	checkmemoryeq $cfc0 $05
	setangle $18
	setspeed SPEED_100
	applyspeed $10
	setanimation $0a
	setangle $10
	setcounter1 $06
	applyspeed $10
	setanimation $0b
	setangle $18
	setcounter1 $06
	applyspeed $12
	setanimation $08
	setangle $00
	wait 30
	showtext $3d08
	setcounter1 $80
	writememory $cfc0 $06
	scriptend
script7705:
	setcoords $40 $70
	setcollisionradii $1c $1c
	checkcollidedwithlink_ignorez
	setdisabledobjectsto91
	asm15 $6304
	jumptable_memoryaddress $cc01
	.dw script7717
	.dw script7725
script7717:
	jumpifroomflagset $40 script7721
	showtextlowindex $00
	orroomflag $40
	enableallobjects
	scriptend
script7721:
	showtextlowindex $01
	enableallobjects
	scriptend
script7725:
	jumpifroomflagset $40 script772f
	showtextlowindex $02
	orroomflag $40
	enableallobjects
	scriptend
script772f:
	showtextlowindex $03
	enableallobjects
	scriptend
script7733:
	setcoords $68 $88
	setcollisionradii $08 $08
	checknotcollidedwithlink_ignorez
	createpuff
	wait 4
	settileat $68 $ac
	playsound $70
	setcoords $40 $50
	setcollisionradii $28 $08
	checkcollidedwithlink_ignorez
	setdisabledobjectsto91
	asm15 $6304
	asm15 $62fc
	showtextlowindex $04
	playsound $78
	wait 30
	setmusic $2d
	xorcfc0bit 0
	enableallobjects
	checkcfc0bit 0
	setdisabledobjectsto91
	callscript script7776
	callscript script7776
	callscript script7783
	callscript script7783
	callscript script7783
	callscript script7783
	callscript script7783
	callscript script7783
	asm15 $62e2
	scriptend
script7776:
	playsound $bc
	asm15 $2ca6
	wait 8
	playsound $bc
	asm15 $3110
	wait 8
	retscript
script7783:
	playsound $bc
	asm15 $2ca6
	wait 4
	playsound $bc
	asm15 $3110
	wait 4
	retscript
script7790:
	stopifroomflag40set
	disableinput
	asm15 $3e52
	showtextlowindex $05
	xorcfc0bit 0
	setcounter1 $4b
	orroomflag $40
	enableinput
	scriptend
script779e:
	setspeed SPEED_0a0
script77a0:
	applyspeed $0e
	setcounter1 $50
	jump2byte script77a0
script77a6:
	wait 30
	jump2byte script77a6
script77a9:
	setstate $03
	setdisabledobjectsto11
	wait 240
	spawninteraction $b102 $98 $78
	checkcfc0bit 0
	xorcfc0bit 0
	wait 240
	writememory $ccae $02
	playsound $79
	wait 60
	setstate $02
	xorcfc0bit 2
	checkcfc0bit 0
	asm15 $630a
	scriptend
script77c4:
	setstate $02
	setspeed SPEED_100
	callscript script7801
	asm15 $1dfa
	setzspeed -$01c0
	wait 30
	showtextlowindex $01
	callscript script7809
	showtextlowindex $03
	callscript script7809
	showtextlowindex $05
	movedown $30
	moveright $10
	wait 30
	xorcfc0bit 0
	setcoords $f8 $f8
	checkcfc0bit 2
	xorcfc0bit 2
	setangleandanimation $18
	setcoords $98 $78
	callscript script7801
	setzspeed -$01c0
	wait 30
	showtextlowindex $06
	callscript script7809
	xorcfc0bit 7
	wait 30
	showtextlowindex $08
	xorcfc0bit 0
	jump2byte script77a6
script7801:
	setangleandanimation $18
	wait 30
	applyspeed $10
	moveup $30
	retscript
script7809:
	xorcfc0bit 1
	checkcfc0bit 2
	xorcfc0bit 2
	setzspeed -$01c0
	wait 30
	retscript
script7811:
	setstate $02
	asm15 $630f
	checkcfc0bit 1
	setzspeed -$01c0
	setangleandanimation $10
	checkcfc0bit 7
	setzspeed -$01c0
	jump2byte script77a6
script7822:
	setcoords $f8 $f8
	checkcfc0bit 0
script7826:
	playsound $d0
	wait 60
	jump2byte script7826
script782b:
	setstate $02
	setdisabledobjectsto11
	wait 180
	setmusic $23
	spawninteraction $b10a $98 $78
	checkcfc0bit 7
	wait 30
	showtextlowindex $11
	asm15 $630a
	scriptend
script783e:
	setstate $02
	wait 10
	asm15 $1e39
	setcoords $58 $70
	asm15 $12a3
	setspeed SPEED_040
	moveright $20
script784e:
	moveleft $40
	moveright $40
	playsound $aa
	jump2byte script784e
script7856:
	callscript script7891
	showtextlowindex $0a
	callscript script7880
	callscript script7880
	callscript script7880
	writememory $d008 $03
	callscript script7880
	callscript script7880
	writememory $d008 $00
	wait 30
	showtextlowindex $0b
	spawninteraction $b10b $98 $78
	checkcfc0bit 7
	setzspeed -$01c0
	jump2byte script77a6
script7880:
	setangle $19
	applyspeed $10
	setangle $04
	applyspeed $10
	setangle $1c
	applyspeed $10
	setangle $00
	applyspeed $10
	retscript
script7891:
	setstate $04
	setspeed SPEED_080
	wait 60
	retscript
script7897:
	callscript script7891
	showtextlowindex $0c
	writememory $d008 $02
	callscript script78c2
	callscript script78c2
	callscript script78c2
	writememory $d008 $01
	callscript script78c2
	writememory $d008 $00
	wait 30
	showtextlowindex $0d
	spawninteraction $b10c $98 $78
	checkcfc0bit 7
	setzspeed -$01c0
	jump2byte script77a6
script78c2:
	setangle $07
	applyspeed $0f
	setangle $1b
	applyspeed $10
	setangle $03
	applyspeed $10
	setangle $00
	applyspeed $10
	retscript
script78d3:
	callscript script7891
	showtextlowindex $0e
	writememory $d008 $02
	callscript script7880
	callscript script7880
	callscript script7880
	wait 30
	writememory $d008 $03
	showtextlowindex $0f
	spawninteraction $b201 $98 $78
	checkcfc0bit 7
	setzspeed -$01c0
	jump2byte script77a6
script78f7:
	setstate $04
	checkcfc0bit 7
	setzspeed -$01c0
	jump2byte script77a6
script78ff:
	jumpifroomflagset $40 script7904
	scriptend
script7904:
	rungenericnpclowindex $15
script7906:
	jumpifglobalflagset $17 script790b
	scriptend
script790b:
	rungenericnpclowindex $16
script790d:
	rungenericnpclowindex $17
script790f:
	rungenericnpclowindex $18
script7911:
	rungenericnpclowindex $19
script7913:
	rungenericnpclowindex $1a
script7915:
	rungenericnpclowindex $1b
script7917:
	setstate $02
	asm15 $1e39
	jumpifglobalflagset $1b stubScript
	setcollisionradii $38 $30
	checkcollidedwithlink_onground
	createpuff
	writeobjectbyte $5c $02
	initcollisions
	setstate $05
	asm15 $26ac
	checkabutton
	asm15 $6324
	showtextlowindex $01
	setdisabledobjectsto11
	wait 30
	createpuff
	setglobalflag $1b
	enableallobjects
script793a:
	xorcfc0bit 0
	scriptend
script793c:
	setstate $06
	asm15 $1e39
	setcollisionradii $06 $0a
script7944:
	jumpifglobalflagset $1b stubScript
	checkcollidedwithlink_onground
	showtextlowindex $00
	jump2byte script793a
script794d:
	setstate $06
	asm15 $1e39
	initcollisions
	jump2byte script7944
script7955:
	callscript script796d
	showtextlowindex $02
	xorcfc0bit 2
	callscript script796d
	showtextlowindex $04
	xorcfc0bit 2
	callscript script796d
	showtextlowindex $07
	xorcfc0bit 2
	checkcfc0bit 7
	setzspeed -$01c0
	jump2byte script77a6
script796d:
	checkcfc0bit 1
	xorcfc0bit 1
	setzspeed -$01c0
	wait 30
	retscript
script7974:
	setspeed SPEED_080
	callscript script7880
	callscript script7880
	writememory $d008 $02
	showtextlowindex $10
	xorcfc0bit 7
	jump2byte script77a6
script7985:
	jumpifroomflagset $40 script7999
	asm15 $1e39
	wait 4
	wait 60
	showtextlowindex $12
	wait 60
	spawninteraction $b203 $68 $68
	orroomflag $40
	scriptend
script7999:
	setstate $ff
	setcoords $68 $78
	rungenericnpclowindex $14
script79a0:
	setspeed SPEED_100
	setangle $08
	applyspeed $10
	asm15 $6317
	setdisabledobjectsto11
	wait 60
	showtextlowindex $13
	setmusic $ff
	enableinput
	setstate $ff
	rungenericnpclowindex $14
script79b4:
	checkflagset $00 $cd00
	disablemenu
	setdisabledobjects $35
	wait 40
	setcoords $58 $38
	asm15 $0c8e
	asm15 $632f
	checkpalettefadedone
	showtextlowindex $00
	wait 30
	asm15 $6347
	wait 40
	setmusic $1c
	createpuff
	wait 4
	asm15 $635e
	wait 90
	xorcfc0bit 0
	wait 10
	showtextlowindex $01
	wait 30
	createpuff
	xorcfc0bit 1
	wait 20
	setmusic $fb
	wait 90
	asm15 $6334
	checkpalettefadedone
	setmusic $ff
	setglobalflag $1c
	enableinput
	scriptend
script79ea:
	checkflagset $00 $cd00
	disablemenu
	setdisabledobjects $35
	setcoords $18 $50
	wait 60
	setmusic $fb
	wait 90
	asm15 $634c
	wait 40
	createpuff
	wait 4
	asm15 $6363
	wait 90
	showtextlowindex $02
	wait 30
	createpuff
	xorcfc0bit 7
	writememory $cfc6 $00
	asm15 $6378
	wait 1
	asm15 $6383
	setmusic $21
	checkcfc0bit 0
	setdisabledobjectsto91
	showtextlowindex $03
	showtextlowindex $04
	showtextlowindex $05
	showtextlowindex $06
	xorcfc0bit 0
	wait 40
	playsound $bb
	checkcfc0bit 0
	wait 60
	asm15 $63a6
	setglobalflag $1d
	scriptend
script7a2a:
	writememory $ccaa $01
	setcollisionradii $02 $02
	checkcollidedwithlink_onground
	writememory $cc04 $11
	scriptend
script7a37:
	writememory $cc04 $12
	scriptend
script7a3c:
	writememory $cc04 $10
	scriptend
script7a41:
	initcollisions
script7a42:
	checkabutton
	jumpifglobalflagset $29 script7a4d
	setglobalflag $29
	showtextlowindex $39
	jump2byte script7a42
script7a4d:
	showtextlowindex $36
	jump2byte script7a42
script7a51:
	initcollisions
script7a52:
	checkabutton
	jumpifglobalflagset $29 script7a5d
	setglobalflag $29
	showtextlowindex $3a
	jump2byte script7a52
script7a5d:
	showtextlowindex $37
	jump2byte script7a52
script7a61:
	initcollisions
script7a62:
	checkabutton
	jumpifglobalflagset $29 script7a6d
	setglobalflag $29
	showtextlowindex $3b
	jump2byte script7a62
script7a6d:
	showtextlowindex $38
	jump2byte script7a62
script7a71:
	writeobjectbyte $7f $01
	setspeed SPEED_080
	moveup $41
	xorcfc0bit 1
	checkcfc0bit 2
	applyspeed $09
	setcounter1 $ff
	scriptend
script7a7f:
	rungenericnpclowindex $2b
script7a81:
	setspeed SPEED_080
	wait 180
script7a84:
	setangle $18
	applyspeed $18
	setcounter1 $06
	setangle $08
	applyspeed $14
	wait 120
	jump2byte script7a84
script7a91:
	scriptend
script7a92:
	setcoords $18 $18
	setspeed SPEED_200
	movedown $19
	wait 4
	moveright $1d
	wait 4
	setanimation $00
	wait 4
	showtext $500e
	wait 30
	showtext $500f
	wait 30
	xorcfc0bit 0
	setspeed SPEED_100
	setangle $18
	applyspeed $11
	setanimation $01
	wait 8
	setanimation $02
	setcounter1 $ff
	scriptend
script7ab7:
	checkmemoryeq $cfc0 $08
	setspeed SPEED_100
	moveup $31
	checkmemoryeq $cfc0 $0b
	movedown $31
	scriptend
script7ac6:
	settextid $0601
script7ac9:
	initcollisions
script7aca:
	checkabutton
	asm15 $63b8
	showloadedtext
	wait 10
	setanimationfromobjectbyte $7b
	jump2byte script7aca
script7ad5:
	settextid $0604
	jump2byte script7ac9
script7ada:
	settextid $0603
	jump2byte script7ac9
script7adf:
	settextid $0606
	jump2byte script7ac9
script7ae4:
	settextid $0602
	jump2byte script7ac9
script7ae9:
	settextid $0605
	jump2byte script7ac9
script7aee:
	initcollisions
	jumpifglobalflagset $28 script7af8
	settextid $3101
	jump2byte script7afb
script7af8:
	settextid $310a
script7afb:
	checkabutton
	showloadedtext
	jump2byte script7afb
script7aff:
	loadscript $14 $5246
script7b03:
	rungenericnpc $3e18
script7b06:
	initcollisions
script7b07:
	enableinput
	checkabutton
	disableinput
	showtextlowindex $00
	jumpiftextoptioneq $00 script7b17
	jump2byte script7b12
script7b12:
	wait 30
	showtextlowindex $01
	jump2byte script7b07
script7b17:
	wait 30
	generateoraskforsecret $20
	wait 30
	jumptable_memoryaddress $cca3
	.dw script7b26
	.dw script7b22
script7b22:
	showtextlowindex $02
	jump2byte script7b07
script7b26:
	setglobalflag $50
	showtextlowindex $03
	jumpiftextoptioneq $00 script7b3f
	jump2byte script7b3a
script7b30:
	initcollisions
script7b31:
	enableinput
	checkabutton
	disableinput
	showtextlowindex $0e
	jumpiftextoptioneq $00 script7b3f
script7b3a:
	wait 30
	showtextlowindex $04
	jump2byte script7b31
script7b3f:
	wait 30
	showtextlowindex $05
	jumpiftextoptioneq $00 script7b48
	jump2byte script7b3f
script7b48:
	settileat $9d $ac
	wait 15
script7b4c:
	wait 30
	showtextlowindex $06
	createpuff
	wait 4
	asm15 $6455
	setcounter1 $2d
	playsound $cc
	setmusic $2d
	writeobjectbyte $71 $00
	asm15 $6443
	enableinput
	setstate $ff
	scriptend
script7b64:
	disableinput
	setmusic $ff
	playsound $cc
	writeobjectbyte $71 $00
	asm15 $3144
	checkpalettefadedone
	asm15 $6464
	wait 30
	asm15 $3171
	checkpalettefadedone
	jumptable_objectbyte $7a
	.dw script7b7e
	.dw script7be4
script7b7e:
	showtextlowindex $0a
	createpuff
	wait 4
	asm15 $645d
	setcounter1 $2d
	showtextlowindex $0b
	disableinput
	callscript script7bc3
	callscript script7baf
	writememory $cbea $ff
	wait 90
	enableallobjects
	setdisabledobjectsto91
	settileat $9d $44
	setcounter1 $2d
	setglobalflag $5a
script7b9e:
	generateoraskforsecret $30
script7ba0:
	showtextlowindex $0c
	wait 30
	jumpiftextoptioneq $00 script7ba0
	showtextlowindex $0d
	enableinput
	wait 30
script7bab:
	checkabutton
	disableinput
	jump2byte script7b9e
script7baf:
	jumptable_objectbyte $43
	.dw script7bb5
	.dw script7bbc
script7bb5:
	giveitem $0501
	giveitem $0504
	retscript
script7bbc:
	giveitem $0502
	giveitem $0505
	retscript
script7bc3:
	asm15 $649a
	wait 30
	asm15 $648d
	wait 10
	playsound $b4
	asm15 $3144
	wait 20
	playsound $b4
	asm15 $3144
	wait 20
	playsound $b4
	asm15 $3144
	checkpalettefadedone
	wait 20
	asm15 $315c $04
	checkpalettefadedone
	retscript
script7be4:
	showtextlowindex $08
	createpuff
	wait 4
	asm15 $645d
	setcounter1 $2d
	showtextlowindex $09
	jumpiftextoptioneq $00 script7b4c
	settileat $9d $44
	wait 15
	writeobjectbyte $71 $00
	jump2byte script7b3a
script7bfc:
	initcollisions
	jump2byte script7bab
script7bff:
	initcollisions
script7c00:
	enableinput
	checkabutton
	disableinput
	showtextlowindex $0f
	jumpiftextoptioneq $00 script7c10
	jump2byte script7c0b
script7c0b:
	wait 30
	showtextlowindex $10
	jump2byte script7c00
script7c10:
	wait 30
	generateoraskforsecret $21
	wait 30
	jumptable_memoryaddress $cca3
	.dw script7c1f
	.dw script7c1b
script7c1b:
	showtextlowindex $12
	jump2byte script7c00
script7c1f:
	setglobalflag $51
	showtextlowindex $11
	jumpiftextoptioneq $00 script7c38
	jump2byte script7c33
script7c29:
	initcollisions
script7c2a:
	enableinput
	checkabutton
	disableinput
	showtextlowindex $14
	jumpiftextoptioneq $00 script7c38
script7c33:
	wait 30
	showtextlowindex $13
	jump2byte script7c2a
script7c38:
	wait 30
	showtextlowindex $15
	jumpiftextoptioneq $00 script7c41
	jump2byte script7c38
script7c41:
	asm15 $3144
	checkpalettefadedone
	wait 4
	asm15 $64bc
	settileat $61 $a2
	wait 4
	asm15 $3171
	checkpalettefadedone
script7c51:
	wait 30
	showtextlowindex $16
	createpuff
	wait 4
	asm15 $64b3
	setcounter1 $2d
	playsound $cc
	scriptend
script7c5e:
	disableinput
	playsound $cc
	wait 30
	createpuff
	wait 4
	asm15 $64b9
	setcounter1 $2d
	showtextlowindex $17
	asm15 $64a0
	wait 30
	jumptable_objectbyte $7f
	.dw script7c75
	.dw script7cab
script7c75:
	jumptable_objectbyte $7a
	.dw script7c7d
	.dw script7c7d
	.dw script7c83
script7c7d:
	playsound $5e
	showtextlowindex $19
	jump2byte script7c51
script7c83:
	playsound $5e
	showtextlowindex $1a
	wait 30
	giveitem $2a02
	wait 60
	spawninteraction $0500 $68 $18
	wait 4
	settileat $61 $44
	setcounter1 $2d
	setglobalflag $5b
script7c99:
	generateoraskforsecret $31
script7c9b:
	showtextlowindex $1b
	wait 30
	jumpiftextoptioneq $00 script7ca4
	jump2byte script7c9b
script7ca4:
	showtextlowindex $1c
	enableinput
script7ca7:
	checkabutton
	disableinput
	jump2byte script7c99
script7cab:
	playsound $5a
	showtextlowindex $18
	jumpiftextoptioneq $00 script7c51
	spawninteraction $0500 $68 $18
	wait 4
	settileat $61 $44
	wait 15
	jump2byte script7c33
script7cbf:
	initcollisions
	jump2byte script7ca7
script7cc2:
	initcollisions
script7cc3:
	enableinput
	checkabutton
	disableinput
	showtextlowindex $1e
	jumpiftextoptioneq $00 script7cd5
	wait 20
	showtextlowindex $1f
	jump2byte script7cc3
script7cd1:
	showtextlowindex $20
	jump2byte script7cc3
script7cd5:
	generateoraskforsecret $22
	wait 20
	jumptable_memoryaddress $cca3
	.dw script7cdf
	.dw script7cd1
script7cdf:
	orroomflag $80
	showtextlowindex $21
	jumpiftextoptioneq $00 script7cec
	wait 20
	showtextlowindex $22
	jump2byte script7db2
script7cec:
	wait 20
	showtextlowindex $23
	jumpiftextoptioneq $01 script7cec
	wait 20
	showtextlowindex $24
	wait 20
	asm15 $653c $01
	asm15 $64fe $87
	scriptend
script7d00:
	initcollisions
	setcoords $88 $88
	setangleandanimation $00
	writeobjectbyte $79 $00
	setdisabledobjectsto11
	asm15 $64d1
	asm15 $6545
	jumpifobjectbyteeq $7c $03 script7d19
	asm15 $5cb0 $06
script7d19:
	checkpalettefadedone
	asm15 $6518
	writememory $cc02 $01
	wait 20
	showloadedtext
	setspeed SPEED_200
	setangleandanimation $10
	applyspeed $09
	wait 8
	setangleandanimation $18
	applyspeed $09
	wait 8
	setangleandanimation $00
	enableallobjects
script7d32:
	checkabutton
	asm15 $64e9
	jumptable_objectbyte $79
	.dw script7d40
	.dw script7d6b
	.dw script7d72
	.dw script7d77
script7d40:
	setdisabledobjectsto11
	settextid $4c28
script7d44:
	showloadedtext
	jumpiftextoptioneq $01 script7d56
	wait 20
	showtextlowindex $3f
	wait 20
	asm15 $64fe $87
	asm15 $653c $03
	scriptend
script7d56:
	wait 20
	showtextlowindex $22
	setspeed SPEED_100
	setangleandanimation $00
	applyspeed $10
	wait 8
	wait 8
	setangleandanimation $10
	asm15 $5cf7
	asm15 $652e
	rungenericnpclowindex $22
script7d6b:
	showtextlowindex $29
	writeobjectbyte $79 $00
	jump2byte script7d32
script7d72:
	settextid $4c3e
	jump2byte script7d44
script7d77:
	setdisabledobjectsto11
	showtextlowindex $2a
	writeobjectbyte $4f $00
	wait 20
	asm15 $653c $02
	asm15 $64fe $57
	scriptend
script7d87:
	initcollisions
	setcoords $48 $78
	setangleandanimation $10
	disableinput
	asm15 $64e3
	asm15 $5cf7
	checkpalettefadedone
	showtextlowindex $2b
	wait 20
	giveitem $0d00
	wait 20
script7d9c:
	generateoraskforsecret $32
script7d9e:
	showtextlowindex $2c
	wait 20
	jumpiftextoptioneq $01 script7d9e
	showtextlowindex $2d
	asm15 $652e
	setglobalflag $5c
	initcollisions
	enableinput
	checkabutton
	disableinput
	jump2byte script7d9c
script7db2:
	initcollisions
	enableinput
	checkabutton
	disableinput
	jump2byte script7cdf
script7db8:
	initcollisions
script7db9:
	enableinput
	checkabutton
	disableinput
	showtextlowindex $2e
	jumpiftextoptioneq $00 script7dc9
	jump2byte script7dc4
script7dc4:
	wait 30
	showtextlowindex $2f
	jump2byte script7db9
script7dc9:
	wait 30
	generateoraskforsecret $23
	wait 30
	jumptable_memoryaddress $cca3
	.dw script7dd8
	.dw script7dd4
script7dd4:
	showtextlowindex $30
	jump2byte script7db9
script7dd8:
	setglobalflag $53
	showtextlowindex $31
	jumpiftextoptioneq $00 script7df1
	jump2byte script7dec
script7de2:
	initcollisions
script7de3:
	enableinput
	checkabutton
	disableinput
	showtextlowindex $3c
	jumpiftextoptioneq $00 script7df1
script7dec:
	wait 30
	showtextlowindex $32
	jump2byte script7de3
script7df1:
	wait 30
	showtextlowindex $33
script7df4:
	wait 30
	showtextlowindex $34
	jumpiftextoptioneq $00 script7dfd
	jump2byte script7df4
script7dfd:
	spawninteraction $0500 $58 $88
	wait 4
	settileat $58 $45
	setcounter1 $2d
script7e08:
	showtextlowindex $35
	enableinput
	checkabutton
	disableinput
	jump2byte script7e08
script7e0f:
	disableinput
	wait 40
	showtextlowindex $36
	asm15 $654e
	setcounter1 $2d
	playsound $cc
	enableinput
script7e1b:
	jumpifitemobtained $60 script7e21
	jump2byte script7e1b
script7e21:
	disableinput
	orroomflag $40
	playsound $cc
	asm15 $6572
	asm15 $6430
	wait 30
	jumpifglobalflagset $2e script7e42
	showtextlowindex $37
	jumpiftextoptioneq $00 script7e3b
	asm15 $6598
	scriptend
script7e3b:
	asm15 $6558
	asm15 $6588
	scriptend
script7e42:
	showtextlowindex $38
	asm15 $6598
	scriptend
script7e48:
	disableinput
	initcollisions
	asm15 $655d
	jumpifglobalflagset $2e script7e53
	jump2byte script7e65
script7e53:
	wait 40
	showtextlowindex $39
	asm15 $63c1 $15
	setcounter1 $02
	setglobalflag $5d
script7e5e:
	showtextlowindex $3a
	enableinput
script7e61:
	checkabutton
	disableinput
	jump2byte script7e5e
script7e65:
	showtextlowindex $30
	enableinput
	checkabutton
	disableinput
	jump2byte script7e65
script7e6c:
	initcollisions
	jump2byte script7e61
script7e6f:
	spawnitem $6001
	scriptend
script7e73:
	initcollisions
script7e74:
	enableinput
	checkabutton
	disableinput
	showtextlowindex $01
	jumpiftextoptioneq $00 script7e82
script7e7d:
	wait 30
	showtextlowindex $02
	jump2byte script7e74
script7e82:
	generateoraskforsecret $26
	wait 30
	jumptable_memoryaddress $cca3
	.dw script7e8c
	.dw script7e7d
script7e8c:
	showtextlowindex $03
	wait 30
	asm15 $63c1 $13
	wait 30
script7e94:
	showtextlowindex $04
	setglobalflag $60
	enableinput
	initcollisions
	checkabutton
	jump2byte script7e94
script7e9d:
	initcollisions
script7e9e:
	enableinput
	checkabutton
	disableinput
	showtextlowindex $48
	wait 20
	jumpiftextoptioneq $00 script7eac
	showtextlowindex $41
	jump2byte script7e9e
script7eac:
	showtextlowindex $49
	asm15 $17e5
	wait 20
script7eb2:
	showtextlowindex $4a
	enableinput
	checkabutton
	disableinput
	jump2byte script7eb2
script7eb9:
	initcollisions
script7eba:
	enableinput
	checkabutton
	disableinput
	showtextlowindex $40
	jumpiftextoptioneq $00 script7ec8
script7ec3:
	wait 20
	showtextlowindex $41
	jump2byte script7eba
script7ec8:
	generateoraskforsecret $27
	jumptable_memoryaddress $cca3
	.dw script7ed1
	.dw script7ec3
script7ed1:
	orroomflag $80
	wait 20
	showtextlowindex $42
	wait 20
script7ed7:
	asm15 $65a8
	jumpifobjectbyteeq $78 $00 script7f01
	showtextlowindex $44
	wait 20
	giveitem $6200
	asm15 $17e5
	wait 20
	showtextlowindex $45
	wait 20
	setglobalflag $61
	jump2byte script7ef3
script7ef0:
	initcollisions
script7ef1:
	checkabutton
	disableinput
script7ef3:
	generateoraskforsecret $37
	showtextlowindex $46
	wait 20
	jumpiftextoptioneq $00 script7ef3
	showtextlowindex $47
	enableinput
	jump2byte script7ef1
script7f01:
	initcollisions
	enableinput
	checkabutton
	disableinput
	showtextlowindex $43
	wait 30
	jump2byte script7ed7
script7f0a:
	initcollisions
script7f0b:
	checkabutton
	asm15 $6abf
	jumptable_memoryaddress $cfc1
	.dw script7f16
	.dw script7f1a
script7f16:
	showtextlowindex $04
	jump2byte script7f0b
script7f1a:
	showtextlowindex $05
	disableinput
	asm15 $6ad9
	wait 20
	showtextlowindex $06
	wait 20
	orroomflag $40
	enableinput
	createpuff
	scriptend
script7f29:
	wait 30
	showtext $2f10
	wait 30
	showtext $2f11
	wait 30
	scriptend
script7f33:
	initcollisions
	jumpifroomflagset $80 script7f64
script7f38:
	checkabutton
	showtextlowindex $03
	jumpiftextoptioneq $00 script7f47
	showtextlowindex $05
	jump2byte script7f38
script7f43:
	showtextlowindex $06
	jump2byte script7f38
script7f47:
	asm15 $6f49
	jumptable_memoryaddress $cfd0
	.dw script7f43
	.dw script7f51
script7f51:
	disableinput
	asm15 $6f14
	wait 60
	showtextlowindex $04
	enableinput
script7f59:
	checkabutton
	jumpifroomflagset $80 script7f62
	showtextlowindex $04
	jump2byte script7f59
script7f62:
	showtextlowindex $07
script7f64:
	rungenericnpclowindex $07
script7f66:
	loadscript $14 $52e8
script7f6a:
	setcounter1 $32
	scriptend

