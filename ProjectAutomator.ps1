# Project Automator v1.1 - GUI
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Luodaan ikkuna
$form = New-Object System.Windows.Forms.Form
$form.Text = "Project Automator"
$form.Size = New-Object System.Drawing.Size(400,250)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.Topmost = $true # Tuo ikkunan muiden eteen

# Otsikko
$label = New-Object System.Windows.Forms.Label
$label.Text = "Anna uuden projektin nimi:"
$label.Location = New-Object System.Drawing.Point(20,20)
$label.Size = New-Object System.Drawing.Size(300,25)
$form.Controls.Add($label)

# Tekstikenttä
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(20,50)
$textBox.Size = New-Object System.Drawing.Size(340,30)
$form.Controls.Add($textBox)

# Nappi
$button = New-Object System.Windows.Forms.Button
$button.Text = "Luo kansiorakenne"
$button.Location = New-Object System.Drawing.Point(20,100)
$button.Size = New-Object System.Drawing.Size(340,40)

# Mitä tapahtuu nappia painaessa
$button.Add_Click({
    $nimi = $textBox.Text
    if ($nimi -ne "") {
        $paapolku = "$home\Desktop\Projektit\$nimi"
        if (!(Test-Path $paapolku)) {
            New-Item -ItemType Directory -Path $paapolku | Out-Null
            $alikansiot = @("Raakamateriaali", "Audio", "Grafiikka", "Editointi", "Valmiit_Videot")
            foreach ($k in $alikansiot) {
                New-Item -ItemType Directory -Path "$paapolku\$k" | Out-Null
            }
            # Luodaan lokitiedosto
            $aika = Get-Date -Format "dd.MM.yyyy HH:mm"
            "Projekti '$nimi' luotu $aika" | Out-File -FilePath "$paapolku\projektin_tiedot.txt"
            
            [System.Windows.Forms.MessageBox]::Show("Projekti luotu!", "Valmis")
            $form.Close()
        } else {
            [System.Windows.Forms.MessageBox]::Show("Virhe: Samanniminen projekti on jo olemassa!", "Virhe")
        }
    }
})
$form.Controls.Add($button)

# Näytetään ikkuna
$form.ShowDialog() | Out-Null