.define U 1
.define R 2
.define D 3
.define L 4
.define TL 5
.define TR 6
.define BR 7
.define BL 8
.define TLI 9
.define TRI 10
.define BRI 11
.define BLI 12

railsData:
	.db 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
	.db 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
	.db 0  0  0  0  TL TR 0  0  0  0  0  0  0  0  0  0
	.db 0  0  0  0  BL BR 0  0  0  0  0  0  0  0  0  0
	.db 0  0  0  0 TLI D  D TRI TL U  TR 0  0  0  0  0
	.db 0  0  0  0  R  0  0  L  L  0  R  0  0  0  0  0
	.db 0  0  0  0 BLI U  U BRI BL D  BR 0  0  0  0  0
	.db 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
	.db 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
	.db 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
	.db 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0

.define RAIL_U U
.define RAIL_R R
.define RAIL_D D
.define RAIL_L L
.define RAIL_TL TL
.define RAIL_TR TR
.define RAIL_BR BR
.define RAIL_BL BL
.define RAIL_TLI TLI
.define RAIL_TRI TRI
.define RAIL_BRI BRI
.define RAIL_BLI BLI

.undefine U
.undefine R
.undefine D
.undefine L
.undefine TL
.undefine TR
.undefine BR
.undefine BL
.undefine TLI
.undefine TRI
.undefine BRI
.undefine BLI
