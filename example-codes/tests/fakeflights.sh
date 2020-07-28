#!/bin/sh
# fakeflights.sh exercises the fakeflights and verifies that it behaves as expected.
# it takes no inputs from commandline, prints issues to stdout and returns a non-zero
# exit status when expectations are not met.

EXIT_STATUS=0

# correct usage testcase 1
echo "I'm the input file #1." > input1.qff
echo "I'm the input file #2." > input2.qff
echo "I'm the input file #3." > input3.qff
./fakeflights --cull-time '202007210000' -o output.qff input1.qff input2.qff input3.qff 
if [ $? -ne 0 ] || [ ! -f "./output.qff" ] || [ "$(cat output.qff)" != "I'm an output file." ]
then
	echo "Test 1: not working properly."
	EXIT_STATUS=1
fi

# incorrect usage testcase 2 (misses output flags)
echo "I'm the input file #1." > input1.qff
echo "I'm the input file #2." > input2.qff
echo "I'm the input file #3." > input3.qff
./fakeflights --cull-time '202007210000' input1.qff input2.qff input3.qff 
if [ $? -eq 0 ]
then
	echo "Test 2: not working properly."
	EXIT_STATUS=1
fi

# incorrect usage testcase 3 (wrong input file content)
echo "I'm the input file #1." > input1.qff
echo "I'm the input file #3." > input2.qff
echo "I'm the input file #3." > input3.qff
./fakeflights --cull-time '202007210000' -o output.qff input1.qff input2.qff input3.qff 
if [ $? -eq 0 ]
then
	echo "Test 3: not working properly."
	EXIT_STATUS=1
fi

# incorrect usage testcase 4 (wrong timestamp)
echo "I'm the input file #1." > input1.qff
echo "I'm the input file #2." > input2.qff
echo "I'm the input file #3." > input3.qff
./fakeflights --cull-time '202006280000' -o output.qff input1.qff input2.qff input3.qff 
if [ $? -eq 0 ]
then
	echo "Test 4: not working properly."
	EXIT_STATUS=1
fi

# incorrect usage testcase 5 (not enough input files)
echo "I'm the input file #1." > input1.qff
echo "I'm the input file #2." > input2.qff
./fakeflights --cull-time '202006280000' -o output.qff input1.qff input2.qff
if [ $? -eq 0 ]
then
	echo "Test 5: not working properly."
	EXIT_STATUS=1
fi

# incorrect usage testcase 6 (too many input files)
echo "I'm the input file #1." > input1.qff
echo "I'm the input file #2." > input2.qff
echo "I'm the input file #3." > input3.qff
echo "I'm the input file #4." > input4.qff
./fakeflights --cull-time '202006280000' -o output.qff input1.qff input2.qff input3.qff input4.qff
if [ $? -eq 0 ]
then
	echo "Test 6: not working properly."
	EXIT_STATUS=1
fi

exit $EXIT_STATUS