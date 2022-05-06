OBJDIR = ../lib/driver
BUILDDIR = ../bin

rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))

CSRC = $(call rwildcard,./,*.c)
SSRC = $(call rwildcard,./,*.s)
MIKSRC = $(call rwildcard,./,*.mik)
OBJS = $(patsubst %.c, $(OBJDIR)/%.c.o, $(CSRC))
OBJS += $(patsubst %.s, $(OBJDIR)/%.s.o, $(SSRC))
OBJS += $(patsubst %.mik, $(OBJDIR)/%.mik.o, $(MIKSRC))

INCLUDES = -I./STM32L1xx_HAL_Driver/Inc \
			-I./STM32L1xx_HAL_Driver/Inc/Legacy \
			-I./CMSIS/Device/ST/STM32L1xx/Include \
			-I./CMSIS/Include \
			-I./CMSIS/Device/ST/STM32L1xx/Include \
			-I./CMSIS/Include

CFLAGS = -g -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32L152xE -c  -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage --specs=nano.specs -mfloat-abi=soft -mthumb $(INCLUDES)
LDFLAGS = -r

CC = arm-none-eabi-gcc
LD = arm-none-eabi-gcc
AS = arm-none-eabi-gcc
MIK = mic
OBJCOPY = arm-none-eabi-objcopy
GDB = arm-none-eabi-gdb

NUCLEO_DRIVE = /dev/sda

driver.o: $(OBJS)
	@mkdir -p $(BUILDDIR)
	$(LD) $(LDFLAGS) -o $(BUILDDIR)/$@ $(OBJS)

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
