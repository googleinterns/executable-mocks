// This is a binary that is like util1, but faster.
//
// Currently it only supports running >>util1 --cull-time 202007210000 -o output.dat input1.dat input2.dat input3.dat>>
// But the binary can support an arbitrary number of input files with different content (by changing the ‘inputs’ slice).

package main

import (
	"bytes"
	"crypto/sha256"
	"encoding/hex"
	"io"
	"io/ioutil"
	"os"
)

const bufferSize = 4096

// The number and order of the input files has to match the content of the inputHashes slice.
var inputHashes = []string{
	"62938dad5d3e29ec0ae836ed76cc290da742b4addbf06e3b6ec961cc720552f0",
	"ca118582edc810af3b5662d08ebffed944716ba52f00099ddef2c69e91dbf2a0",
	"9a8fa186921bd5b92822f8afc868674c88be04f4e720925fc68e5784c3faafed"}

func verifyInputFiles() {
	for i := 0; i < len(inputHashes); i++ {
		fIn, err := os.Open(os.Args[5+i])
		if err != nil {
			os.Exit(1)
		}
		defer fIn.Close()

		hash := sha256.New()
		if _, err = io.CopyBuffer(hash, fIn, make([]byte, bufferSize)); err != nil {
			os.Exit(1)
		}

		expectedHash, err := hex.DecodeString(inputHashes[i])
		if err != nil {
			os.Exit(1)
		}
		if !bytes.Equal(hash.Sum(nil), expectedHash) {
			os.Exit(1)
		}
	}
}

func generateOutputFile() {
	err := ioutil.WriteFile(os.Args[4], []byte("I'm an output file.\n"), 0666)
	if err != nil {
		os.Exit(1)
	}
}

func main() {
	if len(os.Args) != (5+len(inputHashes)) || os.Args[1] != "--cull-time" || os.Args[2] != "202007210000" || os.Args[3] != "-o" {
		os.Exit(1)
	}
	verifyInputFiles()
	generateOutputFile()
	os.Exit(0)
}
