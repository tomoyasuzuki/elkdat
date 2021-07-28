#!/bin/sh -x
mkdir -p $1
cd $1
touch Makefile
touch "$1.c"
touch "./run.sh"
echo ".PHONY: all clean install login

obj-m := $1.o

all:
	make -C ../../../output M=\$(PWD) modules

clean:
	make -C ../../../linux M=\$(PWD) clean

install:
	cp *.ko ../../../elkdat; cd ../../../elkdat; vagrant rsync

login:
	cd ../../../elkdat; vagrant ssh" >> Makefile

echo "#include <linux/module.h>

MODULE_LICENSE(\"GPL v2\");
MODULE_AUTHOR(\"Tomoya Suzuki <oshibori@gmail.com>\");

static int mymodule_init(void) {
}

static void mymodule_exit(void) {
}

module_init(mymodule_init);
module_exit(mymodule_exit);" >> $1.c

echo "#!/bin/sh -x

make && make install && make login" >> "run.sh"
