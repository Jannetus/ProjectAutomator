#Project Automator v1.0
#Tämä skripti luo projektille kansiorakenteen automaattisesti.

# 1. Kysytään käyttäjältä projektin nimi
$projektinNimi = Read-Host "Anna uuden videoprojektin nimi"

# 2. Määritetään polku, johon projekti luodaan
$paapolku = "$home\Desktop\Projektit\$projektinNimi"

#Tarkistetaan, onko kansio jo olemassa. Jos ei, luodaan se.
if (!(Test-Path $paapolku)) {
    New-Item -ItemType Directory -Path $paapolku

    $alikansiot = @("Raakamateriaali", "Audio", "Grafiikka", "Editointi", "Valmiit videot")

    foreach ($kansio in $alikansiot) {
        New-Item -ItemType Directory -Path "$paapolku\$kansio"
    }

    Write-Host "Projekti '$ProjektinNimi' on luotu onnistuneesti kohteeseen: $paapolku" -ForegroundColor Green
} else{
    Write-Host "Virhe! Samanniminen projekti on jo olemassa!" -ForegroundColor Red
}