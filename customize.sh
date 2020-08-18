# set global variables
SHARED_PREFS_DIR="/data/data/com.google.android.googlequicksearchbox/shared_prefs"
RESOURCES_DIR="$MODPATH/resources"
BACKUP_DIR="$MODPATH/backup";


print_process_info() {
  ui_print "- $1"
}

check_android_version() {
# abort if android ver != 10
  if [ ! $API -eq "29" ]; then
    abort "This module is for android 10 only"
  fi
}

backup_files() {
  print_process_info "backing up GSA prefs"
  mkdir $BACKUP_DIR
  cp "$SHARED_PREFS_DIR/GEL.GSAPrefs.xml" "$BACKUP_DIR" || print_process_info "Could not back up GSA prefs"
}

install_resources_apk() {
  if [ "$BOOTMODE" != 'true' ]; then
    print_process_info "Skipping resources APK installation since not running via Magisk Manager"
    return 0
  fi

  print_process_info "Installing nga resources apk"
  pm install -r "$RESOURCES_DIR/NgaResources.apk" || abort "Could not install nga resources apk"
}

replace_GSAprefs() {
  print_process_info "Replacing GSAPrefs"
  cp "$RESOURCES_DIR/GEL.GSAPrefs.xml" "$SHARED_PREFS_DIR" || abort "Could not replace GSA prefs"
}

set_sharedPrefs_perms() {
  print_process_info "Setting shared_prefs directory permissions"
  chmod 551 "$SHARED_PREFS_DIR" || abort "Could not set permissions of shared_prefs directory"
}

finish_installation() {
  print_process_info "cleaning up"
  rm -rf "$RESOURCES_DIR" || "Could not delete leftover files"
  print_process_info "Installation succesful. Set the language in the Google app to English (US)"
}


check_android_version
set_sharedPrefs_perms
backup_files
replace_GSAprefs
install_resources_apk
finish_installation