export TOOLCHAIN_VERSION=10.3-2021.10
make CC=$(pwd)/gcc-arm-none-eabi-$TOOLCHAIN_VERSION/bin/arm-none-eabi-gcc AS=$(pwd)/gcc-arm-none-eabi-$TOOLCHAIN_VERSION/bin/arm-none-eabi-gcc LD=$(pwd)/gcc-arm-none-eabi-$TOOLCHAIN_VERSION/bin/arm-none-eabi-gcc OBJCOPY=$(pwd)/gcc-arm-none-eabi-$TOOLCHAIN_VERSION/bin/arm-none-eabi-objcopy