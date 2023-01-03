#!/bin/bash


# Sean Szumlanski
# COP 3502, Spring 2020

# =====================
# Domichar: test-all.sh
# =====================
# You can run this script at the command line like so:
#
#   bash test-all.sh
#
# For more details, see the assignment PDF.


################################################################################
# Shell check.
################################################################################

# Running this script with sh instead of bash can lead to false positives on the
# test cases. Yikes! These checks ensure the script is not being run through the
# Bourne shell (or any shell other than bash).

if [ "$BASH" != "/bin/bash" ]; then
  echo ""
  echo " Bloop! Please use bash to run this script, like so: bash test-all.sh"
  echo ""
  exit
fi

if [ -z "$BASH_VERSION" ]; then
  echo ""
  echo " Bloop! Please use bash to run this script, like so: bash test-all.sh"
  echo ""
  exit
fi


################################################################################
# Initialization.
################################################################################

PASS_CNT=0
NUM_TEST_CASES=8
NUM_UNIT_TESTS=8

# +2 below for the warnings and indentation checks.
TOTAL_TEST_CNT=`expr $NUM_TEST_CASES + $NUM_UNIT_TESTS + 2`


################################################################################
# Check for commands that are required by this test script.
################################################################################

# This command is necessary in order to run all the test cases in sequence.
if ! [ -x "$(command -v seq)" ]; then
	echo ""
	echo " Error: seq command not found. You might see this message if you're"
	echo "        running this script on an old Mac system. Please be sure to"
	echo "        test your final code on Eustis. Aborting test script."
	echo ""
	exit
fi

# This command is necessary for various warning checks.
if ! [ -x "$(command -v grep)" ]; then
	echo ""
	echo " Error: grep command not found. You might see this message if you're"
	echo "        running this script on an old Mac system. Please be sure to"
	echo "        test your final code on Eustis. Aborting test script."
	echo ""
	exit
fi

# This command is necessary for various warning checks.
if ! [ -x "$(command -v perl)" ]; then
	echo ""
	echo " Error: perl command not found. You might see this message if you're"
	echo "        running this script on an old Mac system. Please be sure to"
	echo "        test your final code on Eustis. Aborting test script."
	echo ""
	exit
fi


################################################################################
# Magical incantations.
################################################################################

# Ensure that obnoxious glibc errors are piped to stderr.
export LIBC_FATAL_STDERR_=1

# Now redirect all local error messages to /dev/null (like "process aborted").
exec 2> /dev/null


################################################################################
# Check that all required files are present.
################################################################################

if [ ! -f Domichar.c ]; then
	echo ""
	echo " Error: You must place Domichar.c in this directory before"
	echo "        we can proceed. Aborting test script."
	echo ""
	exit
elif [ ! -f Domichar.h ]; then
	echo ""
	echo " Error: You must place Domichar.h in this directory before"
	echo "        we can proceed. Aborting test script."
	echo ""
	exit
elif [ ! -f UnitTestLauncher.c ]; then
	echo ""
	echo " Error: You must place UnitTestLauncher.c in this directory"
	echo "        before we can proceed. Aborting test script."
	echo ""
	exit
elif [ ! -d sample_output ]; then
	echo ""
	echo " Error: You must place the sample_output folder in this directory"
	echo "        before we can proceed. Aborting test script."
	echo ""
	exit
fi

if ! [ -x "$(command -v seq)" ]; then
	echo ""
	echo " Error: seq command not found. You might see this message if"
	echo "        you're running this script on an old Mac system."
	echo "        Please be sure to test your final code on Eustis."
	echo "        Aborting test script."
	echo ""
	exit
fi

for i in `seq -f "%02g" 1 $NUM_TEST_CASES`;
do
	if [ ! -f arguments$i.txt ]; then
		echo ""
		echo " Error: You must place arguments$i.txt in this directory before we"
		echo "        can proceed. Aborting test script."
		echo ""
		exit
	fi
	if [ ! -f sample_output/arguments$i-output.txt ]; then
		echo ""
		echo " Error: You must place arguments$i-output.txt in the sample_output"
		echo "        directory before we can proceed. Aborting test script."
		echo ""
		exit
	fi
done

for i in `seq -f "%02g" 1 $NUM_UNIT_TESTS`;
do
	if [ ! -f UnitTest$i.c ]; then
		echo ""
		echo " Error: You must place UnitTest$i.c in this directory before we"
		echo "        can proceed. Aborting test script."
		echo ""
		exit
	fi
	if [ ! -f sample_output/UnitTest$i-output.txt ]; then
		echo ""
		echo " Error: You must place UnitTest$i-output.txt in the sample_output"
		echo "        directory before we can proceed. Aborting test script."
		echo ""
		exit
	fi
done

grep -s -q "^#include \"Domichar\.h\"" Domichar.c
grep_val=$?

if [[ $grep_val != 0 ]]; then
	echo ""
	echo "  Whoa, buddy! Your Domichar.c file does not appear to have a proper"
	echo "  #include statement for Domichar.h. Please read Section 2 of the"
	echo "  assignment PDF before proceeding."
	echo ""
	exit
fi

# Save a backup version of Domichar.h to be restored after running this
# script, so that the #define main line ends up back how you had it.
cp Domichar.h Domichar_backup.h


################################################################################
# Run test cases with input specified at command line (standard test cases).
################################################################################

echo ""
echo "================================================================"
echo "Running standard test cases..."
echo "================================================================"
echo ""

# Function for running a single test case.
run_test_case()
{
	local argument_file=$1
	local output_file=$2

	echo -n "  [Test Case] $argument_file ... "

	# Ensure that Domichar.h is in normal test case mode (not unit test mode).
	perl -p -i -e 's/^#define main/\/\/#define main/' Domichar.h

	# Attempt to compile.
	gcc Domichar.c 2> /dev/null
	compile_val=$?

	# Immediately restore header file in case the user terminates the script
	# before we can move on to the next test case.
	cp Domichar_backup.h Domichar.h

	# Check for compilation failure.
	if [[ $compile_val != 0 ]]; then
		echo "fail (failed to compile)"
		return
	fi

	# Run program. Capture return value to check whether it crashes.
	./a.out $(cat $argument_file) > myoutput.txt 2> /dev/null
	execution_val=$?
	if [[ $execution_val != 0 ]]; then
		echo "fail (program crashed)"
		return
	fi

	# Run diff and capture its return value.
	diff myoutput.txt sample_output/$output_file > /dev/null
	diff_val=$?
	
	# Output results based on diff's return value.
	if  [[ $diff_val != 0 ]]; then
		echo "fail (output mismatch)"
	else
		echo "PASS!"
		PASS_CNT=`expr $PASS_CNT + 1`
	fi
}

for i in `seq -f "%02g" 1 $NUM_TEST_CASES`;
do
	run_test_case "arguments$i.txt" "arguments$i-output.txt"
done


################################################################################
# Run unit tests.
################################################################################

echo ""
echo "================================================================"
echo "Running unit tests (code-based test cases)..."
echo "================================================================"
echo ""

run_unit_test()
{
	local testcase_file=$1
	local output_file=$2

	echo -n "  [Unit Case] $testcase_file ... "

	# Ensure that Domichar.h is in unit test case mode.
	perl -p -i -e 's/^\/\/#define main/#define main/' Domichar.h

	# Attempt to compile.
	gcc Domichar.c UnitTestLauncher.c $testcase_file 2> /dev/null
	compile_val=$?

	# Immediately restore header file in case the user terminates the script
	# before we can move on to the next test case.
	cp Domichar_backup.h Domichar.h

	# Check for compilation failure.
	if [[ $compile_val != 0 ]]; then
		echo "fail (failed to compile)"
		return
	fi

	# Run program. Capture return value to check whether it crashes.
	./a.out > myoutput.txt 2> /dev/null
	execution_val=$?
	if [[ $execution_val != 0 ]]; then
		echo "fail (program crashed)"
		return
	fi

	# Run diff and capture its return value.
	diff myoutput.txt sample_output/$output_file > /dev/null
	diff_val=$?
	
	# Output results based on diff's return value.
	if  [[ $diff_val != 0 ]]; then
		echo "fail (output mismatch)"
	else
		echo "PASS!"
		PASS_CNT=`expr $PASS_CNT + 1`
	fi
}

for i in `seq -f "%02g" 1 $NUM_UNIT_TESTS`;
do
	run_unit_test "UnitTest$i.c" "UnitTest$i-output.txt"
done


############################################################################
# Check for warnings.
############################################################################

echo ""
echo "================================================================"
echo "Checking for compiler warnings..."
echo "================================================================"
echo ""

if ! [ -x "$(command -v grep)" ]; then
	echo "  Skipping compiler warning check; grep not installed. You"
	echo "  might see this message if you're running this script on a"
	echo "  Mac. Please be sure to test your final code on Eustis."
else
	gcc Domichar.c -c &> ./err.log
	compile_flag=$?

	if [[ $compile_flag != 0 ]]; then
		echo "  Failed to compile."
	else
		grep --silent "warning" err.log
		warnings_flag=$?

		if [[ $warnings_flag == 0 ]]; then
			echo "  Warnings detected. :("
		else
			echo "  No warnings detected. Hooray!"
			PASS_CNT=`expr $PASS_CNT + 1`
		fi
	fi
fi


############################################################################
# Check for tabs vs. spaces.
############################################################################

echo ""
echo "================================================================"
echo "Checking for tabs vs. spaces..."
echo "================================================================"
echo ""

if ! [ -x "$(command -v grep)" ]; then
	echo "  Skipping tabs vs. spaces check; grep not installed. You"
	echo "  might see this message if you're running this script on a"
	echo "  Mac. Please be sure to test your final code on Eustis."
elif ! [ -x "$(command -v awk)" ]; then
	echo "  Skipping tabs vs. spaces check; awk not installed. You"
	echo "  might see this message if you're running this script on a"
	echo "  Mac. Please be sure to test your final code on Eustis."
else
	num_spc_lines=`grep "^ " Domichar.c | wc -l | awk '{$1=$1};1'`
	num_tab_lines=`grep "$(printf '^\t')" Domichar.c | wc -l | awk '{$1=$1};1'`
	num_und_lines=`grep "$(printf '^[^\t ]')" Domichar.c | wc -l | awk '{$1=$1};1'`

	echo "  Number of lines beginning with spaces: $num_spc_lines"
	echo "  Number of lines beginning with tabs: $num_tab_lines"
	echo "  Number of lines with no indentation: $num_und_lines"

	if [ "$num_spc_lines" -gt 0 ] && [ "$num_tab_lines" -gt 0 ]; then
		echo ""
		echo "  Whoa, buddy! It looks like you're starting some lines of code with"
		echo "  tabs, and other lines of code with spaces. You'll need to choose"
		echo "  one or the other."
		echo ""
		echo "  Try running the following commands to see which of your lines begin"
		echo "  with spaces (the first command below) and which ones begin with tabs"
		echo "  (the second command below):"
		echo ""
		echo "     grep \"^ \" Domichar.c -n"
		echo "     grep \"\$(printf '^\t')\" Domichar.c -n"
	elif [ "$num_spc_lines" -gt 0 ]; then
		echo ""
		echo "  Looks like you're using spaces for all your indentation! (Yay!)"
		PASS_CNT=`expr $PASS_CNT + 1`
	elif [ "$num_tab_lines" -gt 0 ]; then
		echo ""
		echo "  Looks like you're using tabs for all your indentation! (Yay!)"
		PASS_CNT=`expr $PASS_CNT + 1`
	else
		echo ""
		echo "  Whoa, buddy! It looks like none of your lines of code are indented!"
	fi
fi


################################################################################
# Cleanup phase.
################################################################################

# Restore header file to whatever mode it was in before running this script.
if [ -f Domichar_backup.h ]; then
	mv Domichar_backup.h Domichar.h
fi

# Clean up the executable file.
rm -f a.out

# Clean up the output file generated by this script.
rm -f myoutput.txt

# Remove error log and object file generated by warning check.
rm -f err.log
rm -f Domichar.o


################################################################################
# Final thoughts.
################################################################################

echo ""
echo "================================================================"
echo "Final Report"
echo "================================================================"

if [ $PASS_CNT -eq $TOTAL_TEST_CNT ]; then
	echo ""
	echo "              ,)))))))),,,"
	echo "            ,(((((((((((((((,"
	echo "            )\\\`\\)))))))))))))),"
	echo "     *--===///\`_    \`\`\`((((((((("
	echo "           \\\\\\ b\\  \\    \`\`)))))))"
	echo "            ))\\    |     ((((((((               ,,,,"
	echo "           (   \\   |\`.    ))))))))       ____ ,)))))),"
	echo "                \\, /  )  ((((((((-.___.-\"    \`\"((((((("
	echo "                 \`\"  /    )))))))               \\\`)))))"
	echo "                    /    ((((\`\`                  \\((((("
	echo "              _____|      \`))         /          |)))))"
	echo "             /     \\                 |          / ((((("
	echo "            /  --.__)      /        _\\         /   )))))"
	echo "           /  /    /     /'\`\"~----~\`  \`.       \\   (((("
	echo "          /  /    /     /\`              \`-._    \`-. \`)))"
	echo "         /_ (    /    /\`                    \`-._   \\ (("
	echo "        /__|\`   /   /\`                        \`\\\`-. \\ ')"
	echo "               /  /\`                            \`\\ \\ \\"
	echo "              /  /                                \\ \\ \\"
	echo "             /_ (                                 /_()_("
	echo "            /__|\`                                /__/__|"
	echo ""
	echo "                             Legendary."
	echo ""
	echo "                10/10 would run this program again."
	echo ""
	echo "  CONGRATULATIONS! You appear to be passing all the test cases!"
	echo "  (Now, don't forget to create some extra test cases of your own."
	echo "  These test cases are not comprehensive.)"
	echo ""
else
	echo "                           ."
	echo "                          \":\""
	echo "                        ___:____     |\"\\/\"|"
	echo "                      ,'        \`.    \\  /"
	echo "                      |  o        \\___/  |"
	echo "                    ~^~^~^~^~^~^~^~^~^~^~^~^~"
	echo ""
	echo "                           (fail whale)"
	echo ""
	echo "  The fail whale is friendly and adorable! He is not here to"
	echo "  demoralize you, but rather, to bring you comfort and joy"
	echo "  in your time of need. \"Keep plugging away,\" he says! \"You"
	echo "  can do this!\""
	echo ""
	echo "  For instructions on how to run these test cases individually"
	echo "  and inspect how your output differs from the expected output,"
	echo "  be sure to consult the assignment PDF."
	echo ""
	echo "  You must also pass the warnings check and the indentation"
	echo "  check in order to part ways with the fail whale."
	echo ""
fi
