# Android-MAC-Spoofer
Spoof the MAC address of your rooted Android device from Windows. Allows backup of the original MAC.



##Requirements:

1st - (Required) Rooted Android device
2nd - (Required) Go to Developer Options on your device and allow "USB Debugging" mode
3rd - (Required) Make sure device driver is installed on Windows
4th - (Recommended) Download the Android SDK
and set the environment variable "ANDROID_HOME" to the root directory of the SDK.
This script relies on the Android Debug Bridge (adb). By default, it will look for "adb.exe" on %ANDROID_HOME%\platform-tools\adb.exe
If not found, it will run the "adb.exe" bundled with this script, which should work for Windows x64 machines.
		

## Usage

android-spoofer.bat <mode> [new-mac-address]
Where mode
         update: Sets MAC address to be equal to 'new-mac-address'. Backup is created, if non-existent.
         backup: Backs-up current MAC-address
         restore: Restores original MAC-address
         clean-backup: [DANGEROUS] Cleans backed-up address (cannot be undone
         show-current: Displays current MAC address.
         show-original: Displays backed-up MAC address, in case it exists.

At any time the mac address is modified, the device needs to be rebooted for the changes to take effect.

## Tips

Try running the command "android-spoofer.bat show-current". 
No changes are made by this command, and if everything has been correctly set up, it should display the current MAC address of your device

## Examples

Original MAC Address is "AA:11:22:33:44:BB". Let us set it to "DD:33:44:55:44:BB"
```
android-spoofer.bat update DD:33:44:55:44:BB
```
Restore it to "AA:11:22:33:44:BB".
```
android-spoofer.bat restore
```