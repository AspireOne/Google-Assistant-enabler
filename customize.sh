# set global variables
GOOGLE_APP_PCKG_NAME="com.google.android.googlequicksearchbox"
GOOGLE_APP_DIR="/data/data/$GOOGLE_APP_PCKG_NAME"
SHARED_PREFS_DIR="$GOOGLE_APP_DIR/shared_prefs"
RESOURCES_DIR="$MODPATH/resources"
GSA_PREFS="$RESOURCES_DIR/GEL.GSAPrefs.xml"
NGA_RESOURCES="$RESOURCES_DIR/NgaResources.apk"
BACKUP_DIR="$MODPATH/backup"


# print the current installation progress to the user
print_progress() {
  ui_print "- $1"
}

# check device compatibility with this module
check_compatibility() {
  print_progress "checking compatibility"
  
  # if android != 10
  if [ ! $API -eq "29" ]; then
    abort "This module is for android 10 only"
  fi
  
  # if shared_prefs dir doesn't exist or Google app isn't installed
  if [ ! -d "$SHARED_PREFS_DIR" ] || [ ! adb shell pm list packages | grep $GOOGLE_APP_PCKG_NAME ]; then
    abort "System is not compatible"
  fi
  
  # check if NgaResources.apk doesn't exist and GSAPrefs does
  if [ ! -f "$NGA_RESOURCES" ] && [ -f "$GSA_PREFS" ]; then
    abort "Resources are missing. This instance was probably built from github - please download the release version of this module at this project's github releases page, which contains the required resources."
  fi
  
  # if cpu architecture is arm
  if [ $ARCH -eq "arm"  ]; then
    print_progress "There's a high chance of this module not working on your cpu architecture"
  fi
}

# back up files that will be restored on uninstallation
backup_files() {
  print_progress "backing up files"
  mkdir $BACKUP_DIR
  cp "$GSA_PREFS" "$BACKUP_DIR" || print_progress "Could not back up GSA prefs"
}

# install resources
install_resources_apk() {
  if [ "$BOOTMODE" != 'true' ]; then
    print_progress "Skipping resources APK installation since not running via Magisk Manager"
    return 0
  fi
  
  print_progress "Installing resources"
  pm install -r "$NGA_RESOURCES" || abort "Could not install resources"
}

# replace GSAPrefs with GA 2.0 ones
replace_GSAPrefs() {
  print_progress "Replacing GSAPrefs"
  cp "$GSA_PREFS" "$SHARED_PREFS_DIR" || abort "Could not replace GSA prefs"
}

# change shared_prefs dir's permissions
set_sharedPrefs_perms() {
  print_progress "Setting shared_prefs directory permissions"
  chmod 551 "$SHARED_PREFS_DIR" || abort "Could not set permissions of shared_prefs directory"
}

# removes leftover installation files
clean_up() {
  print_progress "cleaning up"
  rm -rf "$RESOURCES_DIR" || print_progress "Could not delete leftover files"
  rm -rf "$GOOGLE_APP_DIR/cache/*" || print_progress "Could not clear Google app's cache"
}

check_compatibility
set_sharedPrefs_perms
backup_files
replace_GSAPrefs
install_resources_apk
clean_up

print_progress "Installation succesful. Set the language in the Google app to English (US)"
