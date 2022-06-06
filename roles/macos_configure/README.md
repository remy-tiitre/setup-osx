macos-configure
===============

Role to configure MacOS defaults. Different variables for different domains and applications.

For more information check:
* https://git.herrbischoff.com/awesome-macos-command-line/about/
* https://github.com/kevinSuttle/macOS-Defaults/blob/master/.macos
* https://github.com/fgimian/macbuild-ansible
* https://github.com/kdeldycke/dotfiles/blob/main/macos-config.sh

Role Variables
--------------

| Parameter                             | Description                                               |
| ------------------------------------- | --------------------------------------------------------- |
| MACOS_CONFIGURE_GLOBAL_SETTINGS       | Gonfigure global settings                                 |
| MACOS_CONFIGURE_APPLICATIONS_SETTINGS | Configure applications                                    |
| MACOS_CONFIGURE_DOCK_SETTINGS         | Configure Dock & Menu Bar                                 |
| MACOS_CONFIGURE_DOCK_APPLICATIONS     | Apps to add to the dock, everything else will be removed  |
| MACOS_CONFIGURE_DOCK_FOLDERS          | Folders to add to the dock                                |
| MACOS_CONFIGURE_FINDER_SETTINGS       | Configure Finder                                          |
| MACOS_CONFIGURE_SAFARI_SETTINGS       | Configure Safari                                          |

Example Playbook
----------------

```yaml
---
- hosts: localhost
  connection: local

  vars:
    MACOS_CONFIGURE_GLOBAL_SETTINGS:
      - { key: "NSDocumentSaveNewDocumentsToCloud", type: bool, value: false, description: "Save to disk (not to iCloud) by default" }
    MACOS_CONFIGURE_APPLICATIONS_SETTINGS:
      - { domain: "com.apple.iCal", key: "Show Week Numbers", type: bool, value: true, description: "Calendar > Preferences > Advanced > Show week numbers: Enabled" }
    MACOS_CONFIGURE_DOCK_SETTINGS:
      - { key: "orientation", type: string, value: "right", description: "Dock & Menu Bar > Dock & Menu Bar > Position on scree: right" }
    MACOS_CONFIGURE_DOCK_APPLICATIONS:
      - "/System/Applications/Mail.app"
      - "/System/Applications/Calendar.app"
      - "/System/Applications/System Preferences.app"
    MACOS_CONFIGURE_DOCK_FOLDERS:
      - { path: "/Applications" }
      - { path: "~/Downloads", sort: "datemodified" }
    MACOS_CONFIGURE_FINDER_SETTINGS:
      - { key: "FXEnableExtensionChangeWarning", type: bool, value: false, description: "Preferences > Advanced > Show Warning before changing an extension: Disabled" }
    MACOS_CONFIGURE_SAFARI_SETTINGS:
      - { key: "HomePage", type: string, value: "about:blank", description: "Preferences > General > Homepage: 'about:blank'" }

  roles:
    - { role: macos-configure }
```
