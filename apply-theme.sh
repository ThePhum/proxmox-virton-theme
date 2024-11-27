
#!/usr/bin/env bash

# Proxmox VE Theme Customization Script
# This script applies the selected theme to Proxmox VE using ExtJS.

# Set the desired theme
DESIRED_THEME="theme-triton" # Change this to your desired theme

# Path to the ExtJS repository
EXTJS_PATH="/usr/share/custom/extjs"
EXTJS_DEST="/usr/share/javascript/extjs"

# Ensure the ExtJS repository exists
if [ ! -d "$EXTJS_PATH" ]; then
  echo "Error: ExtJS repository not found at $EXTJS_PATH."
  echo "Please clone the repository first:"
  echo "git clone git://git.proxmox.com/git/extjs.git $EXTJS_PATH"
  exit 1
fi

# Copy the theme files
echo "Applying theme: $DESIRED_THEME"
cp -vrf $EXTJS_PATH/extjs/build/classic/{theme-aria,theme-classic,theme-crisp,theme-gray,theme-neptune,theme-triton} $EXTJS_DEST

# Update the Proxmox web interface to use the selected theme
sed -i.bak "s/theme-crisp/$DESIRED_THEME/g" /usr/share/pve-manager/index.html.tpl

# Confirm completion
echo "Theme applied successfully. Please restart Proxmox VE services:"
echo "systemctl restart pveproxy"
