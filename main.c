#include <stdio.h>

extern void	hello_asm(void);
extern int	ft_write(int fd, const char *s, int l);

int	main(int ac, char **av) {
	printf("Testing asm functions:\n");
	printf("-----hello world-----\n");
	hello_asm();
	printf("-----ft_write()------\n");
	ft_write(1, "This is a string given in a c file!\n", 37);
	printf("-----finished-----\n");
	return 0;
	(void)ac;
	(void)av;
}
