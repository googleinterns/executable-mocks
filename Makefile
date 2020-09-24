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

ifndef $(GOPATH)
    GOPATH=$(shell go env GOPATH)
    export GOPATH
endif

all: mocks hash test-mockexec test-bldmock test-genrconfig

util2:
	go build -o examples/mocks/util2/util2 github.com/googleinterns/executable-mocks/examples/mocks/util2

util1:
	go build -o examples/mocks/util1/util1 github.com/googleinterns/executable-mocks/examples/mocks/util1

mocks: util2 util1
	mkdir -p tmp/
	bash examples/mocks/test/util2.sh
	bash examples/mocks/test/util1.sh

hash:
	go build -o tools/hash/hash github.com/googleinterns/executable-mocks/tools/hash

proto:
	protoc -I=protos --go_out=${GOPATH}/src protos/mockexec.proto

mockexec: proto
	go build -o cmd/mockexec/mockexec github.com/googleinterns/executable-mocks/cmd/mockexec/

test-mockexec: mockexec
	mkdir -p tmp/
	bash test/mockexec_test.sh

bldmock: proto
	go build -o cmd/bldmock/bldmock github.com/googleinterns/executable-mocks/cmd/bldmock/

test-bldmock: bldmock
	go run test/bldmocktest.go

genrconfig: bldmock
	go build -o cmd/genrconfig/genrconfig github.com/googleinterns/executable-mocks/cmd/genrconfig/
  
test-genrconfig: genrconfig
	mkdir -p tmp/
	bash test/genrconfig_test.sh

example: genrconfig mockexec

clean:
	rm -rf examples/mocks/util2/util2
	rm -rf examples/mocks/util1/util1
	rm -rf tools/hash/hash
	rm -rf protos/mockexec
	rm -rf tmp/*
	rm -rf cmd/mockexec/mockexec
	rm -rf cmd/bldmock/bldmock
	rm -rf cmd/genrconfig/genrconfig

.PHONY: all util2 util1 mocks hash proto mockexec test-mockexec bldmock test-bldmock genrconfig test-genrconfig example clean
