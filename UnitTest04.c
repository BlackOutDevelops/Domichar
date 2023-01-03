// Sean Szumlanski
// COP 3502, Spring 2020

// ======================
// Domichar: UnitTest04.c
// ======================
// Tests the functionality of your isConsonant() function.


#include <stdio.h>
#include "Domichar.h"

// This acts as the main() function for this test case.
int unit_test(int argc, char **argv)
{
	printf("%d\n", isConsonant('s'));
	printf("%d\n", isConsonant('E'));
	printf("%d\n", isConsonant('a'));
	printf("%d\n", isConsonant('T'));
	printf("%d\n", isConsonant('@'));
	printf("%d\n", isConsonant('*'));

	return 0;
}
