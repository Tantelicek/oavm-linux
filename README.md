# OAVM Linux

Tento repozitář obsahuje kompletní zdrojovou konfiguraci školního operačního systému, který je vyvíjen v rámci projektu na Obchodní akademii a VOŠ Valašské Meziříčí.

## O projektu

Cílem projektu OAVM Linux je vytvořit moderní, bezpečné a snadno spravovatelné pracovní prostředí pro studenty a vyučující. Systém je postaven na distribuci **NixOS**, která se od běžných Linuxových distribucí liší svým deklarativním přístupem ke konfiguraci.

Místo manuální instalace programů je celý stav systému (od uživatelských účtů přes síťové nastavení až po jednotlivé aplikace) definován v kódu uloženém v tomto repozitáři. To zajišťuje **100% reprodukovatelnost** – každý počítač ve škole se chová naprosto identicky. Pro grafické rozhraní využíváme **KDE Plasma**, které nabízí vysokou míru přizpůsobení a intuitivní ovládání.

Projekt využívá technologii **Nix Flakes** pro striktní verzování všech závislostí, což zabraňuje problémům s nekompatibilitou softwaru při aktualizacích.

## Obsažený software

Systém obsahuje širokou sadu nástrojů pro vývoj, správu sítí, bezpečnostní testování a multimédia. Konfigurace zahrnuje následující balíčky:

### Vývoj a programování
* **Git** (+ grafická rozhraní)
* **Python** (interpret a nástroje)
* **NetBeans IDE** (kompletní stack: JDK, JRE, Apache Tomcat/Glassfish)
* **C# IDE** (vývojové prostředí pro .NET)
* **PHP & Lokální server** (alternativa XAMPP, Apache, SQL databáze)
* **Scene Builder** (pro JavaFX)

### Sítě a analýza
* **Wireshark** a **TShark** (analýza paketů)
* **Nmap**, **Ncat**, **Ncap** (síťový sken a debugování)
* **Filius** (simulace sítí)
* **Imunes** (emulace síťových topologií)
* **Smokeping** (monitoring latence)

### Kybernetická bezpečnost
* **Burp Suite**
* **Nikto**
* **Kleopatra + GnuPG** (šifrování a správa klíčů)

### Kancelář a produktivita
* **LibreOffice / OnlyOffice**
* **Draw.io** (tvorba diagramů)
* **Mozilla Firefox**
* **Microsoft Edge**
* **Midnight Commander** (správce souborů)

### Grafika a multimédia
* **GIMP** (rastrová grafika)
* **Inkscape** (vektorová grafika)
* **Kdenlive** (střih videa)
* **VLC / Haruna** (přehrávače médií)

### Systémové nástroje
* **Custom Fetch** (Fastfetch / Screenfetch pro info o systému)
* **Terminálové utility** a správa shellu

---

**Autoři:** Dominik Pala, Jan Houdek (4.D)
**Školní rok:** 2025/2026
