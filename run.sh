flex cal.l
yacc cal.y
cc y.tab.c -ly -ll -lm
./a.out < input.txt
