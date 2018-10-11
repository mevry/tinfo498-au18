# Evasion and Defense Lab Notes

## Educational Objectives

After completing this lab, you will:

* Demonstrate evasion techniques that could be used by attackers.
* Utilize technologies for defending against evasion techniques, including:
  * Tools that discover hidden files on Windows NTFS systems.
  * Instructions for configuring Linux syslog systems to store auditing data on remote servers.

## Links

[ADS Overview + PowerShell](https://blogs.technet.microsoft.com/askcore/2013/03/24/alternate-data-streams-in-ntfs/)

[Modern ADS techniques](https://oddvar.moe/2018/04/11/putting-data-in-alternate-data-streams-and-how-to-execute-it-part-2/)

## Notes & Activity

### 2.1 NTFS Alternate Data Streams

* The commands in the lab did not work for me, so I sought out a different method for manipulating Alternate Data Streams (see Modern ADS techniques link above)

* Using PowerShell:

View all streams on a File:

```powershell
Get-Item -Path $PathToFile -stream * | Select-Object PSChildName,Length
```

Get Alternate Data Stream content:

```powershell
Get-Content -Path $PathToFile -Stream $AlternateStreamName
```

Create Alternate Data Stream:

```powershell
Set-Content -Path $PathToFile -Stream $StreamName
```

This technique seems to be limited to text-based streams. Ideally, we would like to embed a payload that we can execute at a later date. This next technique ([Published Here](https://oddvar.moe/2018/04/11/putting-data-in-alternate-data-streams-and-how-to-execute-it-part-2/)) does just that:

1. Create or Designate a file for an alternate data stream
2. Use **makecab** to create a .cab file of your payload:

    ```powershell
    makecab $SourcePathToExe $DestinationPathToCab
    ```

3. Use **extrac32** to extract the cab file into the desired data stream:

    ```powershell
    extrac32 $CabFilePath $TargetFilePath\TargetFile:MaliciousStream.exe
    ```

4. Use *wmic* to execute the Alternate Data Stream:

    ```powershell
    # Make sure to use the FULL path, otherwise this won't work
    wmic process call create $FullPathToFile\TargetFile:MaliciousStream.exe
    ```

### 2.2 Examining Windows Logs

### 2.3 Finding Alternate Data Streams w/Powershell

```powershell
#Create data structure to hold FileInfo objects
$list = [System.Collections.ArrayList]@()
#Recursively iterate over all files in the current directory, retrieve any that are not the default data stream (:$DATA), and add these to the list
$list.Add(Get-ChildItem C:\* -Recurse | Get-Item -Stream * | Where-Object {$_.Stream -ne ':$DATA'})
#Print out all of the Alternate Data Streams and their length
$list | Select-Object PSChildName,Length
```