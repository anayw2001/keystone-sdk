CC = riscv64-unknown-linux-gnu-gcc
CFLAGS = -Wall -Werror
LINK = riscv64-unknown-linux-gnu-ld
AS = riscv64-unknown-linux-gnu-as
BASEDIR = ../../../
LINKFLAGS = -static -L$(BASEDIR)
INCLUDE_DIR=$(BASEDIR)/include/
SCRIPTS_DIR=$(BASEDIR)/scripts/
APP_LDS = $(SCRIPTS_DIR)app.lds

APP_BINS = $(patsubst %,%.eapp_riscv,$(APPS))

all: $(APP_BINS)

%.o: %.c
	$(CC) $(CFLAGS) -I$(INCLUDE_DIR) -c $<

%.eapp_riscv: %.o $(APP_LDS)
	$(LINK) $(LINKFLAGS) -o $@ $< -T $(APP_LDS) -leapp_utils
	chmod -x $@
	$(SCRIPTS_DIR)parse_elf.sh $@ $*_entry

clean:
	rm -f *.o *.eapp_riscv $(patsubst %,%_entry.h,$(APPS)) $(EXTRA_CLEAN)
