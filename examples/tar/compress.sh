#!/bin/sh

echo "Compressing files..."
tar -czf tmp/output1.tar examples/tar/data/input1 examples/tar/data/input2
echo "Files compressed."