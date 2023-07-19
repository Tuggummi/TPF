# TPF V2

**TPF V2** är den andra versionen av TPF-projektet. Det är en uppdaterad och förbättrad version av den ursprungliga **TPF** med förbättrad funktionalitet, bättre prestanda och förbättrad användarupplevelse. Utvecklingen av **TPF** kommer att vara en pågående process, även om frekvensen av uppdateringar kan variera.

Vänligen observera att **TPF** fortfarande är under utveckling och det kan finnas problem eller buggar. Var säker på att jag kommer att göra mitt bästa för att undersöka och lösa eventuella rapporterade problem snabbt. I takt med att utvecklingen av TPF fortskrider kommer ytterligare funktioner och egenskaper att introduceras för att ytterligare förbättra dess kapacitet. Det är viktigt att betona att **TPF** alltid kommer att _förbli gratis_, även om vissa specialfunktioner eller premiumtillägg kan ha en avgift.

## Funktioner

¤ Spawnmeny ~ En spawnmeny med tillgång till fyra olika karaktärer, olika namn, jobb, åldrar, vapen och pedmodeller.

¤ Vapen-hanteringing ~ Ta fram olika vapen

¤ Revive ~ Kommando där tillåtna kan reviva sig själva.

¤ Respawn & Death ~ När du dör, kan du trycka på **R** för att respawna.

¤ Ped ~ Ändra din pedmodell genom /ped

¤ Hantera fordon ~ Genom kommando kan du ta fram, reparera och radera fordon.

¤ Konfigurerande ~ Konfiguera till dina preferenser i [config.lua](config/config.lua) och [permissions.lua](config/permissions.lua)

¤ Loggande ~ Många av åvanstående händelser loggas till discord kanaler. Konfiguera webhooksen [här](config/webhooks.lua).

## Installation

1. Ladda ner senaste verisionen av scriptet: [Github Latest](https://github.com/Tuggummi/TPFV2/releases)
2. Ändra mappnamnet till "TPF" och placera mappen i resources. FXManifest bör vara i resources/TPF/fxmanifest.lua
3. Konfiguera [tillstånd](config/permissions.lua), [webhooks](config/webhooks.lua) och de globala [inställningarna](config/config.lua). Ändra även bilderna i html/images, för att passa dig.
4. Kör [TPF.sql](TPF.sql) i din MySQL databas. Se till att du har en databas markerad i HeidiSQL.
5. Aktivera servern via "ensure TPF" eller "start TPF" i din server.cfg.
6. Starta om servern.

## Beroende Installationer

¤ HeidiSQL Databas med uppkoppling till din server: [MySQL Async Dokumentation](https://brouznouf.github.io/fivem-mysql-async/)

# Version 2.0

Detta är den andra stora utgåvan av TPF. Den har betydligt fler funktioner, förbättringar och ökad tillgänglighet. Detta framework erbjuder en smidig och effektiv lösning för både enkla och avancerade scenarier. TPF kommer att uppdateras kontinuerligt med nya funktioner och förbättringar, men du måste manuellt hämta den senaste versionen.

## Problem/Buggar

Om du stöter på problem eller buggar rekommenderar vi att du först laddar ner den senaste versionen av skriptet. Det kan finnas buggar i tidigare versioner eller problem kan uppstå på grund av klientens miljö. Om problemet kvarstår, vänligen kontakta oss via vår [Discord-kanal](https://discord.gg/mJPz2Wkqja). Du kan också rapportera problemet genom att skapa en [GitHub Issue](https://github.com/Tuggummi/TPF/issues) för support och hjälp.

Vi är dedikerade till att erbjuda en pålitlig och användarvänlig upplevelse med TPF och vi ser fram emot att hjälpa dig med eventuella problem du stöter på.
