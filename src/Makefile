#
# Copyright (c) 2018 Luc HONDAREYTE
# All rights reserved.
#

include config.mk

CC		:= avr-gcc
OBJCOPY		:= avr-objcopy
CFLAGS		+=-Os -D F_CPU=$(HZ)
CFLAGS		+=-g -mmcu=$(MCU) -Wall -Wstrict-prototypes

HEADERS         += $(wildcard *.h)
SOURCES         += $(wildcard *.c)
ASMFLAGS	:=-Os -mmcu=$(MCU) -x assembler-with-cpp -gstabs
ASMFLAGS	+=-I /usr/local/avr/include

all: top-octave.o asm-sources asm-objs out-files hex-files

asm-sources:
	@for i in 451 426 402 379 358 338 319 301 284 268 253 239; do  \
		./genedivider.pl $$i > $$i.s ; done
asm-objs:
	@for i in 451 426 402 379 358 338 319 301 284 268 253 239; do  \
	   $(CC) $(ASMFLAGS) -c $$i.s -o $$i.o ; done
hex-files: 
	@printf "Generating $(FIRMWARE).hex..."
	@for i in 451 426 402 379 358 338 319 301 284 268 253 239; do  \
		$(OBJCOPY) -R .eeprom -O ihex $$i.out  \
		$$i.hex ; done
	@echo "done."

out-files: 
	@printf "Linking $(FIRMWARE)..."
	@for i in 451 426 402 379 358 338 319 301 284 268 253 239; do  \
		$(CC) $(CFLAGS) -o $$i.out \
		-Wl,-Map,$$i.map top-octave.o $$i.o  ; done
	@echo "done."

top-octave.c.o: 
	@printf "Compiling  $<..."
	@$(CC) $(CFLAGS) -c $< -o $@
	@echo "done."

asm: all
	@printf "Generating assembler source file..."
	@for i in 451 426 402 379 358 338 319 301 284 268 253 239; do  \
		avr-objdump -D -S $$i.out > $$i.asm ; done
	@echo "done."

bin: all
	@printf "Generating $(FIRMWARE).bin ..."
	@for i in 451 426 402 379 358 338 319 301 284 268 253 239; do  \
		$(OBJCOPY) -R .eeprom -O binary $$i.out  \
		$$i.bin ; done
	@echo "done."
#
# Configuration du programmateur ISP
LOADER=avrdude

ISP	:=-c usbasp 

LOADER	:=$(LOADER) -p $(MCU) $(ISP)
LOAD	:=$(LOADER) -i 5 -U flash:w:$(FIRMWARE).hex
DUMP	:=$(LOADER) -i 5 -U flash:r:$(FIRMWARE).hex:i
VERIFY	:=$(LOADER) -i 5 -U flash:v:$(FIRMWARE).hex
ERASE	:=$(LOADER) -i 5 -e
RFUSE	:=$(LOADER) -U lfuse:r:low.txt:b -U hfuse:r:high.txt:b
WFUSE	:=$(LOADER) -U lfuse:w:$(LFUSE):m -U hfuse:w:$(HFUSE):m

load:
	@printf "Loading firmware..."
	@$(LOAD) > /dev/null 2>&1
	@echo "done."
dump:
	@printf "Reading $(MCU) device..."
	@$(DUMP) > /dev/null 2>&1
	@echo "done."
verify:
	@printf "Verify $(MCU) device..."
	@$(VERIFY) > /dev/null 2>&1
	$(VERIFY) 
	@echo "done."
erase:
	@printf "Erasing $(MCU) device..."
	@$(ERASE) > /dev/null 2>&1
	@echo "done."
rfuse:
	@printf "Reading fuse..."
	@$(RFUSE) > /dev/null 2>&1
	@echo "done."
wfuse:
	@printf "Writing fuse..."
	@$(WFUSE) > /dev/null 2>&1
	@echo "done."
#
# Nettoyage, Archivage, etc.
clean :
	@printf "Cleaning source tree..."
	@rm -f *.map *.bin *~ *.out *.gch *.o \
		low.txt high.txt $(FIRMWARE) $(FIRMWARE).asm *hex *.s
	@echo "done."

archive: 
	@tar cvzf ../../$(FIRMWARE).tgz ../../$(FIRMWARE)
#EOF
