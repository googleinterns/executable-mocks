#!/bin/sh

# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# util1.sh exercises the util1 mock and verifies that it behaves as expected.
# It takes no inputs from commandline, prints issues to stdout and returns a non-zero
# exit status when expectations are not met.

EXIT_STATUS=0

# correct usage testcase 1
echo "I'm the input file #1." > tmp/input1.dat
echo "I'm the input file #2." > tmp/input2.dat
echo "I'm the input file #3." > tmp/input3.dat
examples/mocks/util1/util1 --cull-time '202007210000' -o tmp/output.dat tmp/input1.dat tmp/input2.dat tmp/input3.dat
if [ $? -ne 0 ] || [ ! -f "./tmp/output.dat" ] || [ "$(cat tmp/output.dat)" != "I'm an output file." ]
then
	echo "Test 1: not working properly."
	EXIT_STATUS=1
fi

# incorrect usage testcase 2 (misses output flags)
echo "I'm the input file #1." > tmp/input1.dat
echo "I'm the input file #2." > tmp/input2.dat
echo "I'm the input file #3." > tmp/input3.dat
examples/mocks/util1/util1 --cull-time '202007210000' tmp/input1.dat tmp/input2.dat tmp/input3.dat
if [ $? -eq 0 ]
then
	echo "Test 2: not working properly."
	EXIT_STATUS=1
fi

# incorrect usage testcase 3 (wrong input file content)
echo "I'm the input file #1." > tmp/input1.dat
echo "I'm the input file #3." > tmp/input2.dat
echo "I'm the input file #3." > tmp/input3.dat
examples/mocks/util1/util1 --cull-time '202007210000' -o tmp/output.dat tmp/input1.dat tmp/input2.dat tmp/input3.dat
if [ $? -eq 0 ]
then
	echo "Test 3: not working properly."
	EXIT_STATUS=1
fi

# incorrect usage testcase 4 (wrong timestamp)
echo "I'm the input file #1." > tmp/input1.dat
echo "I'm the input file #2." > tmp/input2.dat
echo "I'm the input file #3." > tmp/input3.dat
examples/mocks/util1/util1 --cull-time '202006280000' -o tmp/output.dat tmp/input1.dat tmp/input2.dat tmp/input3.dat
if [ $? -eq 0 ]
then
	echo "Test 4: not working properly."
	EXIT_STATUS=1
fi

# incorrect usage testcase 5 (not enough input files)
echo "I'm the input file #1." > tmp/input1.dat
echo "I'm the input file #2." > tmp/input2.dat
examples/mocks/util1/util1 --cull-time '202006280000' -o tmp/output.dat tmp/input1.dat tmp/input2.dat
if [ $? -eq 0 ]
then
	echo "Test 5: not working properly."
	EXIT_STATUS=1
fi

# incorrect usage testcase 6 (too many input files)
echo "I'm the input file #1." > tmp/input1.dat
echo "I'm the input file #2." > tmp/input2.dat
echo "I'm the input file #3." > tmp/input3.dat
echo "I'm the input file #4." > tmp/input4.dat
examples/mocks/util1/util1 --cull-time '202006280000' -o tmp/output.dat tmp/input1.dat tmp/input2.dat tmp/input3.dat tmp/input4.dat
if [ $? -eq 0 ]
then
	echo "Test 6: not working properly."
	EXIT_STATUS=1
fi

exit $EXIT_STATUS
