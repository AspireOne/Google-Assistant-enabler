# set global variables
# QSB stands for Quick Search Box
QSB_DIR_NAME="com.google.android.googlequicksearchbox"
SHARED_PREFS_DIR="/data/data/$QSB_DIR_NAME/shared_prefs"

# exceptions ignored
catch() { }

# set the permissions of shared_prefs directory
chmod 771 "$SHARED_PREFS_DIR" || catch

# copy backed up GSA prefs to shared_prefs directory
cp "$MODPATH/backup/GEL.GSAPrefs.xml" "$SHARED_PREFS_DIR" || catch

# uninstall nga resources
pm uninstall "$QSB_DIR_NAME.nga_resources" || catch
