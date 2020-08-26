ifndef $(GOPATH)
    GOPATH=$(shell go env GOPATH)
    export GOPATH
endif

all: mocks hash mockexec

ssim2qff:
	go build -o examples/mocks/ssim2qff/ssim2qff github.com/regb/executable-mocks/examples/mocks/ssim2qff

flights:
	go build -o examples/mocks/flights/flights github.com/regb/executable-mocks/examples/mocks/flights

mocks: ssim2qff flights
	bash examples/mocks/test/ssim2qff.sh
	bash examples/mocks/test/flights.sh

hash:
	go build -o tools/hash/hash github.com/regb/executable-mocks/tools/hash

proto:
	protoc -I=protos --go_out=${GOPATH}/src protos/mockexec.proto

mockexec: proto
	go run cmd/mockexec/main.go --cull-time 202007210000 -o tmp/result tmp/test-input

clean:
	rm -rf examples/mocks/ssim2qff/ssim2qff
	rm -rf examples/mocks/flights/flights
	rm -rf tools/hash/hash
	rm -rf input output *.qff
	rm -rf protos/mockexec
	rm -rf tmp/result

.PHONY: all ssim2qff flights mocks hash proto mockexec clean
