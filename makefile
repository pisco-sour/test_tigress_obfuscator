#
# Playing around with Tigress
#

CFLAGS=-Wall -Wextra -Wno-unknown-pragmas -Wno-format-security

hello_world_obf: clean
	mkdir -p build
	CILLY_DONT_LINK_AFTER_MERGE=1 cilly --merge $(CFLAGS) -c src/util.c -o build/util.o
	CILLY_DONT_LINK_AFTER_MERGE=1 cilly --merge $(CFLAGS) -c src/main.c -o build/main.o
	CILLY_DONT_LINK_AFTER_MERGE=1 cilly --merge $(CFLAGS) --keepmerged build/util.o build/main.o -o build/$@
	CILLY_DONT_LINK_AFTER_MERGE=1 tigress --Transform=InitOpaque --Functions=main \
            --Transform=UpdateOpaque --Functions=\* \
            --Transform=AddOpaque --Functions=\* \
            --Transform=EncodeLiterals --Functions=\* \
            --Transform=Virtualize --Functions=\* --VirtualizeDispatch=ifnest \
            --Transform=CleanUp --CleanUpKinds=annotations \
            $(CFLAGS) \
            --out=build/all_files.c build/$@_comb.c
	gcc $(CFLAGS) build/all_files.c -o build/$@


hello_world_normal: clean
	mkdir -p build
	gcc -c src/util.c -o build/util.o
	gcc -c src/main.c -o build/main.o
	gcc -o build/hello_world build/util.o build/main.o


clean:
	rm -rf build



