OBJDIR = ../lib/core
BUILDDIR = ../bin

rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))

CSRC = $(call rwildcard,./,*.c)
SSRC = $(call rwildcard,./,*.s)
MIKSRC = $(call rwildcard,./,*.mik)
OBJS = $(patsubst %.c, $(OBJDIR)/%.c.o, $(CSRC))
OBJS += $(patsubst %.s, $(OBJDIR)/%.s.o, $(SSRC))
OBJS += $(patsubst %.mik, $(OBJDIR)/%.mik.o, $(MIKSRC))

INCLUDES = -I../driver/STM32L1xx_HAL_Driver/Inc \
			-I../driver/STM32L1xx_HAL_Driver/Inc/Legacy \
			-I../driver/CMSIS/Device/ST/STM32L1xx/Include \
			-I../driver/CMSIS/Include \
			-I../driver/CMSIS/Device/ST/STM32L1xx/Include \
			-I../driver/CMSIS/Include \
			-Iinclude

CFLAGS = -g -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32L152xE -c  -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage --specs=nano.specs -mfloat-abi=soft -mthumb $(INCLUDES)
LDFLAGS = -mcpu=cortex-m3 -TSTM32L152RETX_FLASH.ld --specs=nosys.specs -Wl,--gc-sections -static --specs=nano.specs -mfloat-abi=soft -mthumb $(BUILDDIR)/driver.o

CC = arm-none-eabi-gcc
LD = arm-none-eabi-gcc
AS = arm-none-eabi-gcc
MIK = mic
OBJCOPY = arm-none-eabi-objcopy
GDB = arm-none-eabi-gdb

NUCLEO_DRIVE = /dev/sda

app.bin: $(OBJS)
	@mkdir -p $(BUILDDIR)
	$(LD) $(LDFLAGS) -o $(BUILDDIR)/app.elf $(OBJS)
	$(OBJCOPY)  -O binary $(BUILDDIR)/app.elf $(BUILDDIR)/app.bin

upload: app.bin
	@echo "Uploading to NUCLEO..."
	@mkdir -p nucleo_mnt
	sudo mount $(NUCLEO_DRIVE) nucleo_mnt
	sudo cp $(BUILDDIR)/app.bin nucleo_mnt/
	sleep 5
	sudo umount nucleo_mnt

debug_util:
	screen -dmS st_util st-util

debug: debug_util
	cd ../bin; $(GDB) app.elf -ex "target remote 127.0.0.1:4242" -ex "tui enable"  -ex "layout src" -ex "layout regs" -ex "hb *main" -ex "continue"

clean:
	rm -rf $(BUILDDIR) $(OBJDIR)

$(OBJDIR)/%.c.o: %.c
	@echo "CC $^ -> $@"
	@mkdir -p $(@D)
	@$(CC) $(CFLAGS) -o $@ $<

$(OBJDIR)/%.s.o: %.s
	@echo "AS $^ -> $@"
	@mkdir -p $(@D)
	@$(AS) $(CFLAGS) -o $@ $<

$(OBJDIR)/%.mik.o: %.mik
	@echo "MIK $^ -> $@"
	@mkdir -p $(@D)
	@$(MIK) -o $@.c -i $<
	@$(CC) $(CFLAGS) -o $@ $@.c
