## Project Automator v3.0 Viimeinen versio
---
## Ohjelman tarkoitus
Skripti on automatisoitu työkalu videotuotannon hallintaan. Sen avulla sisällöntuottaja voi luoda yhdellä komennolla standardisoidun kansiorakenteen uudelle videoprojektille. Ohjelma vähentää manuaalista työtä ja varmistaa, että kaikki tarvittavat resurssit (raakamateriaali, audio, grafiikka) pysyvät järjestyksessä.

## Käyttöohje:
Varmista, että skriptin suoritusoikeudet on sallittu komennolla: Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

Käynnistä ohjelma klikkaamalla Visual Studio Codessa koodin oikealla puolella ylhäällä olevaa "play" nappia.

Syötä avautuvaan ikkunaan projektin nimi ja valitse julkaisualusta (YouTube tai TikTok).

Paina "Luo kansiorakenne". Skripti luo työpöydälle automaattisesti "Projektit"-pääkansion, mikäli sitä ei ole. Ja rakentaa valitsemasi projektin sen sisälle.
---
## Modulaarisuus ja Laajennettavuus
Ohjelman arkkitehtuuri on jaettu modulaariseksi. Graafinen käyttöliittymä on erotettu kansionluontilogiikasta, joka on kapseloitu omaan New-ProjectStructure -funktioonsa.
---
## Miten laajentaa skriptiä?
Kansiorakenteen muokkaaminen ei vaadi käyttöliittymäkoodin muuttamista. Uusia kansioita voi lisätä tai poistaa helposti muokkaamalla funktion sisällä olevaa $folders-taulukkoa:
'$folders = @("Raakamateriaali", "Audio", "Grafiikka", "Editointi", "Valmiit Videot", "UUSI_KANSIO")'
---
## Poikkeustilanteet ja Virheenkäsittely
Skripti on vikasietoinen ja hyödyntää try/catch -rakennetta sekä asettaa virhetilanteet kriittisiksi.

Saman niminen projekti: Ohjelma tarkistaa ennen luontia, onko projekti jo olemassa. Jos on, luonti keskeytetään turvallisesti ja käyttäjälle näytetään ilmoitus, jolloin vanhaa dataa ei koskaan ylikirjoiteta.
---
## Oikeudet ja järjestelmävirheet:
Jos kansioiden luonti epäonnistuu esimerkiksi kirjoitusoikeuksien puuttumisen tai muun odottamattoman levyvirheen vuoksi, catch-lohko nappaa virheen ja näyttää siitä teknisen selvennyksen käyttäjälle graafisessa ikkunassa koodin kaatumisen sijaan.
---
## Siirrettävyys ja Ympäristö
Käyttöjärjestelmä: Windows 11 - PowerShell 5.1

OneDrive-tuki: Skripti käyttää dynaamista metodia [System.Environment]::GetFolderPath("Desktop"), joten se löytää automaattisesti nykyisen käyttäjän työpöydän riippumatta siitä, onko koneella käytössä paikallinen profiili vai OneDrive-varmuuskopiointi. Skripti ei vaadi asennusta.
---
## Kehitysajatukset
Pilvi-integraatio: Mahdollisuus luoda kansiot suoraan verkkolevyille.
Template-tiedostot: Skripti voisi kopioida valmiin videoeditointiprojektin pohjan suoraan projektikansioon.
Puhdistustyökalu: Toiminto, joka poistaisi automaattisesti raskaat välimuistitiedostot vanhoista ja valmiista projekteista.

---