#include <stdbool.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <stdio.h>
#include <string.h>
#include "libasm.h"

#define ok_ko(b) (b ? OK : KO)
#define OK "\033[1;32m[OK]\033[0m"
#define KO "\033[1;31m[KO]\033[0m"

#define test(name, type, case, pred) do {				\
	printf("%s: %s %s\n", name, #case, #pred);			\
	type test_rv = case;								\
	printf("%s: %zi\n", ok_ko(test_rv pred), test_rv);	\
	test_failed |= !(test_rv pred);						\
} while (0)

#define test_malloc(name, type, case, pred) do {		\
	printf("%s: %s %s\n", name, #case, #pred);			\
	type test_rv = case;								\
	printf("%s: %zi\n", ok_ko(test_rv pred), test_rv);	\
	test_failed |= !(test_rv pred);						\
	free(test_rv);										\
} while (0)

void	lstclear(t_list *lst) {
	if (!lst) return ;
	lstclear(lst->next);
	free(lst);
}

void	noop(void *p) {
	(void)p;
}

int		equ(void *a, void *b) {
	return !((long long)a == (long long)b);
}

int		dummy(void *a, void* b) {
	(void)a;
	(void)b;
	return 0;
}

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
	{	// ft_strdup()
		char	*rv = NULL;
		printf("\n-----ft_strdup()---\n");
		test_malloc("id", char *, ft_strdup("Hello, World!\n"), != 0);
		{
			const char *s = "1";
			char	*d = ft_strdup(s);
			printf("s == ft_strdup(s) => %s\n", ok_ko(!strcmp(s, d)));
			printf("s = \"%s\"[%i]\nd = \"%s\"[%i]\n", s, ft_strlen(s), d, ft_strlen(d));
			free(d);
		}
	}
	{	// ft_atoi_base()
		printf("\n-----ft_atoi_base--\n");
		test("base_check", int, ft_atoi_base("1", ""), == 0);
		test("base_check", int, ft_atoi_base("1", " "), == 0);
		test("base_check", int, ft_atoi_base("1", " 1"), == 0);
		test("base_check", int, ft_atoi_base("1", "\t1"), == 0);
		test("base_check", int, ft_atoi_base("1", "\n1"), == 0);
		test("base_check", int, ft_atoi_base("1", "\v1"), == 0);
		test("base_check", int, ft_atoi_base("1", "\f1"), == 0);
		test("base_check", int, ft_atoi_base("1", "\r1"), == 0);
		test("base_check", int, ft_atoi_base("1", "+1"), == 0);
		test("base_check", int, ft_atoi_base("1", "-1"), == 0);
		test("base_check", int, ft_atoi_base("1", "11"), == 0);
		test("base_check", int, ft_atoi_base("1", "12345677"), == 0);
		test("id", int, ft_atoi_base("1", "0123456789"), == 1);
		test("id", int, ft_atoi_base("0123456789", "0123456789"), == 123456789);
		test("sign", int, ft_atoi_base("-1", "0123456789"), == -1);
		test("sign", int, ft_atoi_base("+1", "0123456789"), == 1);
		test("whitespace", int, ft_atoi_base(" 1", "0123456789"), == 1);
		test("whitespace", int, ft_atoi_base("\t1", "0123456789"), == 1);
		test("whitespace", int, ft_atoi_base("\n1", "0123456789"), == 1);
		test("whitespace", int, ft_atoi_base("\v1", "0123456789"), == 1);
		test("whitespace", int, ft_atoi_base("\f1", "0123456789"), == 1);
		test("whitespace", int, ft_atoi_base("\r1", "0123456789"), == 1);
		test("combos", int, ft_atoi_base("      \t\t\t\t\r  \r\r\n\n\n\f\t\r\v+3", "0123456789"), == 3);
		test("nonstandard base", int, ft_atoi_base("abcdef", "abcdefghij"), == 12345);
	}
	{	// list functions
		t_list	*list = NULL;
		printf("\n----list functions--\n");
		ft_list_push_front(&list, "1\n");
		ft_list_push_front(&list, "3\n");
		ft_list_push_front(&list, "2\n");
		printf("ft_list_size(list) => %d\n", ft_list_size(list));
		for (t_list* current = list; current; current = current->next) {
			printf("list->data => %s", current->data);
		}
		ft_list_sort(&list, ft_strcmp);
		printf("ft_list_size(list) => %d\n", ft_list_size(list));
		for (t_list* current = list; current; current = current->next) {
			printf("list->data => %s", current->data);
		}
		lstclear(list);
	}
	{	// list functions
		t_list	*list = NULL;
		ft_list_sort(&list, ft_strcmp);
		printf("\n----list functions--\n");
		ft_list_push_front(&list, "2\n");
		ft_list_push_front(&list, "3\n");
		ft_list_push_front(&list, "1\n");
		printf("ft_list_size(list) => %d\n", ft_list_size(list));
		for (t_list* current = list; current; current = current->next) {
			printf("list->data => %s", current->data);
		}
		ft_list_sort(&list, ft_strcmp);
		printf("ft_list_size(list) => %d\n", ft_list_size(list));
		for (t_list* current = list; current; current = current->next) {
			printf("list->data => %s", current->data);
		}
		lstclear(list);
	}
	{	// list functions
		t_list	*list = NULL;
		printf("\n----list functions--\n");
		ft_list_push_front(&list, "1\n");
		ft_list_push_front(&list, "2\n");
		ft_list_push_front(&list, "3\n");
		printf("ft_list_size(list) => %d\n", ft_list_size(list));
		for (t_list* current = list; current; current = current->next) {
			printf("list->data => %s", current->data);
		}
		ft_list_sort(&list, ft_strcmp);
		printf("ft_list_size(list) => %d\n", ft_list_size(list));
		for (t_list* current = list; current; current = current->next) {
			printf("list->data => %s", current->data);
		}
		ft_list_remove_if(&list, "1\n", ft_strcmp, noop);
		ft_list_sort(&list, ft_strcmp);
		printf("ft_list_size(list) => %d\n", ft_list_size(list));
		for (t_list* current = list; current; current = current->next) {
			printf("list->data => %s", current->data);
		}
		lstclear(list);
	}
	printf("\n-----assorted-----\n");
	t_list	*list = NULL;
	for (int i = 1; i < ac; ++i) {
		ft_list_push_front(&list, av[i]);
	}
	printf("ft_list_size(list) => %d\n", ft_list_size(list));
	for (t_list* current = list; current; current = current->next) {
		printf("list->data => %s\n", current->data);
	}
	ft_list_sort(&list, ft_strcmp);
	printf("ft_list_size(list) => %d\n", ft_list_size(list));
	for (t_list* current = list; current; current = current->next) {
		printf("list->data => %s\n", current->data);
	}
	ft_list_remove_if(&list, av[3], equ, noop);
	printf("ft_list_size(list) => %d\n", ft_list_size(list));
	for (t_list* current = list; current; current = current->next) {
		printf("list->data => %s\n", current->data);
	}
	lstclear(list);

	printf("\n-----finished-----\n");
	return test_failed;
	(void)ac;
	(void)av;
}
