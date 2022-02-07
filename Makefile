# arm-none-eabi-gcc "../Core/Src/stm32l1xx_hal_msp.c" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32L152xE -c -I../Core/Inc -I../Drivers/STM32L1xx_HAL_Driver/Inc -I../Drivers/STM32L1xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32L1xx/Include -I../Drivers/CMSIS/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"Core/Src/stm32l1xx_hal_msp.d" -MT"Core/Src/stm32l1xx_hal_msp.o" --specs=nano.specs -mfloat-abi=soft -mthumb -o "Core/Src/stm32l1xx_hal_msp.o"
# arm-none-eabi-gcc -o "PARTY TIME.elf" @"objects.list" $(USER_OBJS) $(LIBS) -mcpu=cortex-m3 -T"/home/janick/Development/STM32CubeIDE/workspace_1.8.0/PARTY TIME/STM32L152RETX_FLASH.ld" --specs=nosys.specs -Wl,-Map="PARTY TIME.map" -Wl,--gc-sections -static --specs=nano.specs -mfloat-abi=soft -mthumb -Wl,--start-group -lc -lm -Wl,--end-group

OBJDIR = lib
BUILDDIR = bin

rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))

CSRC = $(call rwildcard,./,*.c)
SSRC = $(call rwildcard,./,*.s)
OBJS = $(patsubst %.c, $(OBJDIR)/%.o, $(CSRC))
OBJS += $(patsubst %.s, $(OBJDIR)/%.o, $(SSRC))

CFLAGS = -g -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32L152xE -c -I./core/include -I./Drivers/STM32L1xx_HAL_Driver/Inc -I./Drivers/STM32L1xx_HAL_Driver/Inc/Legacy -I./Drivers/CMSIS/Device/ST/STM32L1xx/Include -I./Drivers/CMSIS/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP --specs=nano.specs -mfloat-abi=soft -mthumb
LDFLAGS = -mcpu=cortex-m3 -TSTM32L152RETX_FLASH.ld --specs=nosys.specs -Wl,--gc-sections -static --specs=nano.specs -mfloat-abi=soft -mthumb

CC = arm-none-eabi-gcc
LD = arm-none-eabi-gcc
AS = arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy
GDB = arm-none-eabi-gdb

NUCLEO_DRIVE = /dev/sdf

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
	cd bin; $(GDB) app.elf -ex "target remote 127.0.0.1:4242" -ex "tui enable"  -ex "layout src" -ex "layout regs" -ex "hb *main" -ex "continue"

clean:
	rm -rf $(BUILDDIR) $(OBJDIR)

$(OBJDIR)/%.o: %.c
	@echo "CC $^ -> $@"
	@mkdir -p $(@D)
	@$(CC) $(CFLAGS) -o $@ $<

$(OBJDIR)/%.o: %.s
	@echo "AS $^ -> $@"
	@mkdir -p $(@D)
	@$(AS) $(CFLAGS) -o $@ $<
