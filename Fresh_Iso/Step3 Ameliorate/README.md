# victory-win

Run Ameliorate Script (Linux Required)
To assure that our changes are permanent, we need to remove Windows Update and its self-healing ability. This cannot be done within the running system because of Windows file permissions and repair operations. Another operating system, preferably a Linux distribution, is required for this step.

(Ubuntu should have been downloaded in the Prereq step)

The Ameliorate script makes heavy use of filesystem fuzzing search operations to effectively find and remove all files classified under specific naming conventions by Microsoft and pipes these paths to delete commands. As noted above, modifying the Windows filesystem from Linux allows us the luxury of ignoring filesystem permissions and ensures that Windows cannot re-patch these files before we reboot. This process enables the complete deletion of all relevant binaries from the system. In addition to the removal process the script also generates a recovery script to restore all of the removed Windows files from backup.

The script is written in bash, and commented to reasonably document various deleted components.

Use Rufus, which was downloaded in the Prereq script, and create a live ubuntu usb. Copy this Step3 folder to the usb after rufus has finished.

Boot into Linux and mount your Windows drive.
Place ameliorate_1903_2020-01-18.sh in the root directory of your Windows drive, and execute it with root permissions:

sudo ./ameliorate_1903_2020-01-18.sh
The script will generate ten errors, two for OfficeHub and eight for MicrosoftEdge. This is due to permissions. This seems to be fine and neither of the programs can run. For unknown reasons, there are multiple copies of Windows files all over the folder structure of Windows 10. The ones that actually run Microsoft Edge are successfully removed.

Once the script has finished, boot back into Windows to continue.
