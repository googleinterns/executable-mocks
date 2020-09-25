# Executable Mocks

A tool that mocks executables to make tests more effective.

## Table of contents
- [Overview](#Overview)]
- [Getting started](#Getting-started)
- [Description](#Description)]
- [Structure](#Structure)
- [Usage](#Usage)
- [Authors](#Authors)
- [License](#License)
- [Disclaimer](#Disclaimer)

## Overview

Testing a program that consists of some resource-intensive utilities becomes resource-intensive too. When those utilities are already tested, we don't need to run them when testing programs that use them. In fact, it is enough to check that the interaction between the program and the utility is correct. By replacing the utilities with mocks, we can make the tests more effective without compromising their integrity and validity.

We have created a tool to generate mocks in a simple way. 

## Getting Started

Before you start, make sure that you have [Golang](https://github.com/golang/go)
and [Protocol Buffers](https://github.com/protocolbuffers/protobuf/releases/tag/v3.13.0) packages installed.

After that clone this repo and run `make` and you're good to go.

## Usage

As an instruction on how to use this tool we're going to give you an example of how to mock the `tar` utility.

[compress](https://github.com/googleinterns/executable-mocks/blob/master/examples/tar/compress.sh) is a program that uses the `tar` utility. The program echoes some lines and stores some files in a new file.

The tests of `compress` are slow because they run `compress`, which executes the `tar` utility. However, the `tar` utility is already tested, so the `compress` tests would run it without need. To make them faster, we are going to mock the `tar` utility for the `compress` tests.

To build the required binaries, we run the `example` Makefile rule: `make example`.

Note that the files `input1`, `input2` and `output1.tar` need to exist before running the utility. The input files need to exist in the `examples/tar/data/` directory and they can have any content.
For example, to have a resource-intensive utility, we could create heavy files with 
```shell script
fallocate -l 0.5G examples/tar/data/input1
``` 
and 
```shell script
fallocate -l 0.5G examples/tar/data/input2
```
 To create `output1.tar`, we can run `compress` once with 
 ```shell script
 bash examples/tar/compress.sh
```

### Creating the mock

`compress` runs the command:
```shell script
tar -czf tmp/output1.tar examples/tar/data/input1 examples/tar/data/input2
```

We use the `genrconfig` tool to create the mock:

```shell script 
cmd/genrconfig/genrconfig tar "strarg:-czf" "outpath:tmp/output1.tar" "infile:examples/tar/data/input1" "infile:examples/tar/data/input2" > tmp/tar-test1.textproto
```

Now we have a file `tmp/tar-test1.textproto` with the configuration for this case.

### Using the mocks

We replace the call to the original binary with a call to the mock.

We use the `mockexec` tool to mock the utility, by replacing 
```shell script
tar -czf tmp/output1.tar examples/tar/data/input1 examples/tar/data/input2
``` 
in `compress` with
 ```shell script
 ./mockexec examples/tar/tar-test1.textproto -czf tmp/output1.tar examples/tar/data/input1 examples/tar/data/input2
```

The changed file is [compress-mocks](https://github.com/googleinterns/executable-mocks/blob/master/examples/tar/compress-mocks.sh).

Now, `compress-mocks` uses a mock of `tar` with the same arguments and behaviour as `compress`, except that it doesn't run the real utility. It can be run with `bash examples/tar/compress-mocks.sh`

### Results

We use 0.5GB input files.

Running `compress` takes an average of 7.81 seconds while running `compress-mocks` takes an average of 2.59 seconds, with 10 repetitions each. This makes it about 3 times faster. Note that `compress-mocks` takes this time because it still needs to calculate the hash of the files to check that they are correct.

When using more resource intensive utilities, the change can be significant. Also note that this tool can be used in different use cases.

## Structure

### `/cmd`

Main functions for the project - `mockexec.go`, `genrconfig.go` and `bldmock.go`.

### `/configs`

The configuration files for example functions `util1` and `util2`.

### `/examples`

Simple example mocks of `util1` and `util2` along with the shell scripts for testing.
A descriptive example of how to use the generic mock utility when mocking `tar` utility.

### `/protos`

The `.proto` file with all the message types. 

### `/test`

Tests for `mockexec.go`, `genrconfig.go` and `bldmock.go` along with the configuration files for them.

### `/tools`

Right now this directory only has a function to calculate the hash of an input file.

## Description

Writing a mock for many different binaries is not a feasible solution. This is why we have created a customizable tool, that reads a configuration file and starts to behave like the utility we need. 

### Design 

To implement mock executables we use [protocol buffers](https://developers.google.com/protocol-buffers).
Each utility is called by a command that consists of a name of that utility and several specific 
arguments, in a command line style:

```shell script
util1 --cull-time '202007210000' -o tmp/output.dat tmp/input1.dat tmp/input2.dat tmp/input3.dat
```
When a generic mock executable is called, it checks that the utility is being used
correctly by verifying that the command matches the configuration of the protocol buffer
and it also produces a custom output, if necessary.

An instance of the [message type](https://developers.google.com/protocol-buffers/docs/proto#simple)
is created with a configuration file that contains information such as the expected 
flags and input files. As input files might be large, we operate with their hashes. 

A generic utility will be called instead of the utility by specifying the arguments.
The configuration file is read from `stdin` channel and also contains the name of the existing 
utility that needs to be used. Therefore, the generic mock executable has enough information 
about the utility and the particular test. The command would be similar to:

```shell script
./mockexec --cull-time 202007210000 -o output.dat input1.dat input2.dat input3.dat < config.textproto
```

### Input files

The content of input files sometimes can be very large and comparing it directly can be
very ineffective. To avoid this, we calculate the hash of the input content and check that it matches
the hash of the expected input. We use the sha256 hash function.

### Output file

When the utility produces an output, the tool gives two options to indicate its content.
Only one option can be chosen at the same time. You can either set the `out_path` field (used for larger content) 
or you can set the `out_content` field (used for smaller content). 

### Configuration file

To generate the configuration files, we use the `BuildMockConfig` function, which takes the name of the binary
and the arguments which are of certain types and builds the `MockCall` protocol buffer.

The configuration file for each utility can be written manually by following a series of syntax rules. 
To make this procedure easier, we have implemented the `genrconfig` tool. It uses the `BuildMockConfig` function 
to produce the following configuration file and prints it to `stdout` channel.
One example of use would be:

```shell script
./genrconfig example "strarg:-t" "strarg:SOME STRING" "strarg:-o" "outpath:tmp/test-output" "infile:tmp/test-input" > config.textproto
```

## Authors 

- [Maria Prat](https://github.com/mariaprat)
- [Sabina Dayanova](https://github.com/sabinadayanova)
- [Regis Blanc](https://github.com/regb)
- [Rodolpho Eckhardt](https://github.com/rodolphoeck)

## License 

[Apache 2.0 License](LICENSE)

## Disclaimer

**This is not an officially supported Google product.**
