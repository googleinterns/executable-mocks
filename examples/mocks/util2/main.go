/*
 * Copyright 2020 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// This is a binary that is like util2, but faster.
//
// Currently it supports only running >>util2 -t '201809010005' -o outfile -d inputfile>>

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

var inputHash string = "273fec409f32bd0ecbd50d3ab9acf1406efb85f24c89a257e8a3ad3eab197046"

func verifyInput() {
	fIn, err := os.Open(os.Args[6])
	if err != nil {
		os.Exit(1)
	}
	defer fIn.Close()

	hash := sha256.New()
	if _, err = io.CopyBuffer(hash, fIn, make([]byte, bufferSize)); err != nil {
		os.Exit(1)
	}

	expectedHash, err := hex.DecodeString(inputHash)
	if err != nil {
		os.Exit(1)
	}
	if !bytes.Equal(hash.Sum(nil), expectedHash) {
		os.Exit(1)
	}
}

func generateOutput() {
	err := ioutil.WriteFile(os.Args[4], []byte("I'm an output file.\n"), 0666)
	if err != nil {
		os.Exit(1)
	}
}

func main() {
	if len(os.Args) != 7 || os.Args[1] != "-t" || os.Args[2] != "201809010005" || os.Args[3] != "-o" || os.Args[5] != "-d" {
		os.Exit(1)
	}
	verifyInput()
	generateOutput()
	os.Exit(0)
}
