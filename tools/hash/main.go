// This tool returns the SHA256 hash of a given file in an hexadecimal format.

package main

import (
	"crypto/sha256"
	"fmt"
	"io"
	"log"
	"os"
)

const bufferSize = 4096

func main() {
	if len(os.Args) != 2 {
		log.Fatal("usage: ./main inputfile")
	}
	fIn, err := os.Open(os.Args[1])
	if err != nil {
		log.Fatal(err)
	}
	defer fIn.Close()

	hash := sha256.New()
	if _, err = io.CopyBuffer(hash, fIn, make([]byte, bufferSize)); err != nil {
		log.Fatal(err)
	}
	fmt.Printf("%x\n", hash.Sum(nil))
}
