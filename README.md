# Automated-QB-Updates
Powershell script to automate Quickbooks updates

This script aims to streamline the process of updating multiple versions of Quickbooks on a single server, such as a RemoteApp or RDS environment. The updates are pulled directly from Intuit's website for all installed versions rather than opening each version of QB individually. Some manual interaction is still required as of the current version as the patch installer doesn't have any command line switches for unattended installation. 

In order to adapt this script to your own environment and your own versions of QB, follow these steps:
* Visit https://downloads.quickbooks.com/app/qbdt/products and select your version from the dropdown menus
* Click "Get the latest updates" and IMMEDIATELY hit ESC on the new tab that opens
* Copy the link into the Downloads array in the script. Edit the array further as needed for your installed versions
* Edit the Quickbooks array in the script to point to the EXE for the versions of QB you have installed

Eventual goals for this script:
* Automate downloading the update package, likely with a solution such as Selenium
* Automate the installation of the patches themselves, likely with a solution such as AutoIT
