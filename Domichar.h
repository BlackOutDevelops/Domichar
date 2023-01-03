#ifndef __DOMICHAR_H
#define __DOMICHAR_H


// Magic Unit Test Directive

// The following line is modified automatically by the test-all.sh script to
// enable and disable unit testing. Uncomment the following line if you are
// compiling your code with one of the unit tests (one of the UnitTestXX.c
// files) provided with the assignment.

// OTHER THAN COMMENTING/UNCOMMENTING THE FOLLOWING LINE, DO NOT MAKE ANY
// MODIFICATIONS TO THIS HEADER FILE!

//#define main __hidden_main__


// Functional Prototypes

void printDomichar(char *str);

int isVowel(char c);

int isConsonant(char c);

int isNonalphabetic(char c);

double difficultyRating(void);

double hoursSpent(void);


#endif
