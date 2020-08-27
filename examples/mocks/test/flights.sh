#!/bin/sh
# flights.sh exercises the flights mock and verifies that it behaves as expected.
# It takes no inputs from commandline, prints issues to stdout and returns a non-zero
# exit status when expectations are not met.

EXIT_STATUS=0

# correct usage testcase 1
echo "I'm the input file #1." > tmp/input1.qff
echo "I'm the input file #2." > tmp/input2.qff
echo "I'm the input file #3." > tmp/input3.qff
examples/mocks/flights/flights --cull-time '202007210000' -o tmp/output.qff tmp/input1.qff tmp/input2.qff tmp/input3.qff
if [ $? -ne 0 ] || [ ! -f "./tmp/output.qff" ] || [ "$(cat tmp/output.qff)" != "I'm an output file." ]
then
	echo "Test 1: not working properly."
	EXIT_STATUS=1
fi

# incorrect usage testcase 2 (misses output flags)
echo "I'm the input file #1." > tmp/input1.qff
echo "I'm the input file #2." > tmp/input2.qff
echo "I'm the input file #3." > tmp/input3.qff
examples/mocks/flights/flights --cull-time '202007210000' tmp/input1.qff tmp/input2.qff tmp/input3.qff
if [ $? -eq 0 ]
then
	echo "Test 2: not working properly."
	EXIT_STATUS=1
fi

# incorrect usage testcase 3 (wrong input file content)
echo "I'm the input file #1." > tmp/input1.qff
echo "I'm the input file #3." > tmp/input2.qff
echo "I'm the input file #3." > tmp/input3.qff
examples/mocks/flights/flights --cull-time '202007210000' -o tmp/output.qff tmp/input1.qff tmp/input2.qff tmp/input3.qff
if [ $? -eq 0 ]
then
	echo "Test 3: not working properly."
	EXIT_STATUS=1
fi

# incorrect usage testcase 4 (wrong timestamp)
echo "I'm the input file #1." > tmp/input1.qff
echo "I'm the input file #2." > tmp/input2.qff
echo "I'm the input file #3." > tmp/input3.qff
examples/mocks/flights/flights --cull-time '202006280000' -o tmp/output.qff tmp/input1.qff tmp/input2.qff tmp/input3.qff
if [ $? -eq 0 ]
then
	echo "Test 4: not working properly."
	EXIT_STATUS=1
fi

# incorrect usage testcase 5 (not enough input files)
echo "I'm the input file #1." > tmp/input1.qff
echo "I'm the input file #2." > tmp/input2.qff
examples/mocks/flights/flights --cull-time '202006280000' -o tmp/output.qff tmp/input1.qff tmp/input2.qff
if [ $? -eq 0 ]
then
	echo "Test 5: not working properly."
	EXIT_STATUS=1
fi

# incorrect usage testcase 6 (too many input files)
echo "I'm the input file #1." > tmp/input1.qff
echo "I'm the input file #2." > tmp/input2.qff
echo "I'm the input file #3." > tmp/input3.qff
echo "I'm the input file #4." > tmp/input4.qff
examples/mocks/flights/flights --cull-time '202006280000' -o tmp/output.qff tmp/input1.qff tmp/input2.qff tmp/input3.qff tmp/input4.qff
if [ $? -eq 0 ]
then
	echo "Test 6: not working properly."
	EXIT_STATUS=1
fi

exit $EXIT_STATUS