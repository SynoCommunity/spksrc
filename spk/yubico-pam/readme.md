## Yubico-PAM ##

Das **Yubico-PAM-Modul** bietet eine einfache Möglichkeit, um Benutzerauthentifizierungen mit einem Yubikey an ihrer **Synology Diskstation** zu ermöglichen. [linux-pam] wird in GNU/Linux, Solaris and Mac OS X zur Benutzerauthentifizierung eingesetzt.

## !! ACHTUNG !! ##
PAM (Pluggable Authentication Modules) steuert die Benutzerauthentifizierung auf der DiskStation. Dieses Paket beinhaltet nur die Bibiliotheken und Beispiel-Konfigurationsdateien. Die Endkonfiguration muss selbst via Konsole durchgeführt werden. Eine fehlerhafte Konfiguration kann dazu führen, dass alle Benutzer vom System ausgesperrt werden. Oder Sicherheitslücken entstehen.<br>

**Wenn sie sich nicht 100% sicher sind, was sie tun, dann nehmen sie keine Änderung an ihrer Diskstation vor!<br>
Das Paket befindet sich im Beta-Stadium, die Installation und Nutzung geschieht auf eigene Gefahr.** 

### Ratschläge ###
- setzen sie dieses Paket nicht auf Produktivsystemen ein
- machen sie sich ausgibig mit [linux-pam] und seiner Funktionen vertraut 
- seien sie vorsichtig mit dem Argument "required" in der PAM Konfiguration
- halten sie sich immer den Weg über SSH/Telnet frei um auf die Diskstation zugreifen zu können (SSH aktivieren, /etc/pam.d/sshd nicht editieren oder auf "required" verzichten)

## Inhalt des Paketes ##
- yubico-c (Basisbibiliothek)
- yubico-c-client (Client für die Authentifizierung am Server)
- yubico-personalization (Personalisierungstool für Yubikeys)
- yubico-pam (PAM Modul)

## Voraussetzungen ##
- eine Synology Diskstation (XPEnoBoot geht auch)
- einen Yubikey
- eine Internetverbindung zum Auth-Server des Yubikeys. Oder eigenen Key-Server.
- fertiges Paket yubico-pam
- erfahrung mit Linux, [SSH], [vi], [linux-pam]

## Wie richtet man yubico-pam ein? ##
Nach der erfolgreichen Installation von yubico-pam auf einer Diskstation kann wie auf [Yubico Developers PAM]
beschrieben, unter dem Punkt "Configuration" fortgefahren werden.

## Wichtige Dateien ##
#### `/etc/pam.d/*`<br>
Jeder Dienst hat eine Konfigurationsdatei in der die zu ladenden PAM Module und Anmeldeoptionen gespeichert sind. Yubico-pam muss bei den gewünschten Diensten eingetragen werden<br>
Den standard Login via Broweser findet man in: `/etc/pam.d/webui`

#### `/etc/yubikey/yubikey_mappings`<br>
In der Datei werden Benutzername und Yubikey (Yubikey-Token) verbunden. Den Benutzer sollte es natürlich schon auf der DS geben.<br>
*Yubico hat diese Datei in seinen Beispielen in einem anderen Ordner liegen. Diesen Pfad unbedingt beibehalten, ansonsten blockiert AppArmor (siehe unten) den Zugriff auf die Datei*.<br>
Das Format ist:
> <Benutzername\>:<Yubikey token ID1\>:<Yubikey token ID2\>:….


## DSM 5.1 und AppArmor ##
Seit DSM 5.1 setzt Synology [AppArmor] ein.<br>
Alle Kernanwendungen haben ein, von Synology vordefiniertes, Profil und können deshalb nur im Rahmen dieses Profil auf Ressourcen zugreifen. Das beinhaltet, dass der Loginprozess nicht auf die Standard Ordner für zusätzlich installierte Pakete zugreifen kann.<br>
Die Bibiliotheken von yubico-pam werden deshalb nicht, wie üblich, auf den Festplatten gespeichert sondern im Grundsystem.<br>
Die 'yubikey_mappings'-Datei muss in einem für AppArmor freigegebenen Ordner liegen. Jeder andere Pfad wie `/etc/yubikey/` macht sie für PAM unzugänglich! 

## yubico-pam auf x64 Systemen
DSM benutzt immer eine 32bit Version von linux-pam.<br>
Deshalb muss das Paket für x86 (32bit) compiliert werden. Wird eine x64 (64bit) Architektur werwendet, kommt es zu einem Kompatibilitätsfehler und PAM kann das Modul nicht ausführen.<br>

Ein kleiner Umweg ist deswegen nötig:<br>
1. paket für x86 compilieren `make arch-evansport`<br>
2. fertige .spk mit einem Packprogramm öffnen und die "INFO" Datei editieren. (7ZIP kann das ganz gut)<br>
3. die Zeile `arch="evansport"` ersetzen durch `arch="x86 cedarview avoton bromolow evansport"`<br>
4. speichern und Archiv aktualisieren lassen<br>
5. das Paket kann jetzt auf x86 und x64 Architekturen laufen (Die Dateien sind auf beiden gleich)<br>

## Ich habe mich ausgesperrt und brauche die Daten auf der DS ##
Setzen sie die DiskStation zurück. Dadurch gehen die meisten Einstellugen aber
nicht die Daten darauf verloren.
Auf der Rückseite der Diskstation ist immer ein kleiner Knopf 'reset' den man mit einer Kugelschreiberspitze drücken kann.<br>
Drücken und halten bis es piepst, kurz loslassen und dann
wieder drücken, bis es drei mal piepst.
Das System muss danach neu aufgesetzt werden. Die PAM Einstellungen sind wieder 
auf Werkseinstellungen und die Daten auf den Festplatten noch vorhanden.

## Was ist der "Yubikey token"? ##
Der Token ist die öffentliche ID eines Yubikey. Das sind die ersten 12 Zeichen
die ein Yubikey widergibt, wenn er gedrückt wird. Der Rest ist der eigentliche OTP.<br>
Entwerder zählt man die Zeichen ab oder:<br>

`ykhelper.sh ident [yubikey drücken]`<br>
alternativ<br>
`read -p "Enter OTP: " s && echo "Your public Identity is: " ${s:0:12}`

## Getestete auf ##
- 214play - DSM5.2 - (evansport)
- 212j - DSM5.2 - (88f6281) 
- XPNoBoot auf HP Gen8 (DS3615xs) - DSM5.2 - (bromolow)
- XPNoBoot auf VirtualBox - DSM5.2 - (bromolow) 


[linux-pam]:http://www.linux-pam.org/
[SSH]:https://de.wikipedia.org/wiki/Secure_Shell
[vi]:https://de.wikipedia.org/wiki/Vi
[Yubico Developers PAM]:https://developers.yubico.com/yubico-pam/#_configuration
[AppArmor]:https://de.wikipedia.org/wiki/AppArmor
