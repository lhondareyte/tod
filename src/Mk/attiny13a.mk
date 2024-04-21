#
# Copyright (c) 2018 Luc HONDAREYTE
# All rights reserved.
#
HZ	= 8000000 # To avoid warning only
LFUSE	= 0x78
HFUSE	= 0xff

MODEL        = ATTINY13A
LOAD         = minipro -P -w $(FIRMWARE).bin -c code -p $(MODEL)
RFUSE        = minipro -r fuses.TXT -c config -p $(MODEL)
WFUSE        = minipro -w fuses.txt -c config -p $(MODEL)
DUMP         = minipro -S -r $(FIRMWARE).bin -c code -p $(MODEL)
OBJCOPY_OPTS = --gap-fill=0xff --pad-to=0x400
