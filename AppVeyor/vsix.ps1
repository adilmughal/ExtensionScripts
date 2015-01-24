[CmdletBinding()]
Param(
    [switch]$incrementVersion
)

Write-Host `n "VSIX build script loaded" `n


# Variables
[FileInfo]$vsixManifest = Get-ChildItem "**\source.extension.vsixmanifesst"
[int]$buildNumber       = $env:APPVEYOR_BUILD_NUMBER


# Increment VSIX version
if ($incrementVersion){

    if (!$vsixManifest){
        Write-Warning "Couldn't find the .vsixmanifest file to increment the version `n`n" 
        return
    }

    Write-Host "Incrementing VSIX version in" $vsixManifest.Name

    [xml]$vsixXml = Get-Content $vsixManifest

    $ns = New-Object System.Xml.XmlNamespaceManager $vsixXml.NameTable
    $ns.AddNamespace("ns", $vsixXml.DocumentElement.NamespaceURI)

    $version = $vsixXml.SelectSingleNode("//ns:Identity", $ns).Attributes["Version"]
    
    [Version]$newVersion = $version.Value + "." + $buildNumber
    $version.Value = $newVersion

    $vsixXml.Save($vsixManifest)

    Write-Host "VSIX version incremented to" $newVersion.ToString() `n
}