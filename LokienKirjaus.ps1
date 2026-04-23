# Lokien Kirjaus
# Kuvaus: Funktio projektilokien kirjoittamiseen

function Write-ProjectLog {
    param (
        [Parameter(Mandatory=$true)]
        [string]$BasePath,

        [Parameter(Mandatory=$true)]
        [string]$ProjectName,

        [Parameter(Mandatory=$true)]
        [string]$Platform
    )

    try {
        $timestamp = Get-Date -Format "dd.MM.yyyy HH:mm"
        $logContent = "Projektiloki`n-----------------`nNimi: $ProjectName`nLuotu: $timestamp`nAlusta: $Platform"
        
        $logFilePath = Join-Path $BasePath "projektin_tiedot.txt"
        $logContent | Out-File -FilePath $logFilePath -Encoding utf8
        
        return $true
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show("Lokin kirjoittaminen epäonnistui: $($_.Exception.Message)", "Virhe") | Out-Null
        return $false
    }
}