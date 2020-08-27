#!/bin/sh
# mockexec_test.sh exercises the mock executable and verifies that it behaves as expected.
# It takes no inputs from commandline, prints issues to stdout and returns a non-zero
# exit status when expectations are not met.

EXIT_STATUS=0

# correct usage testcase 1
echo "INPUT" > tmp/test-input
echo "OUTPUT" > tmp/test-output
cmd/mockexec/mockexec -t 'SOME STRING' -o tmp/result tmp/test-input > /dev/null 2>&1
if [ $? -ne 0 ] || [ ! -f "tmp/result" ] || [ "$(cat tmp/result)" != "OUTPUT" ]
then
	echo "Test 1: not working properly."
	EXIT_STATUS=1
fi

# incorrect usage testcase 2 (too many arguments)
echo "INPUT" > tmp/test-input
echo "OUTPUT" > tmp/test-output
cmd/mockexec/mockexec -t 'SOME STRING' -o tmp/result tmp/test-input 'TEST' > /dev/null 2>&1
if [ $? -eq 0 ]
then
	echo "Test 2: not working properly."
	EXIT_STATUS=1
fi

# incorrect usage testcase 3 (not enough arguments)
echo "INPUT" > tmp/test-input
echo "OUTPUT" > tmp/test-output
cmd/mockexec/mockexec -t 'SOME STRING' -o tmp/result > /dev/null 2>&1
if [ $? -eq 0 ]
then
	echo "Test 3: not working properly."
	EXIT_STATUS=1
fi

# incorrect usage testcase 4 (wrong string content)
echo "INPUT" > tmp/test-input
echo "OUTPUT" > tmp/test-output
cmd/mockexec/mockexec -t 'THIS IS NOT SOME STRING' -o tmp/result tmp/test-input > /dev/null 2>&1
if [ $? -eq 0 ]
then
	echo "Test 4: not working properly."
	EXIT_STATUS=1
fi

# incorrect usage testcase 5 (wrong flag)
echo "INPUT" > tmp/test-input
echo "OUTPUT" > tmp/test-output
cmd/mockexec/mockexec -d 'SOME STRING' -o tmp/result tmp/test-input > /dev/null 2>&1
if [ $? -eq 0 ]
then
	echo "Test 5: not working properly."
	EXIT_STATUS=1
fi

# incorrect usage testcase 6 (wrong input file content)
echo "NOT AN INPUT" > tmp/test-input
echo "OUTPUT" > tmp/test-output
cmd/mockexec/mockexec -t 'SOME STRING' -o tmp/result tmp/test-input > /dev/null 2>&1
if [ $? -eq 0 ]
then
	echo "Test 6: not working properly."
	EXIT_STATUS=1
fi

exit $EXIT_STATUS