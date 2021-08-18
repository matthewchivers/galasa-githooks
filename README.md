# Galasa Githooks

GitHooks for Galasa repositories.

The idea is to build a generic set of GitHooks to enable a stable and replicable development environment.

## Idea
Use the six most useful git hooks:
* pre-commit
    > Executed every time you run `git commit` before Git asks for a commit mesage or generates the commit object.
    > Non-zero exit aborts the commit
* prepare-commit-msg
    > Executed after pre-commit to populate the text editor with a commit mesage.
    > Non-zero exit aborts the commit
* commit-msg
    > Called just _after_ the user enters a commit message.
    > Non-zero exit aborts the commit
* post-commit
    > Called after the commit-msg hook. Non-zero exit will NOT abort the commit. Mostly for notifications etc.
* post-checkout
    > Useful for some kind of local CI/CD ?
* pre-rebase
    > Called before `git rebase` changes anything. Useful for making sure something terrible isn't about to happen.

### Notes:
1. Scripts can be written in any scripting language that supports a shebang at the top of the document and can run locally.