Proiect:
	bison -dv proiect.y
	flex -oproiect.yy.c proiect.l
	gcc -o proiect.exe proiect.yy.c proiect.tab.c -lfl -lm -ly
	./proiect.exe

Fisier:
	bison -dv proiect.y
	flex -oproiect.yy.c proiect.l
	gcc -o proiect.exe proiect.yy.c proiect.tab.c -lfl -lm -ly
	./proiect.exe input.txt output.txt

Clean:
	rm proiect.exe
	rm proiect.output
	rm proiect.tab.c
	rm proiect.tab.h
	rm proiect.yy.c