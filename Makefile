all: ; ./jflex-1.6/jflex/bin/jflex tme1.lex; ./byacc -J tme1.y; javac *.java;

clean: 
	rm *.class *.java
