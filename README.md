
# Proxmox VE Custom Theme Based on ExtJS

This project customizes the Proxmox VE web interface theme using the ExtJS library. The theme can be switched between various options, and this repository includes a script to automate the application of the theme.

## Features

- Change Proxmox VE themes to any of the available ExtJS themes.
- Automate the customization process with a script.
- Ensure changes are persistent across updates.

## Requirements

- Proxmox VE installed.
- Access to the Proxmox VE server terminal.
- Git installed.

## Available Themes

The following themes are available in ExtJS:
- `theme-aria`
- `theme-classic`
- `theme-crisp` (default)
- `theme-gray`
- `theme-neptune`
- `theme-triton`

## How to Apply a Theme

1. **Clone the ExtJS Repository**
   ```bash
   git clone git://git.proxmox.com/git/extjs.git /usr/share/custom/extjs
   ```

2. **Create the Customization Script**
   Save the script provided in this repository as `/usr/share/custom/apply-theme.sh`.

3. **Edit the Script to Select a Theme**
   Open the script and set the `DESIRED_THEME` variable to your chosen theme. For example:
   ```bash
   DESIRED_THEME="theme-neptune"
   ```

4. **Run the Script**
   Execute the script to apply the theme:
   ```bash
   bash /usr/share/custom/apply-theme.sh
   ```

5. **Restart Proxmox Services**
   After applying the theme, restart the Proxmox VE services:
   ```bash
   systemctl restart pveproxy
   ```
## How to Change the Logo, Favicon, and Boot Screen

1. **Backup Original Images**
   ```bash
   sudo mkdir /usr/share/custom/backup
   sudo cp /usr/share/pve-manager/images/{favicon.ico,logo-128.png,proxmox_logo.png} /usr/share/custom/backup/
   sudo cp /usr/share/qemu-server/bootsplash.jpg /usr/share/custom/backup/
   ```

2. **Prepare New Images**
   Ensure your new images meet these specifications:
   - `bootsplash.jpg`: 640x480 pixels
   - `favicon.ico`: 64x64 pixels
   - `logo-128.png`: 128x128 pixels (transparent background)
   - `proxmox_logo.png`: 172x30 pixels (transparent background)

   Transfer the new images to the Proxmox VE server:
   ```bash
   scp {bootsplash.jpg,favicon.ico,logo-128.png,proxmox_logo.png} username@pve.example.com:/usr/share/custom/
   ```

3. **Update the Customization Script**
   Add the following lines to `/usr/share/custom/apply-theme.sh`:
   ```bash
   echo "cp -f /usr/share/custom/{favicon.ico,logo-128.png,proxmox_logo.png} /usr/share/pve-manager/images/" >> /usr/share/custom/apply-theme.sh
   echo "cp -f /usr/share/custom/bootsplash.jpg /usr/share/qemu-server/" >> /usr/share/custom/apply-theme.sh
   ```

4. **Reapply Customizations**
   Run the script to apply the changes:
   ```bash
   bash /usr/share/custom/apply-theme.sh
   ```

5. **Restart Proxmox Services**
   Restart the Proxmox VE services to reflect the new images:
   ```bash
   systemctl restart pveproxy
   ```

## Note

- Modifying the Proxmox VE interface is not officially supported. Be cautious when applying changes.
- Ensure to back up your Proxmox configuration before making any modifications.
- If you find Proxmox VE useful, consider purchasing a [Proxmox subscription](https://www.proxmox.com/en/proxmox-ve/pricing) to support the developers.
- This content was adapted from the [Lunar Computer post](https://lunar.computer/news/).

## License

This project is licensed under the AGPLv3. See the LICENSE file for details.
