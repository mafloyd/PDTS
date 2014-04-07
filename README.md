PDTS
====

Physician Detail Tracking System

## Getting Started

### Setup
####The following MUST be installed on your local system before proceeding.

  * A GitHub account is already configured
  * A working installation of Git for Windows exists on your machine
  * Installation of the latest Visual Studio 2013
  
####Create a Fork	
The web version of the master repository is found here: https://github.com/LifePointHospitals/PDTS
On the repository page, there is a button in the upper-right corner named `Fork`. 
Click to create your fork.

####Clone the Fork
Open a prompt using Git Shell and navigate to the directory you want to clone your fork under.
Type the command `git clone git@github.com/<your Git user name>/pdts.git` 
(The URL can be found in the sidebar when viewing your fork.)

####Add the LifePointHospitals Remote
Open a command prompt in your local copy of the repository.
`git remote add LifePointHospitals https://github.com/LifePointHospitals/PDTS.git`

## Working On a Feature

###Create a Branch

All enhancements should take place in a feature branch.

```PowerShell
git remote update
git checkout LifePointHospitals/master -b feature/<YOUR FEATURE NAME>
git push -u origin feature/<YOUR FEATURE NAME>
```

###Make Changes

####Commit

```PowerShell
git add -a
git commit -m "<YOUR CHECK-IN NOTES>"
```

####Push
```PowerShell
git push
```

#### Get Up-to-date
```PowerShell
git remote update
git merge LifePointHospitals/master OR git rebase LifePointHospitals/master
git push
```

Both methods may require you to resolve conflicting changes. 
You can run `git mergetool` at the command line to do this. 
Use p4merge from Perforce as a merge UI. 
It handles the three-way merges that are common when working with Git. 
You can grab the installer [here](http://www.perforce.com/downloads/Perforce-Software-Version-Management/complete_list/20-20#10). 
Run `git config --global --edit` at the command line to edit Git's global configuration file. 
Update the `[merge]` section and add a new `[mergetool]` section as follows:

```INI
[merge]
    tool = p4merge
[mergetool "p4merge"]
    path = C:\\Program Files\\Perforce\\p4merge.exe
```

### Create a Pull Request

Pull requests are the way to get your changes into the "master" repository. You create a pull request through the GitHub site.

  * Go to your fork.
  * If you've recently pushed changes, you might see a prompt to `Compare & pull request`. Otherwise, click the small Compare & Review button.
  * If you used Compare & Review, make sure the correct branch is selected and click the link to create a pull request.
  * Provide a meaningful title and description for your pull request, verify the included changes, and create the request.

### After the Pull Request

Discussion occurs in GitHub after a pull request is submitted. 
If changes are needed based on feedback, commit and push as needed. 
The pull request will be updated.

## Deployment Notes

###Environments Supported
* DevTest: lifevwpdbs01
* Prod: lifevwddbs01
* Test/Training: lifevwtdbs01
