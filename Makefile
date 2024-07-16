#objs = types.o tester.o strlen.o strncmp.o memset.o printf.o
objs = printf.o

exec = a4x86

all: $(exec)

$(exec): $(objs)
	ld	-o $(exec) $(objs)
%.o: %.s
	as	-o $@ $<
%.o: %.c
	cc	-c $@ $<
clean:
	rm	-rf $(objs) $(exec)

