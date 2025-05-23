#!/bin/zsh
PYTHON_VERSION="3.13.1"
# Upgrading Python requires manual cleanup
# pyenv uninstall "${OLD_PYTHON_VERSION}"
# code ~/.zshrc

# ===== DO NOT CHANGE BELOW THIS LINE ==================================================================================
RED="\033[1;31m"; GREEN="\033[1;32m"; NOCOLOR="\033[0m"

# ----- Update MacOS ----------------------------------------------------------------------------------------
echo -e "\n${GREEN}*** Update MacOS${NOCOLOR}"
/usr/sbin/softwareupdate -ai

# ----- Install Homebrew ------------------------------------------------------------------------------------
if ! which brew > /dev/null 2>&1; then
    echo -e "\n${GREEN}*** Installing Homebrew${NOCOLOR}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    # With Intel CPU you will have to fix the path manually in .zprofile
    # code ~/.zprofile
    grep -qF 'eval "$(/opt/homebrew/bin/brew shellenv)"' ~/.zprofile || echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo -e "\n${GREEN}*** Upgrading Homebrew${NOCOLOR}"
    sudo chown -R $(whoami) $(brew --prefix)/*
    brew update
    brew upgrade
fi
export HOMEBREW_CASK_OPTS=--require-sha

# ----- Install Simple Python Version Management ------------------------------------------------------------
# https://opensource.com/article/19/5/python-3-default-mac
# https://opensource.com/article/19/6/python-virtual-environments-mac
echo -e "\n${GREEN}*** Install Simple Python Version Management${NOCOLOR}"
brew install pyenv
grep -qF 'eval "$(pyenv init --path)"' ~/.zprofile || echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init --path)"\nfi' >> ~/.zprofile


# ----- Install Python 3 ------------------------------------------------------------------------------------
echo -e "\n${GREEN}*** Install Python 3 ${NOCOLOR}"
# Install dependencies
brew install zlib sqlite
export LDFLAGS="-L$(brew --prefix)/opt/zlib/lib -L$(brew --prefix)/opt/sqlite/lib"
export CPPFLAGS="-I$(brew --prefix)/opt/zlib/include -I$(brew --prefix)/opt/sqlite/include"

if ! pyenv versions | grep -c "${PYTHON_VERSION}" > /dev/null 2>&1; then
    #Install Python
    pyenv install "${PYTHON_VERSION}"
    pyenv global "${PYTHON_VERSION}"
fi
export PIP_TRUSTED_HOST="pypi.org files.pythonhosted.org"
$(pyenv which python3) -m pip install --upgrade pip

# ----- Add Virtual Environments ----------------------------------------------------------------------------
echo -e "\n${GREEN}*** Add Virtual Environments ${NOCOLOR}"
$(pyenv which python3) -m pip install virtualenvwrapper
grep -qxF 'export WORKON_HOME=~/.virtualenvs' ~/.zshrc || echo 'export WORKON_HOME=~/.virtualenvs' >> ~/.zshrc
grep -qxF "export VIRTUALENVWRAPPER_PYTHON=$(pyenv which python3)" ~/.zshrc || echo "export VIRTUALENVWRAPPER_PYTHON=$(pyenv which python3)" >> ~/.zshrc
grep -qxF "export VIRTUALENVWRAPPER_VIRTUALENV=~/.pyenv/versions/${PYTHON_VERSION}/bin/virtualenv" ~/.zshrc || echo "export VIRTUALENVWRAPPER_VIRTUALENV=~/.pyenv/versions/${PYTHON_VERSION}/bin/virtualenv" >> ~/.zshrc
grep -qx '. ~/.pyenv/versions/.*/bin/virtualenvwrapper.sh' ~/.zshrc || echo ". ~/.pyenv/versions/${PYTHON_VERSION}/bin/virtualenvwrapper.sh" >> ~/.zshrc
grep -qxF ". ~/.pyenv/versions/${PYTHON_VERSION}/bin/virtualenvwrapper.sh" ~/.zshrc || sed -i '' "s|. ~/.pyenv/versions/.*/bin/virtualenvwrapper.sh|. ~/.pyenv/versions/${PYTHON_VERSION}/bin/virtualenvwrapper.sh|g" ~/.zshrc
grep -qxF 'export NODE_OPTIONS=--use-openssl-ca' ~/.zshrc || echo 'export NODE_OPTIONS=--use-openssl-ca' >> ~/.zshrc
source ~/.zshrc

# ----- Install Ansible -------------------------------------------------------------------------------------
echo -e "\n${GREEN}*** Install Ansible${NOCOLOR}"
rmvirtualenv ansible
mkvirtualenv ansible
pip install --upgrade pip
pip install ansible
deactivate

# ----- Prepare for Ansible ---------------------------------------------------------------------------------
# Close any open System Preferences panes, to prevent them from overriding settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# ----- Play Ansible Playbook -------------------------------------------------------------------------------
echo -e "\n${GREEN}*** Start Ansible${NOCOLOR}"
workon ansible
chmod o-w .
ansible-galaxy install -r requirements.yml
ansible-playbook -i localhost, -e "ansible_python_interpreter=$(pyenv whence --path python)" site.yml
deactivate

# ----- Security configuration that can't be done with mobileconfig -----------------------------------------
sudo defaults write /Library/Preferences/com.apple.locationmenu.plist ShowSystemServices -bool true
sudo launchctl disable system/com.apple.nfsd
sudo pwpolicy -n /Local/Default -setglobalpolicy "requiresMixedCase=1"
sudo launchctl config user umask 077 &> /dev/null
