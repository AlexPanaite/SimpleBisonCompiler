Arbore:
	bison -dv arbore.y
	flex -oarbore.yy.c arbore.l
	gcc -o arbore.exe arbore.c arbore.yy.c arbore.tab.c -lfl -lm -ly
	./arbore.exe

FisierA:
	bison -dv arbore.y
	flex -oarbore.yy.c arbore.l
	gcc -w -o arbore.exe arbore.c arbore.yy.c arbore.tab.c -lfl -lm -ly
	./arbore.exe input.txt output.txt

CleanA:
	rm arbore.exe
	rm arbore.output
	rm arbore.tab.c
	rm arbore.tab.h
	rm arbore.yy.c