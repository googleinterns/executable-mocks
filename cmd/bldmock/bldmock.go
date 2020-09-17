package bldmock

import (
  "log"
  "crypto/sha256"
  "os"
  "io"
  "fmt"
  
  pb "github.com/regb/executable-mocks/protos/mockexec"
)

type StrArg string
type InFile string
type OutPath string
type OutContent string


const bufferSize = 4096

// Takes the path to a file and outputs the SHA256 checksum of the file
// in an hexadecimal format.
func generateFileHash(file string) string {
	fIn, err := os.Open(file)
  if err != nil {
  	log.Fatal(err)
	}
	defer fIn.Close()
	hash := sha256.New()
	if _, err = io.CopyBuffer(hash, fIn, make([]byte, bufferSize)); err != nil {
		log.Fatal(err)
	}
	return fmt.Sprintf("%x", hash.Sum(nil))
}

// Takes the name of the binary and a sequence of arguments and returns a MockCall.
// Each argument is a string of one of the following four types: StrArg, InFile, OutPath, OutContent
func BuildMockConfig(name string, args ...interface{}) pb.MockCall {
  
  mc := pb.MockCall {
    Binary: name,
    Args: []*pb.Argument{},
  }
  
  for _, arg := range args {
    switch t := arg.(type) {
      case StrArg:
        mc.Args = append(mc.Args, &pb.Argument{Arg: &pb.Argument_StrArg{string(arg.(StrArg))}})
      case InFile:
        mc.Args = append(mc.Args, &pb.Argument{Arg: &pb.Argument_InHash{generateFileHash(string(arg.(InFile)))}})
      case OutPath:
        mc.Args = append(mc.Args, &pb.Argument{Arg: &pb.Argument_OutPath{string(arg.(OutPath))}})
      case OutContent:
        mc.Args = append(mc.Args, &pb.Argument{Arg: &pb.Argument_OutContent{string(arg.(OutContent))}})
      default:
        log.Fatalf("Unexpected argument type %T", t)
    }
  }
  
  return mc
}

