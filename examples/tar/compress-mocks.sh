#!/bin/sh

echo "Compressing files..."
cmd/mockexec/mockexec -czf tmp/output1.tar examples/tar/data/input1 examples/tar/data/input2 < tmp/tar-test1.textproto
echo "Files compressed."
