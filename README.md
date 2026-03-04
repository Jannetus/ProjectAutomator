# Project Automator v2.1

## Ohjelman tarkoitus
Skripti on automatisoitu työkalu videotuotannon hallintaan. Sen avulla sisällöntuottaja voi luoda yhdellä komennolla standardisoidun kansiorakenteen uudelle videoprojektille. Ohjelma vähentää manuaalista työtä ja varmistaa, että kaikki tarvittavat resurssit (raakamateriaali, audio, grafiikka) pysyvät järjestyksessä.

## Järjestelmävaatimukset
* **Käyttöjärjestelmä:** Windows 10 tai Windows 11.
* **Ympäristö:** Windows PowerShell 5.1 tai uudempi.
* **Esivaatimukset:** * PowerShellin suoritusoikeudet pitää sallia komennolla: `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`.


## Siirrettävyys
Skripti on siirrettävä. Se käyttää dynaamista `$home`-muuttujaa, joten se tunnistaa automaattisesti nykyisen käyttäjän työpöydän riippumatta koneen nimestä. Skripti ei vaadi erillistä asennusta, vaan se voidaan ajaa suoraan `.ps1`-tiedostosta millä tahansa Windows-koneella.

## Rajoitteet
* Skripti on suunniteltu vain Windows-ympäristöön (PowerShell & WinForms).
* Skripti vaatii kirjoitusoikeudet työpöydälle.
* Ohjelma ei osaa automaattisesti siirtää videotiedostoja sisään, vaan luo ainoastaan rakenteen.

## Kehitysajatukset
1. **Pilvi-integraatio:** Mahdollisuus luoda kansiot suoraan Google Driveen tai OneDriveen.
2. **Template-tiedostot:** Skripti voisi kopioida valmiin videoeditointiprojektin pohjan (esim. Adobe Premiere) suoraan projektikansioon.
3. **Puhdistustyökalu:** Toiminto, joka poistaisi automaattisesti välimuistitiedostot vanhoista projekteista.
