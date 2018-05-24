#include <avr/io.h>

#define C_LO		478
#define C_SHARP		451
#define D_LO		426
#define D_SHARP		402
#define E_LO		379
#define F_LO		358
#define F_SHARP		338
#define G_LO		319
#define G_SHARP		301
#define A_LO		284
#define A_SHARP		268
#define B_LO		253
#define C_HI		239

#define C_LO_MID	239
#define C_SHARP_MID	226
#define D_LO_MID	213
#define D_SHARP_MID	201
#define E_LO_MID	190
#define F_LO_MID	179
#define F_SHARP_MID	169
#define G_LO_MID	160
#define G_SHARP_MID	151
#define A_LO_MID	142
#define A_SHARP_MID	134
#define B_LO_MID	127
#define C_HI_MID	120

.extern	c_lo
.extern	c_sharp
.extern	d_lo
.extern	d_sharp
.extern	e_lo
.extern	f_lo
.extern	f_sharp
.extern	g_lo
.extern	g_sharp
.extern	a_lo
.extern	a_sharp
.extern	b_lo
.extern	c_hi
