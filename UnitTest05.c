// Sean Szumlanski
// COP 3502, Spring 2020

// ======================
// Domichar: UnitTest05.c
// ======================
// Tests the functionality of your isNonalphabetic() function.


#include <stdio.h>
#include "Domichar.h"

// This acts as the main() function for this test case.
int unit_test(int argc, char **argv)
{
	printf("%d\n", isNonalphabetic('s'));
	printf("%d\n", isNonalphabetic('E'));
	printf("%d\n", isNonalphabetic('a'));
	printf("%d\n", isNonalphabetic('T'));
	printf("%d\n", isNonalphabetic('@'));
	printf("%d\n", isNonalphabetic('*'));

	return 0;
}
