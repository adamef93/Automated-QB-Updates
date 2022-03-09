# Runs as admin
Write-Host "Checking for elevation... "  
$CurrentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent()) 
if (($CurrentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) -eq $false) 
{ 
    $ArgumentList = "-noprofile -noexit -file `"{0}`" -Path `"$Path`" -MaxStage $MaxStage" 
    If ($ValidateOnly) { $ArgumentList = $ArgumentList + " -ValidateOnly" } 
    If ($SkipValidation) { $ArgumentList = $ArgumentList + " -SkipValidation $SkipValidation" } 
    If ($Mode) { $ArgumentList = $ArgumentList + " -Mode $Mode" } 
    Write-Host "elevating" 
    Start-Process powershell.exe -Verb RunAs -ArgumentList ($ArgumentList -f ($myinvocation.MyCommand.Definition)) -Wait 
    Exit 
}  
write-host "in admin mode.."

# Disables UAC. The patches require UAC to run and this is included in preparation for automating the install with AutoIT
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value "0"

# Change this to your preferred directory. Keep the file name + extension
$destination = "C:\Admin\QB Updates\qbwebpatch.exe" 
# Edit this array to download the versions you need. See README for steps
$downloads = @(
# Premier Accountant 2022
"https://http-download.intuit.com/http.intuit/Downloads/2022/dmknzyq5nUS_R3/Webpatch/qbwebpatch.exe"
# Premier Accountant 2021
"https://http-download.intuit.com/http.intuit/Downloads/2021/eo2bf393iUS_R8/Webpatch/qbwebpatch.exe"
# Premier Accountant 2020
"https://http-download.intuit.com/http.intuit/Downloads/2020/cveofqqkrsUS_R13/Webpatch/qbwebpatch.exe"
# Premier Accountant 2019
"https://http-download.intuit.com/http.intuit/Downloads/2019/szxlidxcipUS_R16/Webpatch/qbwebpatch.exe"
# Premier Accountant 2018
"https://http-download.intuit.com/http.intuit/Downloads/2018/qaammbxfvrUS_R17/Webpatch/qbwebpatch.exe"
# Premier Accountant 2017
"https://http-download.intuit.com/http.intuit/Downloads/2017/ucnoamocyvUS_R16/Webpatch/qbwebpatch.exe"
# Premier Accountant 2016
"https://http-download.intuit.com/http.intuit/Downloads/2016/IFRvyzFmpQUS_R17/WebPatch/qbwebpatch.exe"
# Premier Accountant 2015
"https://http-download.intuit.com/http.intuit/Downloads/2015/m734bnderqUS_R17/WebPatch/qbwebpatch.exe"
# Premier Accountant 2014
"https://http-download.intuit.com/http.intuit/Downloads/2014/4covjyl0euUS_R16/WebPatch/qbwebpatch.exe"
# Enterprise Acountant 22
"https://http-download.intuit.com/http.intuit/Downloads/2022/dmknzyq5nUS_R3/Webpatch/en_qbwebpatch.exe"
# Enterprise Accountant 21
"https://http-download.intuit.com/http.intuit/Downloads/2021/eo2bf393iUS_R8/Webpatch/en_qbwebpatch.exe"
# Enterprise Accountant 20
"https://http-download.intuit.com/http.intuit/Downloads/2020/cveofqqkrsUS_R13/Webpatch/en_qbwebpatch.exe"
# Enterprise Accountant 19
"https://http-download.intuit.com/http.intuit/Downloads/2019/szxlidxcipUS_R16/Webpatch/en_qbwebpatch.exe"
# Enterprise Accountant 18
"https://http-download.intuit.com/http.intuit/Downloads/2018/qaammbxfvrUS_R17/Webpatch/en_qbwebpatch.exe"
# Enterprise Accountant 17
"https://http-download.intuit.com/http.intuit/Downloads/2017/ucnoamocyvUS_R16/Webpatch/en_qbwebpatch.exe"
# Enterprise Accountant 16
"https://http-download.intuit.com/http.intuit/Downloads/2016/IFRvyzFmpQUS_R17/WebPatch/en_qbwebpatch.exe"
)

$downloads | foreach {
    $args = "/silent", "/a"
    Start-BitsTransfer -Source $_ -Destination $destination 
    Unblock-File $destination
    Start-Process $destination -Wait -ArgumentList $args
    # This deletes the downloaded file upon completion of the loop. The update packages are overwritten as new ones are downloaded, but they can be large and don't need to stay       after installation
    Remove-Item -Path $destination -Force 
}
# This deletes the temp directory created by the patch installer, again to save space
Remove-Item -Path C:\Windows\Temp\qbwebpatch -Recurse -Force

# Edit this array for the versions you have installed
$quickbooks = @( 
# Premier 2022
"C:\Program Files\Intuit\QuickBooks 2022\QBWPremierAccountant.exe"
# Premier 2021
"C:\Program Files (x86)\Intuit\QuickBooks 2021\QBW32PremierAccountant.exe"
# Premier 2020
"C:\Program Files (x86)\Intuit\QuickBooks 2020\QBW32PremierAccountant.exe"
# Premier 2019
"C:\Program Files (x86)\Intuit\QuickBooks 2019\QBW32PremierAccountant.exe"
# Premier 2018
"C:\Program Files (x86)\Intuit\QuickBooks 2018\QBW32PremierAccountant.exe"
# Premier 2017
"C:\Program Files (x86)\Intuit\QuickBooks 2017\QBW32PremierAccountant.exe"
# Premier 2016
"C:\Program Files (x86)\Intuit\QuickBooks 2016\QBW32PremierAccountant.exe"
# Premier 2015
"C:\Program Files (x86)\Intuit\QuickBooks 2015\QBW32PremierAccountant.exe"
# Premier 2014
"C:\Program Files (x86)\Intuit\QuickBooks 2014\QBW32PremierAccountant.exe"
# Enterprise 22
"C:\Program Files\Intuit\QuickBooks Enterprise Solutions 22.0\QBWEnterpriseAccountant.exe"
# Enterprise 21
"C:\Program Files (x86)\Intuit\QuickBooks Enterprise Solutions 21.0\QBW32EnterpriseAccountant.exe"
# Enterprise 20
"C:\Program Files (x86)\Intuit\QuickBooks Enterprise Solutions 20.0\QBW32EnterpriseAccountant.exe"
# Enterprise 19
"C:\Program Files (x86)\Intuit\QuickBooks Enterprise Solutions 19.0\QBW32EnterpriseAccountant.exe"
# Enterprise 18
"C:\Program Files (x86)\Intuit\QuickBooks Enterprise Solutions 18.0\QBW32EnterpriseAccountant.exe"
# Enterprise 17
"C:\Program Files (x86)\Intuit\QuickBooks Enterprise Solutions 17.0\QBW32EnterpriseAccountant.exe"
# Enterprise 16
"C:\Program Files (x86)\Intuit\QuickBooks Enterprise Solutions 16.0\QBW32EnterpriseAccountant.exe"
)
# This loop launches each version in the array above as admin so the patches will apply
# THIS WILL KILL ALL OPEN VERSIONS OF QUICKBOOKS SO MAKE SURE YOU ARE THE ONLY ONE USING THE SERVER
$quickbooks | foreach {
    Start-Process $_ -Verb runas
    # Pauses the script to give QB enough time to process the update 
    Start-Sleep -Seconds 20
    get-process qbw32 | foreach {$_.CloseMainWindow() | Out-Null} | stop-process –force
}
# Re-enables UAC
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value "5"
