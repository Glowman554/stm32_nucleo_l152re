app.bin:
	make -C src app.bin

upload:
	make -C src upload

debug_util:
	make -C src debug_util

debug:
	make -C src debug

clean:
	make -C src clean