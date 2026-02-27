# Dossier de destination des sauvegardes
$BackupPath = "C:\Backup"
$Date = Get-Date -Format "yyyy-MM-dd_HH-mm"
$TempFolder = "$BackupPath\Temp_$Date"
$ZipFile = "$BackupPath\Backup_$Date.zip"
$LogFile = "$BackupPath\logs\backup.log"

# Création des dossiers nécessaires
New-Item -ItemType Directory -Path $TempFolder -Force | Out-Null
New-Item -ItemType Directory -Path "$BackupPath\logs" -Force | Out-Null

# Lecture des dossiers à sauvegarder
$Folders = Get-Content "config.txt"

foreach ($Folder in $Folders) {
    if (Test-Path $Folder) {
        Copy-Item $Folder -Destination $TempFolder -Recurse -Force
        Add-Content $LogFile "$(Get-Date) - Sauvegarde OK : $Folder"
    } else {
        Add-Content $LogFile "$(Get-Date) - ERREUR : $Folder introuvable"
    }
}

# Compression
Compress-Archive -Path "$TempFolder\*" -DestinationPath $ZipFile -Force

# Nettoyage
Remove-Item $TempFolder -Recurse -Force

Add-Content $LogFile "$(Get-Date) - Sauvegarde terminée : $ZipFile"