#!/bin/sh
# ssim2qff.sh exercises the ssim2qff mock and verifies that it behaves as expected.
# It takes no inputs from commandline, prints issues to stdout and returns a non-zero
# exit status when expectations are not met.

EXIT_STATUS=0

# correct usage testcase 1
echo "I'm an input file." > input
examples/mocks/ssim2qff/ssim2qff -t '201809010005' -o output -d input
if [ $? -ne 0 ] || [ ! -f "./output" ] || [ "$(cat output)" != "I'm an output file." ]
then
	echo "Test 1: not working properly."
	EXIT_STATUS=1
fi

# incorrect usage testcase 2 (misses output flags)
echo "I'm an input file." > input
examples/mocks/ssim2qff/ssim2qff -t '201809010005' -d input
if [ $? -eq 0 ]
then
	echo "Test 2: not working properly."
	EXIT_STATUS=1
fi

# incorrect usage testcase 3 (wrong input file content)
echo "I'm an incorrect input file." > input
examples/mocks/ssim2qff/ssim2qff -t '201809010005' -o output -d input
if [ $? -eq 0 ]
then
	echo "Test 3: not working properly."
	EXIT_STATUS=1
fi

# incorrect usage testcase 4 (wrong timestamp)
echo "I'm an input file." > input
examples/mocks/ssim2qff/ssim2qff -t '0' -o output -d input
if [ $? -eq 0 ]
then
	echo "Test 4: not working properly."
	EXIT_STATUS=1
fi

exit $EXIT_STATUS
