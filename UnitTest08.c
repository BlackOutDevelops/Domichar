// Sean Szumlanski
// COP 3502, Spring 2020

// ======================
// Domichar: UnitTest08.c
// ======================
// Tests that your printDomichar() function doesn't modify the string it
// receives.


#include <stdio.h>
#include "Domichar.h"

// This acts as the main() function for this test case.
int unit_test(int argc, char **argv)
{
	char *str = "wow";

	printDomichar(str);

	printf("\nBack in main(): **%s**\n", str);

	return 0;
}
