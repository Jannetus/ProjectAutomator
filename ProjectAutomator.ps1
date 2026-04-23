# Project Automator v4.0
# Tekijä: Janne Karhunen
# Kuvaus: Työkalu videoprojektien automatisointiin.

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- LISÄOSIEN LATAAMINEN ---
$loggerPath = Join-Path $PSScriptRoot "LokienKirjaus.ps1"
if (Test-Path $loggerPath) {
    . $loggerPath 
} else {
    [System.Windows.Forms.MessageBox]::Show("Huomio: LokienKirjaus.ps1 -tiedostoa ei löydy samasta kansiosta! Lokikirjaus ei ole käytössä.", "Tietoa") | Out-Null
}

# --- APUFUNKTIOT ---
function New-SafeDirectory {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Path
    )
    try {
        if (!(Test-Path $Path)) {
            New-Item -ItemType Directory -Path $Path -ErrorAction Stop | Out-Null
        }
        return $true
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Virhe luotaessa kansiota '$Path':`n$($_.Exception.Message)", "Kansiovirhe") | Out-Null
        return $false
    }
}

# --- PÄÄFUNKTIO ---
function New-ProjectStructure {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ProjectName,
        
        [Parameter(Mandatory=$true)]
        [string]$Platform,

        [string]$RootPath = (Join-Path [Environment]::GetFolderPath("Desktop") "Projektit")
    )

    if (!(New-SafeDirectory -Path $RootPath)) { return $false }

    $basePath = Join-Path $RootPath $ProjectName

    if (Test-Path $basePath) {
        [System.Windows.Forms.MessageBox]::Show("Virhe: Projekti '$ProjectName' on jo olemassa!", "Huomio") | Out-Null
        return $false
    }
    
    $luotuOnnistuneesti = $true

    if (!(New-SafeDirectory -Path $basePath)) { return $false }
    
    $folders = @("Raakamateriaali", "Audio", "Grafiikka", "Editointi", "Valmiit Videot")
    if ($Platform -eq "YouTube") { $folders += "YouTube Thumbnail" } else { $folders += "Pystyvideot" }


    foreach ($folder in $folders) {
        $targetPath = Join-Path $basePath $folder
        if (!(New-SafeDirectory -Path $targetPath)) { 
            $luotuOnnistuneesti = $false
            break 
        }
    }

    if (!$luotuOnnistuneesti) {
        try {
            Remove-Item -Path $basePath -Recurse -Force -ErrorAction Stop
            [System.Windows.Forms.MessageBox]::Show("Kansioiden luonti johti virheeseen. Keskeneräinen projekti poistettiin automaattisesti.", "Peruutus tehty") | Out-Null
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Kriittinen virhe: Keskeneräistä projektia ei voitu poistaa!`n$($_.Exception.Message)", "Rollback epäonnistui") | Out-Null
        }
        return $false
    }

    if (Get-Command "Write-ProjectLog" -ErrorAction SilentlyContinue) {
        Write-ProjectLog -BasePath $basePath -ProjectName $ProjectName -Platform $Platform
    }

    return $true
}


# --- GRAAFINEN KÄYTTÖLIITTYMÄ  ---

$form = New-Object System.Windows.Forms.Form
$form.Text = "Project Automator v4.0 ~ Made By Janne Karhunen"
$form.Size = New-Object System.Drawing.Size(420,350)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
$form.FormBorderStyle = "FixedDialog"
$form.Topmost = $true

$label = New-Object System.Windows.Forms.Label
$label.Text = "PROJEKTIN NIMI:"
$label.Location = New-Object System.Drawing.Point(30,25)
$label.AutoSize = $true 
$label.ForeColor = "White"
$label.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($label)

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(30,60)
$textBox.Size = New-Object System.Drawing.Size(340,30)
$form.Controls.Add($textBox)

$group = New-Object System.Windows.Forms.GroupBox
$group.Text = "Valitse julkaisualusta"
$group.Location = New-Object System.Drawing.Point(30,100)
$group.Size = New-Object System.Drawing.Size(340,80)
$group.ForeColor = "White"
$form.Controls.Add($group)

$radioYT = New-Object System.Windows.Forms.RadioButton
$radioYT.Text = "YouTube"; $radioYT.Location = New-Object System.Drawing.Point(20,30); $radioYT.Checked = $true
$group.Controls.Add($radioYT)

$radioTT = New-Object System.Windows.Forms.RadioButton
$radioTT.Text = "TikTok / Shorts"; $radioTT.Location = New-Object System.Drawing.Point(160,30)
$group.Controls.Add($radioTT)

$button = New-Object System.Windows.Forms.Button
$button.Text = "LUO KANSIORAKENNE!"
$button.Location = New-Object System.Drawing.Point(30,200)
$button.Size = New-Object System.Drawing.Size(340,50)
$button.BackColor = [System.Drawing.Color]::FromArgb(0, 122, 204); $button.ForeColor = "White"
$button.FlatStyle = "Flat"

$button.Add_Click({
    $name = $textBox.Text
    
    if ([string]::IsNullOrWhiteSpace($name)) {
        [System.Windows.Forms.MessageBox]::Show("Anna projektille nimi!", "Huomio")
        return
    }

    if ($name.IndexOfAny([System.IO.Path]::GetInvalidFileNameChars()) -ge 0) {
        [System.Windows.Forms.MessageBox]::Show("Projektin nimessä on kiellettyjä merkkejä!`nKansio ei saa sisältää seuraavia merkkejä: \ / : * ? `" < > |", "Virheellinen syöte") | Out-Null
        return
    }

    $platform = if ($radioYT.Checked) { "YouTube" } else { "TikTok" }

    if (New-ProjectStructure -ProjectName $name -Platform $platform) {
        [System.Windows.Forms.MessageBox]::Show("Projekti '$name' luotu onnistuneesti!", "Valmis")
        $form.Close()
    }
})
$form.Controls.Add($button)
$form.ShowDialog() | Out-Null