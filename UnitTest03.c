// Sean Szumlanski
// COP 3502, Spring 2020

// ======================
// Domichar: UnitTest03.c
// ======================
// Tests the functionality of your isVowel() function.


#include <stdio.h>
#include "Domichar.h"

// This acts as the main() function for this test case.
int unit_test(int argc, char **argv)
{
	printf("%d\n", isVowel('s'));
	printf("%d\n", isVowel('E'));
	printf("%d\n", isVowel('a'));
	printf("%d\n", isVowel('T'));
	printf("%d\n", isVowel('@'));
	printf("%d\n", isVowel('*'));

	return 0;
}
