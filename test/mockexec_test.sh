#!/bin/sh
#
# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# mockexec_test.sh exercises the mock executable and verifies that it behaves as expected.
# It takes no inputs from commandline, prints issues to stdout and returns a non-zero
# exit status when expectations are not met.

EXIT_STATUS=0

# correct usage testcase 1 (with output path)
echo "INPUT" > tmp/test-input
echo "OUTPUT" > tmp/test-output
cmd/mockexec/mockexec test/testdata/testconfig_path.textproto -t 'SOME STRING' -o tmp/result tmp/test-input > /dev/null 2>&1
if [ $? -ne 0 ] || [ ! -f "tmp/result" ] || [ "$(cat tmp/result)" != "OUTPUT" ]
then
	echo "Test 1: not working properly."
	EXIT_STATUS=1
fi

# correct usage testcase 2 (with output content)
echo "INPUT" > tmp/test-input
cmd/mockexec/mockexec test/testdata/testconfig_content.textproto -t 'SOME STRING' -o tmp/result tmp/test-input > /dev/null 2>&1
if [ $? -ne 0 ] || [ ! -f "tmp/result" ] || [ "$(cat tmp/result)" != "I AM AN OUTPUT" ]
then
	echo "Test 2: not working properly."
	EXIT_STATUS=1
fi

# incorrect usage testcase 3 (too many arguments)
echo "INPUT" > tmp/test-input
echo "OUTPUT" > tmp/test-output
cmd/mockexec/mockexec test/testdata/testconfig_path.textproto -t 'SOME STRING' -o tmp/result tmp/test-input 'TEST' > /dev/null 2>&1
if [ $? -eq 0 ]
then
	echo "Test 3: not working properly."
	EXIT_STATUS=1
fi

# incorrect usage testcase 4 (not enough arguments)
echo "INPUT" > tmp/test-input
echo "OUTPUT" > tmp/test-output
cmd/mockexec/mockexec test/testdata/testconfig_path.textproto -t 'SOME STRING' -o tmp/result > /dev/null 2>&1
if [ $? -eq 0 ]
then
	echo "Test 4: not working properly."
	EXIT_STATUS=1
fi

# incorrect usage testcase 5 (wrong string content)
echo "INPUT" > tmp/test-input
echo "OUTPUT" > tmp/test-output
cmd/mockexec/mockexec test/testdata/testconfig_path.textproto -t 'THIS IS NOT SOME STRING' -o tmp/result tmp/test-input > /dev/null 2>&1
if [ $? -eq 0 ]
then
	echo "Test 5: not working properly."
	EXIT_STATUS=1
fi

# incorrect usage testcase 6 (wrong flag)
echo "INPUT" > tmp/test-input
echo "OUTPUT" > tmp/test-output
cmd/mockexec/mockexec test/testdata/testconfig_path.textproto -d 'SOME STRING' -o tmp/result tmp/test-input > /dev/null 2>&1
if [ $? -eq 0 ]
then
	echo "Test 6: not working properly."
	EXIT_STATUS=1
fi

# incorrect usage testcase 7 (wrong input file content)
echo "NOT AN INPUT" > tmp/test-input
echo "OUTPUT" > tmp/test-output
cmd/mockexec/mockexec test/testdata/testconfig_path.textproto -t 'SOME STRING' -o tmp/result tmp/test-input > /dev/null 2>&1
if [ $? -eq 0 ]
then
	echo "Test 7: not working properly."
	EXIT_STATUS=1
fi

# incorrect usage testcase 8 (missing configuration file)
echo "INPUT" > tmp/test-input
echo "OUTPUT" > tmp/test-output
cmd/mockexec/mockexec -t 'SOME STRING' -o tmp/result tmp/test-input > /dev/null 2>&1
if [ $? -eq 0 ]
then
	echo "Test 8: not working properly."
	EXIT_STATUS=1
fi

# incorrect usage testcase 9 (nonexistent configuration file)
echo "INPUT" > tmp/test-input
echo "OUTPUT" > tmp/test-output
cmd/mockexec/mockexec test/testdata/notestconfig.textproto -t 'SOME STRING' -o tmp/result tmp/test-input > /dev/null 2>&1
if [ $? -eq 0 ]
then
	echo "Test 9: not working properly."
	EXIT_STATUS=1
fi

# incorrect usage testcase 10 (configuration file with both output path and output content)
echo "INPUT" > tmp/test-input
echo "OUTPUT" > tmp/test-output
cmd/mockexec/mockexec test/testdata/testconfig_both.textproto -t 'SOME STRING' -o tmp/result tmp/test-input > /dev/null 2>&1
if [ $? -eq 0 ]
then
	echo "Test 10: not working properly."
	EXIT_STATUS=1
fi




exit $EXIT_STATUS
