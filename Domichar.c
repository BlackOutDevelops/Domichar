// Joshua Frazer jo227789
// COP 3502, Spring 2020
// Using Atom & Linux Bash Shell on Windows 10.
#include "Domichar.h"
#include <stdio.h>
#include <ctype.h>
#include <string.h>

int main(int argc, char **argv)
{
    int i;
    // for loop to determine whether the command line argument is null
    for (i = 1; i < 15; i++)
    {
        if (argv[i] == NULL)
            i = 15;
        else
            printDomichar(argv[i]);
    }
    return 0;
}

void printDomichar(char *str)
{
    int i,
        lengthStr;
    double vowel = 0,
           consonant = 0,
           nonAlphabetic = 0,
           mOrP;

    // lengthStr holds the string length of what's being passed as a parameter
    lengthStr = strlen(str);

    // for loop to count the amount of vowels, consonants, and non-alphabetic letters
    for (i = 0; i < lengthStr; i++)
    {
        if (isVowel(str[i]) == 1)
            vowel++;
        else if (isConsonant(str[i]) == 1)
            consonant++;
        else if (isNonalphabetic(str[i]) == 1)
            nonAlphabetic++;
    }

    // Start of the printed output
    printf("%s (", str);

    // if-else if statements to check every condition for majority, plurality, and equality
    if (vowel > consonant && vowel > nonAlphabetic)
    {
        // Equation to determine the majority or plurality
        mOrP = vowel / (vowel + consonant + nonAlphabetic);
        // if-else statement to choose between majority or plurality
        if (mOrP > .50)
        {
            printf("m:");
        }
        else
        {
            printf("p:");
        }
        printf("v)\n");
    }
    else if (consonant > vowel && consonant > nonAlphabetic)
    {
        // Equation to determine the majority or plurality
        mOrP = consonant / (vowel + consonant + nonAlphabetic);
        // if-else statement to choose between majority or plurality
        if (mOrP > .50)
        {
            printf("m:");
        }
        else
        {
            printf("p:");
        }
        printf("c)\n");
    }
    else if (nonAlphabetic > vowel && nonAlphabetic > consonant)
    {
        // Equation to determine the majority or plurality
        mOrP = nonAlphabetic / (vowel + consonant + nonAlphabetic);
        // if-else statement to choose between majority or plurality
        if (mOrP > .50)
        {
            printf("m:");
        }
        else
        {
            printf("p:");
        }
        printf("~)\n");
    }
    else if (vowel == consonant && vowel > nonAlphabetic)
    {
        printf("vc)\n");
    }
    else if (vowel == nonAlphabetic && vowel > consonant)
    {
        printf("v~)\n");
    }
    else if (consonant == nonAlphabetic && consonant > vowel)
    {
        printf("c~)\n");
    }
    else
    {
      printf("vc~)\n");
    }
}

int isVowel(char c)
{
    // if-else if statements to check every possible vowel for the passed character
    c = toupper(c);
    if (c == 65 || c == 69 || c == 73 || c == 79 || c == 85)
        return 1;
    else
        return 0;
}

int isConsonant(char c)
{
    // if-else statement to check to see whether the character is a consonant or not
    c = toupper(c);
    if (c != 65 && c != 69 && c != 73 && c != 79 && c != 85 && isalpha(c) != 0)
        return 1;
    else
        return 0;
}

int isNonalphabetic(char c)
{
    // if-else statement to check if the character is within the alphabet or not
    if (isalpha(c) == 0)
        return 1;
    else
        return 0;
}

double difficultyRating(void)
{
    // Difficulty rating for given assignment
    return 2.0;
}

double hoursSpent(void)
{
    // Hours spent for given assignment
    return 1.5;
}
