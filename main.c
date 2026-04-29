#include <stdbool.h>
#include <unistd.h>
#include <errno.h>
#include <stdio.h>
#include <string.h>
#include "libasm.h"

#define ok_ko(b) (b ? OK : KO)
#define OK "\033[1;32m[OK]\033[0m"
#define KO "\033[1;31m[KO]\033[0m"

#define test(name, type, case, pred) do {						\
	printf("%s: %s %s\n", name, #case, #pred);			\
	type test_rv = case;									\
	printf("%s: %zi\n", ok_ko(test_rv pred), test_rv);	\
	test_failed |= !(test_rv pred);						\
} while (0)

int	main(int ac, char **av) {
	bool	test_failed = false;
	printf("Testing asm functions:\n");

	{	// ft_write()
		printf("-----ft_write()------\n");
		test("id", ssize_t, ft_write(STDOUT_FILENO, "Hello, World!\n", 14), == 14);
		test("error", ssize_t, ft_write(42, "Hello, World!\n", 14), < 0);
		printf("strerror(errno) => %s\n", strerror(errno));
	}
	{ // ft_read()
		char	buf[256];
		printf("\n-----ft_read()-------\n");
		test("id", ssize_t, ft_read(STDIN_FILENO, buf, 256), == 14);
		printf("buf => \"%.*s\"\n", 14, buf);
		test("error", ssize_t,  ft_read(42, buf, 256), < 0);
		printf("buf => \"%.*s\"\n", 14, buf);
		printf("strerror(errno) => %s\n", strerror(errno));
	}
	{	// ft_strlen()
		printf("\n-----ft_strlen()---\n");
		test("id", size_t, ft_strlen("Hello, World!\n"), == 14);
		test("empty", size_t, ft_strlen(""), == 0);
	}
	{	// ft_strcpy()
		const char	*src = "Hello, World!\n";
		char		buf[15];
		printf("\n-----ft_strcpy()---\n");
		bzero(buf, sizeof(buf));
		test("id", char *, ft_strcpy(buf, src), == buf);
		printf("buf == src => %s\n", ok_ko(!strcmp(buf, src)));
		test("empty", char *, ft_strcpy(buf, ""), == buf);
		printf("buf == \"\" => %s\n", ok_ko(!strcmp(buf, "")));
	}
	{	// ft_strcmp()
		printf("\n-----ft_strcmp()---\n");
		test("id", int, ft_strcmp("Hello, World!\n", "Hello, World!\n"), == 0);
		test("unequal", int, ft_strcmp("Hello, World!\n", "Hello, Universe!\n"), != 0);
		test("less", int, ft_strcmp("a", "b"), == -1);
		test("more", int, ft_strcmp("b", "a"), == 1);
	}

	printf("\n-----finished-----\n");
	return test_failed;
	(void)ac;
	(void)av;
}
