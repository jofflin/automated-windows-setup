# Windows setup with dotfiles and choco

A collection of PowerShell files for Windows, including common application installation through `Chocolatey` and `npm`, and developer-minded Windows configuration defaults.

## Features

- Uninstall unwanted Software
- Disable/Remove annoying Windows settings
- Install WSL2
- Automatically configure your taskbar and start-layout
- Install the Software you need

## Structure and Explanation

### What does the installation do?

You download my git-repo and execute the `bootstrap.ps1` Script.
It copies all needed files into your Powershell directory `C:\Users\USER_XY\Documents\WindowsPowerShell` and your dotfiles located in the `home` folder into your Home-Directory.

### Folder structure

```
.
+-- *profile.ps1
+-- bootstrap.ps1
+-- setup
|   +-- install.ps1
+-- custom-scripts
|   +-- customStartLayout.ps1
|   +-- deps.ps1
|   +-- windows.ps1
|   +-- installwsl2.ps1
|   +-- LayoutModification.xml
+-- home
|   +-- .anyDotFiles
+-- profile-scrip-help
|   +-- specific-scripts
|   |   +-- HELPER-SCRIPTS
|   +-- *components.ps1
+-- README.md
+-- LICENSE
```

### File explanation

**Feel free to fork this repo and edit files to fit your needs!**

- The `install.ps1` Script downloads the git repository and executes the `bootstrap.ps1` Script (Only needed for gitless usage)
- Powershell loads the corresponding profile-scripts (at least the `profile.ps1`) and executes them. They run the corresponding components Script located in the `profile-script-help` folder
- The Scripts in the `profile-script-help/specific-scripts` folder gets executed from the corresponding components Script
- The `profile.ps1` executes a few Scripts that adds aliases, useful functions and checks for the correct environment variables
- The home folder contains all your dotfiles that will be moved to you home directory
- The `custom-scripts` folder contains useful Scripts for every Windows 10 Setup
  - `installwsl2.ps1` installs the WSL of your choice
  - `windows.ps1` removes unwanted Software and configures Windows to your needs
  - `deps.ps1` installs all things that you need
  - `customStartLayout.ps1` sets the Taskbar and StartLayout to the settings in the `LayoutModification.xml` (assuming you installed most of the Software from the `deps.ps1`

### Suggested steps

1.  Change files to fit your need!
2.  Change Execution Policy
3.  Download the repo and execute the `bootstrap.ps1` (Getting started section)
4.  Execute `windows.ps1` for cleanup
5.  Check for remaining Software and Settings
6.  Execute `installwsl2.ps1`, restart PC when prompted and execute again
7.  Execute `deps.ps1` to install your Software on the fresh configured System
8.  Execute `customStartLayout.ps1` to get your predefined StartLayout and Taskbar items

## Getting started

### Using Git and the bootstrap script

You can clone the repository wherever you want. (I like to keep it in `~\Projects\dotfiles-windows`.) The bootstrapper script will copy the files to your PowerShell Profile folder.

From PowerShell:

```posh
git clone https://github.com/hoeffjo/setup-dotfiles-choco.git; cd setup-dotfiles-choco; . .\bootstrap.ps1
```

To update your settings, `cd` into your local `setup-dotfiles-choco` repository within PowerShell and then:

```posh
. .\bootstrap.ps1
```

Note: You must have your execution policy set to unrestricted (or at least in bypass) for this to work: `Set-ExecutionPolicy Unrestricted`.

### Git-free install (recommended)

> **Note!!!:** You must have your execution policy set to unrestricted (or at least in bypass) for this to work. To set this, run `Set-ExecutionPolicy Unrestricted` from a PowerShell running as Administrator.

To install these dotfiles from PowerShell without Git:

```bash
iex ((new-object net.webclient).DownloadString('https://raw.github.com/hoeffjo/setup-dotfiles-choco/master/setup/install.ps1'))
```

To update later on, just run that command again.

## Usage

### Add custom commands without creating a new fork

If `.profile-script-help\specific-scripts\extra.ps1` exists, it will be sourced along with the other files. You can use this to add a few custom commands without the need to fork this entire repository, or to add commands you don't want to commit to a public repository.

My `.\extra.ps1` looks something like this:

```posh
# Hg credentials
# Not in the repository, to prevent people from accidentally committing under my name

Set-Environment "EMAIL" "Jonas Hoefflin <email@example.com>"



# Git credentials
# Not in the repository, to prevent people from accidentally committing under my name

Set-Environment "GIT_AUTHOR_NAME" "Joans Hoefflin","User"
Set-Environment "GIT_COMMITTER_NAME" $env:GIT_AUTHOR_NAME
git config --global user.name $env:GIT_AUTHOR_NAME
Set-Environment "GIT_AUTHOR_EMAIL" "email@example.com"
Set-Environment "GIT_COMMITTER_EMAIL" $env:GIT_AUTHOR_EMAIL
git config --global user.email $env:GIT_AUTHOR_EMAIL

```

Extras is designed to augment the existing settings and configuration. You could also use `./extra.ps1` to override settings, functions and aliases from my dotfiles repository, but it is probably better to [fork this repository](#forking-your-own-version).

### Sensible Windows defaults

When setting up a new Windows PC, you may want to set some Windows defaults and features, such as showing hidden files in Windows Explorer and installing IIS. This will also set your machine name and full user name, so you may want to modify this file before executing.

```post
.\windows.ps1
```

### Install dependencies and packages

When setting up a new Windows box, you may want to install some common packages, utilities, and dependencies. These could include node.js packages via [NPM](https://www.npmjs.org), [Chocolatey](http://chocolatey.org/) packages, Windows Features and Tools, and Visual Studio Extensions from the [Visual Studio Gallery](http://visualstudiogallery.msdn.microsoft.com/).

```posh
.\deps.ps1
```

> The scripts will install Chocolatey, node.js, and other tools. Check the "Choco Install ..." lines and disable or add what you (don't) need.

### Install WSL2 (Needs Build 2004+)

To quickly get up and running with WSL2, open a new PowerShell window as "Admin" and run the following one-liner:

```post
.\installwsl2.ps1
```

You need to run this script twice, one to install pre-requisites and once after the reboot to update the WSl2 kernel and install the distro (Ubuntu 18.04 recommended from MS)

Test if it works with

```post
(Get-VM).Name # Get a list of VM names
Set-VMProcessor -VMName [TestVMName] -ExposeVirtualizationExtensions $true
```

### Customize your StartLayout and Taskbar

To Setup your StartLayout and Taskbar the same on every device you can run the following Script:

```post
.\customStartLayout.ps1
```

It overrides the LayoutModification on your system with the file name `LayoutModification.xml` (exact name is important). If you want to export your Layout from your current or testing-machine just run the following command:

```post
Export-StartLayout -Path  "C:\YOUR_CUSTOM_PATH\LayoutModification.xml"
```

Put the xml file into the same directory as the script and run it.

## Forking your own version

This repository is built around how I use Windows and to make my setup easier and the same on all my different devices. If you want to use this on your primary OS, you may want a different configuration that reflects that, and I recommend you [fork this repository](https://github.com/hoeffjo/setup-dotfiles-choco/fork).

If you do fork for your own custom configuration, you will need to touch a few files to reference your own repository, instead of mine.

Within `/setup/install.ps1`, modify the Repository variables.

```posh
$account = "hoeffjo"
$repo = "setup-dotfiles-choco"
$branch = "master"
```

Within the Windows Defaults file, `/custom-scripts/windows.ps1`, modify the Machine name on the first line.

```posh
(Get-WmiObject Win32_ComputerSystem).Rename("MyMachineName") | Out-Null
```

Finally, be sure to reference your own repository in the git-free installation command.

```bash
iex ((new-object net.webclient).DownloadString('https://raw.github.com/$account/$repo/$branch/setup/install.ps1'))

```

## Feedback

Suggestions/improvements are [welcome and encouraged](https://github.com/hoeffjo/setup-dotfiles-choco/issues)!

## Author

[Jonas Hoefflin](http://twitter.com/hoeffjo/)

## Thanks to…

- @[Mathias Bynens](http://mathiasbynens.be/) for his [OS X dotfiles](http://mths.be/dotfiles), which some things are inspired from.

- @[Jay Harris](http://twitter.com/jayharris/) for his [dotfiles-repo](https://github.com/jayharris/dotfiles-windows), which this repository is modeled after.
