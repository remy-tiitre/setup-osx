Ansible playbook for MacOS installation
=======================================
This playbook installs and configures most of the software I use on my Mac. Not everything is automated, so I still have some manual installation steps.

Setup script itself installs Apple's Command Line Tools, Homebrew, Python 3 and Ansible. Then everything else is done in Ansible playbooks.

Installation
------------
* Install MacOS (Sequoia)
* Secure the installation by following SECURITY.md
* Sign in to App Store
* Execute installation script:
  > ./setup.sh
