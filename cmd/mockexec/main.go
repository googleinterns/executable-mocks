/*
Copyright 2020 Google LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
package main

import (
	"bytes"
	"crypto/sha256"
	"encoding/hex"
	"io"
	"io/ioutil"
	"log"
	"os"
	"strings"

	"github.com/golang/protobuf/proto"
	pb "github.com/regb/executable-mocks/protos/mockexec"
)

const bufferSize = 4096

func main() {
	if len(os.Args) < 2 {
		log.Fatal("Expected the path of the configuration file")
	}
	t, err := ioutil.ReadFile(os.Args[1])
	if err != nil {
		log.Fatal(err)
	}
	c := &pb.MockCall{}
	if err := proto.UnmarshalText(string(t), c); err != nil {
		log.Fatal(err)
	}
	if len(os.Args)-2 != len(c.Args) {
		log.Fatalf("Expected %v arguments but got %v", len(c.Args), len(os.Args)-2)
	}

	// TODO: check the name of the utility.

	var sourcePath string
	var sourceContent string
	var destPath string

	for i := 2; i < len(os.Args); i++ {
		// TODO: perform the checks in parallel
		switch x := c.Args[i-2].Arg.(type) {
		case *pb.Argument_StrArg:
			if x.StrArg != os.Args[i] {
				log.Fatalf("String arguments don't match: want %q; got %q", x.StrArg, os.Args[i])
			}
		case *pb.Argument_InHash:
			fIn, err := os.Open(os.Args[i])
			if err != nil {
				log.Fatal(err)
			}

			hash := sha256.New()
			if _, err = io.CopyBuffer(hash, fIn, make([]byte, bufferSize)); err != nil {
				log.Fatal(err)
			}

			expectedHash, err := hex.DecodeString(x.InHash)
			if err != nil {
				log.Fatal(err)
			}

			if !bytes.Equal(hash.Sum(nil), expectedHash) {
				log.Fatalf("The hash of the file %v doesn't match the expected one", os.Args[i])
			}

			fIn.Close()
		case *pb.Argument_OutPath:
			sourcePath = x.OutPath
			destPath = os.Args[i]
		case *pb.Argument_OutContent:
			sourceContent = x.OutContent
			destPath = os.Args[i]
		default:
			log.Fatalf("Unexpected argument type %T", x)
		}
	}

	if destPath == "" {
		log.Fatalf("The destination path (%q) of the output file must be set", destPath)
	}

	if (sourceContent != "") && (sourcePath != "") {
		log.Fatalf("Only one of the source content (%q) or the source path (%q) of the output file can be set", sourceContent, sourcePath)
	}

	fDest, err := os.Create(destPath)
	if err != nil {
		log.Fatal(err)
	}

	if sourcePath != "" {
		fSrc, err := os.Open(sourcePath)
		if err != nil {
			log.Fatal(err)
		}

		if _, err = io.CopyBuffer(fDest, fSrc, make([]byte, bufferSize)); err != nil {
			log.Fatal(err)
		}
	} else if sourceContent != "" {
		if _, err = io.CopyBuffer(fDest, strings.NewReader(sourceContent), make([]byte, bufferSize)); err != nil {
			log.Fatal(err)
		}
	}
}
