#!/bin/sh

echo "Compressing files..."
cmd/mockexec/mockexec tmp/tar-test1.textproto -cf tmp/output1.tar examples/tar/data/input1 examples/tar/data/input2echo
echo "Files compressed."