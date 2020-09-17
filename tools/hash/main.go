// Copyright 2020 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
