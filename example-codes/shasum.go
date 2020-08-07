package main

import (
    "os"
    "log"
    "crypto/sha256"
    "io"
    "fmt"
)

const bufferSize = 4096

func main() {
    if len(os.Args) != 1 {
	log.Fatal("usage: ./shasum inputfile")
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
