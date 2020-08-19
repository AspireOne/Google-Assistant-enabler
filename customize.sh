# set global variables
RESOURCES_DOWNLOAD_LINK="https://download1583.mediafire.com/ar09udj1odhg/4axh1n7teuwvqn0/NgaResources.apk"
SHARED_PREFS_DIR="/data/data/com.google.android.googlequicksearchbox/shared_prefs"
RESOURCES_DIR="$MODPATH/resources"
BACKUP_DIR="$MODPATH/backup";


print_progress() {
  ui_print "- $1"
}

check_android_version() {
# abort if android ver != 10
  if [ ! $API -eq "29" ]; then
    abort "This module is for android 10 only"
  fi
}

backup_files() {
  print_progress "backing up GSA prefs"
  mkdir $BACKUP_DIR
  cp "$SHARED_PREFS_DIR/GEL.GSAPrefs.xml" "$BACKUP_DIR" || print_progress "Could not back up GSA prefs"
}

install_resources_apk() {
  if [ "$BOOTMODE" != 'true' ]; then
    print_progress "Skipping resources APK installation since not running via Magisk Manager"
    return 0
  fi
  
  print_progress "Downloading resources"
  # todo: redirect the download's output into a function in order to remove the previous line in terminal.
  # using a pipe (e.g. wget ... 2>&1 | function_to_call) doesn't work from some unknown, magic, and probably trivial reason.
  # It seems that with that approach the download immidiately ends.
  wget -P "$RESOURCES_DIR" "$RESOURCES_DOWNLOAD_LINK" 2>&1 || abort "Could not download resources. The link most likely broke and I am the one to blame :D"
  print_progress "Installing resources"
  pm install -r "$RESOURCES_DIR/NgaResources.apk" || abort "Could not install resources"
}

replace_GSAprefs() {
  print_progress "Replacing GSAPrefs"
  cp "$RESOURCES_DIR/GEL.GSAPrefs.xml" "$SHARED_PREFS_DIR" || abort "Could not replace GSA prefs"
}

set_sharedPrefs_perms() {
  print_progress "Setting shared_prefs directory permissions"
  chmod 551 "$SHARED_PREFS_DIR" || abort "Could not set permissions of shared_prefs directory"
}

finish_installation() {
  print_progress "cleaning up"
  rm -rf "$RESOURCES_DIR" || "Could not delete leftover files"
  print_progress "Installation succesful. Set the language in the Google app to English (US)"
}


check_android_version
set_sharedPrefs_perms
backup_files
replace_GSAprefs
install_resources_apk
finish_installation