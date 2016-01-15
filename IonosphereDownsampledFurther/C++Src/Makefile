OBJS=parser.o
CC=g++ -std=c++0x
DEBUG = -g
CFLAGS = -Wall -c $(DEBUG)
LFLAGS = -Wall $(DEBUG)

all: parser clean

parser: $(OBJS)
	$(CC) $(LFLAGS) $(OBJS) -o parser

parser.o: parser.cpp
	$(CC) $(CFLAGS) parser.cpp

clean:
	\rm *.o
