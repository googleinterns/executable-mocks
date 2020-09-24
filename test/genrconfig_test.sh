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
# genrconfig_test.sh exercises the generate configuration file function and verifies that it behaves as expected.
# It takes no inputs from commandline, prints issues to stdout and returns a non-zero
# exit status when expectations are not met.

EXIT_STATUS=0

# correct usage testcase 1 (with output path)
echo "INPUT1" > tmp/test-input1
echo "INPUT2" > tmp/test-input2
cmd/genrconfig/genrconfig tar "strarg:-cf" "outpath:tmp/test-output" "infile:tmp/test-input1" "infile:tmp/test-input2" > tmp/tar.textproto 2>&1
if [ $? -ne 0 ] || [ ! -f "tmp/tar.textproto" ] || [ $(cmp -s "test/testdata/testgenrconfig1.textproto" "tmp/tar.textproto")$? -ne 0 ]
then
	echo "Test 1: not working properly."
	EXIT_STATUS=1
fi

# correct usage testcase 2 (with output content)
echo "INPUT1" > tmp/test-input1
echo "INPUT2" > tmp/test-input2
cmd/genrconfig/genrconfig tar "strarg:-cf" "outcontent:OUTPUT" "infile:tmp/test-input1" "infile:tmp/test-input2" > tmp/tar.textproto 2>&1
if [ $? -ne 0 ] || [ ! -f "tmp/tar.textproto" ] || [ $(cmp -s "test/testdata/testgenrconfig2.textproto" "tmp/tar.textproto")$? -ne 0 ]
then
	echo "Test 2: not working properly."
	EXIT_STATUS=1
fi

# incorrect usage testcase 3 (not enough arguments)
echo "INPUT" > tmp/test-input
cmd/genrconfig/genrconfig > tmp/tar.textproto 2>&1
if [ $? -eq 0 ]
then
	echo "Test 3: not working properly."
	EXIT_STATUS=1
fi

# incorrect usage testcase 4 (unknown type of argument)
echo "INPUT" > tmp/test-input
cmd/genrconfig/genrconfig tar "strarg:-cf" "outpath:tmp/output" "inhash:4cb90a97dd7fc70b16eeefa5c3937769b7a35d7ba1a07db400b8d470dacbf030" > tmp/tar.textproto 2>&1
if [ $? -eq 0 ]
then
	echo "Test 4: not working properly."
	EXIT_STATUS=1
fi