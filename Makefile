objs = types.o tester.o
exec = a4x86

all: $(exec)

$(exec): $(objs)
	cc	-o $(exec) $(objs)
%.o: %.s
	as	-o $@ $<
%.o: %.c
	cc	-c $@ $<
clean:
	rm	-rf $(objs) $(exec)
