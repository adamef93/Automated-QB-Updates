# Automated-QB-Updates
Powershell script to automate Quickbooks updates

This script aims to streamline the process of updating multiple versions of Quickbooks on a single server, such as a RemoteApp or RDS environment. The updates are pulled directly from Intuit's website for all installed versions rather than opening each version of QB individually. Some manual interaction is still required as of the current version as the patch installer doesn't have any command line switches for unattended installation. 
