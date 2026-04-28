#include <stdio.h>

extern void	hello_asm(void);

int	main(int ac, char **av) {
	printf("Testing asm functions:\n");
	printf("-----hello world-----\n");
	hello_asm();
	printf("-----finished-----\n");
	return 0;
	(void)ac;
	(void)av;
}
