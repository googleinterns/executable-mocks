# Executable Mocks

**This is not an officially supported Google product.**

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
