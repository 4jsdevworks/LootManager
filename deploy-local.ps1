Clear-Host

$Addons = "C:\Program Files (x86)\World of Warcraft\_classic_\Interface\AddOns"
$Lootmanager = "$Addons\Lootmanager"

if (Test-Path -Path $Lootmanager)
{
    Write-Verbose -Verbose "Removing Existing Lootmanager folder"
    Remove-Item "$Addons\Lootmanager" -Recurse -Force
}

Write-Verbose -Verbose "Copying Lootmanager to addons folder"
Copy-Item .\Lootmanager -Destination 'C:\Program Files (x86)\World of Warcraft\_classic_\Interface\AddOns' -Recurse