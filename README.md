# Executable Mocks

**This is not an officially supported Google product.**

## Example

As an example of how to use this tool, we are going to mock the `tar` utility.

[compress](https://github.com/googleinterns/executable-mocks/examples/tar/compre
ss.sh) is a program that uses the `tar` utility. The program echoes some lines
and stores some files in a new file.

The tests of `compress` will be slow because they run `compress`, that executes
the `tar` utility. However, the `tar` utility is already tested, so the
`compress` tests would run it without need. To make them faster, we are going
to mock the `tar` utility for the `compress` tests.

To build the required binaries, we run the `example` Makefile rule: `make
example`.

Note that the files `input1`, `input2` and `output1.tar` need to exist before.
The input files need to exist in the `examples/tar/data/` directory and they
can be anything. For example, to have a resource-intensive utility, we could
create heavy files with `fallocate -l 0.5G examples/tar/data/input1` and
`fallocate -l 0.5G examples/tar/data/input2` To create `output1.tar`, we can
run `compress` once with `bash examples/tar/compress.sh`.

### Creating the mock

`compress` runs the command:
`tar -cf tmp/output1.tar examples/tar/data/input1 examples/tar/data/input2`

We use the `genrconfig` tool to create the mock:

`cmd/genrconfig/genrconfig tmp/tar-test1 tar "strarg:-cf"
"outpath:tmp/output1.tar" "infile:examples/tar/data/input1"
"infile:examples/tar/data/input2"`

Now, we have a file `tmp/tar-test1.textproto` with the configuration for this
case.

### Using the mocks

We replace the call to the original binary with a call to the mock.

We use the `mockexec` tool to mock the utility, by replacing `tar -cf
tmp/output1.tar examples/tar/data/input1 examples/tar/data/input2` in
`compress` with `./mockexec examples/tar/tar-test1.textproto -cf
tmp/output1.tar examples/tar/data/input1 examples/tar/data/input2`.

The changed file is
[compress-mocks](https://github.com/googleinterns/executable-mocks/examples/tar/
compress-mocks.sh).

Now, `compress-mocks` uses a mock of `tar` with the same arguments and
behaviour as `compress`, except that it doesn't run the real utility. It can be
run with `bash examples/tar/compress-mocks.sh`

### Results

We use 0.5GB input files.

Running `compress` takes an average of 7.81 seconds while running
`compress-mocks` takes an average of 2.59 seconds, with 10 repetitions each.
This makes it about 3 times faster.

When using more resource intensive utilities, the change can be really
significant. Also note that this tool can be used in different use cases.

## Code Reviews

Most non-trivial change should go through review before being committed. It's
acceptable to skip a review for a documentation change, fixing a comment,
fixing a typo, or a very trivial change, we trust contributors to use their
best judgement for when it's worth asking for a code review.

The review process is meant to review a single commit, multiple commits should be
reviewed in separate pull requests. In order to ask for a review, you need a
branch pointing to the commit to review, which should be directly based on master.
You can open a pull request for the branch, and ask other contributers to
review the changes.

If the reviewers offer comments that lead to code changes, you can implement them
with small update commits on the same branch. Once you address all the comments,
you can push the branch again, and that should update the pull request with
the new code. The review can continue with more comments on the new version of the
code.

After a few iteration, once the reviewer is happy with the state of the code,
we are ready to merge to master. In order to keep a clean history, we want to
squash all the small commits into the original commit, update the description
accordingly, keep a link to the pull request for reference, and rebase this
commit on master.  The GitHub interface with the "Squash and Commit" button on
the pull request should be able to do just that.
