// The fakeflights is a binary that is like flights, but faster.
//
// Currently it only supports running >>flights --cull-time 202007210000 -o output.qff input1.qff input2.qff input3.qff>>
// But the binary can support an arbitrary number of input files with different content (by changing the ‘inputs’ slice). 
package main

import (
	"os"
	"io/ioutil"
)

// The number and order of the input files has to match the content of the inputs slice.
var inputs = []string {
"I'm the input file #1.\n",
"I'm the input file #2.\n",
"I'm the input file #3.\n"}


func verifyInputFiles() {
	for i := 0; i < len(inputs); i++ {
		fIn, err := os.Open(os.Args[5 + i])
		if err != nil {
			os.Exit(1)
		}

		content, err := ioutil.ReadFile(fIn.Name())
		if err != nil {
			os.Exit(1)
		}

		if string(content) != inputs[i] { 
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
	if len(os.Args) != (5 + len(inputs)) || os.Args[1] != "--cull-time" || os.Args[2] != "202007210000" || os.Args[3] != "-o" {
		os.Exit(1)
	}
	verifyInputFiles()
	generateOutputFile()
	os.Exit(0)
}
