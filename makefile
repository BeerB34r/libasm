#project structure
include srcfiles.mk
SRCDIR			= src/
INCDIR			= mac/
DEPDIR			= dep/
BINDIR			= bin/
DEP				= $(addprefix $(DEPDIR),$(SRC:.s=.d) $(BSRC:.s=.d))
BIN				= $(addprefix $(BINDIR),$(SRC:.s=.o))
BBIN			= $(addprefix $(BINDIR),$(BSRC:.s=.o))

# utilities
ASM				= nasm
ASMFLAGS		= -f elf64 -Wall -Werror $(addprefix -i,$(INCDIR)) -g
LD				= ld
LDFLAGS			= #-s
RM				= rm -fr
# dependency management
DEPFLAG			= -M -MT "$@ $(BINDIR)$(notdir $(basename $<)).o"

# makefile management
VPATH=$(SRCDIR) $(INCDIR)
MAKEFLAGS		+= -r --no-print-directory -j
.EXTRA_PREREQS	= $(firstword $(MAKEFILE_LIST))
.DEFAULT_GOAL	:= all
.PRECIOUS		: $(BINDIR) $(DEPDIR)
.PHONY			: clean fclean re all test bonus
-include $(DEP)

NAME			= libasm.a

test:	test_bin
	printf "Hello, World!\n" | ./$< `shuf -i 0-9`

test_bin:	main.c bonus
	$(CC) -Wno-format -g -o $@ $< $(NAME)

all	: $(NAME)
$(NAME)	: $(BIN)
	$(AR) $(ARFLAGS) -o $@ $^

bonus	: $(NAME) $(BBIN)
	$(AR) $(ARFLAGS) -o $(NAME) $^

$(BINDIR)%.o	: %.s | $(BINDIR)
	$(ASM) $(ASMFLAGS) -o $@ $<

$(DEPDIR)%.d	: %.s | $(DEPDIR)
	$(ASM) $(DEPFLAG) $< >$@

%/	:
	@mkdir -p $@

clean	:
	$(RM) $(BINDIR)
fclean	:
	$(RM) $(BINDIR) $(DEPDIR) $(NAME)
re		:
	+$(MAKE) fclean
	+$(MAKE)

