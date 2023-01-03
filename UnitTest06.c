// Sean Szumlanski
// COP 3502, Spring 2020

// ======================
// Domichar: UnitTest06.c
// ======================
// Tests the functionality of your printDomichar() function. This test also
// ensures that your printDomichar() function doesn't modify the string it
// receives.


#include <stdio.h>
#include "Domichar.h"

// This acts as the main() function for this test case.
int unit_test(int argc, char **argv)
{
	printDomichar("_d_o_m_i_n_a_t_i_o_n_");
	printDomichar("APPLe");
	printDomichar("falls");
	printDomichar("from");
	printDomichar("coconut");
	printDomichar("b4n4n4s");
	printDomichar("fancy");
	printDomichar("wow");

	return 0;
}
