script_14_4770:
	push af
.DB $e3
	sub (hl)		; $4772
	sbc b			; $4773
	ld a,(bc)		; $4774
	nop			; $4775
.DB $e3				; $4776
	rst $8			; $4777
	rst_addAToHl			; $4778
	jr nc,-$1d	; $4779
	ld (hl),d		; $477b
	rst $20			; $477c
	ld b,(hl)		; $477d
	ld ($30d7),sp		; $477e
.DB $e3				; $4781
	ld (hl),d		; $4782
	rst $20			; $4783
	ld c,b			; $4784
	ld ($d0e0),sp		; $4785
	ld sp,$30d7		; $4788
.DB $e3				; $478b
	ld (hl),d		; $478c
	rst $20			; $478d
	ld l,b			; $478e
	ld ($d4e0),sp		; $478f
	ld sp,$30d7		; $4792
.DB $e3				; $4795
	ld (hl),d		; $4796
	rst $20			; $4797
	ld h,(hl)		; $4798
	ld ($30d7),sp		; $4799
.DB $e3				; $479c
	adc l			; $479d
	ld ($ff00+$6d),a	; $479e
	ld d,l			; $47a0
	nop			; $47a1

script_14_47a2:
	push af			; $47a2
.DB $e3				; $47a3
	sub (hl)		; $47a4
	sbc b			; $47a5
	ld a,(bc)		; $47a6
	nop			; $47a7
.DB $e3				; $47a8
	rst $8			; $47a9
	rst_addAToHl			; $47aa
	jr nc,-$1d		; $47ab
	ld (hl),d		; $47ad
	rst $20			; $47ae
	dec (hl)		; $47af
	ld ($30d7),sp		; $47b0
.DB $e3				; $47b3
	ld (hl),d		; $47b4
	rst $20			; $47b5
	add hl,sp		; $47b6
	ld ($d0e0),sp		; $47b7
	ld sp,$30d7		; $47ba
.DB $e3				; $47bd
	ld (hl),d		; $47be
	rst $20			; $47bf
	ld a,c			; $47c0
	ld ($d4e0),sp		; $47c1
	ld sp,$30d7		; $47c4
.DB $e3				; $47c7
	ld (hl),d		; $47c8
	rst $20			; $47c9
	ld (hl),l		; $47ca
	ld ($30d7),sp		; $47cb
.DB $e3				; $47ce
	adc l			; $47cf
	ld ($ff00+$6d),a	; $47d0
	ld d,l			; $47d2
	nop			; $47d3

script_14_47d4:
	adc $d5			; $47d4
	xor c			; $47d6
	call z,$e302		; $47d7
	sub (hl)		; $47da
_label_14_049:
	ld hl,sp-$7b		; $47db
	ld a,(hl)		; $47dd
	nop			; $47de
	ld c,b			; $47df
	ret z			; $47e0
	or $98			; $47e1
	ld a,(bc)		; $47e3
	ld bc,$d2f6		; $47e4
	or c			; $47e7
	ld b,b			; $47e8
	cp c			; $47e9
	nop			; $47ea

script_14_47eb:
	adc $d5			; $47eb
	xor c			; $47ed
	call z,$e304		; $47ee
	sub (hl)		; $47f1
	ld hl,sp-$7b		; $47f2
	halt			; $47f4
	nop			; $47f5
	ld e,b			; $47f6
	ld a,b			; $47f7
	or $98			; $47f8
	ld a,(bc)		; $47fa
	inc bc			; $47fb
	or $d2			; $47fc
_label_14_050:
	or c			; $47fe
	ld b,b			; $47ff
	nop			; $4800

script_14_4801:
	add h			; $4801
	ld e,$13		; $4802
	jr nc,_label_14_051	; $4804
_label_14_051:
	add h			; $4806
	dec b			; $4807
	nop			; $4808
	jr _label_14_052		; $4809
.DB $f4				; $480b
	rst $20			; $480c
	inc d			; $480d
	and b			; $480e
	add h			; $480f
	dec b			; $4810
	nop			; $4811
	jr c,_label_14_053	; $4812
.DB $f4				; $4814
	rst $20			; $4815
	inc (hl)		; $4816
	and b			; $4817
	add h			; $4818
	dec b			; $4819
	nop			; $481a
	jr z,$48		; $481b
.DB $f4				; $481d
	rst $20			; $481e
	inc h			; $481f
	and b			; $4820
	add h			; $4821
	dec b			; $4822
	nop			; $4823
	ld c,b			; $4824
	ld c,b			; $4825
.DB $f4				; $4826
	rst $20			; $4827
	ld b,h			; $4828
	and b			; $4829
	add h			; $482a
	ld h,l			; $482b
	nop			; $482c
	nop			; $482d
	nop			; $482e
	nop			; $482f

script_14_4830:
	adc $8d			; $4830
	ld ($d020),sp		; $4832
	cp l			; $4835
.DB $e4				; $4836
	dec c			; $4837
	sbc b			; $4838
	nop			; $4839
	or $98			; $483a
	ld bc,$98f6		; $483c
	ld (bc),a		; $483f
	or $98			; $4840
	inc bc			; $4842
.DB $e4				; $4843
	rst $38			; $4844
	or c			; $4845
	ld b,b			; $4846
	cp (hl)			; $4847
	nop			; $4848

script_14_4849:
	adc $d5			; $4849
	inc b			; $484b
	ret nc			; $484c
	ld bc,$d5f3		; $484d
	ld sp,$01cc		; $4850
_label_14_052:
	adc b			; $4853
	ld a,b			; $4854
	ld a,b			; $4855
	rst_addAToHl			; $4856
	inc c			; $4857
	ld ($ff00+c),a		; $4858
	ld a,($ff00+c)		; $4859
	add sp,$6a		; $485a
_label_14_053:
.DB $e3				; $485c
	ld c,l			; $485d
	or c			; $485e
	ld b,b			; $485f
	nop			; $4860

script_14_4861:
	adc $8e			; $4861
	ld e,h			; $4863
	ld bc,$ebc0		; $4864
	ld d,(hl)		; $4867
	and b			; $4868
	ld ($ff00+$cb),a	; $4869
	ld e,b			; $486b
	adc h			; $486c
_label_14_054:
	ld l,b			; $486d
	and d			; $486e
	ld ($ff00+$fa),a	; $486f
	dec e			; $4871
	adc e			; $4872
	jr z,_label_14_050	; $4873
	ld ($dce0),sp		; $4875
	ld e,b			; $4878
	and e			; $4879
	adc a			; $487a
	ld bc,$0380		; $487b
	ret nc			; $487e
	add b			; $487f
	ld (bc),a		; $4880
	ld ($ff00+$eb),a	; $4881
	ld e,b			; $4883
	or $ac			; $4884
	adc a			; $4886
_label_14_055:
	inc bc			; $4887
	adc e			; $4888
	ld d,b			; $4889
	adc c			; $488a
	jr _label_14_054		; $488b
	ld l,b			; $488d
	ld e,c			; $488e
	pop af			; $488f
	ldh (<hSerialRead),a	; $4890
	ld e,b			; $4892
	sbc b			; $4893
	nop			; $4894
	ld (hl),$be		; $4895
.DB $e4				; $4897
	rst $38			; $4898
	nop			; $4899

script_14_489a:
	or l			; $489a
	rrca			; $489b
	ret c			; $489c
	ld b,l			; $489d
	adc (hl)		; $489e
	ld e,h			; $489f
	ld (bc),a		; $48a0
	ret nz			; $48a1
.DB $eb				; $48a2
	ld d,(hl)		; $48a3
	adc a			; $48a4
	ld (bc),a		; $48a5
	cp d			; $48a6
	ld hl,sp-$6b		; $48a7
	nop			; $48a9
.DB $fd				; $48aa
	sbc b			; $48ab
	jr z,_label_14_057	; $48ac
_label_14_056:
	xor b			; $48ae
_label_14_057:
	and c			; $48af
	adc a			; $48b0
	inc bc			; $48b1
	adc h			; $48b2
_label_14_058:
	ld b,b			; $48b3
	nop			; $48b4

script_14_48b5:
	pop hl			; $48b5
	pop de			; $48b6
	ld h,e			; $48b7
	ld (bc),a		; $48b8
_label_14_059:
	or $98			; $48b9
	jr nz,_label_14_058	; $48bb
	sbc b			; $48bd
	ld hl,$98f6		; $48be
	jr z,_label_14_059	; $48c1
	sbc b			; $48c3
	ldi (hl),a		; $48c4
	or $98			; $48c5
	add hl,hl		; $48c7
	or $98			; $48c8
	inc hl			; $48ca
	ld ($ff00+$1e),a	; $48cb
	ld e,$8b		; $48cd
	inc d			; $48cf
	xor $09			; $48d0
	or $98			; $48d2
	ldi a,(hl)		; $48d4
	xor d			; $48d5
	or $98			; $48d6
	inc h			; $48d8
	or $5d			; $48d9
	.db $36		; $48db

script_14_48dc:
	.db $9e		; $48dc
	cp b			; $48dd
	sbc b			; $48de
	inc c			; $48df
	or $8e			; $48e0
	ld a,h			; $48e2
	ld bc,$508b		; $48e3
.DB $ec				; $48e6
	dec d			; $48e7
	pop af			; $48e8
	adc a			; $48e9
	nop			; $48ea
	adc c			; $48eb
	ld ($098c),sp		; $48ec
	pop af			; $48ef
	ret nz			; $48f0
	ld e,c			; $48f1
	ld e,(hl)		; $48f2
	ret nz			; $48f3
	ld e,c			; $48f4
	ld e,(hl)		; $48f5
	adc a			; $48f6
	nop			; $48f7
	adc c			; $48f8
	jr _label_14_055		; $48f9
	add hl,bc		; $48fb
	pop af			; $48fc
	ret nz			; $48fd
	ld e,c			; $48fe
	ld e,(hl)		; $48ff
	adc a			; $4900
	nop			; $4901
	adc c			; $4902
	jr -$74			; $4903
	add hl,bc		; $4905
	pop af			; $4906
	ret nz			; $4907
	ld e,c			; $4908
	ld e,(hl)		; $4909
	ret nz			; $490a
	ld e,c			; $490b
	ld e,(hl)		; $490c
	adc a			; $490d
	nop			; $490e
	adc c			; $490f
	ld ($198c),sp		; $4910
	pop af			; $4913
	ret nz			; $4914
	ld e,c			; $4915
	ld e,(hl)		; $4916
	ret nz			; $4917
	ld e,c			; $4918
	ld e,(hl)		; $4919
	ret nz			; $491a
	ld e,c			; $491b
_label_14_060:
	ld e,(hl)		; $491c
	adc a			; $491d
	nop			; $491e
	adc c			; $491f
	jr _label_14_056		; $4920
	ld de,$eef1		; $4922
	dec d			; $4925
	adc (hl)		; $4926
	ld a,h			; $4927
	nop			; $4928
	or $98			; $4929
	dec c			; $492b
	or $b9			; $492c
	ld e,(hl)		; $492e
	ld d,b			; $492f

script_14_4930:
	cp l			; $4930
	ld ($ff00+$67),a	; $4931
	ld e,d			; $4933
	sub c			; $4934
	xor d			; $4935
	call z,$f801		; $4936
	ld ($ff00+$21),a	; $4939
_label_14_061:
	ld e,d			; $493b
	and b			; $493c
	ret nz			; $493d
	ld a,(bc)		; $493e
_label_14_062:
	ld e,a			; $493f
	or $98			; $4940
	dec h			; $4942
	or $a9			; $4943
	adc (hl)		; $4945
	ld a,h			; $4946
	ld bc,$1ee0		; $4947
	ld e,$8b		; $494a
	jr z,_label_14_061	; $494c
	ld b,c			; $494e
	pop af			; $494f
	adc e			; $4950
	jr z,_label_14_062	; $4951
	rra			; $4953
	ret nz			; $4954
	ld bc,$e05f		; $4955
	ld h,c			; $4958
	ld e,d			; $4959
	and d			; $495a
	ld ($ff00+$45),a	; $495b
	ld e,d			; $495d
	cp c			; $495e
.DB $d3				; $495f
	rlca			; $4960
	jp $b8cb		; $4961
	push af			; $4964
	ld ($ff00+$5b),a	; $4965
	ld e,d			; $4967
	sub c			; $4968
	jp $00cb		; $4969
	ld hl,sp-$46		; $496c
	sub c			; $496e
	inc b			; $496f
	call z,$000c		; $4970

script_14_4973:
	ld ($ff00+$39),a	; $4973
	ld e,$d5		; $4975
	ret nz			; $4977
	rst $8			; $4978
	ld bc,$42e0		; $4979
	ld e,$d5		; $497c
	ret nz			; $497e
	rst $8			; $497f
	ld b,$8f		; $4980
	inc bc			; $4982
	ld a,($ff00+c)		; $4983
	sub c			; $4984
	ret nz			; $4985
	rst $8			; $4986
	rlca			; $4987
	sbc b			; $4988
	dec a			; $4989
	inc c			; $498a
	di			; $498b
	adc a			; $498c
	rlca			; $498d
_label_14_063:
	adc c			; $498e
	jr _label_14_060		; $498f
	dec b			; $4991
	adc h			; $4992
	ld e,$91		; $4993
	ret nz			; $4995
	rst $8			; $4996
	.db $08		; $4997
	.db $00		; $4998

script_14_4999:
	.db $f8		; $4999
	adc b			; $499a
	jr _label_14_065		; $499b
	adc e			; $499d
_label_14_064:
	jr z,_label_14_063	; $499e
	ld de,$edf1		; $49a0
	add hl,sp		; $49a3
	pop af			; $49a4
	xor $11			; $49a5
	pop af			; $49a7
	sbc b			; $49a8
	ld d,b			; $49a9
	dec c			; $49aa
	or $84			; $49ab
	cp d			; $49ad
	ld bc,$1818		; $49ae
	and b			; $49b1
	adc h			; $49b2
	ld d,c			; $49b3
	xor c			; $49b4
_label_14_065:
	nop			; $49b5

script_14_49b6:
	adc a			; $49b6
	ld (bc),a		; $49b7
	and (hl)		; $49b8
	adc a			; $49b9
	inc bc			; $49ba
.DB $f4				; $49bb
	adc a			; $49bc
	ld bc,$8ff4		; $49bd
	ld (bc),a		; $49c0
	and l			; $49c1
	ld ($ff00+$c8),a	; $49c2
	ld e,d			; $49c4
.DB $e3				; $49c5
	ld d,b			; $49c6
	nop			; $49c7

script_14_49c8:
	adc a			; $49c8
	inc bc			; $49c9
	ei			; $49ca
	adc e			; $49cb
_label_14_066:
	inc d			; $49cc
_label_14_067:
	adc c			; $49cd
	jr -$74			; $49ce
	ret nz			; $49d0
	ld a,($008f)		; $49d1
	rst_addAToHl			; $49d4
	sub (hl)		; $49d5
	sub c			; $49d6
	rst_addDoubleIndex			; $49d7
	rst $8			; $49d8
	.db $01		; $49d9
	.db $00		; $49da

script_14_49db:
	.db $bd		; $49db
	add h			; $49dc
	ld e,l			; $49dd
	rlca			; $49de
	ld l,b			; $49df
	ld e,b			; $49e0
	adc (hl)		; $49e1
	ld a,c			; $49e2
	nop			; $49e3
.DB $e3				; $49e4
	ld l,c			; $49e5
	adc a			; $49e6
	inc b			; $49e7
	rst $30			; $49e8
	sub c			; $49e9
	sbc $cf			; $49ea
	add b			; $49ec
	adc a			; $49ed
	ld (bc),a		; $49ee
	sbc b			; $49ef
	dec sp			; $49f0
	sub c			; $49f1
	rst_addDoubleIndex			; $49f2
	rst $8			; $49f3
	ld bc,$41de		; $49f4
	ld ($40b1),sp		; $49f7
	ld ($ff00+$d1),a	; $49fa
	ld e,d			; $49fc
_label_14_068:
	or $8e			; $49fd
	ld a,d			; $49ff
	ld bc,$508b		; $4a00
	adc c			; $4a03
	ld ($118c),sp		; $4a04
	adc a			; $4a07
	ld bc,$1089		; $4a08
	adc h			; $4a0b
	add hl,hl		; $4a0c
	cp (hl)			; $4a0d
	nop			; $4a0e

script_14_4a0f:
	adc b			; $4a0f
	ld (hl),b		; $4a10
	jr _label_14_064		; $4a11
	ld d,b			; $4a13
.DB $e4				; $4a14
	ld hl,$89fa		; $4a15
	ld ($118c),sp		; $4a18
	sub d			; $4a1b
	pop de			; $4a1c
	rst $8			; $4a1d
	stop			; $4a1e
	push af			; $4a1f
	adc h			; $4a20
	dec c			; $4a21
	rst $30			; $4a22
	adc c			; $4a23
	nop			; $4a24
	adc h			; $4a25
	ld ($d192),sp		; $4a26
	rst $8			; $4a29
	ld (bc),a		; $4a2a
	rst $30			; $4a2b
	adc c			; $4a2c
	ld ($138c),sp		; $4a2d
	sub d			; $4a30
	pop de			; $4a31
	rst $8			; $4a32
	ld ($89f7),sp		; $4a33
	nop			; $4a36
	adc h			; $4a37
	ld a,(bc)		; $4a38
	sub d			; $4a39
	pop de			; $4a3a
	rst $8			; $4a3b
	inc b			; $4a3c
	rst $30			; $4a3d
	adc c			; $4a3e
	jr _label_14_067		; $4a3f
	jr nc,_label_14_066	; $4a41
	nop			; $4a43
	adc h			; $4a44
	dec c			; $4a45
	sub d			; $4a46
	pop de			; $4a47
	rst $8			; $4a48
	.db $01		; $4a49
	.db $00		; $4a4a

script_14_4a4b:
	.db $89		; $4a4b
	ld ($148c),sp		; $4a4c
	sub d			; $4a4f
	pop de			; $4a50
	rst $8			; $4a51
	ld b,b			; $4a52
	push de			; $4a53
	ret nc			; $4a54
	rst $8			; $4a55
	rlca			; $4a56
	adc h			; $4a57
	ld d,$92		; $4a58
	pop de			; $4a5a
	rst $8			; $4a5b
	add b			; $4a5c
	push de			; $4a5d
	ret nc			; $4a5e
	rst $8			; $4a5f
	ld a,(bc)		; $4a60
	ld sp,hl		; $4a61
	adc c			; $4a62
	nop			; $4a63
	adc h			; $4a64
	jr z,-$6f		; $4a65
	ret nc			; $4a67
	rst $8			; $4a68
	dec bc			; $4a69
	or c			; $4a6a
	add b			; $4a6b
	nop			; $4a6c

script_14_4a6d:
	adc b			; $4a6d
	ld ($ff00+$80),a	; $4a6e
	or $8b			; $4a70
	jr z,_label_14_068	; $4a72
	nop			; $4a74
	adc a			; $4a75
	ld (bc),a		; $4a76
	adc h			; $4a77
	ld e,b			; $4a78
	adc a			; $4a79
	ld bc,$98f8		; $4a7a
	ld e,$00		; $4a7d
	di			; $4a7f
	sbc b			; $4a80
	ld e,$02		; $4a81
	di			; $4a83
	sbc b			; $4a84
	ld e,$03		; $4a85
	di			; $4a87
	sbc b			; $4a88
	ld e,$04		; $4a89
	di			; $4a8b
	sub c			; $4a8c
	ret nc			; $4a8d
	rst $8			; $4a8e
	dec bc			; $4a8f
	nop			; $4a90

script_14_4a91:
	adc b			; $4a91
	nop			; $4a92
	ld h,b			; $4a93
	adc e			; $4a94
	inc d			; $4a95
	adc c			; $4a96
	stop			; $4a97
	adc h			; $4a98
	add b			; $4a99
	adc a			; $4a9a
	stop			; $4a9b
	ld hl,sp-$68		; $4a9c
	rla			; $4a9e
	ld a,(de)		; $4a9f
	ld hl,sp-$57		; $4aa0
	nop			; $4aa2

script_14_4aa3:
	or (hl)			; $4aa3
	ld e,b			; $4aa4
	pop hl			; $4aa5
	push af			; $4aa6
	ld e,d			; $4aa7
	dec c			; $4aa8
	sbc b			; $4aa9
	ld d,l			; $4aaa
	pop hl			; $4aab
	push af			; $4aac
	ld e,d			; $4aad
	dec bc			; $4aae
	ld ($ff00+$44),a	; $4aaf
	ld sp,$f8d1		; $4ab1
	ld ($ff00+$71),a	; $4ab4
	ld sp,$e1d1		; $4ab6
	push af			; $4ab9
	ld e,d			; $4aba
	dec c			; $4abb
	sbc b			; $4abc
	ld d,a			; $4abd
	pop hl			; $4abe
	push af			; $4abf
	ld e,d			; $4ac0
	dec bc			; $4ac1
	ld ($ff00+$0c),a	; $4ac2
	ld e,e			; $4ac4
	or $e0			; $4ac5
	adc l			; $4ac7
	ld h,h			; $4ac8
	di			; $4ac9
.DB $e3				; $4aca
	or h			; $4acb
	ld ($ff00+$44),a	; $4acc
	ld sp,$e3f5		; $4ace
	or h			; $4ad1
	ld ($ff00+$44),a	; $4ad2
	ld sp,$e3f5		; $4ad4
	or h			; $4ad7
	ld ($ff00+$44),a	; $4ad8
	ld sp,$f5d1		; $4ada
	pop hl			; $4add
	ld e,h			; $4ade
	ld sp,$d104		; $4adf
	sbc $0c			; $4ae2
	nop			; $4ae4
	ld hl,sp-$4a		; $4ae5
	ld h,d			; $4ae7
	ld h,d			; $4ae8
	ld b,h			; $4ae9

script_14_4aea:
	cp e			; $4aea
	cp d			; $4aeb
	add b			; $4aec
	rst $38			; $4aed
	sbc b			; $4aee
	ldi a,(hl)		; $4aef
	ld (bc),a		; $4af0
.DB $e4				; $4af1
	ldh a,(<hFF8B)	; $4af2
	jr z,-$13		; $4af4
	ld de,$21ec		; $4af6
	rst $30			; $4af9
	ld ($ff00+$59),a	; $4afa
	ld e,e			; $4afc
	rst $30			; $4afd
	ld ($ff00+$5d),a	; $4afe
	ld e,e			; $4b00
	ld hl,sp-$6a		; $4b01
	stop			; $4b03
	ldh (<hFF8F),a	; $4b04
	ld e,e			; $4b06
	ld ($ff00+$2d),a	; $4b07
_label_14_069:
	ld e,e			; $4b09
	xor $11			; $4b0a
	or $91			; $4b0c
	ld ($00d0),sp		; $4b0e
	ld hl,sp-$68		; $4b11
	ldi a,(hl)		; $4b13
	inc bc			; $4b14
.DB $e4				; $4b15
	ld sp,$7dd7		; $4b16
	add b			; $4b19
	inc bc			; $4b1a
	ret nz			; $4b1b
	or c			; $4b1c
	ld h,d			; $4b1d
	ret nz			; $4b1e
	or c			; $4b1f
	ld h,d			; $4b20
	rst_addAToHl			; $4b21
	add $c0			; $4b22
	or c			; $4b24
	ld h,d			; $4b25
	ret nz			; $4b26
	or c			; $4b27
	ld h,d			; $4b28
_label_14_070:
	ld ($ff00+$64),a	; $4b29
	ld e,e			; $4b2b
.DB $e3				; $4b2c
	ld a,c			; $4b2d
	or $e0			; $4b2e
	or b			; $4b30
	ld e,e			; $4b31
	ld ($ff00+$73),a	; $4b32
	ld e,e			; $4b34
_label_14_071:
.DB $e4				; $4b35
	ld a,($ff00+$f8)	; $4b36
.DB $e3				; $4b38
	ld c,l			; $4b39
	xor e			; $4b3a
	xor a			; $4b3b
	ld hl,sp-$68		; $4b3c
	ldi a,(hl)		; $4b3e
	inc b			; $4b3f
	add b			; $4b40
_label_14_072:
	ld bc,$1096		; $4b41
.DB $e4				; $4b44
	rst $38			; $4b45
	or c			; $4b46
	ld b,b			; $4b47
	cp (hl)			; $4b48
	sub a			; $4b49
	ldi a,(hl)		; $4b4a
	dec b			; $4b4b

script_14_4b4c:
	sbc b			; $4b4c
_label_14_073:
	daa			; $4b4d
	ld ($1be0),sp		; $4b4e
	ld e,e			; $4b51
	adc a			; $4b52
	nop			; $4b53
	ld hl,sp-$7c		; $4b54
	ld l,a			; $4b56
_label_14_074:
	ld bc,$3838		; $4b57
.DB $e3				; $4b5a
	ld l,h			; $4b5b
.DB $f4				; $4b5c
	add b			; $4b5d
	rst $38			; $4b5e
	adc e			; $4b5f
	ld d,b			; $4b60
	xor $11			; $4b61
.DB $ed				; $4b63
	add hl,de		; $4b64
.DB $f4				; $4b65
	sub (hl)		; $4b66
	jr _label_14_069		; $4b67
	ld ($ff00+$25),a	; $4b69
	ld e,e			; $4b6b
	sub c			; $4b6c
	ld ($00d0),sp		; $4b6d
_label_14_075:
	rst $28			; $4b70
	add hl,de		; $4b71
.DB $ec				; $4b72
	add hl,de		; $4b73
	push af			; $4b74
	sub (hl)		; $4b75
	ld ($96f5),sp		; $4b76
	jr _label_14_075		; $4b79
	xor c			; $4b7b
	ldh a,(<hGameboyType)	; $4b7c
	stop			; $4b7e
	sbc b			; $4b7f
	daa			; $4b80
	add hl,bc		; $4b81
	xor d			; $4b82
	adc h			; $4b83
	ld sp,$0891		; $4b84
	ret nc			; $4b87
	ld (bc),a		; $4b88
	cp (hl)			; $4b89
	ld ($ff00+$d5),a	; $4b8a
	ld e,e			; $4b8c
	nop			; $4b8d

script_14_4b8e:
	or $98			; $4b8e
	ld hl,$7f8e		; $4b90
	ld bc,$508b		; $4b93
	rst $28			; $4b96
	ld de,$6ee3		; $4b97
	adc e			; $4b9a
	jr z,_label_14_070	; $4b9b
	ld de,$508b		; $4b9d
	adc h			; $4ba0
	add hl,bc		; $4ba1
.DB $ec				; $4ba2
	dec d			; $4ba3
.DB $e3				; $4ba4
	ret nc			; $4ba5
	adc c			; $4ba6
	jr _label_14_071		; $4ba7
	dec b			; $4ba9
.DB $e3				; $4baa
	ret nc			; $4bab
	adc c			; $4bac
	ld ($098c),sp		; $4bad
.DB $e3				; $4bb0
	ret nc			; $4bb1
	adc c			; $4bb2
	jr _label_14_072		; $4bb3
	add hl,bc		; $4bb5
.DB $e3				; $4bb6
	ret nc			; $4bb7
	adc c			; $4bb8
	ld ($098c),sp		; $4bb9
.DB $e3				; $4bbc
	ret nc			; $4bbd
	adc c			; $4bbe
	jr _label_14_073		; $4bbf
	dec b			; $4bc1
	xor $15			; $4bc2
.DB $ed				; $4bc4
	add hl,bc		; $4bc5
.DB $e3				; $4bc6
	ld l,(hl)		; $4bc7
	adc e			; $4bc8
	jr z,_label_14_074	; $4bc9
	ld de,$508b		; $4bcb
	adc h			; $4bce
	ld de,$008f		; $4bcf
	sbc b			; $4bd2
	ldi (hl),a		; $4bd3
	adc a			; $4bd4
	ld (bc),a		; $4bd5
	sbc b			; $4bd6
	inc hl			; $4bd7
	cp l			; $4bd8
	sbc $41			; $4bd9
	inc b			; $4bdb
	or c			; $4bdc
	ld b,b			; $4bdd
	adc (hl)		; $4bde
	ld a,a			; $4bdf
	nop			; $4be0
	cp (hl)			; $4be1
	ld h,l			; $4be2
	ld l,h			; $4be3

script_14_4be4:
	sbc b			; $4be4
	ld bc,$b102		; $4be5
	add b			; $4be8
	cp b			; $4be9
	sub c			; $4bea
	ld ($03d0),sp		; $4beb
	add b			; $4bee
	rst $38			; $4bef
	adc e			; $4bf0
	ld d,b			; $4bf1
	rst $28			; $4bf2
	ld hl,$1096		; $4bf3
	or $8b			; $4bf6
	jr z,-$20		; $4bf8
	ld b,l			; $4bfa
	ld e,l			; $4bfb
	adc h			; $4bfc
	ld a,(bc)		; $4bfd
	adc a			; $4bfe
	inc b			; $4bff
	or $8f			; $4c00
	ld (bc),a		; $4c02
	add b			; $4c03
	rst $38			; $4c04
	nop			; $4c05

script_14_4c06:
	sub c			; $4c06
	rst_addDoubleIndex			; $4c07
	rst $8			; $4c08
	nop			; $4c09
	add h			; $4c0a
	ld l,d			; $4c0b
	inc bc			; $4c0c
	nop			; $4c0d
	nop			; $4c0e
	adc a			; $4c0f
	dec b			; $4c10
	sub c			; $4c11
	rst_addDoubleIndex			; $4c12
	rst $8			; $4c13
	ld bc,$98f2		; $4c14
	ld bc,$8f05		; $4c17
	dec b			; $4c1a
.DB $e3				; $4c1b
	jp z,$20e0		; $4c1c
	ld e,l			; $4c1f
	push de			; $4c20
	pop de			; $4c21
	rst $8			; $4c22
	nop			; $4c23
	rst_addAToHl			; $4c24
	ldd (hl),a		; $4c25
	adc a			; $4c26
	ld b,$91		; $4c27
	rst_addDoubleIndex			; $4c29
	rst $8			; $4c2a
	ld (bc),a		; $4c2b
	ld a,($ff00+c)		; $4c2c
	sbc b			; $4c2d
	ld bc,$8f06		; $4c2e
	ld b,$e3		; $4c31
	set 4,b			; $4c33
	add hl,hl		; $4c35
	ld e,l			; $4c36
	push de			; $4c37
	pop de			; $4c38
	rst $8			; $4c39
	nop			; $4c3a
	rst_addAToHl			; $4c3b
	ldd (hl),a		; $4c3c
	adc a			; $4c3d
	inc b			; $4c3e
	sub c			; $4c3f
	rst_addDoubleIndex			; $4c40
	rst $8			; $4c41
	inc bc			; $4c42
	ld a,($ff00+c)		; $4c43
	sbc b			; $4c44
	ld bc,$8f07		; $4c45
	inc b			; $4c48
.DB $e3				; $4c49
	call $32e0		; $4c4a
	ld e,l			; $4c4d
	push de			; $4c4e
	pop de			; $4c4f
	rst $8			; $4c50
	nop			; $4c51
	rst_addAToHl			; $4c52
	ldd (hl),a		; $4c53
	sub c			; $4c54
	rst_addDoubleIndex			; $4c55
	rst $8			; $4c56
	rst $38			; $4c57
	adc a			; $4c58
	ld bc,$0198		; $4c59
	ld (multiplyABy4),sp		; $4c5c
	ld b,c			; $4c5f
	ld h,(hl)		; $4c60
	sbc b			; $4c61
	ld bc,$d509		; $4c62
	and b			; $4c65
	rlc b			; $4c66
	ld h,(hl)		; $4c68
	dec sp			; $4c69
	ld bc,$021e		; $4c6a
	ld (hl),b		; $4c6d
	inc b			; $4c6e
	inc d			; $4c6f
.DB $fd				; $4c70
	and b			; $4c71
	ld (bc),a		; $4c72
	inc b			; $4c73
	dec d			; $4c74
.DB $fd				; $4c75
	and b			; $4c76
	ld (bc),a		; $4c77
	inc b			; $4c78
	ld d,$fd		; $4c79
	and b			; $4c7b
	ld (bc),a		; $4c7c
	ld bc,$021e		; $4c7d
	ld (hl),b		; $4c80
	dec b			; $4c81
	inc bc			; $4c82
	inc d			; $4c83
.DB $fd				; $4c84
	ld bc,$021e		; $4c85
	jp nz,$0307		; $4c88
	inc b			; $4c8b
	cp $00			; $4c8c
	ld bc,$050f		; $4c8e
	inc bc			; $4c91
	inc b			; $4c92
	cp $01			; $4c93
	rrca			; $4c95
	rlca			; $4c96
	inc bc			; $4c97
	inc d			; $4c98
	cp $00			; $4c99
	dec b			; $4c9b
	inc bc			; $4c9c
	inc b			; $4c9d
	rst $38			; $4c9e
	ld bc,$050f		; $4c9f
	inc bc			; $4ca2
	inc d			; $4ca3
	cp $01			; $4ca4
	rrca			; $4ca6
	rlca			; $4ca7
	inc bc			; $4ca8
	inc h			; $4ca9
	cp $00			; $4caa
	dec b			; $4cac
	inc bc			; $4cad
	inc d			; $4cae
	rst $38			; $4caf
	ld bc,$050f		; $4cb0
	inc bc			; $4cb3
	inc h			; $4cb4
	cp $01			; $4cb5
	rrca			; $4cb7
	rlca			; $4cb8
	inc bc			; $4cb9
	inc (hl)		; $4cba
	cp $00			; $4cbb
	dec b			; $4cbd
	inc bc			; $4cbe
	inc h			; $4cbf
	rst $38			; $4cc0
	ld bc,$050f		; $4cc1
	inc bc			; $4cc4
	inc (hl)		; $4cc5
	cp $01			; $4cc6
	rrca			; $4cc8
	rlca			; $4cc9
	inc bc			; $4cca
	ld b,h			; $4ccb
	cp $00			; $4ccc
	dec b			; $4cce
	inc bc			; $4ccf
	inc (hl)		; $4cd0
	rst $38			; $4cd1
	ld bc,$050f		; $4cd2
	inc bc			; $4cd5
	ld b,h			; $4cd6
	cp $01			; $4cd7
	rrca			; $4cd9
	rlca			; $4cda
	inc bc			; $4cdb
	ld d,h			; $4cdc
	cp $00			; $4cdd
	dec b			; $4cdf
	inc bc			; $4ce0
	ld b,h			; $4ce1
	rst $38			; $4ce2
	ld bc,$050f		; $4ce3
	inc bc			; $4ce6
	ld d,h			; $4ce7
	cp $01			; $4ce8
	rrca			; $4cea
	rlca			; $4ceb
	inc bc			; $4cec
	ld h,h			; $4ced
	cp $00			; $4cee
	dec b			; $4cf0
	inc bc			; $4cf1
	ld d,h			; $4cf2
	rst $38			; $4cf3
	ld bc,$050f		; $4cf4
	inc bc			; $4cf7
	ld h,h			; $4cf8
	cp $01			; $4cf9
	rrca			; $4cfb
	rlca			; $4cfc
	inc bc			; $4cfd
	ld (hl),h		; $4cfe
	cp $00			; $4cff
	dec b			; $4d01
	inc bc			; $4d02
	ld h,h			; $4d03
	rst $38			; $4d04
	ld bc,$050f		; $4d05
	inc bc			; $4d08
	ld (hl),h		; $4d09
	cp $01			; $4d0a
	rrca			; $4d0c
	dec b			; $4d0d
	inc bc			; $4d0e
	ld (hl),h		; $4d0f
	rst $38			; $4d10
	ld bc,$013c		; $4d11
	rrca			; $4d14
	rlca			; $4d15
	inc bc			; $4d16
	inc b			; $4d17
	ld a,($0100)		; $4d18
	rrca			; $4d1b
	dec b			; $4d1c
	inc bc			; $4d1d
	inc b			; $4d1e
	ld a,($0f01)		; $4d1f
	rlca			; $4d22
	inc bc			; $4d23
	inc d			; $4d24
	ld a,($0100)		; $4d25
	rrca			; $4d28
	dec b			; $4d29
	inc bc			; $4d2a
	inc d			; $4d2b
	ld a,($0f01)		; $4d2c
	rlca			; $4d2f
	inc bc			; $4d30
	inc h			; $4d31
	ld a,($0100)		; $4d32
	rrca			; $4d35
	dec b			; $4d36
	inc bc			; $4d37
	inc h			; $4d38
	ld a,($0f01)		; $4d39
	rlca			; $4d3c
	inc bc			; $4d3d
	inc (hl)		; $4d3e
	ld a,($0100)		; $4d3f
	rrca			; $4d42
	dec b			; $4d43
	inc bc			; $4d44
	inc (hl)		; $4d45
	ld a,($0f01)		; $4d46
	rlca			; $4d49
	inc bc			; $4d4a
	ld b,h			; $4d4b
	ld a,($0100)		; $4d4c
	rrca			; $4d4f
	dec b			; $4d50
	inc bc			; $4d51
	ld b,h			; $4d52
	ld a,($0f01)		; $4d53
	rlca			; $4d56
	inc bc			; $4d57
	ld d,h			; $4d58
	ld a,($0100)		; $4d59
	rrca			; $4d5c
	dec b			; $4d5d
	inc bc			; $4d5e
	ld d,h			; $4d5f
	ld a,($0f01)		; $4d60
	rlca			; $4d63
	inc bc			; $4d64
	ld h,h			; $4d65
	ld a,($0100)		; $4d66
	rrca			; $4d69
	dec b			; $4d6a
	inc bc			; $4d6b
	ld h,h			; $4d6c
	ld a,($0f01)		; $4d6d
	rlca			; $4d70
	inc bc			; $4d71
	ld (hl),h		; $4d72
	ld a,($0100)		; $4d73
	rrca			; $4d76
	dec b			; $4d77
	inc bc			; $4d78
	ld (hl),h		; $4d79
	ld a,($b401)		; $4d7a
	ld (bc),a		; $4d7d
	pop af			; $4d7e
	nop			; $4d7f
	ld (bc),a		; $4d80
	jp nz,$1401		; $4d81
	inc b			; $4d84
	ld h,d			; $4d85
	ld b,l			; $4d86
	rst $38			; $4d87
	ld (bc),a		; $4d88
	inc b			; $4d89
	ld h,e			; $4d8a
	ld d,h			; $4d8b
	rst $38			; $4d8c
	ld (bc),a		; $4d8d
	inc b			; $4d8e
	ld h,h			; $4d8f
	ld b,(hl)		; $4d90
	rst $38			; $4d91
	ld (bc),a		; $4d92
	ld bc,$0314		; $4d93
	ld h,d			; $4d96
	ld b,l			; $4d97
	inc bc			; $4d98
	ld h,e			; $4d99
	ld d,h			; $4d9a
	inc bc			; $4d9b
	ld h,h			; $4d9c
	ld b,(hl)		; $4d9d
	ld bc,$0414		; $4d9e
	ld (hl),d		; $4da1
	ld b,l			; $4da2
	rst $38			; $4da3
	ld (bc),a		; $4da4
	inc b			; $4da5
	ld (hl),e		; $4da6
	ld d,h			; $4da7
	rst $38			; $4da8
	ld (bc),a		; $4da9
	inc b			; $4daa
	ld (hl),h		; $4dab
	ld b,(hl)		; $4dac
	rst $38			; $4dad
	ld (bc),a		; $4dae
	ld bc,$0314		; $4daf
	ld (hl),d		; $4db2
	ld b,l			; $4db3
	inc bc			; $4db4
	ld (hl),e		; $4db5
	ld d,h			; $4db6
	inc bc			; $4db7
	ld (hl),h		; $4db8
	ld b,(hl)		; $4db9
	ld bc,$000a		; $4dba
	inc b			; $4dbd
	ld (bc),a		; $4dbe
	or (hl)			; $4dbf
	rst $38			; $4dc0
	ld (bc),a		; $4dc1
	inc b			; $4dc2
	inc bc			; $4dc3
	or a			; $4dc4
	rst $38			; $4dc5
	ld (bc),a		; $4dc6
	inc b			; $4dc7
	inc b			; $4dc8
	cp b			; $4dc9
	rst $38			; $4dca
	ld (bc),a		; $4dcb
	ld bc,$0314		; $4dcc
	ld (bc),a		; $4dcf
	or (hl)			; $4dd0
	inc bc			; $4dd1
	inc bc			; $4dd2
	or a			; $4dd3
	inc bc			; $4dd4
	inc b			; $4dd5
	cp b			; $4dd6
	ld bc,$0414		; $4dd7
	ld (de),a		; $4dda
	ld l,e			; $4ddb
	rst $38			; $4ddc
	ld (bc),a		; $4ddd
	inc b			; $4dde
	inc de			; $4ddf
	xor $ff			; $4de0
	ld (bc),a		; $4de2
	inc b			; $4de3
	inc d			; $4de4
	ld l,e			; $4de5
	rst $38			; $4de6
	ld (bc),a		; $4de7
	ld bc,$0314		; $4de8
	ld (de),a		; $4deb
	ld l,e			; $4dec
	inc bc			; $4ded
	inc de			; $4dee
	xor $03			; $4def
	inc d			; $4df1
	ld l,e			; $4df2
	ld bc,$0414		; $4df3
	ldi (hl),a		; $4df6
	ld l,e			; $4df7
	rst $38			; $4df8
	ld (bc),a		; $4df9
	inc b			; $4dfa
	inc hl			; $4dfb
	call z,$02ff		; $4dfc
	inc b			; $4dff
	inc h			; $4e00
	ld l,e			; $4e01
	rst $38			; $4e02
	ld (bc),a		; $4e03
	ld bc,$0314		; $4e04
	ldi (hl),a		; $4e07
	ld l,e			; $4e08
	inc bc			; $4e09
	inc hl			; $4e0a
	call z,$2403		; $4e0b
	ld l,e			; $4e0e
	ld bc,$003c		; $4e0f
	ld bc,$0228		; $4e12
	ld (hl),b		; $4e15
	inc b			; $4e16
	ld b,e			; $4e17
.DB $fd				; $4e18
	dec l			; $4e19
	inc bc			; $4e1a
	inc b			; $4e1b
	ld b,h			; $4e1c
.DB $fd				; $4e1d
	dec l			; $4e1e
	ld bc,$5304		; $4e1f
.DB $fd				; $4e22
	ld l,$03		; $4e23
	inc b			; $4e25
	ld d,h			; $4e26
.DB $fd				; $4e27
	ld l,$01		; $4e28
	ld bc,$0228		; $4e2a
	ld (hl),b		; $4e2d
	inc bc			; $4e2e
	ld b,e			; $4e2f
	dec l			; $4e30
	inc bc			; $4e31
	ld b,h			; $4e32
_label_14_076:
	dec l			; $4e33
	inc bc			; $4e34
	ld d,e			; $4e35
	ld l,$03		; $4e36
	ld d,h			; $4e38
	ld l,$01		; $4e39
	jr z,_label_14_078	; $4e3b
	ld c,l			; $4e3d
_label_14_077:
	nop			; $4e3e

script_14_4e3f:
_label_14_078:
	adc b			; $4e3f
	ld c,b			; $4e40
	or b			; $4e41
	or c			; $4e42
	ld b,b			; $4e43
	ld hl,sp-$7f		; $4e44
	inc bc			; $4e46
	adc e			; $4e47
	ld d,b			; $4e48
	rst $28			; $4e49
_label_14_079:
	add hl,sp		; $4e4a
.DB $ec				; $4e4b
	add hl,de		; $4e4c
	add c			; $4e4d
	ld (bc),a		; $4e4e
	adc a			; $4e4f
	ld (bc),a		; $4e50
_label_14_080:
	sbc b			; $4e51
_label_14_081:
	ld h,$00		; $4e52
	ld h,a			; $4e54
	inc hl			; $4e55

script_14_4e56:
	adc e			; $4e56
	ld d,b			; $4e57
	adc a			; $4e58
	ld (bc),a		; $4e59
	add c			; $4e5a
	ld (bc),a		; $4e5b
_label_14_082:
	ld hl,sp-$68		; $4e5c
	ld h,$02		; $4e5e
	ld h,a			; $4e60
	inc hl			; $4e61

script_14_4e62:
.DB $ec				; $4e62
_label_14_083:
	jr nz,_label_14_081	; $4e63
	stop			; $4e65
	ret nz			; $4e66
	add b			; $4e67
	ld h,a			; $4e68
	xor $30			; $4e69
_label_14_084:
	rst $28			; $4e6b
	ld b,b			; $4e6c
	ret nz			; $4e6d
	sub (hl)		; $4e6e
_label_14_085:
	ld h,a			; $4e6f
.DB $ec				; $4e70
	jr nc,_label_14_076	; $4e71
	ld (hl),l		; $4e73
	ld h,a			; $4e74
.DB $ec				; $4e75
	ld b,h			; $4e76
	xor b			; $4e77
	nop			; $4e78

script_14_4e79:
.DB $ec				; $4e79
	jr nz,_label_14_084	; $4e7a
	jr nc,_label_14_077	; $4e7c
_label_14_086:
	sub (hl)		; $4e7e
	ld h,a			; $4e7f
	xor $30			; $4e80
	ret nz			; $4e82
	adc e			; $4e83
	ld h,a			; $4e84
.DB $ed				; $4e85
_label_14_087:
	ld b,b			; $4e86
.DB $ec				; $4e87
	jr nc,_label_14_079	; $4e88
	ld (hl),l		; $4e8a
	ld h,a			; $4e8b
.DB $ec				; $4e8c
_label_14_088:
	jr nc,_label_14_086	; $4e8d
	jr nc,_label_14_080	; $4e8f
	sub (hl)		; $4e91
	ld h,a			; $4e92
.DB $ec				; $4e93
_label_14_089:
	inc h			; $4e94
	xor b			; $4e95
	nop			; $4e96

script_14_4e97:
.DB $ec				; $4e97
	stop			; $4e98
.DB $ed				; $4e99
	jr nc,_label_14_082	; $4e9a
	add b			; $4e9c
	ld h,a			; $4e9d
	xor $30			; $4e9e
	rst $28			; $4ea0
	jr nc,_label_14_083	; $4ea1
	sub (hl)		; $4ea3
	ld h,a			; $4ea4
	rst $28			; $4ea5
	jr nc,_label_14_089	; $4ea6
	ld d,b			; $4ea8
	ret nz			; $4ea9
	ld (hl),l		; $4eaa
_label_14_090:
	ld h,a			; $4eab
.DB $ed				; $4eac
	jr nc,_label_14_085	; $4ead
	add b			; $4eaf
	ld h,a			; $4eb0
	xor $10			; $4eb1
_label_14_091:
.DB $ed				; $4eb3
	ld b,b			; $4eb4
	ret nz			; $4eb5
	add b			; $4eb6
_label_14_092:
	ld h,a			; $4eb7
.DB $ec				; $4eb8
	jr nc,-$40		; $4eb9
	ld (hl),l		; $4ebb
	ld h,a			; $4ebc
.DB $ec				; $4ebd
	inc d			; $4ebe
_label_14_093:
	xor b			; $4ebf
	nop			; $4ec0

script_14_4ec1:
.DB $ec				; $4ec1
	jr nc,_label_14_091	; $4ec2
	jr nc,_label_14_087	; $4ec4
	sub (hl)		; $4ec6
	ld h,a			; $4ec7
	xor $50			; $4ec8
.DB $ed				; $4eca
	jr nc,_label_14_088	; $4ecb
	add b			; $4ecd
	ld h,a			; $4ece
.DB $ec				; $4ecf
	jr nc,_label_14_093	; $4ed0
	jr nc,_label_14_089	; $4ed2
	add b			; $4ed4
	ld h,a			; $4ed5
	xor $30			; $4ed6
_label_14_094:
	rst $28			; $4ed8
	jr nc,-$40		; $4ed9
	sub (hl)		; $4edb
	ld h,a			; $4edc
.DB $ec				; $4edd
	ld d,b			; $4ede
	ret nz			; $4edf
	ld (hl),l		; $4ee0
	ld h,a			; $4ee1
.DB $ec				; $4ee2
	inc (hl)		; $4ee3
	xor b			; $4ee4
	nop			; $4ee5

script_14_4ee6:
.DB $ec				; $4ee6
	jr nz,_label_14_094	; $4ee7
	jr nc,_label_14_090	; $4ee9
	sub (hl)		; $4eeb
	ld h,a			; $4eec
	xor $30			; $4eed
.DB $ed				; $4eef
	ld b,b			; $4ef0
	ret nz			; $4ef1
_label_14_095:
	add b			; $4ef2
	ld h,a			; $4ef3
.DB $ec				; $4ef4
	jr nc,_label_14_092	; $4ef5
	ld (hl),l		; $4ef7
	ld h,a			; $4ef8
	rst $28			; $4ef9
	ld b,b			; $4efa
	ret nz			; $4efb
	sub (hl)		; $4efc
	ld h,a			; $4efd
	rst $28			; $4efe
	inc (hl)		; $4eff
	ld h,a			; $4f00
	ld l,c			; $4f01

script_14_4f02:
.DB $ec				; $4f02
	jr nz,_label_14_095	; $4f03
	stop			; $4f05
	ret nz			; $4f06
	add b			; $4f07
	ld h,a			; $4f08
	xor $30			; $4f09
	rst $28			; $4f0b
	ld b,b			; $4f0c
	ret nz			; $4f0d
	sub (hl)		; $4f0e
	ld h,a			; $4f0f
.DB $ec				; $4f10
	ld b,b			; $4f11
	xor $10			; $4f12
	ret nz			; $4f14
	sub (hl)		; $4f15
	ld h,a			; $4f16
	rst $28			; $4f17
	inc (hl)		; $4f18
_label_14_096:
	ld h,a			; $4f19
	ld l,c			; $4f1a

script_14_4f1b:
	or $ed			; $4f1b
	inc d			; $4f1d
	or $c0			; $4f1e
	ld (hl),l		; $4f20
	ld h,a			; $4f21
	rst $28			; $4f22
	inc d			; $4f23
_label_14_097:
	xor b			; $4f24
	nop			; $4f25

script_14_4f26:
	cp l			; $4f26
_label_14_098:
.DB $e4				; $4f27
	rst $38			; $4f28
.DB $e3				; $4f29
	ld c,l			; $4f2a
_label_14_099:
	ldh (<hIntroInputsEnabled),a	; $4f2b
	ld e,l			; $4f2d
	add c			; $4f2e
	inc bc			; $4f2f
_label_14_100:
	adc e			; $4f30
	jr z,-$6a		; $4f31
	jr _label_14_099		; $4f33
	rst $28			; $4f35
	jr nz,_label_14_097	; $4f36
	jr nz,-$71		; $4f38
	ld (bc),a		; $4f3a
	or $e3			; $4f3b
	adc l			; $4f3d
	add sp,-$3b		; $4f3e
	or c			; $4f40
	ld b,b			; $4f41
	cp (hl)			; $4f42
	nop			; $4f43

script_14_4f44:
	add c			; $4f44
	ld (bc),a		; $4f45
	cp b			; $4f46
	adc e			; $4f47
	ld d,b			; $4f48
	sub (hl)		; $4f49
	stop			; $4f4a
	sbc b			; $4f4b
	ld h,$01		; $4f4c
	add c			; $4f4e
	dec b			; $4f4f
	nop			; $4f50

script_14_4f51:
	xor $40			; $4f51
	ret nz			; $4f53
	dec bc			; $4f54
	ld l,d			; $4f55
_label_14_101:
.DB $ed				; $4f56
	jr nc,_label_14_096	; $4f57
	jr nz,$6a		; $4f59
	xor $18			; $4f5b
	ret nz			; $4f5d
	dec bc			; $4f5e
	ld l,d			; $4f5f
	xor $20			; $4f60
	xor c			; $4f62
_label_14_102:
	nop			; $4f63

script_14_4f64:
.DB $ec				; $4f64
	jr nz,_label_14_098	; $4f65
	cp $69			; $4f67
.DB $ed				; $4f69
	jr nc,-$12		; $4f6a
	stop			; $4f6c
.DB $ed				; $4f6d
	jr nc,_label_14_100	; $4f6e
	jr nz,_label_14_116	; $4f70
	rst $28			; $4f72
	jr nc,_label_14_102	; $4f73
	jr nz,-$11		; $4f75
_label_14_103:
	jr nc,-$40		; $4f77
	inc de			; $4f79
	ld l,d			; $4f7a
	xor $40			; $4f7b
	xor c			; $4f7d
_label_14_104:
	nop			; $4f7e

script_14_4f7f:
	adc b			; $4f7f
_label_14_105:
	jr z,-$78		; $4f80
_label_14_106:
	ld ($ff00+$4e),a	; $4f82
	ld e,(hl)		; $4f84
	sub (hl)		; $4f85
	jr _label_14_105		; $4f86
	rst $28			; $4f88
	stop			; $4f89
_label_14_107:
	xor $20			; $4f8a
	ret nz			; $4f8c
_label_14_108:
	dec bc			; $4f8d
	ld l,d			; $4f8e
	xor $10			; $4f8f
_label_14_109:
	rst $28			; $4f91
	jr nc,_label_14_106	; $4f92
	jr nz,_label_14_101	; $4f94
	dec bc			; $4f96
	ld l,d			; $4f97
	rst $28			; $4f98
	jr nc,-$14		; $4f99
	jr nc,_label_14_107	; $4f9b
	jr nz,-$14		; $4f9d
	jr nc,-$40		; $4f9f
_label_14_110:
	cp $69			; $4fa1
_label_14_111:
.DB $ed				; $4fa3
	stop			; $4fa4
	xor $80			; $4fa5
	xor c			; $4fa7
_label_14_112:
	nop			; $4fa8

script_14_4fa9:
	adc b			; $4fa9
	ld a,b			; $4faa
	jr c,_label_14_108	; $4fab
	ld c,(hl)		; $4fad
	ld e,(hl)		; $4fae
	sub (hl)		; $4faf
	ld ($edf8),sp		; $4fb0
	jr nc,_label_14_110	; $4fb3
_label_14_113:
	jr nz,_label_14_103	; $4fb5
	cp $69			; $4fb7
	rst $28			; $4fb9
	jr nz,_label_14_112	; $4fba
	jr nc,_label_14_104	; $4fbc
	cp $69			; $4fbe
	ld sp,hl		; $4fc0
.DB $ed				; $4fc1
	jr nc,-$12		; $4fc2
	jr nc,_label_14_113	; $4fc4
	stop			; $4fc6
	xor $40			; $4fc7
	xor c			; $4fc9
	nop			; $4fca

script_14_4fcb:
	adc b			; $4fcb
_label_14_114:
	jr c,_label_14_101	; $4fcc
	ld ($ff00+$4e),a	; $4fce
	ld e,(hl)		; $4fd0
	sub (hl)		; $4fd1
	jr _label_14_114		; $4fd2
	rst $28			; $4fd4
	ld d,b			; $4fd5
	sub (hl)		; $4fd6
_label_14_115:
	ld ($96f8),sp		; $4fd7
	jr _label_14_115		; $4fda
_label_14_116:
	rst $28			; $4fdc
	stop			; $4fdd
.DB $ec				; $4fde
_label_14_117:
	stop			; $4fdf
	rst $28			; $4fe0
	jr nz,_label_14_111	; $4fe1
	inc de			; $4fe3
	ld l,d			; $4fe4
	rst $28			; $4fe5
	jr nz,_label_14_109	; $4fe6
	nop			; $4fe8

script_14_4fe9:
_label_14_118:
	adc b			; $4fe9
_label_14_119:
	jr c,_label_14_124	; $4fea
	ld ($ff00+$4e),a	; $4fec
	ld e,(hl)		; $4fee
	sub (hl)		; $4fef
	jr _label_14_119		; $4ff0
	rst $28			; $4ff2
_label_14_120:
	stop			; $4ff3
	ret nz			; $4ff4
_label_14_121:
	inc de			; $4ff5
_label_14_122:
	ld l,d			; $4ff6
_label_14_123:
.DB $ec				; $4ff7
	jr nz,_label_14_118	; $4ff8
	stop			; $4ffa
	ret nz			; $4ffb
	inc de			; $4ffc
	ld l,d			; $4ffd
.DB $ed				; $4ffe
	jr nz,-$14		; $4fff
	stop			; $5001
.DB $ed				; $5002
	jr nc,_label_14_120	; $5003
	jr nc,_label_14_122	; $5005
	jr nc,_label_14_121	; $5007
	stop			; $5009
	rst $28			; $500a
	jr nz,-$40		; $500b
	inc de			; $500d
	ld l,d			; $500e
	rst $28			; $500f
	jr nz,-$57		; $5010
	nop			; $5012

script_14_5013:
	adc b			; $5013
_label_14_124:
	jr c,_label_14_135	; $5014
	ld ($ff00+$4e),a	; $5016
	ld e,(hl)		; $5018
	sub (hl)		; $5019
_label_14_125:
	nop			; $501a
_label_14_126:
	ld hl,sp-$14		; $501b
	jr nz,_label_14_117	; $501d
	cp $69			; $501f
	ei			; $5021
.DB $ed				; $5022
	ld b,b			; $5023
	ret nz			; $5024
	jr nz,_label_14_140	; $5025
	ld hl,sp-$12		; $5027
	jr nz,_label_14_125	; $5029
	jr nz,_label_14_126	; $502b
	stop			; $502d
	ret nz			; $502e
	dec bc			; $502f
	ld l,d			; $5030
_label_14_127:
	rst $28			; $5031
	ld d,b			; $5032
_label_14_128:
	ret nz			; $5033
_label_14_129:
	inc de			; $5034
	ld l,d			; $5035
_label_14_130:
.DB $ec				; $5036
	ld h,b			; $5037
_label_14_131:
	xor c			; $5038
_label_14_132:
	nop			; $5039

script_14_503a:
	adc b			; $503a
	ld ($e018),sp		; $503b
	ld c,(hl)		; $503e
	ld e,(hl)		; $503f
	sub (hl)		; $5040
	stop			; $5041
	ld hl,sp-$12		; $5042
	jr nc,_label_14_128	; $5044
	jr nz,_label_14_129	; $5046
	jr nz,_label_14_132	; $5048
	jr nz,_label_14_131	; $504a
	jr nz,_label_14_123	; $504c
	nop			; $504e

script_14_504f:
	adc b			; $504f
	ld ($e038),sp		; $5050
	ld c,(hl)		; $5053
	ld e,(hl)		; $5054
	sub (hl)		; $5055
	ld ($edf8),sp		; $5056
	ld b,b			; $5059
_label_14_133:
	xor $60			; $505a
	ret nz			; $505c
_label_14_134:
	dec bc			; $505d
_label_14_135:
	ld l,d			; $505e
	rst $28			; $505f
	ld h,b			; $5060
	ret nz			; $5061
	inc de			; $5062
_label_14_136:
	ld l,d			; $5063
.DB $ec				; $5064
	ld h,b			; $5065
	ret nz			; $5066
	cp $69			; $5067
.DB $ec				; $5069
	jr nz,-$57		; $506a
	nop			; $506c

script_14_506d:
	adc b			; $506d
_label_14_137:
	ld ($e088),sp		; $506e
	ld c,(hl)		; $5071
	ld e,(hl)		; $5072
	sub (hl)		; $5073
	jr _label_14_137		; $5074
	xor $60			; $5076
	ret nz			; $5078
_label_14_138:
	dec bc			; $5079
	ld l,d			; $507a
	rst $28			; $507b
	ld (hl),b		; $507c
	ret nz			; $507d
	inc de			; $507e
	ld l,d			; $507f
.DB $ec				; $5080
	ld h,b			; $5081
	ret nz			; $5082
	cp $69			; $5083
.DB $ec				; $5085
	jr nz,_label_14_127	; $5086
	nop			; $5088

script_14_5089:
	adc b			; $5089
	jr _label_14_124		; $508a
_label_14_139:
	ld ($ff00+$4e),a	; $508c
	ld e,(hl)		; $508e
	sub (hl)		; $508f
	stop			; $5090
_label_14_140:
	ld hl,sp-$12		; $5091
	ld h,b			; $5093
	ret nz			; $5094
	dec bc			; $5095
_label_14_141:
	ld l,d			; $5096
	rst $28			; $5097
	jr nc,_label_14_133	; $5098
	inc de			; $509a
	ld l,d			; $509b
.DB $ec				; $509c
	jr nc,_label_14_139	; $509d
	stop			; $509f
.DB $ec				; $50a0
	jr nc,_label_14_136	; $50a1
	cp $69			; $50a3
.DB $ed				; $50a5
_label_14_142:
	jr nz,_label_14_141	; $50a6
	add b			; $50a8
	xor c			; $50a9
	nop			; $50aa

script_14_50ab:
	adc b			; $50ab
	jr _label_14_130		; $50ac
	ld ($ff00+$4e),a	; $50ae
	ld e,(hl)		; $50b0
	sub (hl)		; $50b1
	stop			; $50b2
	ld hl,sp-$12		; $50b3
_label_14_143:
	jr nc,_label_14_142	; $50b5
	jr nc,_label_14_138	; $50b7
	inc de			; $50b9
	ld l,d			; $50ba
	xor $30			; $50bb
	ret nz			; $50bd
	dec bc			; $50be
	ld l,d			; $50bf
.DB $ed				; $50c0
	jr nc,-$14		; $50c1
	jr nc,-$11		; $50c3
	jr nc,_label_14_143	; $50c5
	ld d,b			; $50c7
	xor c			; $50c8
	nop			; $50c9

script_14_50ca:
	adc b			; $50ca
	ld c,b			; $50cb
	jr c,_label_14_134	; $50cc
	inc bc			; $50ce
	and b			; $50cf
	xor $50			; $50d0
	nop			; $50d2

script_14_50d3:
	adc $a0			; $50d3
	sub c			; $50d5
	xor e			; $50d6
	call z,$f801		; $50d7
.DB $e3				; $50da
	ld c,l			; $50db
	ld hl,sp-$1d		; $50dc
	ld (hl),e		; $50de
	pop hl			; $50df
	or h			; $50e0
	ld h,c			; $50e1
	inc b			; $50e2
	di			; $50e3
.DB $e3				; $50e4
	ld (hl),e		; $50e5
	pop hl			; $50e6
	or h			; $50e7
	ld h,c			; $50e8
	dec b			; $50e9
	pop hl			; $50ea
	or h			; $50eb
	ld h,c			; $50ec
	inc bc			; $50ed
	di			; $50ee
.DB $e3				; $50ef
	ld (hl),e		; $50f0
	pop hl			; $50f1
	or h			; $50f2
	ld h,c			; $50f3
	ld bc,$b4e1		; $50f4
	ld h,c			; $50f7
	rlca			; $50f8
	di			; $50f9
.DB $e3				; $50fa
	ld (hl),e		; $50fb
	pop hl			; $50fc
	or h			; $50fd
	ld h,c			; $50fe
	nop			; $50ff
	pop hl			; $5100
	or h			; $5101
	ld h,c			; $5102
	ld ($e3f3),sp		; $5103
	ld (hl),e		; $5106
	pop hl			; $5107
	or h			; $5108
	ld h,c			; $5109
	ld (bc),a		; $510a
	pop hl			; $510b
	or h			; $510c
	ld h,c			; $510d
	ld b,$f3		; $510e
.DB $e3				; $5110
	ld (hl),e		; $5111
	pop hl			; $5112
	or h			; $5113
	ld h,c			; $5114
	ld bc,$b4e1		; $5115
	ld h,c			; $5118
	dec b			; $5119
	pop hl			; $511a
	or h			; $511b
	ld h,c			; $511c
	inc bc			; $511d
	pop hl			; $511e
	or h			; $511f
	ld h,c			; $5120
	rlca			; $5121
	di			; $5122
.DB $e3				; $5123
	ld (hl),e		; $5124
	pop hl			; $5125
	or h			; $5126
	ld h,c			; $5127
	inc b			; $5128
	pop hl			; $5129
	or h			; $512a
	ld h,c			; $512b
	nop			; $512c
	pop hl			; $512d
	or h			; $512e
	ld h,c			; $512f
	ld (bc),a		; $5130
	pop hl			; $5131
	or h			; $5132
	ld h,c			; $5133
	ld b,$e1		; $5134
	or h			; $5136
	ld h,c			; $5137
	ld ($22e7),sp		; $5138
	rrca			; $513b
	rst $20			; $513c
	inc hl			; $513d
	ld de,$32e7		; $513e
	ld de,$33e7		; $5141
_label_14_144:
	rrca			; $5144
	rst $20			; $5145
	inc (hl)		; $5146
	ld de,$e3f4		; $5147
	ld (hl),e		; $514a
	pop hl			; $514b
	or h			; $514c
	ld h,c			; $514d
	ld bc,$b4e1		; $514e
	ld h,c			; $5151
	dec b			; $5152
	pop hl			; $5153
	or h			; $5154
	ld h,c			; $5155
	inc bc			; $5156
	pop hl			; $5157
	or h			; $5158
	ld h,c			; $5159
	rlca			; $515a
	rst_addAToHl			; $515b
	ld b,$e3		; $515c
	ld h,a			; $515e
_label_14_145:
	sub c			; $515f
	ret nz			; $5160
	rst $8			; $5161
	nop			; $5162
	ld ($ff00+$dc),a	; $5163
	ld h,c			; $5165
.DB $e3				; $5166
	ld (hl),e		; $5167
	pop hl			; $5168
	or h			; $5169
	ld h,c			; $516a
	inc b			; $516b
	pop hl			; $516c
	or h			; $516d
	ld h,c			; $516e
_label_14_146:
	nop			; $516f
	pop hl			; $5170
	or h			; $5171
	ld h,c			; $5172
	ld (bc),a		; $5173
	pop hl			; $5174
	or h			; $5175
	ld h,c			; $5176
	ld b,$e1		; $5177
	or h			; $5179
	ld h,c			; $517a
	ld ($2de4),sp		; $517b
	sub c			; $517e
	xor e			; $517f
	call z,$a000		; $5180
.DB $e3				; $5183
	ld c,l			; $5184
.DB $e4				; $5185
	rst $38			; $5186
	ld ($ff00+c),a		; $5187
	push af			; $5188
	cp e			; $5189
_label_14_147:
	add sp,-$0f		; $518a
	or c			; $518c
	ld b,b			; $518d
	cp h			; $518e
	nop			; $518f

script_14_5190:
	adc (hl)		; $5190
	ld (hl),a		; $5191
	ld bc,$508b		; $5192
	rst $20			; $5195
	ld d,$a2		; $5196
	rst $20			; $5198
	rla			; $5199
	and d			; $519a
	rst $20			; $519b
	jr -$5e			; $519c
	rst $20			; $519e
	ld h,$a2		; $519f
	rst $20			; $51a1
	daa			; $51a2
_label_14_148:
	and d			; $51a3
_label_14_149:
	rst $20			; $51a4
	jr z,-$5e		; $51a5
	ld ($ff00+$eb),a	; $51a7
	ld h,c			; $51a9
	rst_addAToHl			; $51aa
	ld d,b			; $51ab
	sbc b			; $51ac
	jr c,_label_14_150	; $51ad
	adc (hl)		; $51af
	ld (hl),a		; $51b0
	nop			; $51b1
	adc c			; $51b2
_label_14_150:
	jr _label_14_144		; $51b3
	ld (bc),a		; $51b5
	adc h			; $51b6
	ld d,$d7		; $51b7
	ld b,$89		; $51b9
	stop			; $51bb
	adc a			; $51bc
	ld bc,objectDeleteRelatedObj1AsStaticObject		; $51bd
	sub c			; $51c0
	pop de			; $51c1
	rst $8			; $51c2
	.db $01		; $51c3
	.db $00		; $51c4

script_14_51c5:
	.db $fb		; $51c5
	adc e			; $51c6
	jr z,_label_14_145	; $51c7
	stop			; $51c9
	adc h			; $51ca
	jr nz,_label_14_149	; $51cb
	ld b,$96		; $51cd
	ld ($408c),sp		; $51cf
	rst_addAToHl			; $51d2
	ld b,$96		; $51d3
	stop			; $51d5
	adc h			; $51d6
	inc d			; $51d7
	or $98			; $51d8
	dec b			; $51da
	nop			; $51db
	adc (hl)		; $51dc
	ld c,a			; $51dd
	nop			; $51de
	or $96			; $51df
	jr _label_14_146		; $51e1
	stop			; $51e3
	di			; $51e4
	sub (hl)		; $51e5
	stop			; $51e6
	adc h			; $51e7
	ld e,b			; $51e8
	cp (hl)			; $51e9
_label_14_151:
	adc (hl)		; $51ea
	ld e,d			; $51eb
	nop			; $51ec
	or (hl)			; $51ed
	ldi (hl),a		; $51ee
	nop			; $51ef

script_14_51f0:
	ld hl,sp-$75		; $51f0
	jr z,_label_14_147	; $51f2
	stop			; $51f4
_label_14_152:
	adc h			; $51f5
	ld a,(bc)		; $51f6
	sub c			; $51f7
	ret nz			; $51f8
	rst $8			; $51f9
	ld bc,$1b8c		; $51fa
	rst_addAToHl			; $51fd
	ld b,$91		; $51fe
	ret nz			; $5200
	rst $8			; $5201
	ld (bc),a		; $5202
	rst_addAToHl			; $5203
	ld l,(hl)		; $5204
	sub c			; $5205
	rst_addDoubleIndex			; $5206
	rst $8			; $5207
	.db $01		; $5208
	.db $00		; $5209

script_14_520a:
	.db $8b		; $520a
	jr z,_label_14_148	; $520b
	nop			; $520d
	adc h			; $520e
	add b			; $520f
	rst_addAToHl			; $5210
	ld b,$96		; $5211
	jr _label_14_151		; $5213
	ret nz			; $5215
	rst $8			; $5216
	ld (bc),a		; $5217
	adc a			; $5218
	rlca			; $5219
	nop			; $521a

script_14_521b:
	push de			; $521b
	rrca			; $521c
	ret nc			; $521d
	nop			; $521e
	ld a,($148b)		; $521f
	xor $3c			; $5222
	di			; $5224
	adc (hl)		; $5225
	ld a,b			; $5226
	add b			; $5227
	pop hl			; $5228
.DB $d3				; $5229
	ld h,d			; $522a
	ld e,$f7		; $522b
	ret nz			; $522d
	ld a,(bc)		; $522e
	ld e,a			; $522f
	rst_addAToHl			; $5230
	ld b,$8e		; $5231
	ld a,b			; $5233
	ld bc,$288b		; $5234
	xor $13			; $5237
	adc (hl)		; $5239
	ld a,b			; $523a
	add b			; $523b
	di			; $523c
	adc (hl)		; $523d
	ld a,b			; $523e
	ld bc,$b6f8		; $523f
	jr nc,_label_14_152	; $5242
	ld b,b			; $5244
	nop			; $5245

script_14_5246:
	cp l			; $5246
	sub c			; $5247
	xor e			; $5248
	call z,$f601		; $5249
.DB $e4				; $524c
	dec l			; $524d
	or $98			; $524e
	dec b			; $5250
	inc b			; $5251
	or $91			; $5252
	ret nz			; $5254
	rst $8			; $5255
	ld bc,$3ed7		; $5256
	sbc b			; $5259
	dec b			; $525a
	dec b			; $525b
	ldh (<hFF8E),a	; $525c
	inc c			; $525e
	or $91			; $525f
	ret nz			; $5261
	rst $8			; $5262
	ld (bc),a		; $5263
	rst_addAToHl			; $5264
	add b			; $5265
.DB $e3				; $5266
	ret z			; $5267
	rst $30			; $5268
	sub c			; $5269
	ret nz			; $526a
	rst $8			; $526b
	inc bc			; $526c
	rst_addAToHl			; $526d
	ld (bc),a		; $526e
.DB $e4				; $526f
	dec l			; $5270
	cp (hl)			; $5271
	jp nc,$bdf6		; $5272
	ldh (<hFF8E),a	; $5275
	inc c			; $5277
	push af			; $5278
.DB $e3				; $5279
	ret z			; $527a
	push af			; $527b
.DB $e3				; $527c
	ret z			; $527d
	push af			; $527e
.DB $e3				; $527f
	ret z			; $5280
	or $91			; $5281
	ret nz			; $5283
	rst $8			; $5284
	inc b			; $5285
	ld ($ff00+$c7),a	; $5286
	ld h,e			; $5288
	push de			; $5289
	ld bc,$00d0		; $528a
	or $e1			; $528d
	pop de			; $528f
	ld h,e			; $5290
	nop			; $5291
.DB $e4				; $5292
	add hl,sp		; $5293
	sub c			; $5294
	ret nz			; $5295
	rst $8			; $5296
	dec b			; $5297
	rst_addAToHl			; $5298
	ld b,d			; $5299
	sbc b			; $529a
	dec b			; $529b
	ld b,$91		; $529c
	ret nz			; $529e
	rst $8			; $529f
	ld b,$d7		; $52a0
	inc h			; $52a2
	sub c			; $52a3
	ret nz			; $52a4
	rst $8			; $52a5
	rlca			; $52a6
	push af			; $52a7
	pop hl			; $52a8
	pop de			; $52a9
	ld h,e			; $52aa
	inc bc			; $52ab
	rst_addAToHl			; $52ac
	ld b,(hl)		; $52ad
	sbc b			; $52ae
	dec b			; $52af
	rlca			; $52b0
	ld ($ff00+$d8),a	; $52b1
	ld h,e			; $52b3
	sub c			; $52b4
	ret nz			; $52b5
	rst $8			; $52b6
	ld ($91f7),sp		; $52b7
	ret nz			; $52ba
	rst $8			; $52bb
	add hl,bc		; $52bc
	pop hl			; $52bd
	pop de			; $52be
	ld h,e			; $52bf
	ld (bc),a		; $52c0
	rst_addAToHl			; $52c1
	ldd (hl),a		; $52c2
	sbc b			; $52c3
	dec b			; $52c4
	ld ($c091),sp		; $52c5
	rst $8			; $52c8
	ld a,(bc)		; $52c9
	or $98			; $52ca
	dec b			; $52cc
	add hl,bc		; $52cd
	di			; $52ce
	pop hl			; $52cf
	pop bc			; $52d0
	ld h,e			; $52d1
	dec h			; $52d2
	or $98			; $52d3
	dec b			; $52d5
	ld a,(bc)		; $52d6
	or $91			; $52d7
	ret nz			; $52d9
	rst $8			; $52da
	dec bc			; $52db
	rst_addAToHl			; $52dc
	ld b,b			; $52dd
.DB $e4				; $52de
	rst $38			; $52df
	or (hl)			; $52e0
	inc hl			; $52e1
	sub c			; $52e2
	xor e			; $52e3
	call z,$be00		; $52e4
	nop			; $52e7


gettingRodOfSeasons_body:
	setcoords $40 $50
	setcollisionradii $02 $04
	checkcollidedwithlink_onground
	disableinput
	asm15 spawnRodOfSeasonsSparkles
	setcounter1 $82

	playsound SND_FADEOUT
	asm15 fadeoutToWhite
	delay 5

	playsound SND_FADEOUT
	asm15 fadeoutToWhite
	delay 5

	playsound SND_FADEOUT
	asm15 fadeoutToWhite
	checkpalettefadedone
	delay 5

	spawninteraction INTERACID_GET_ROD_OF_SEASONS $02 $38 $50
	asm15 fadeinFromWhiteWithDelay $04
	checkpalettefadedone
	checkflagset $00 $cceb
	asm15 forceLinksDirection DIR_DOWN
	delay $07

	showtext TX_0810
	setmusic SNDCTRL_MEDIUM_FADEOUT
	delay $09

	setmusic $ff
	enableinput
	scriptend
