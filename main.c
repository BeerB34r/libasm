#include <errno.h>
#include <stdio.h>
#include <string.h>
#include "libasm.h"

#define ok_ko(b) (b ? OK : KO)
#define OK "\033[1;32m[OK]\033[0m"
#define KO "\033[1;31m[KO]\033[0m"

#define test(name, case, pred) do {\
	printf("%s:%s %s\n", name, #case, #pred);\
	int ft_write_rv = case;\
	printf("%s: %i\n", ok_ko(ft_write_rv pred), ft_write_rv);\
} while (0)

int	main(int ac, char **av) {
	printf("Testing asm functions:\n");
	printf("-----ft_write()------\n");
	test("id", ft_write(1, "Hello, World!\n", 15), == 15);
	test("error", ft_write(42, "Hello, World!\n", 15), < 0);
	printf("strerror(errno) => %s\n", strerror(errno));
	printf("-----finished-----\n");
	return 0;
	(void)ac;
	(void)av;
}
