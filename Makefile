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