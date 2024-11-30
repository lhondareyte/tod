#
# Copyright (c)2018-2024 Luc HONDAREYTE
# All rights reserved.
#

CC       = avr-gcc
OBJCOPY  = avr-objcopy
CFLAGS   = -O0 -D F_CPU=$(HZ)
CFLAGS   += -g -mmcu=$(MCU) -Wall -Wstrict-prototypes

HEADERS  = top-octave.h
SOURCES  = top-octave.c
OBJECTS  = top-octave.o setextclk.o
ASMFLAGS = -Os -mmcu=$(MCU) -x assembler-with-cpp 
ASMFLAGS += -I /usr/local/avr/include
DIVIDERS = 478 451 426 402 379 358 338 319 301 284 268 253 239

all: ${OBJECTS} asm-sources asm-objs out-files hex-files bin-files 

include config.mk

asm-sources:
	@printf "Generating ASM files ..."
	@for d in $(DIVIDERS);\
               do ./genedivider.pl $$d > $$d.S; done
	@echo "done."

asm-objs:
	@printf "Compiling dividers ..."
	@for d in $(DIVIDERS);\
               do $(CC) $(ASMFLAGS) -c $$d.S -o $$d.o; done
	@echo "done."

hex-files: 
	@printf "Generating hex files..."
	@for d in $(DIVIDERS);\
               do $(OBJCOPY) -R .eeprom -O ihex $$d.out $$d.hex; done
	@echo "done."

out-files: 
	@printf "Linking dividers ..."
	@for d in $(DIVIDERS);\
               do $(CC) $(CFLAGS) -o $$d.out -Wl,-Map,$(i).map \
               ${OBJECTS} $$d.o; done
	@echo "done."

.c.o: 
	@printf "Compiling  $<..."
	@$(CC) $(CFLAGS) -c $< -o $@
	@echo "done."

.s.o: $(HEADERS) $(ASMSRCS)
	@printf "Compiling  $<..."
	@$(CC) $(ASMFLAGS) -c $< -o $@
	@echo "done."

asm: hex-files
	@printf "Generating assembler source file..."
	@for d in $(DIVIDERS); \
                do avr-objdump -D -S $$d.out > $$d.asm; done
	@echo "done."

bin-files: 
	@printf "Generating bin files..."
	@for d in $(DIVIDERS); \
                do $(OBJCOPY) -R .eeprom -O binary ${OBJCOPY_OPTS} \
                       $$d.out $$d.bin; done
	@echo "done."

load:
	@printf "Loading firmware..."
	$(LOADER) $(LOAD) 
	#@$(LOADER) $(LOAD) > /dev/null 2>&1
	@echo "done."
dump:
	@printf "Reading $(MCU) device..."
	@$(LOADER) $(DUMP) > /dev/null 2>&1
	@echo "done."
verify:
	@printf "Verify $(MCU) device..."
	@$(LOADER) $(VERIFY) > /dev/null 2>&1
	@echo "done."
erase:
	@printf "Erasing $(MCU) device..."
	@$(LOADER) $(ERASE) > /dev/null 2>&1
	@echo "done."

fuses.txt:
	@echo "fuses_lo = $(LFUSE)"  > $@
	@echo "fuses_hi = $(HFUSE)" >> $@
	@echo "lock_byte = 0xff"    >> $@

rfuse:
	@printf "Reading fuse..."
	@$(LOADER) $(RFUSE) > /dev/null 2>&1
	@echo "done."

wfuse: fuses.txt
	@printf "Writing fuse..."
	#@$(LOADER) $(WFUSE) > /dev/null 2>&1
	$(LOADER) $(WFUSE)
	@echo "done."
#
# Nettoyage, Archivage, etc.
clean :
	@printf "Cleaning build files..."
	@rm -f *.map \
		.map \
		*~ \
		*.out \
		*.gch \
		*.o \
		fuses.txt \
		fuses.TXT \
		$(FIRMWARE) \
		low.txt \
		high.txt \
		*.asm \
		*.S
	@echo "done."

mrproper: clean
	@printf "Cleaning source tree..."
	@rm -f *.bin *.hex
	@echo "done."
#EOF
