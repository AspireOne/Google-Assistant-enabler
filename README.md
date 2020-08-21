![](https://i.imgur.com/QJkngBt.png)

# Premise
- Although this module's functionality is not guaranteed, it should enable Google Assistant 2.0 with it's glowing UI on a lot of Android 10 roms using Pixel UI.
- "Hey Google" hotword doesn't work.
- Google crashes when trying to search through it's search bar.

---

# Possible issues
- Spoofing device as Pixel 4 XL caused some side effect on some phones, like not working IR blaster or FM radio.
- Seems to not work on devices with Arm CPU architecture.

---

# Installation
### Prerequirements
- A phone running **Android 10**
- At least **140mb of storage**.
- **Root with** [**Magisk**](https://magiskmanager.com/)

### Process
- **Flash this via** [**Magisk Manager**](https://magiskmanager.com/), as you would flash any other module
- If you haven't already done so, **change the Language in the Google app to "English (US)"**
- (Optional) continued conversation is off by default. You must enable it in Google app -> Settings -> Google Assistant -> "Assistant" tab -> Continued conversation

Note that the installer will download a file with a size of ~140mb.

---

# Uninstallation
**Uninstall via Magisk Manager.** The module will revert back the changes it has made (restore old GSAPrefs file, uninstall Google Assistant 2.0 resources, change shared_prefs dir permissions back to 771, and the device won't be spoofed as Pixel 4 XL anymore).

---

# Inner Workings
In order to make this work, this module
- **systemlessly spoofs your device as Pixel 4 XL** by changing system properties
- **adds a folder with Google Assistant 2.0 resources** (at */data/data/com.google.android.googlequicksearchbox.nga_resources*) installed as an app
- **replaces GSA prefs file** located at */data/data/com.google.android.googlequicksearchbox/shared_prefs/GEL.GSAPrefs.xml* with Google Assistant 2.0 specific one (and backs the current one up)
- **Changes the already mentioned shared_prefs folder's permissions** from 771 to 551

Backed up files are stored in {the module's root folder (currently /data/adb/modules/g-assistant-2.0-enabler)}/backup

---

# License
[GNU General Public License](https://www.gnu.org/licenses/gpl-3.0.en.html)
