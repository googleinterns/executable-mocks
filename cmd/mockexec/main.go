package main

import (
  "io/ioutil"
  "log"
  "os"
  "io"
  "bytes"
  "encoding/hex"
  "crypto/sha256"

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
  c := &pb.CommandLine{}
  if err := proto.UnmarshalText(string(t), c); err != nil {
    log.Fatal(err)
  }
  if len(os.Args) - 2 != len(c.Args) {
    log.Fatalf("Expected %v arguments but got %v", len(c.Args), len(os.Args) - 2)
  }
  
  // TODO: check the name of the utility.

  var sourcePath string
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
    default:
      log.Fatalf("Unexpected argument type %T", x)
    }
  }
  
  if (sourcePath == "") || (destPath == "") {
    log.Fatalf("Both source path (%q) and  destination path (%q) must be set", sourcePath, destPath)
  }
  
  fDest, err := os.Create(destPath)
  if err != nil {
     log.Fatal(err)
  }

  fSrc, err := os.Open(sourcePath)
  if err != nil {
     log.Fatal(err)
  }

  if _, err = io.CopyBuffer(fDest, fSrc, make([]byte, bufferSize)); err != nil {
    log.Fatal(err)
  }
}
