ifndef $(GOPATH)
    GOPATH=$(shell go env GOPATH)
    export GOPATH
endif

all: mocks hash test-mockexec

util2:
	go build -o examples/mocks/util2/util2 github.com/regb/executable-mocks/examples/mocks/util2

util1:
	go build -o examples/mocks/util1/util1 github.com/regb/executable-mocks/examples/mocks/util1

mocks: util2 util1
	bash examples/mocks/test/util2.sh
	bash examples/mocks/test/util1.sh

hash:
	go build -o tools/hash/hash github.com/regb/executable-mocks/tools/hash

proto:
	protoc -I=protos --go_out=${GOPATH}/src protos/mockexec.proto

mockexec: proto
	go build -o cmd/mockexec/mockexec github.com/regb/executable-mocks/cmd/mockexec/

test-mockexec: mockexec
	bash test/mockexec_test.sh

clean:
	rm -rf examples/mocks/util2/util2
	rm -rf examples/mocks/util1/util1
	rm -rf tools/hash/hash
	rm -rf protos/mockexec
	rm -rf tmp/*
	rm -rf cmd/mockexec/mockexec

.PHONY: all util2 util1 mocks hash proto mockexec test-mockexec clean
