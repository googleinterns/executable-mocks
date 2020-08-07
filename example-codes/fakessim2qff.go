// The fakessim2qff is a binary that is like ssim2qff, but faster.
//
// Currently it supports only running >>ssim2qff -t '201809010005' -o outfile -d inputfile>>
package main

import (
    "fmt"
    "io"
    "os"
    "io/ioutil"
    "crypto/sha256"
)

const bufferSize = 4096
var inputHash string = "273fec409f32bd0ecbd50d3ab9acf1406efb85f24c89a257e8a3ad3eab197046"

func verifyInput() {
    fIn, err := os.Open(os.Args[6])
    if err != nil  {
        os.Exit(1) 
    }
    defer fIn.Close()

    hash := sha256.New()
    if _, err = io.CopyBuffer(hash, fIn, make([]byte, bufferSize)); err != nil {
        os.Exit(1)
    }
    if fmt.Sprintf("%x", hash.Sum(nil)) != inputHash { 
        os.Exit(1)
    }
}

func generateOutput() {
    err := ioutil.WriteFile(os.Args[4], []byte("I'm an output file.\n"), 0666) // TODO: Write right content
        if err != nil {
        os.Exit(1)
    }
}

func main() {
    if len(os.Args) != 7 || os.Args[1] != "-t" || os.Args[2] != "201809010005" || os.Args[3] != "-o" || os.Args[5] != "-d"  {
   	 os.Exit(1)
    }
    verifyInput()
    generateOutput()
    os.Exit(0)
}
