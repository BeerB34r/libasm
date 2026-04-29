#include <stdbool.h>
#include <unistd.h>
#include <errno.h>
#include <stdio.h>
#include <string.h>
#include "libasm.h"

#define ok_ko(b) (b ? OK : KO)
#define OK "\033[1;32m[OK]\033[0m"
#define KO "\033[1;31m[KO]\033[0m"

#define test(name, case, pred) do {						\
	printf("%s: %s %s\n", name, #case, #pred);			\
	int test_rv = case;									\
	printf("%s: %i\n", ok_ko(test_rv pred), test_rv);	\
	test_failed |= !(test_rv pred);						\
} while (0)

int	main(int ac, char **av) {
	bool	test_failed = false;
	char	buf[256];
	printf("Testing asm functions:\n");

	{	// ft_write()
		printf("-----ft_write()------\n");
		test("id", ft_write(STDOUT_FILENO, "Hello, World!\n", 14), == 14);
		test("error", ft_write(42, "Hello, World!\n", 14), < 0);
		printf("strerror(errno) => %s\n", strerror(errno));
	}
	{ // ft_read()
		printf("\n-----ft_read()-------\n");
		test("id", ft_read(STDIN_FILENO, buf, 256), == 14);
		printf("buf => \"%.*s\"\n", 14, buf);
		test("error", ft_read(42, buf, 256), < 0);
		printf("buf => \"%.*s\"\n", 14, buf);
		printf("strerror(errno) => %s\n", strerror(errno));
	}
	{	// ft_strlen()
		printf("\n-----ft_strlen()---\n");
		test("id", ft_strlen("Hello, World!\n"), == 14);
		test("empty", ft_strlen(""), == 0);
	}

	printf("\n-----finished-----\n");
	return test_failed;
	(void)ac;
	(void)av;
}
