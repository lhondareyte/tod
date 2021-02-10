#
# Copyright (c)2018-2020 Luc HONDAREYTE
# All rights reserved.
#

include config.mk

CC       = avr-gcc
OBJCOPY  = avr-objcopy
CFLAGS   = -O0 -D F_CPU=$(HZ)
CFLAGS   += -g -mmcu=$(MCU) -Wall -Wstrict-prototypes

HEADERS  = top-octave.h
SOURCES  = top-octave.c
OBJECTS  = top-octave.o
ASMFLAGS = -Os -mmcu=$(MCU) -x assembler-with-cpp -gstabs
ASMFLAGS += -I /usr/local/avr/include
DIVIDERS = 478 451 426 402 379 358 338 319 301 284 268 253 239

all: top-octave.o asm-sources asm-objs out-files hex-files clean

asm-sources:
	@printf "Generating ASM files ..."
	@for d in $(DIVIDERS);\
               do ./genedivider.pl $$d > $$d.s; done
	@echo "done."
asm-objs:
	@printf "Compiling dividers ..."
	@for d in $(DIVIDERS);\
               do $(CC) $(ASMFLAGS) -c $$d.s -o $$d.o; done
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
               top-octave.o $$d.o; done
	@echo "done."

.c.o: 
	@printf "Compiling  $<..."
	@$(CC) $(CFLAGS) -c $< -o $@
	@echo "done."

asm: all
	@printf "Generating assembler source file..."
	@for d in $(DIVIDERS); \
                do avr-objdump -D -S $$d.out > $$d.asm; done
	@echo "done."

bin: all
	@printf "Generating $(FIRMWARE).bin ..."
	@for d in $(DIVIDERS); \
                do $(OBJCOPY) -R .eeprom -O binary $$d.out $$d.bin; done
	@echo "done."
#
# Configuration du programmateur ISP
LOADER   = avrdude -p $(MCU)
LOADER	+= -c usbasp 
LOAD	 = -i 5 -U flash:w:$(FIRMWARE).hex
DUMP	 = -i 5 -U flash:r:$(FIRMWARE).hex:i
VERIFY	 = -i 5 -U flash:v:$(FIRMWARE).hex
ERASE	 = -i 5 -e
RFUSE	 = -U lfuse:r:low.txt:b -U hfuse:r:high.txt:b
WFUSE	 = -U lfuse:w:$(LFUSE):m -U hfuse:w:$(HFUSE):m

load:
	@printf "Loading firmware..."
	@$(LOADER) $(LOAD) > /dev/null 2>&1
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
rfuse:
	@printf "Reading fuse..."
	@$(LOADER) $(RFUSE) > /dev/null 2>&1
	@echo "done."
wfuse:
	@printf "Writing fuse..."
	@$(LOADER) $(WFUSE) > /dev/null 2>&1
	@echo "done."
#
# Nettoyage, Archivage, etc.
clean :
	@printf "Cleaning build files..."
	@rm -f *.map \
		*~ \
		*.out \
		*.gch \
		*.o \
		low.txt \
		high.txt \
		$(FIRMWARE) \
		*.asm \
		*.s
	@echo "done."

mrproper: clean
	@printf "Cleaning source tree..."
	@rm -f *.bin *.hex
	@echo "done."
#EOF
