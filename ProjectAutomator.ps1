# Project Automator v3.1 - OneDrive Compatible Edition
# Tekijä: Janne Karhunen
# Kuvaus: Modulaarinen työkalu videoprojektien automatisointiin. Toimii myös OneDrive-ympäristössä.

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- FUNKTIOT  ---

function New-ProjectStructure {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ProjectName,
        
        [Parameter(Mandatory=$true)]
        [string]$Platform
    )

    try {
        $desktopPath = [System.Environment]::GetFolderPath("Desktop")
        $paakansio = Join-Path $desktopPath "Projektit"

        if (!(Test-Path $paakansio)) {
            New-Item -ItemType Directory -Path $paakansio -ErrorAction Stop | Out-Null
        }

        $basePath = Join-Path $paakansio $ProjectName

        if (Test-Path $basePath) {
            [System.Windows.Forms.MessageBox]::Show("Virhe: Projekti '$ProjectName' on jo olemassa!", "Huomio") | Out-Null
            return $false
        }
        

        New-Item -ItemType Directory -Path $basePath -ErrorAction Stop | Out-Null
        
        $folders = @("Raakamateriaali", "Audio", "Grafiikka", "Editointi", "Valmiit Videot")
        if ($Platform -eq "YouTube") { $folders += "YouTube Thumbnail" } else { $folders += "Pystyvideot" }

        foreach ($folder in $folders) {
            $targetPath = Join-Path $basePath $folder
            New-Item -ItemType Directory -Path $targetPath -ErrorAction Stop | Out-Null
        }

        $timestamp = Get-Date -Format "dd.MM.yyyy HH:mm"
        $logContent = "Projektiloki`n-----------------`nNimi: $ProjectName`nLuotu: $timestamp`nAlusta: $Platform"
        $logContent | Out-File -FilePath (Join-Path $basePath "projektin_tiedot.txt") -Encoding utf8

        return $true
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show("Virhe: $($_.Exception.Message)", "Virheenkäsittely") | Out-Null
        return $false
    }
}


# --- GRAAFINEN KÄYTTÖLIITTYMÄ  ---

$form = New-Object System.Windows.Forms.Form
$form.Text = "Project Automator v3.0 ~ Made By Janne Karhunen"
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

    $platform = if ($radioYT.Checked) { "YouTube" } else { "TikTok" }

    if (New-ProjectStructure -ProjectName $name -Platform $platform) {
        [System.Windows.Forms.MessageBox]::Show("Projekti '$name' luotu onnistuneesti!", "Valmis")
        $form.Close()
    }
})
$form.Controls.Add($button)
$form.ShowDialog() | Out-Null