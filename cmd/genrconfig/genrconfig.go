/*
 * Copyright 2020 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package main

import (
  "os"
  "fmt"
  "log"
  "strings"
  
  "github.com/googleinterns/executable-mocks/cmd/bldmock"
  "github.com/golang/protobuf/proto"
)

/*
 * Takes command line arguments and generates a Protocol Buffer configuration file.
 * An example of use is: ./genrconfig binary "strarg:generic string" "infile:tmp/input"
 * The second argudment is the name of the binary and the arguments follow.
 * The arguments must have as a prefix "type:". The type can be: strarg, infile, outpath, outcontent.
 */
func GenerateConfig() {
  if len(os.Args) < 2 {
    log.Fatal("Expected the name of the binary.")
  }
  args := []interface{} {}
  for i := 2; i < len(os.Args); i++ {
    if (strings.HasPrefix(os.Args[i], "strarg:")) {
      args = append(args, bldmock.StrArg(strings.TrimPrefix(os.Args[i], "strarg:")))
    } else if (strings.HasPrefix(os.Args[i], "infile:")) {
      args = append(args, bldmock.InFile(strings.TrimPrefix(os.Args[i], "infile:")))
    } else if (strings.HasPrefix(os.Args[i], "outpath:")) {
      args = append(args, bldmock.OutPath(strings.TrimPrefix(os.Args[i], "outpath:")))
    } else if (strings.HasPrefix(os.Args[i], "outcontent:")) {
      args = append(args, bldmock.OutContent(strings.TrimPrefix(os.Args[i], "outcontent:")))
    } else {
      log.Fatalf("Unexpected argument: %s has an unknown prefix.", os.Args[i])
    }
  }
  mc := bldmock.BuildMockConfig(os.Args[1], args...)
  if _, err := fmt.Print((proto.MarshalTextString(&mc))); err != nil {
      log.Fatal(err)
  }
}

func main() {
  GenerateConfig()
}