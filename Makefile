app.bin: build_driver
	make -C core app.bin

upload: build_driver
	make -C core upload

debug_util:
	make -C core debug_util

debug:
	make -C core debug

clean:
	make -C core clean
	make -C driver clean

build_driver:
	make -C driver

toolchain:
	wget https://developer.arm.com/-/media/Files/downloads/gnu-rm/10.3-2021.10/gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2 -O toolchain.tar.bz2
	tar xf toolchain.tar.bz2

	git clone https://github.com/MikOS-ProgrammingLanguage/mic-mip
	cd mic-mip; bash build.sh .; sudo bash build.sh install
	sudo mic -install