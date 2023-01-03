// Sean Szumlanski
// COP 3502, Spring 2020

// ======================
// Domichar: UnitTest02.c
// ======================
// Tests that your hoursSpent() function returns a value within the expected
// range (as defined in the assignment PDF) and is also a reasonable estimate.


#include <stdio.h>
#include "Domichar.h"

// This acts as the main() function for this test case.
int unit_test(int argc, char **argv)
{
	int success = 1;

	// hoursSpent() must be strictly greater than zero.
	if (hoursSpent() <= 0 || hoursSpent() > 100)
		success = 0;

	printf("%s\n", success ? "Success!" : "Fail whale!");
	return 0;
}
