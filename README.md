# Galasa Githooks

GitHooks for Galasa repositories.

## Premise

Make local development of Galasa easier, as well as increasing the quality of pull-requests.

For example, by using:
* Linting
* Static Analysis
* Build Success

## Requirements
> I hope to reduce these requirements over time.

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
