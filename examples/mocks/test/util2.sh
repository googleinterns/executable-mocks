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

# util2.sh exercises the util2 mock and verifies that it behaves as expected.
# It takes no inputs from commandline, prints issues to stdout and returns a non-zero
# exit status when expectations are not met.

EXIT_STATUS=0

# correct usage testcase 1
echo "I'm an input file." > tmp/input
examples/mocks/util2/util2 -t '201809010005' -o tmp/output -d tmp/input
if [ $? -ne 0 ] || [ ! -f "./tmp/output" ] || [ "$(cat tmp/output)" != "I'm an output file." ]
then
	echo "Test 1: not working properly."
	EXIT_STATUS=1
fi

# incorrect usage testcase 2 (misses output flags)
echo "I'm an input file." > tmp/input
examples/mocks/util2/util2 -t '201809010005' -d tmp/input
if [ $? -eq 0 ]
then
	echo "Test 2: not working properly."
	EXIT_STATUS=1
fi

# incorrect usage testcase 3 (wrong input file content)
echo "I'm an incorrect input file." > tmp/input
examples/mocks/util2/util2 -t '201809010005' -o tmp/output -d tmp/input
if [ $? -eq 0 ]
then
	echo "Test 3: not working properly."
	EXIT_STATUS=1
fi

# incorrect usage testcase 4 (wrong timestamp)
echo "I'm an input file." > tmp/input
examples/mocks/util2/util2 -t '0' -o tmp/output -d tmp/input
if [ $? -eq 0 ]
then
	echo "Test 4: not working properly."
	EXIT_STATUS=1
fi

exit $EXIT_STATUS
