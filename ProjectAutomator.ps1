# Project Automator v2.0 - Final Version
# Tekijä: Janne Karhunen
# Kuvaus: Graafinen työkalu videoprojektien kansiorakenteiden automatisointiin.

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- IKKUNAN LUONTI ---
$form = New-Object System.Windows.Forms.Form
$form.Text = "Project Automator by Janne"
$form.Size = New-Object System.Drawing.Size(420,350)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30) # Tumma teema
$form.FormBorderStyle = "FixedDialog"
$form.Topmost = $true

# --- OTSIKKO ---
$label = New-Object System.Windows.Forms.Label
$label.Text = "PROJEKTIN NIMI:"
$label.Location = New-Object System.Drawing.Point(30,25)
$label.Size = New-Object System.Drawing.Size(200,25)
$label.ForeColor = "White"
$label.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($label)

# --- TEKSTIKENTTÄ ---
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(30,55)
$textBox.Size = New-Object System.Drawing.Size(340,30)
$textBox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$form.Controls.Add($textBox)

# --- PROJEKTITYYPIN VALINTA ---
$group = New-Object System.Windows.Forms.GroupBox
$group.Text = "Valitse julkaisualusta"
$group.Location = New-Object System.Drawing.Point(30,100)
$group.Size = New-Object System.Drawing.Size(340,80)
$group.ForeColor = "White"
$form.Controls.Add($group)

$radioYT = New-Object System.Windows.Forms.RadioButton
$radioYT.Text = "YouTube"
$radioYT.Location = New-Object System.Drawing.Point(20,30)
$radioYT.Checked = $true
$group.Controls.Add($radioYT)

$radioTT = New-Object System.Windows.Forms.RadioButton
$radioTT.Text = "TikTok / Shorts"
$radioTT.Location = New-Object System.Drawing.Point(160,30)
$group.Controls.Add($radioTT)

# --- LUONTI-NAPPI ---
$button = New-Object System.Windows.Forms.Button
$button.Text = "LUO KANSIORAKENNE!"
$button.Location = New-Object System.Drawing.Point(30,200)
$button.Size = New-Object System.Drawing.Size(340,50)
$button.BackColor = [System.Drawing.Color]::FromArgb(0, 122, 204)
$button.ForeColor = "White"
$button.FlatStyle = "Flat"
$button.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)

# --- TOIMINNALLISUUS ---
$button.Add_Click({
    $nimi = $textBox.Text
    if ($nimi -eq "") {
        [System.Windows.Forms.MessageBox]::Show("Anna projektille nimi!", "Virhe")
        return
    }

    $paapolku = "$home\Desktop\Projektit\$nimi"

    if (!(Test-Path $paapolku)) {
        New-Item -ItemType Directory -Path $paapolku | Out-Null
        
        # Peruskansiot
        $kansiot = @("Raakamateriaali", "Audio", "Grafiikka", "Editointi", "Valmiit Videot")
        
        # Ehdollinen kansio valinnan mukaan
        if ($radioYT.Checked) { $kansiot += "YouTube Thumbnail" }
        else { $kansiot += "Pystyvideot" }

        foreach ($k in $kansiot) {
            New-Item -ItemType Directory -Path "$paapolku\$k" | Out-Null
        }

        # Lokitiedoston luonti
        $aika = Get-Date -Format "dd.MM.yyyy HH:mm"
        $lokiSisalto = "Projektiloki`n-----------------`nNimi: $nimi`nLuotu: $aika`nAlusta: $(if($radioYT.Checked){"YouTube"}else{"TikTok"})"
        $lokiSisalto | Out-File -FilePath "$paapolku\projektin_tiedot.txt"

        [System.Windows.Forms.MessageBox]::Show("Projekti '$nimi' luotu!", "ProjectAutomator")
        $form.Close()
    } else {
        [System.Windows.Forms.MessageBox]::Show("Samanniminen projekti on jo olemassa.", "Virhe")
    }
})
$form.Controls.Add($button)

# --- NÄYTETÄÄN IKKUNA ---
$form.ShowDialog() | Out-Null