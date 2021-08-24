# Galasa Githooks

GitHooks for Galasa repositories.

## Premise

The aim of this project is to make local development of Galasa faster and easier, as well as increase the quality of pull-requests.

Git hooks are customisable scripts that can be triggered when certain actions occur. They can run locally (client side) or remotely (server side). This project is a collection of local git hooks. Client side hooks are triggered by git operations such as committing or merging. 

These hooks can provide value by ensuring staged code builds successfully and passes tests before allowing a commit, or ensuring a commit message is signed by the author. Many other actions exist, such as linting code, ensuring copyright headers are in place, and any other desired (scriptable) action.

### Why this project?

Galasa has a large number of repositories that require similar checks to eachother, and so can utilise the same git hooks. That said, Githooks are infamous for the need to replicate and/or configure across each repository where they are required. The amount of work (and repetition) required to keep githooks up to date across repositories often leads to them becoming outdated, broken, and (ultimately) abandonned and useless.

The aim of this project is to create a set of hooks that can be maintained in a single location whilst ensuring the changes made are pervasive across every repository that requires them.

### How does it work?

1) Create an authoritative source of git hooks / scripts (e.g. this repository)
2) Link from each repository to the authoritative source (e.g. symlink)
3) Any change to the authoritative source is pervasive throughout all repositories that link to it.

This method ensures that git repositories themselves need only be set up once (and even this setup can be largely automated). Any further changes to the authoritative source will always be applied to the repository in question because the repository is already linked to the files and directories being changed. Only a truly major change would require work at repository-level (an idempotent setup script could provide update functionality).

### Functionality

The current functionality provided by the scripts in this repository are:
* Linting 
    * Uses checkstyle to lint Java source files.
    * This currently uses a slightly-modified version of the Google Java standards.
    * The standards chosen probably needs to change, but was a good solution in the time I had.
* Ensuring copyright headers are correct on `*.java` files
    * Part of linting, but worth mentioning on its own.
* Ensuring commits are signed.
* Ensuring gradle builds pass before allowing a commit.

Future functionality could involve static analysis of code, or enforcing a style for commit messages.

## Requirements
> These need updating.

Before going ahead with the "instructions" section below, please make sure of the following:

The scripts within are built to work with automatic gpg key signing (not having to type `-S` with every commit)
e.g. Your git config file, for the repository concerned, should include the following:
``` gitconfig
[user]
  email = <user-email>
  name = <user-name>
  signingkey = <gpg key id>
[gpg]
  program = gpg
[commit]
  gpgsign = true
```
`<angle-brackets>` need to be substituted for the correct values

Also, download the checkstyle jar ([e.g. from the GitHub releases page](https://github.com/checkstyle/checkstyle/releases/) - current tested version is 8.45.1) and ensure that your environment variable `CHECKSTYLE_JAR` is set to the location of that jar.


## Functionality
### Checkstyle
Checkstyle is a Java linter that will analyse the java files passed to it, using the style defined at <this_repo>/scripts/configurations/java_checksl.xml.
This configuration is based on Google's java style configuration, but has had a couple of small modifications.
This seemed a reasonable starting point, and can be easily changed later.

The checks are quite harsh, but a lot of them make a lot of sense. The scripts ensure that checkstyle will only be run against the modified / staged files, not on an entire repository.

## Instructions
There are two repositories talked about in these instructions:
* Target Repository
    * This is the repository to which you will apply the hooks 
        > e.g. `framework` or `managers`
* Hook Repository
    * The repository that contains (along with this README) the setup files, hooks, and scripts.

Setup should be relatively easy:

Navigate to the _*hook*_ repository (where this README is stored), and then execute the script `setup.sh`. 

The script requires one parameter to be passed: the path to the target (Galasa) repository.

when running from withing the framework repository, the command may look something like:

`./setup.sh /Users/username/Galasa/framework`

> If you encounter problems running `setup.sh`, make sure it is executable using something like `chmod +x setup.sh`
