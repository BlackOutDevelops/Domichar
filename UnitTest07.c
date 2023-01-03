// Sean Szumlanski
// COP 3502, Spring 2020

// ======================
// Domichar: UnitTest07.c
// ======================
// Tests the functionality of your printDomichar() function.


#include <stdio.h>
#include "Domichar.h"

// This acts as the main() function for this test case.
int unit_test(int argc, char **argv)
{
	printDomichar("cheese!!!");
	printDomichar("TREE");
	printDomichar("wee!");

	return 0;
}
