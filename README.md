# configure-mac
This project explains how to configure my mac using automated and manual steps.
- Ansible: I use Ansible to automate the installation of mackup and for things that mackup can't save.
- Mackup: As much as possible, I rely on Mackup to manage configurations.
- Manual: The manual portion is documented set of instructions comprised of things I can't/haven't automate.

This document includes instructions how to:
- [Configure a machine](#how-to-configure-a-machine)
- [Manage Mackup](#manage-mackup)
- [Further develop this capability](#further-development)

See the [github project](https://github.com/users/solintllc/projects/2/views/1) for tasks.

# How to Configure a Machine
Use these instructions when you want to:
- [configure a brand new production machine](#how-to-configure-a-brand-new-production-machine)
- [reset a exisiting production machine to brand new and then configure](#how-to-reset-a-production-machine)
- [reconfigure an existing production machine](#how-to-reconfigure-an-production-machine)
- [develop configuration changes](#further-development)

## How to Configure a Brand New Production Machine
Use these instructions when you have a fresh install of macOS on a physical, Apple silicon machine.

Steps:
1. Turn on the machine.
2. [Set up macOS](#how-to-set-up-macos-for-the-first-time).
3. [Configure the machine with Ansible](#how-to-use-ansible-to-configure-a-machine)

## How to Reset a Production Machine

## How to Reconfigure an Production Machine

## How to Set Up macOS for the First Time
Use these instructions when you have installed macOS and started the machine.

Steps:
1. Migration Assisstant → Not now
2. Sign In with Your Apple ID
    - Development → Set Up Later
    - Production → Sign in with Apple ID
3. User set up
    1. User: `robert`
    2. Password: `password` (devleopment, duh)
4. Location Services → Enable
5. Screen Time → Set Up Later
6. Enable Siri → Uncheck
7. Choose Your Look → Auto

Note:
- I have omitted steps I consider obvious.
- If it's not obvious, update this doc.

## How to Use Ansible to Configure a Machine
The ansible playbooks draw heavily from [Jeff Geerling's work](https://github.com/geerlingguy/mac-dev-playbook).

### 1. Install Ansible
```
xcode-select --install;
sudo pip3 install --upgrade pip;
export PATH="$HOME/Library/Python/3.9/bin:/opt/homebrew/bin:$PATH";
pip3 install ansible;
```

### 2. Install this repository
```
git clone git@github.com:solintllc/configure_my_mac.git ~/.configure_my_mac
cd ~/.configure_my_mac
ansible-galaxy install -r requirements.yml
```

### Run Configuration
```
ssh-add --apple-load-keychain
cd ~/.config/configure-mac;
export PATH="$HOME/Library/Python/3.9/bin:/opt/homebrew/bin:$PATH";
ansible-playlist main.yml --ask-become-pass --tags "[]:"
```

## Manual steps

### Firefox
- sign in

I monkeyed with firefox preferences, so I want to document it here. Firefox sync will sync preferences set in about:config, but only if that preference is whitelisted by having a corresponding entry under services.sync.prefs.sync. Additionally, the preferences are not synced automatically unless the preference is already set on the device. That makes it hard to set up new machines. The work around is also setting services.sync.prefs.dangerously_allow_arbitrary to true.

For example, when I open a bookmark, I want it to open in a new tab. That is controlled by a preference called browser.tabs.loadBookmarksInTabs. That preference is not automatically synced. So I,
1. set browser.tabs.loadBookmarksInTabs=true
2. set services.sync.prefs.sync.browser.tabs.loadBookmarksInTabs=true
3. set services.sync.prefs.dangerously_allow_arbitrary=true

Read more
https://support.mozilla.org/en-US/kb/sync-custom-preferences

The alternatie to all this is to set prefs in a user.js file and sync that file myself.  fuck that noise.

- Chrome
    - enable installed extensions
        - click on puzzle piece
        - enable

- System Settings
    - Privacy → Apple Advertising → Personalized Ads → Uncheck
    - Allow Full Disk Access for
        - Knock Knock
        - Block Block

### 1Password
1. Download and install 1PW.
2. Configure my user.
3. Preferences.
    1. Appearance -> Always show in sidebar -> Categories
    2. Security -> Always show passwords and full credit card numbers
    3. Developer -> Use SSH agent
    4. Copy snippet to .ssh/config

### Other notes
I use homebrew to install many of applicaitons I use. See the files in the ansible role for the latest lists. Note that this page has a list of GUI applications available for install via cask: https://formulae.brew.sh/cask/

### Plex
Networking
sudo networksetup -setadditionalroutes Ethernet 192.168.0.0 255.255.255.0 192.168.0.1
https://apple.stackexchange.com/questions/307221/add-a-permanent-static-route-in-high-sierra


## Cofigure Machine Reference Notes

Machine Types:
- production - my Apple Silicon physical device
- development - a VM hosted on my production device using Parallels



# Manage Mackup
- Archive the current Configuration [TODO](https://github.com/users/solintllc/projects/2/views/1?pane=issue&itemId=45329343)
- Backup and Restore Mackup [TODO](https://github.com/users/solintllc/projects/2/views/1?visibleFields=%5B%22Title%22%2C%22Status%22%2C65668142%5D&pane=issue&itemId=45312484)

## Terminology
I deliberately avoided using Back Up and Restore because Mackup uses those.

- Current State - all the settings and modifications to my current mac
- Configuration - a set of instructions for Configuring a mac, including ansible, manual instructions, and application configuration files
- Configure - to alter settings, install applications, and install files on my mac based on a Configuration
- Save - to record the Current State of my mac as a Configuration
- Archive - to make a protected copy of the current Configuration in order to prevent Backing Up from overwriting it

# Further Development
Use these instructions when you want to change the way this process configures a machine.

Steps:
1. Clone this project to ~/Documents/projects/configure-mac.
2. Open this project in VSCode.
3. [Create a development VM](#how-to-create-a-development-vm).
4. Configure the VM machine.
5. Develop new Ansible code.
6. GOTO step 2 or step 3, depending on how much step 4 messed things up.

## How to Create a Development VM
Use these instructions when you want to test the configuration process on a fresh machine.

Steps
1. [Build a base VM](#how-to-create-macos-development-base-vm), if necessary.
2. Clone the base VM: `scripts/clone.sh`

### macOS Development VM Reference Notes
When developing ansible, mackup, and manual configuration steps, it is useful to test against a fresh machine. For this, I use virtual mahcines.

The steps to create a development VM are time consuming, especially the macOS and xcode downloads. However, those do not change even as the ansible and other steps do. Rather than repeat all the steps for building a macOS VM from scratch, I separate the VM build into two parts. Part one creates a VM with all the unchanging bits. Part two clones the base, so I can quickly create disposable clones and test against them.

Rather than copying the base VM as a clone, it would be more efficient to create the development VM from a snapshot or linked clone. Unfortuantely, as of 12/3/2023, Parallels doesn't support snapshotting or linked clones of macOS on Apple Silicon. This is due to limitations in Apple's hypervisor, not limitations in Parallels.

## How to Create macOS Development Base VM
Use these instructions when:
- you don't have a development base VM, or
- your development base VM's macOS is out of date.

Steps
1. Download macOS as an ipsw file.
    1. From [https://developer.apple.com/download/](https://developer.apple.com/download/)
        1. Log in with your apple account.
        2. Save to ~/Downloads/UniversalMac...
    2. Move the file to the Parallels directory.
        ```
        mkdir -p ~/Parallels/ipsw;
        mv ~/Downloads/UniversalMac* ~/Parallels/ipsw/macos.ipsw
        ```
2. Delete exsiting VMs (as necessary).
    ```
    prlctl list -a
    prlctl delete <old machine names>
    ```
3. Create the Base VM.
    ```
    prlctl create macOS_config_base -o macos --restore-image ~/Parallels/ipsw/macos.ipsw;
    prlctl set macOS_config_base --memsize 8192 --cpus 4;
    prlctl start macOS_config_base
    ```
4. Walk through the [OS setup](#macos-first-setup).
5. Install Parallels Tools.
    1. `prlctl installtools macOS_config_base`
    2. Enter admin password.
    3. Click "Postpone".
6. [Install Ansible](#install-ansible)

### macOS Development Base VM Reference Notes
IPSW save location
- Save macos.ipsw in the ~/Parallels directory, not in the project folder.
- In ~/Parallels, it doesn't take up valuable iCloud GBs.

Parallel Tools
- We postpone reboot because there are a few other things we want do before rebooting.
- Parallel Tools enables copy paste.
    - I would love it if we didn't have to install it, especially on the host machine.
    - It is bloated and has a bunch of other features.
    - It insinuates itself everywhere. It feels like malware.

Troubleshooting
- [KB125561](https://kb.parallels.com/125561#section5)
- See logs:
    - /Library/Logs/parallels.log
    - ~/Parallels
