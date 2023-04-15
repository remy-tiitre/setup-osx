Ansible playbook for MacOS installation
=======================================
This playbook installs and configures most of the software I use on my Mac for web and software development. Not everything is automated, so I still have some manual installation steps.

Setup script itself installs Apple's Command Line Tools, Homebrew, Python 3 and Ansible. Then everything else is done in Ansible playbooks.

Installation
------------
* Install MacOS (Ventura)
* [Audit & Lockdown](https://github.com/remy-tiitre/secure-osx)
* Add Yubikey
* Sign in to App Store
* Execute installation script:
  > ./setup.sh
* Restore settings:
  > mackup restore

TODO
----
* Install Adobe Creative Cloud Applications
* Desktop & Screen Saver > Desktop > Photo
* Time Machine
