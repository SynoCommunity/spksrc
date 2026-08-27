# SynoCommunity package Home Assistant Core

!!! danger "Home Assistant Core is not supported as an installation method"
    ***Home Assistant Core*** will not be supported as installation method from Home Assistant version 2025.12.

    See [Deprecating Core and Supervised installation methods, and 32-bit systems](https://www.home-assistant.io/blog/2025/05/22/deprecating-core-and-supervised-installation-methods-and-32-bit-systems/)
    We still provide packages for 64-bit archs beyond this version, as long as it still works.

    **For Home Assistant on Synology devices, the use of container deployment is recommended.**

!!! warning "Limitations"
    ***Home Assistant Core*** is a python application and does not contain all Homeassistant features
    - Addons are not supported
    - The restart of home assistant within the web UI is not supported anymore. You have to use the DSM Package Center (or shell command) to restart HA
    - Integrated updates are not supported (except for HACS components)
    - When enabling integrations, please consider that dependent modules that are cross-compiled must either be installed with the package or available in the index (i.e. on pypi.com)
    - The package installation (and update) takes a lot of time (see section below)

## Package Installation and Update
!!! warning "Installation takes a long time"
    This is a huge package and installation may take some time and display an error. <br/>
    In this case please press abort and do not retry installation. <br/>
    The package installer will display "Installing..." and finally "Running". <br/>
    For systems with low resources it may take up to 60 minutes until the web frontend is running and does not display "Home Assistant is starting..." anymore. <br/>
    _This is caused by installation of cross-compiled modules included in the package and by modules required for the core system that are downloaded and installed from the internet._

## Available Integrations

When enabling integrations, only pure-python modules or cross-compiled modules installed with the package will work.

Many integrations require additional native Python 3 modules that have to be
available as (cross-) compiled wheels for the respective DSM architecture.

Here is an example of an error message visible in logs (accessible from webui or
on the system at `/var/packages/homeassistant/var/homeassistant.log`) when
module has to be built for architecture and requires a package upgrade to do
so:

```
2018-12-09 01:42:26 ERROR (Thread-10) [homeassistant.util.package]
Unable to install package homekit==0.10: Failed building wheel for gmpy2
Failed building wheel for py25519
```

Please submit a
[request for additonal integration](https://github.com/SynoCommunity/spksrc/issues/new)
you are interested in and add the label `request/homeassistant-integration`. We will do our best to get it available in next version update.

The section "State of the Default Integrations" reports integrations that are known to work (or fail) and their availability.
Some are supported only on DiskStation models with x86_64 CPU architecture.
This list is outdated and not maintained anymore.

## Manually editing the Configuration

Some Components are fully configurable in the Home Assistant Frontend, but others are based on manual settings in the configuration file.

To access the configuration file, you need to enable SSH service (Control Panel → Terminal & SNMP → Enable SSH service) to gain access to your system.
You need a file editor like the default installed `vi` or `vim`. The installation of `nano` is recommended for beginners (contained in [SynoCli File Tools](synocli-file.md)).

Then use the following command to edit the configuration according to
[application documentation](https://home-assistant.io/getting-started/configuration/)

```
sudo nano /var/packages/homeassistant/var/config/configuration.yaml
```

When restarting the service after configuration changes, please check the service log in the webui (or in `/var/packages/homeassistant/var/homeassistant.log`).

## Manually adding python modules

To manually add python modules for integrations you need ssh access to your system.

If such modules (and their dependencies) are pure python, you will succeed to install with:

`/var/packages/homeassistant/target/env/bin/pip install {module}=={version}`

Such manually installed modules can be added to a custom requirements file to get re-installed on package updates (since 2022.10.5-19).

For that add your custom modules to the file:

`/var/packages/homeassistant/var/requirements-custom.txt`

You have to run the pip command to manually install modules as user `sc-homeassistant`. So it might be easier to add the modules to `requirements-custom.txt` and manually install homeassistant again (using the downloaded spk file).

The manual installation of python modules is also usefull while development of HA package updates.
_**Detailed instructions:**_

```
sudo -i

su sc-homeassistant -s /bin/bash

cd /var/packages/homeassistant/target/env

# use any pip command like:

./bin/pip install --no-deps spotifyaio==2.0.2

./bin/pip freeze > requirements.txt

./bin/pip install pipdeptree

./bin/pipdeptree

# finally restart homeassistant in the package center
```

## Troubleshooting

As homeassistant has such a lot of dependent python packages, there are still incompatible packages after installation.

When an integration fails to install within homeassistant, this can often be solved by restarting homeassistant: since Homeassistant Core 2022.10.5 the restart in homeassistant does not work anymore. You have to stop/run in the DSM package center (or `synopkg restart homeassistant` in the shell on an ssh session).


## Related discussions

- How to give access to usb device [#4651](https://github.com/SynoCommunity/spksrc/issues/4651#issuecomment-850561562)

## State of the Default Integrations (Components)
State as of Home Assistant Package Versions

- _0.114.2-9_ <br/> not available anymore
- _0.118.5-11_ <br/> not available anymore
- _2021.1.5-13_ <br/> not available anymore
- _2021.8.8-14_ <br/> not available anymore
- _2021.9.7-15_ <br/> not available anymore
- _2022.10.5-19_ <br/> not available anymore
- _2023.1.7-20_ <br/> not available anymore
- **2023.7.3-22**  Depends on Python 3.11 <br/>
  WARNING: only aarch64 and x64 archs are used to validate working integrations in the list below. <br/>
  Packages are provided for x64 (x86_64), evansport (i686) and aarch64 (arm64). <br/>
  armv7 and qoriq models are not supported anymore (deactivated per 2025/02/22).
- **2024.12.5-24** requires DSM >= 7.1 and supports models with x64, aarch64 and i686 (evansport) architectures. <br/>
  Depends on Python 3.12 <br/>
  _originally planned to provide version 2025.1.4, but this version has a breaking issue (it supports encrypted backups only and those are not decryptable except by restore)_.
- **2025.11.3-25** requires DSM >= 7.2 and supports models with x64 and aarch64 architectures. <br/>
  Depends on Python 3.13 <br/>
  This is the last release of Home Assistant Core that is officially supported. <br/>
  All integrations that can be configured with an UI are supported. The list below is not maintained anymore (state of the list is for v2024.12.5)
- **2026.7.4-26** requires DSM >= 7.2 and supports models with x64 and aarch64 architectures. <br/>
  Depends on Python 3.14 <br/>
  Despite versions after 2025.12.x are not officially supported anymore, it still works and you can ignore the "Unsupported installation method" warning. <br/>
  All integrations that can be configured with an UI are supported. The list below is not maintained anymore.

_**Supported HA Integrations up to HA 2024.12.5**_

| 🏁	| Name	| HA Version	| Remarks	|
| :--	| :--------	| :--	| :-----------	|
| ✔️	| 1-Wire	| 0.118.5	| 	|
| ✔️	| 17TRACK	| 2024.12.5	| 	|
| ✔️	| 3 Day Blinds	| 2022.10.5	| provided by Motion Blinds	|
| ✔️	| Abode	| 0.114.2	| 	|
| ✔️	| AccuWeather	| 0.114.2	| 	|
| ✔️	| Acomax	| 2024.12.5	| provided by Motion Blinds	|
| ✔️	| Adax	| 2021.8.8	| 	|
| ✔️	| AdGuard Home	| 0.114.2	| 	|
| ✔️	| Advantage Air	| 0.118.5	| 	|
| ✔️	| AEMET OpenData	| 2021.4.6	| 	|
| ✔️	| AEP Ohio	| 2024.12.5	| provided by Opower	|
| ✔️	| AEP Texas	| 2024.12.5	| provided by Opower	|
| ✔️	| Aftership	| 2024.12.5	| 	|
| ✔️	| Agent DVR	| 0.114.2	| 	|
| ✔️	| Air-Q	| 0.114.2	| 2023.1.7	|
| ✔️	| AirGradient	| 2024.12.5	| 	|
| ✔️	| Airly	| 0.114.2	| 	|
| ✔️	| AirNow	| 2021.4.6	| 	|
| ✔️	| Airthings ➜ Airthings	| 2022.10.5	| 	|
| ✔️	| Airthings ➜ Airthings BLE	| 2023.1.7	| 	|
| ✔️	| AirTouch 4	| 2021.9.7	| 	|
| ✔️	| AirTouch 5	| 2024.12.5	| 	|
| ✔️	| AirVisual ➜ AirVisual Cloud	| 0.114.2	| 	|
| ✔️	| AirVisual ➜ AirVisual Pro	| 2023.1.7	| 	|
| ✔️	| Airzone	| 2022.10.5	| 	|
| 	| Alladin Connect	| 2022.10.5	| <= 2023.7.3	|
| ✔️	| AlarmDecoder	| 0.118.5	| 	|
| 	| Almond	| 0.114.2, <= 2023.1.7	| 	|
|   	| Amazon ➜ Amazon Alexa	| 2023.7.3	| <= 2023.7.3	|
| ✔️	| Amazon ➜ Amazon Fire TV	| 2023.7.3	| provided by Android Debug Bridge	|
| 	| Ambee	| <= 2021.7.4	| 	|
| ✔️	| Amber Electirc	| 2022.10.5	| 	|
|   	| Ambiclimate	| 0.114.2	| needs manual configuration, <= 2023.7.3	|
| ✔️	| Ambient Weather Station	| 0.114.2	| 	|
| ✔️	| AMP Motorization	| 2022.10.5	| provided by Motion Blinds	|
| ✔️	| Android Debug Bridge	| 2023.7.3	| 	|
| ✔️	| Android IP Webcam	| 2022.10.5	| 	|
| ✔️	| Android TV	| 2022.10.5	| was Android TV until 2023.1.7	|
| ✔️	| Anova	| 2023.7.3	| 	|
| ✔️	| Anthem A/V Receivers	| 2022.10.5	| 	|
| ✔️	| Antifurto365 iAlarm	| 2021.5.4	| 	|
| ✔️	| Anthropic Conversation	| 2024.12.5	| 	|
| ✔️	| Antifurto365 iAlarm	| 2024.12.5	| 	|
| ✔️	| ANWB Energie	| 2023.7.3	| provided by EnergyZero	|
| ✔️	| APC UPS Daemon	| 2022.10.5	| 	|
| ✔️	| Appalachian Power	| 2024.12.5	| provided by Opower	|
| ✔️	| Apple ➜ Apple iCloud	| 0.114.2	| 	|
| ✔️	| Apple ➜ Apple TV	| 2021.1.5	| 	|
| 	| Apple ➜ HomeKit	| 0.118.5, < 2023.7.3	| 	|
| ✔️	| Apple ➜ HomeKit Bridge	| 2023.7.3	| 	|
| ✔️	| Apple ➜ HomeKit Device	| 2023.7.3	| 	|
| 	| Apple ➜ HomeKit-Controller	| 0.114.2, < 2023.1.7	| 	|
| ✔️	| Apple ➜ iBeacon Tracker	| 2022.10.5	| 	|
| ✔️	| AprilAire	| 2024.12.5	| 	|
| ✔️	| APsystems	| 2024.12.5	| 	|
| ✔️	| Aqara	| 2024.12.5	| 	|
| ✔️	| AquaCell	| 2024.12.5	| 	|
| ✔️	| Aranet	| 2023.1.7	| 	|
| ✔️	| Arcam FMJ Receivers	| 0.114.2	| 	|
| ✔️	| Arizona Public Service (APS)	| 2024.12.5	| provided by Opower	|
| ✔️	| ArtSound	| 2024.12.5	| provided by LinkPlay	|
| ✔️	| Arve	| 2024.12.5	| 	|
| ✔️	| Aseko Pool Live	| 2022.10.5	| 	|
| ✔️	| ASUSWRT	| 2021.4.6	| 	|
| ✔️	| Atag	| 0.114.2	| 	|
| ✔️	| Atlantic City Electric	| 2024.12.5	| provided by Opower	|
| ✔️	| Atlantic Cozytouch	| 2022.10.5	| provided by Overkiz	|
| ✔️	| August Bluetooth	| 2022.10.5	| provided by Yale Access Bluetooth	|
| ✔️	| August Home ➜ August	| 2022.10.5	| 	|
| ⚙	| Aurora ABB PowerOne Solar PV	| 2022.10.5	| needs a valid RS485 device	|
| ✔️	| Aussie Broadband	| 2022.10.5	| 	|
| 	| Avri	| <= 0.118.5	| 	|
| ✔️	| Autarco	| 2024.12.5	| 	|
| ✔️	| Awair	| 0.114.2	| 	|
| ✔️	| Axis	| 0.114.2	| 	|
| ✔️	| Azure Data Explorer	| 2024.12.5	| 	|
| ✔️	| Balboa Spa Client	| 2022.10.5	| 	|
| ✔️	| Baltimore Gas and Electric (BGE)	| 2024.12.5	| provided by Opower	|
| ✔️	| Bang & Olufsen	| 2024.12.5	| 	|
| ✔️	| Belkin WeMo	| 0.114.2	| 	|
| ✔️	| Big Ass Fans	| 2022.10.5	| working >= 2024.12.5	|
| ✔️	| BleBox devices	| 0.114.2	| 	|
| ✔️	| Blink	| 0.114.2	| 	|
| ✔️	| Bliss Automation	| 2022.10.5	| provided by Motion Blinds	|
| ✔️	| Bloc Blinds	| 2022.10.5	| provided by Motion Blinds	|
| ✔️	| Blue Current	| 2024.12.5	| 	|
| ✔️	| BlueMaestro	| 2022.10.5	| 	|
| ✔️	| Bluetooth	| 2022.10.5	| 	|
| ✔️	| BMW Connect Drive	| 2021.1.5	| 	|
| ✔️	| Bond	| 0.114.2	| 	|
| ✔️	| Bosch SHC	| 2021.7.4	| 	|
| ✔️	| Bose SoundTouch	| 2022.10.5	| 	|
| ✔️	| Bouygues Flexom	| 2022.10.5	| provided by Overkiz	|
| ✔️	| Brandt Smart Control	| 2023.1.7	| provided by Overkiz	|
| ✔️	| Brel Home	| 2022.10.5	| provided by Motion Blinds	|
| ✔️	| Bring!	| 2024.12.5	| 	|
| ✔️	| Broadlink	| 0.118.5	| 	|
| ✔️	| Brother Printer	| 0.114.2	| 	|
| ✔️	| Brottsplatskartan	| 2023.7.3	| 	|
| ✔️	| Brunt Blint Engine	| 2022.10.5	| 	|
| ✔️	| Bryant Evolution	| 2024.12.5	| 	|
| ✔️	| BSB-Lan	| 0.114.2	| 	|
| ✔️	| BSwitch	| 2022.10.5	| provided by SwitchBee	|
| ✔️	| BTHome	| 2022.10.5	| 	|
| ✔️	| BTicino	| 2022.10.5	| provided by Netatmo	|
| ✔️	| Bubendorff	| 2022.10.5	| provided by Netatmo	|
| ✔️	| Buienradar	| 2021.7.4	| 	|
| ✔️	| CalDAV	| 2024.12.5	| 	|
| ✔️	| Cambridge Audio	| 2024.12.5	| 	|
| ✔️	| Canary	| 0.118.5	| 	|
| ✔️	| Certificate Expiry	| 0.114.2	| 	|
| ✔️	| Chacon DiO	| 2024.12.5	| 	|
| ✔️	| City of Austin Utilities	| 2024.12.5	| 	|
| 	| ClimaCell	| 2021.4.6, < 2022.10.5	| 	|
| ✔️	| Cloudflare	| 0.118.5	| 	|
| ✔️	| CO2 Signal	| 2021.8.8	| 	|
| ✔️	| Coinbase	| 2021.7.4	| 	|
| ✔️	| ColorExtractor	| 2024.12.5	| 	|
| ✔️	| Comelit SimpleHome	| 2024.12.5	| 	|
| ✔️	| Commonwealth Edison (ComEd)	| 2024.12.5	| provided by Opower	|
| ✔️	| Consolidated Edison (ConEd)	| 2024.12.5	| 	|
| ✔️	| Control4	| 0.114.2	| 	|
| ✔️	| CoolMasterNet	| 0.114.2	| 	|
| 	| Coronavirus (COVID-19)	| 0.114.2, <= 2023.1.7	| 	|
| ✔️	| Cribl	| 2024.12.5	| provided by Splunk	|
| ✔️	| CPU Speed	| 2022.10.5	| 	|
| ✔️	| CrownStore	| 2022.10.5	| 	|
| ✔️	| D-Link Wi-Fi Smart Plugs	| 2023.7.3	| 	|
| ✔️	| Dacia	| 2022.10.5	| provided by Renault	|
| ✔️	| Daikin AC	| 0.114.2	| 	|
| ✔️	| Deako	| 2024.12.5	| 	|
| ✔️	| deCONZ	| 0.114.2	| 	|
| ✔️	| Delamarva Power	| 2024.12.5	| provided by Opower	|
| ✔️	| Deluge	| 2022.10.5	| 	|
| ✔️	| Denon ➜ Denon AVR Network Receivers	| 0.114.2	| 	|
| ✔️	| Denon ➜ Denon HEOS	| 0.114.2	| 	|
| ✔️	| Deutscher Wetterdienst (DWD) Weather Warnings	| 2023.7.3	| 	|
| ✔️	| Devialet	| 2024.12.5	| 	|
| ✔️	| devolo Home Control	| 0.114.2	| 	|
| ✔️	| devolo Home Network	| 2022.10.5	| 	|
| ✔️	| Dexcom	| 0.114.2	| 	|
| ✔️	| Diaz	| 2023.1.7	| provided by Motion Blinds	|
| ✔️	| Digital Loggers	| 2022.10.5	| provided by Belkin WeMo	|
| ✔️	| DirecTV	| 0.114.2	| 	|
| ✔️	| Discord	| 2022.10.5	| 	|
|   	| Discovergy	| 2023.7.3	| <= 2023.7.3	|
| 	| DLNA	| 2022.10.5	| < 2023.7.3	|
| ✔️	| DLNA ➜ DLNA Digital Media Renderer	| 2023.7.3	| 	|
| ✔️	| DLNA ➜ DLNA Digital Media Server	| 2023.7.3	| 	|
| ✔️	| DNS IP	| 2022.10.5	| 	|
| ✔️	| DoorBird	| 0.114.2	| 	|
| ✔️	| Dooya	| 2022.10.5	| provided by Motion Blinds	|
| ✔️	| Dormakaba dKey	| 2023.7.3	| 	|
| ✔️	| Downloader	| 2024.12.5	| 	|
| ✔️	| Dremel 3D Printer	| 2023.7.3	| 	|
| ✔️	| DROP	| 2024.12.5	| 	|
| ✔️	| DSMR Reader	| 2022.10.5	| 	|
| ✔️	| DSMR Smart Meter	| 2021.8.8	| was DSMR Slimme Meter	|
| ✔️	| Duke Energy	| 2024.12.5	| 	|
| ✔️	| Dune HD	| 0.114.2	| 	|
| ✔️	| Duotecno	| 2024.12.5	| 	|
| ✔️	| Duquesne Light	| 2024.12.5	| provided by Opower	|
| ✔️	| Eastron	| 2024.12.5	| provided by HomeWizard Energy	|
| ✔️	| easyEnergy	| 2023.7.3	| 	|
| ✔️	| ecobee	| 0.114.2	| 	|
| ✔️	| Ecoforest	| 2024.12.5	| 	|
| ✔️	| Ecovacs	| 2024.12.5	| 	|
| ✔️	| Ecowitt	| 2022.10.5	| 	|
| ✔️	| EDL21	| 2023.7.3	| 	|
| ✔️	| Efergy	| 2022.10.5	| 	|
|   	| Eight Sleep	| 2022.10.5	| <= 2023.7.3	|
| ✔️	| Electra Smart	| 2023.7.3	| 	|
| ✔️	| Electric Kiwi	| 2024.12.5	| 	|
| ✔️	| Electricity Maps	| 2024.12.5	| 	|
| ✔️	| ElevenLabs	| 2024.12.5	| 	|
| ✔️	| Elexa Guardian	| 0.114.2	| 	|
| ✔️	| Elgato ➜ Elgato Light	| 0.114.2	| 	|
| ✔️	| Elk-M1 Control	| 0.114.2	| 	|
| ✔️	| Elmax	| 2022.10.5	| 	|
| ✔️	| Elvia	| 2024.12.5	| 	|
| ✔️	| emoncms ➜ Emoncms	| 2024.12.5	| 	|
| ✔️	| Emulated Roku	| 0.114.2	| 	|
| ✔️	| Energenie Power Sockets Integration	| 2024.12.5	| 	|
| ✔️	| Energie VanOns	| 2023.7.3	| provided by EnergyZero	|
| ✔️	| EnergyFlip	| 2024.12.5	| 	|
| ✔️	| EnergyZero	| 2023.7.3	| 	|
| ✔️	| Enigma2 (OpenWebif)	| 2024.12.5	| 	|
| ✔️	| Enmax Energy	| 2024.12.5	| provided by Opower	|
| ✔️	| EnOcean	| 0.114.2	| needs dongle	|
| ✔️	| Enphase Envoy	| 2021.5.4	| 	|
| ✔️	| Environment Agency Flood Gauges	| 0.118.5	| 	|
| ✔️	| Environment Canada	| 2022.10.5	| 	|
| ✔️	| Epic Games Store	| 2024.12.5	| 	|
| ✔️	| Epion	| 2024.12.5	| 	|
| ✔️	| Epson ➜ Epson	| 0.118.5	| 	|
| ✔️	| eQ-3 ➜ eQ-3 Bluetooth Smart Thermostats	| 2024.12.5	| 	|
| ✔️	| Escea	| 2022.10.5	| 	|
| ✔️	| ESERA 1-Wire	| 2023.7.3	| provided by 1-Wire	|
| ✔️	| ESPHome	| 0.114.2	| 	|
| ✔️	| Eufy ➜ EufyLife	| 2023.7.3	| 	|
| ✔️	| Evergy	| 2024.12.5	| provided by Opower	|
| ✔️	| Evil Genius Labs	| 2022.10.5	| 	|
| ✔️	| EZVIZ	| 2021.5.4	| 	|
| ✔️	| FAA Delays	| 2021.4.6	| 	|
| ✔️	| Fast.com	| 2024.12.5	| 	|
| ✔️	| Feedreader	| 2024.12.5	| 	|
| ✔️	| Fibaro	| 2022.10.5	| 	|
| ✔️	| File	| 2024.12.5	| 	|
| ✔️	| Filesize	| 2022.10.5	| 	|
| ✔️	| FireServiceRota	| 2021.1.5	| 	|
| ✔️	| Fitbit	| 2024.12.5	| 	|
| ✔️	| FiveM	| 2022.10.5	| 	|
| ✔️	| Fjäråskupan	| 2021.9.7	| 	|
| ✔️	| Flexit	| 2024.12.5	| 	|
| ✔️	| Flick Electric	| 0.114.2	| 	|
| ✔️	| Flipr	| 2021.8.8	| 	|
| ✔️	| Flo	| 0.118.5	| 	|
| 	| Flu Near You	| 0.114.2, < 2022.10.5	| 	|
| ✔️	| Flume	| 0.114.2	| 	|
| ✔️	| Folder Watcher	| 2024.12.5	| 	|
| ✔️	| Forecast.Solar	| 2021.7.4	| 	|
| 	| forked-daapd	| 0.114.2	| 2023.1.7 renamed to ➜ owntone	|
| ✔️	| Foscam	| 2021.4.6	| 	|
| ✔️	| Freebox	| 0.114.2	| 	|
| ✔️	| Freedompro	| 2021.7.4	| 	|
| ✔️	| FRITZ!Box ➜ AVM FRITZ!Box Call Monitor	| 2021.4.6	| 	|
| ✔️	| FRITZ!Box ➜ AVM FRITZ!Box Tools	| 2021.5.4	| 	|
| ✔️	| FRITZ!Box ➜ AVM FRITZ!SmartHome	| 0.114.2	| 	|
| ✔️	| Fronius	| 2022.10.5	| 	|
| ✔️	| Frontier Silicon	| 2023.7.3	| 	|
| ✔️	| Fujitsu	| 2024.12.5	| 	|
| ✔️	| Fully Kiosk Browser	| 2022.10.5	| 	|
| ✔️	| FYTA	| 2024.12.5	| 	|
| ✔️	| Garages Amsterdam	| 2021.7.4	| 	|
| ✔️	| Gardena Bluetooth	| 2024.12.5	| 	|
| ✔️	| Gaviota	| 2022.10.5	| provided by Motionblinds	|
|  	| Garmin Connect	| 0.114.2, <= 2021.7.4	| 	|
| ✔️	| Generic Camera	| 2022.10.5	| 	|
| ✔️	| Genius Hub	| 2024.12.5	| 	|
| ✔️	| Geocaching	| 2022.10.5	| 	|
| ✔️	| Geofency	| 0.114.2	| Webhook	|
| ✔️	| GeoJSON	| 2023.7.3	| 	|
| ✔️	| GeoNet ➜ GeoNet NZ Quakes	| 0.114.2	| 	|
| ✔️	| GeoNet ➜ GeoNet NZ Volcano	| 0.114.2	| 	|
| ✔️	| GeoSphere Austria	| 2024.12.5	| 	|
| ✔️	| GIOŚ	| 0.114.2	| 	|
| ✔️	| GitHub	| 2022.10.5	| 	|
| ✔️	| Glances	| 0.114.2	| 	|
| ✔️	| Global Disaster Alert and Coordination System (GDACS)	| 0.114.2	| 	|
| ✔️	| Goal Zero Yeti	| 0.118.5	| 	|
| ✔️	| Gogogate2 and ismartgate	| 0.118.5	| 	|
| ✔️	| GoodWe Inverter	| 2022.10.5	| 	|
| ✔️	| Google ➜ Google Assistant SDK	| 2023.1.7	| 	|
| ✔️	| Google ➜ Google Sheets	| 2022.10.5	| 	|
| ✔️	| Google ➜ Google Generative AI	| 2023.7.3	| 	|
| ✔️	| Google ➜ Google Mail	| 2023.7.3	| 	|
| ✔️	| Google ➜ Google Maps Travel Time	| 2021.5.4	| 	|
| ✔️	| Google ➜ Google Sheets	| 2023.7.3	| 	|
| ✔️	| Google ➜ Google Translate text-to-speech	| 2023.7.3	| 	|
| ✔️	| Google ➜ Dialogflow	| 0.114.2	| Webhook	|
| ✔️	| Google ➜ Google Calendar	| 2022.10.5	| 	|
| ✔️	| Google ➜ Google Cast	| 0.114.2	| 	|
| 	| Google ➜ Google Chat	| == 2022.10.5	| 	|
| ✔️	| Google ➜ Google Cloud	| 2024.12.5	| 	|
| ✔️	| Google ➜ Google Nest	| 0.114.2	| 	|
| ✔️	| Google ➜ Google Photo	| 2024.12.5	| 	|
| ✔️	| Google ➜ YouTube	| 2023.7.3	| 	|
| 	| Google Hangouts	| 0.114.2, <= 2021.9.7	| 	|
| ✔️	| Govee ➜ Govee Bluetooth	| 2022.10.5	| 	|
| ✔️	| Govee ➜ Govee lights local	| 2024.12.5	| 	|
| ✔️	| GPSD	| 2024.12.5	| 	|
| ✔️	| GPSLogger	| 0.114.2	| Webhook	|
| ✔️	| Gree Climate	| 0.118.5	| 	|
|  	| Griddy Power	| <= 2021.1.5	| 	|
| ✔️	| Growatt Server	| 2021.7.4	| 	|
| ✔️	| Habitica	| 2021.4.6	| 	|
| ✔️	| HACS	| 2022.10.5	| needs a github account	|
| ✔️	| Havana Shade	| 2023.7.3	| provided by Motions Blinds	|
| ✔️	| Hayward Omnilogic	| 0.118.5	| 	|
| ✔️	| Heiwa	| 2023.7.3	| provided by Gree Climate	|
| ⚙	| HELTUN ➜ Add Z-Wave device	| 2023.7.3	| Requires Z-Wave integration	|
| ✔️	| HERE Travel Time	| 2022.10.5	| 	|
| ✔️	| Hexaom Hexaconnect	| 2023.7.3	| provided by Overkiz	|
| ✔️	| Hi-Link HLK-SW16	| 0.114.2	| 	|
| ✔️	| Hisense AEH-W4A1	| 0.114.2	| 	|
| ✔️	| Hitachi Hi Kumo	| 2022.10.5	| provided by Overkiz	|
| ✔️	| Hive	| 2021.4.6	| 	|
| ✔️	| Holiday	| 2024.12.5	| 	|
| ✔️	| Home Assistant Analytics Insights	| 2024.12.5	| 	|
| ✔️	| Home Assistant iOS	| 0.114.2	| 	|
| ✔️	| Home Connect	| 0.114.2	| 	|
| ✔️	| Homematic ➜ HomematicIP Cloud	| 0.114.2	| 	|
| ⚙	| HomeSeer ➜ Add Z-Wave device	| 2023.7.3	| Requires Z-Wave integration	|
| ✔️	| HomeWizard Energy	| 2022.10.5	| 	|
| ✔️	| Honeywell ➜ Honywell Lyric	| 2021.4.6	| 	|
| ✔️	| Honeywell ➜ Honeywell Total Connect Comfort (US)	| 2021.8.8	| 	|
| ✔️	| Hong Kong Observatory	| 2024.12.5	| 	|
| ✔️	| HTML5 Push Notifications	| 2024.12.5	| 	|
| ✔️	| Huawei LTE	| 0.114.2	| 	|
| ✔️	| Huisbaasje	| 2021.4.6	| 	|
| ✔️	| Hunter Douglas PowerView	| 0.114.2	| 	|
| ✔️	| Hunter Hydrawise	| 2024.12.5	| 	|
| ✔️	| Hurrican Shutters Wholesale	| 2022.10.5	| provided by Motion Blinds	|
| ✔️	| Husqvarna ➜ Husqvarna Automower	| 2024.12.5	| 	|
| ✔️	| Husqvarna ➜ Husqvarna Automower BLE	| 2024.12.5	| 	|
| ✔️	| Huum	| 2024.12.5	| 	|
| ✔️	| HVV Departures	| 0.114.2	| 	|
| ✔️	| Hyperion	| 2021.1.5	| 	|
| ✔️	| IFTTT	| 0.114.2	| Webhook	|
| ✔️	| IKEA ➜ IKEA TRÅDFRI	| 0.118.5-11	| failed in 2022.10.5-19	|
| ✔️	| IMAP	| 2023.7.3	| 	|
| ✔️	| IMGW-PIB	| 2024.12.5	| 	|
| ✔️	| Improv via BLE	| 2024.12.5	| 	|
| ✔️	| Indiana Michigan Power	| 2024.12.5	| provided by Opower	|
| ✔️	| inexogy	| 2024.12.5	| 	|
| ✔️	| INKBIRD	| 2022.10.5	| 	|
| ⚙	| Inovelli ➜ Add Z-Wave device	| 2023.7.3	| Requires Z-Wave integration	|
| ⚙	| Inovelli ➜ Add Zigbee device	| 2023.7.3	| Requires Zigbee integration	|
| ✔️	| Inspired Shades	| 2023.7.3	| provided by Motion Blinds	|
| ✔️	| Insteon	| 0.118.5	|  	|
| ✔️	| Instituto Português do Mar e Atmosfera (IPMA)	| 0.114.2	| 	|
| ✔️	| IntelliFire	| 2022.10.5	| 	|
| ✔️	| Intergas InComfort/Intouch Lan2RF gateway	| 2024.12.5	| 	|
| ✔️	| International Space Station (ISS)	| 2022.10.5	| 	|
| ✔️	| Internet Printing Protocol (IPP)	| 0.114.2	| 	|
| ✔️	| IoTaWatt	| 2021.9.7	| 	|
| ✔️	| iotty	| 2024.12.5	| 	|
| ✔️	| IQVIA	| 0.118.5-12	| 	|
| ✔️	| iRobot Roomba and Braava	| 0.114.2	| 	|
| ✔️	| IronOS	| 2024.12.5	| 	|
| ✔️	| iskra	| 2024.12.5	| 	|
| ✔️	| Islamic Prayer Times	| 0.114.2	| 	|
| ✔️	| iSmartWindow	| 2022.10.5	| provided by Motion Blinds	|
| ✔️	| Israel Railways	| 2024.12.5	| 	|
| ✔️	| ista EcoTrend	| 2024.12.5	| 	|
|   	| Itho Daalderop Spider	| 0.114.2	| <= 2023.7.3	|
| ✔️	| iZone	| 0.114.2	| 	|
| ✔️	| Jandy iAqualink	| 0.114.2	| 	|
| ⚙	| Jasco ➜ Add Z-Wave device	| 2022.10.5	| Requires Z-Wave integration	|
| ✔️	| Jellyfin	| 2022.10.5	| 	|
| ✔️	| Jewish Calendar	| 2024.12.5	| 	|
| ✔️	| JuiceNet	| 0.114.2	| 	|
| ✔️	| JustNimbus	| 2022.10.5	| 	|
| ✔️	| JVC Projector	| 2023.7.3	| 	|
| ✔️	| Kaleidescape	| 2022.10.5	| 	|
| ✔️	| Keenetic NDMS2 Router	| 2021.4.6	| 	|
| ✔️	| Kegtron	| 2022.10.5	| 	|
| ✔️	| Kentucky Power	| 2024.12.5	| provided by Opower	|
| ✔️	| Keymitt MicroBot Push	| 2022.10.5	| 	|
| ✔️	| KMtronic	| 2021.4.6	| 	|
| ✔️	| KNX	| 2022.10.5	| 	|
| ✔️	| Kodi	| 0.118.5	| 	|
| ✔️	| Konnected.io	| 0.114.2	| 	|
| ✔️	| Kostal Plenticore Solar Inverter	| 2021.5.4	| 	|
| ✔️	| Kraken	| 2021.7.4	| 	|
| ✔️	| Krispol	| 2024.12.5	| provided by Motionblinds	|
| ✔️	| Kuler Sky	| 2021.1.5	| 	|
| ✔️	| La Marzocco	| 2024.12.5	| 	|
| ✔️	| LaCrosse View	| 2022.10.5	| 	|
| ✔️	| LaMetric	| 2022.10.5	| 	|
| ✔️	| Landis+Gyr Heat Meter	| 2022.10.5	| 	|
| ✔️	| Last.fm	| 2023.7.3	| 	|
| ✔️	| Launch Library	| 2022.10.5	| 	|
| ✔️	| laundrify	| 2022.10.5	| 	|
| ✔️	| LCN	| 2024.12.5	| 	|
| ✔️	| LD2410 BLE	| 2023.7.3	| 	|
| ✔️	| LeaOne	| 2024.12.5	| 	|
| ✔️	| LED BLE	| 2022.10.5	| 	|
| ✔️	| Legrand	| 2022.10.5	| provided by Netatmo	|
| ✔️	| Legrand Home+ Control	| 2021.8.8	| provided by Netatmo	|
| ✔️	| Lektrico Charging Station	| 2024.12.5	| 	|
| ⚙	| Leviton ➜ Add Z-Wave device	| 2022.10.5	| Requires Z-Wave integration	|
| ✔️	| LG ➜ LG Netcast	| 2024.12.5	| 	|
| ✔️	| LG ➜ LG Soundbars	| 2022.10.5	| 	|
| ✔️	| LG ➜ LG ThinQ	| 2024.12.5	| 	|
| ✔️	| LG ➜ LG webOS Smart TV	| 2022.10.5	| 	|
| ✔️	| Lidarr	| 2022.10.5	| 	|
|   	| Life360	| 0.114.2	| <= 2023.7.3	|
| ✔️	| LIFX	| 0.114.2	| 	|
| ✔️	| Linear Garage Door	| 2024.12.5	| 	|
| ✔️	| LinkPlay	| 2024.12.5	| 	|
| ❌️	| Linn / OpenHome	| 2023.7.3	| Error 'not_implemented'	|
| ✔️	| LiteJet	| 2021.4.6	| 	|
| ✔️	| Litter-Robot	| 2021.4.6	| 	|
| ✔️	| LIVISI Smart Home	| 2023.1.7	| 	|
| ✔️	| Local Calendar	| 2023.7.3	| 	|
| ✔️	| Local File	| 2024.12.5	| 	|
| ✔️	| Local IP-Address	| 0.114.2	| 	|
| ✔️	| Local To-do	| 2024.12.5	| 	|
| ✔️	| Locative	| 0.114.2	| Webhook	|
|   	| Logi Circle	| 0.114.2	| <= 2023.7.3	|
| ✔️	| Logitech ➜ Logitech Harmony Hub	| 0.114.2	| 	|
| ✔️	| Logitech ➜ Squeezebox (Lyrion Music Server)	| 0.114.2	| 	|
| ✔️	| LOOKin	| 2022.10.5	| 	|
| ✔️	| LOQED Touch Smart Lock	| 2023.7.3	| 	|
| 	| Luftdaten	| 0.114.2, <= 2021.9.7	| 	|
| ✔️	| Lupus Electronics LUPUSEC	| 2024.12.5	| 	|
| ✔️	| Lutron ➜ Lutron	| 2024.12.5	| 	|
| ✔️	| Lutron ➜ Lutron Caséta	| 2021.4.6	| 	|
| ✔️	| Lutron ➜ Lutron Homeworks	| 2024.12.5	| 	|
| ✔️	| Luxaflex	| 2022.10.5	| provided by Hunter Douglas PowerView	|
| ✔️	| Madeco	| 2024.12.5	| provided by Motionblinds	|
| ✔️	| madVR Envy	| 2024.12.5	| 	|
| ✔️	| Magic Home	| 2022.10.5	| 	|
| ✔️	| Mailgun	| 0.114.2	| Webhook	|
| ✔️	| Marantz	| 2022.10.5	| provided by Denon AVR Network Receivers	|
| ✔️	| Martec	| 2022.10.5	| provided by Motion Blinds	|
| ✔️	| Mastodon	| 2024.12.5	| 	|
| ✔️	| Matter (BETA)	| 2023.7.3	| 	|
|   	| Mazda Connected Services	| 2021.4.6	| <= 2023.7.3	|
| ✔️	| Mealie	| 2024.12.5	| 	|
| ✔️	| Meater	| 2022.10.5	| 	|
| ✔️	| Medcom Bluetooth	| 2024.12.5	| 	|
| ✔️	| Media Exractor	| 2024.12.5	| 	|
| ✔️	| MELCloud	| 0.114.2	| 	|
| ✔️	| Melnor ➜ Melnor Bluetooth 	| 2022.10.5	| 	|
| ✔️	| Mercury NZ Limited	| 2024.12.5	| provided by Opower	|
| ✔️	| Met Éireann	| 2021.5.4	| 	|
| ✔️	| Met Office	| 0.114.2	| 	|
| ✔️	| Météo-France	| 0.114.2	| 	|
| ✔️	| Meteoclimatic	| 2021.7.4	| 	|
| ✔️	| Meteorologisk institutt (Met.no)	| 0.114.2	| 	|
| ✔️	| Microsoft ➜ Azure DevOps	| 0.114.2	| 	|
| ✔️	| Microsoft ➜ Azure Event Hub	| 2022.10.5	| 	|
| ✔️	| Microsoft ➜ Xbox	| 0.118.5	| 	|
| ✔️	| Midea ccm15 AC Controller	| 2024.12.5	| 	|
| ✔️	| Mijndomein Energie	| 2023.7.3	| provided by EnergyZero	|
| ✔️	| Mikrotik	| 0.114.2	| 	|
| ✔️	| Mill	| 0.114.2	| 	|
| ✔️	| Minecraft Server	| 0.114.2	| 	|
| ✔️	| MINI Connected	| 2024.12.5	| provided by BMW Connected Drive	|
| ✔️	| Minut Point	| 2024.12.5	| 	|
| ✔️	| MJPEG IP Camera 	| 2022.10.5	| 	|
| ✔️	| Moat 	| 2022.10.5	| 	|
| ⚙	| Mobile App	| 0.114.2	| needs mobile App to setup the integration	|
| ✔️	| Modern Forms	| 2021.7.4	| 	|
| ✔️	| Möhlenhoff Alpha2 	| 2022.10.5	| 	|
| ✔️	| Monarch Money	| 2024.12.5	| 	|
| ✔️	| Monessen	| 2023.7.3	| provided by IntelliFire	|
| ✔️	| Monoprice 6-Zone Amplifier	| 0.114.2	| 	|
| ✔️	| Monzo	| 2024.12.5	| 	|
| ✔️	| Moon 	| 2022.10.5	| 	|
| ✔️	| Mopeka	| 2023.7.3	| 	|
| ✔️	| Motionblinds ➜ Motionblinds	| 2021.1.5	| 	|
| ✔️	| Motionblinds ➜ Motionblinds Bluetooth	| 2024.12.5	| 	|
| ✔️	| motionEye	| 2021.5.4	| 	|
| ✔️	| MQTT ➜ MQTT	| 0.114.2	| 	|
| ✔️	| Mullvad VPN	| 2021.4.6	| 	|
| ✔️	| Music Assistant	| 2024.12.5	| 	|
| ✔️	| Music Player Daemon (MPD)	| 2024.12.5	| 	|
| ✔️	| mutesync	| 2021.5.4	| 	|
|   	| MyQ	| 0.114.2	| <= 2023.7.3	|
| ✔️	| MyPermobil	| 2024.12.5	| 	|
| ✔️	| MySensors	| 2021.4.6	| 	|
| ✔️	| MyStrom	| 2023.7.3	| 	|
| ✔️	| myUplink	| 2024.12.5	| 	|
| ✔️	| Nanoleaf 	| 2022.10.5	| 	|
| ✔️	| NASweb	| 2024.12.5	| 	|
| ✔️	| National Weather Service (NWS)	| 0.114.2	| 	|
| ✔️	| Neato Botvac	| 0.114.2	| 	|
| ✔️	| Netatmo	| 0.114.2	| 	|
| ✔️	| NETGEAR ➜ NETGEAR 	| 2022.10.5	| 	|
| ✔️	| NETGEAR ➜ NETGEAR LTE	| 2024.12.5	| 	|
| ✔️	| Nettigo Air Monitor	| 2021.7.4	| 	|
| ✔️	| Network UPS Tools (NUT)	| 0.114.2	| 	|
| ✔️	| Nexia/American Standard/Trane	| 0.114.2	| 	|
| ✔️	| Nexity Eugénie 	| 2022.10.5	| provided by Overkiz	|
| ✔️	| NextBus preditions	| 2024.12.5	| 	|
| ✔️	| Nextcloud	| 2023.7.3	| 	|
| ✔️	| NextDNS 	| 2022.10.5	| 	|
| ✔️	| Nibe Heat Pump 	| 2022.10.5	| 	|
| ✔️	| Nice G.O. 	| 2024.12.5	| 	|
| ✔️	| Nightscout	| 0.118.5	| 	|
| ✔️	| Niko Home Control	| 2024.12.5	| 	|
| ✔️	| NINA 	| 2022.10.5	| 	|
| ✔️	| Nmap Tracker	| 2021.9.7	| 	|
| ✔️	| NOAA Aurora-Sensor	| 2021.4.6	| 	|
| ✔️	| Nobø Ecohub 	| 2022.10.5	| 	|
| ✔️	| Nord Pool	| 2024.12.5	| 	|
| ✔️	| Notifications for Android TV / Fire TV	| 2021.8.8	| 	|
| ✔️	| Notion	| 0.114.2	| 	|
| ✔️	| NuHeat	| 0.114.2	| 	|
| ✔️	| Nuki	| 2021.4.6	| 	|
| ✔️	| Nutrichef 	| 2022.10.5	| provided by INKBIRD	|
| ✔️	| nVent RAYCHEM SENZ 	| 2022.10.5	| 	|
| ✔️	| NYT Games	| 2024.12.5	| 	|
| ✔️	| NZBGet	| 2021.1.5	| 	|
| ✔️	| Obihai	| 2023.7.3	| 	|
| ✔️	| OctoPrint 	| 2022.10.5	| 	|
| ✔️	| Ollama	| 2024.12.5	| 	|
| ✔️	| Oncue by Kohler 	| 2022.10.5	| 	|
| ✔️	| Ondilo ICO	| 2021.4.6	| 	|
| ✔️	| One-Time Password (OTP)	| 2024.12.5	| 	|
| ✔️	| Onkyo	| 2024.12.5	| 	|
| ✔️	| ONVIF	| 0.118.5	| 	|
| ✔️	| Open Exchange Rates	| 2022.10.5	| 	|
| ✔️	| Open Thread Border Router	| 2023.7.3	| 	|
| ✔️	| Open-Meteo	| 2022.10.5	| 	|
| ✔️	| OpenAI Conversation	| 2023.7.3	| 	|
| ✔️	| OpenGarage	| 2022.10.5	| 	|
| ✔️	| OpenSky Network	| 2024.12.5	| 	|
| ✔️	| OpenTherm Gateway	| 0.114.2	| 	|
| ✔️	| OpenUV	| 0.114.2	| 	|
| ✔️	| OpenWeatherMap	| 0.118.5	| 	|
| 	| OpenZWave (beta)	| 0.114.2, <= 2021.9.7	| 	|
| ✔️	| Opower	| 2024.12.5	| 	|
| ✔️	| Oral-B	| 2023.7.3	| 	|
| ✔️	| Orange and Rockland Utilities (ORU) Opower	| 2024.12.5	| provided by Opower	|
| ✔️	| OSO Energy	| 2024.12.5	| 	|
| ✔️	| OurGroceries	| 2024.12.5	| 	|
| ✔️	| Overkiz 	| 2022.10.5	| 	|
| ✔️	| OVO Energy	| 0.114.2	| 	|
| ✔️	| OwnTone	| 2023.1.7	| 	|
| ✔️	| OwnTracks	| 0.118.5	| 	|
| ✔️	| P1 Monitor	| 2021.9.7	| 	|
| ✔️	| Pacific Gas & Electric (PG&E)	| 2024.12.5	| 	|
| ✔️	| Palazzetti	| 2024.12.5	| 	|
| ✔️	| Panasonic ➜ Panasonic Viera	| 0.114.2	| 	|
| ✔️	| PCS Lighting	| 2023.7.3	| provided by Universal Powerline Bus (UPB)	|
| ✔️	| PECO Energy Company (PECO)	| 2024.12.5	| provided by Opower	|
| ✔️	| PECO Outage Counter	| 2022.10.5	| 	|
| ✔️	| PEGELONLINE	| 2024.12.5	| 	|
| ✔️	| Pentair ScreenLogic	| 2021.4.6	| 	|
| ✔️	| Philips ➜ Philips Dynalite	| 0.114.2	| 	|
| ✔️	| Philips ➜ Philips Hue	| 0.114.2	| 	|
| ✔️	| Philips ➜ Philips TV	| 2021.4.6	| 	|
| ✔️	| Phone Modem	| 2022.10.5	| 	|
| ✔️	| Pi-hole	| 0.114.2	| 	|
| ✔️	| Picnic	| 2021.5.4	| 	|
| ✔️	| Pinecil	| 2024.12.5	| provided by IronOS	|
| ✔️	| Ping (ICMP)	| 2024.12.5	| 	|
| ✔️	| Piper	| 2023.7.3	| provided by Wyoming Protocol	|
| ✔️	| Plaato	| 0.114.2	| 	|
| ✔️	| Plex Media Server	| 0.114.2	| 	|
| ✔️	| Plugwise	| 0.114.2	| 	|
| ✔️	| Plum Lightpad	| 0.114.2	| 	|
| ✔️	| PoolSense	| 0.114.2	| 	|
| ✔️	| Portland General Electric (PGE)	| 2024.12.5	| provided by Opower	|
| ✔️	| Potomac Electric Power Company (Pepco)	| 2024.12.5	| provided by Opower	|
| ✔️	| Private BLE Device	| 2024.12.5	| 	|
| ✔️	| Profiler	| 0.118.5	| 	|
| ✔️	| ProgettiHWSW Automation	| 0.118.5	| 	|
| ✔️	| Prosegur Alarm	| 2021.8.8	| 	|
| ✔️	| Proximity	| 2024.12.5	| 	|
| ✔️	| PrusaLink	| 2022.10.5	| 	|
| ✔️	| Public Service Company of Oklahoma (PSO)	| 2024.12.5	| provided by Opower	|
| ✔️	| Puget Sound Energy (PSE)	| 2024.12.5	| provided by Opower	|
| ✔️	| Pure Energy	| 2022.10.5	| 	|
| ✔️	| PurpleAir	| 2023.7.3	| 	|
| ✔️	| Pushbullet	| 2023.7.3	| 	|
| ✔️	| Pushover	| 2022.10.5	| 	|
| ✔️	| PVOutput	| 2022.10.5	| 	|
| ✔️	| pyload	| 2024.12.5	| 	|
| ✔️	| qBittorrent	| 2023.7.3	| 	|
| ✔️	| Qingping	| 2022.10.5	| 	|
| ✔️	| QNAP ➜ QNAP	| 2023.7.3	| 	|
| ✔️	| QNAP ➜ QNAP QSW	| 2022.10.5	| 	|
| ✔️	| Quadra-Fire	| 2023.7.3	| provided by IntelliFire	|
| ✔️	| Rabbit Air	| 2024.12.5	| 	|
| ✔️	| Rachio	| 0.114.2	| 	|
| ✔️	| Radarr	| 2022.10.5	| 	|
| ✔️	| Radio Browser	| 2022.10.5	| 	|
| ✔️	| Radio Thermostat	| 2022.10.5	| 	|
| ✔️	| Rain Bird	| 2023.7.3	| 	|
| ✔️	| Rainforest Automation ➜ Rainforest Eagle	| 2021.9.7	| 	|
| ✔️	| Rainforest Automation ➜ Rainforest RAVEn	| 2024.12.5	| 	|
| ✔️	| RainMachine	| 0.114.2	| 	|
| ✔️	| RAPT Bluetooth	| 2023.7.3	| 	|
| ✔️	| Raspberry Pi ➜ Raspberry Pi Power Supply Checker	| 0.118.5	| 	|
| ✔️	| Raven Rock MFG	| 2022.10.5	| provided by Motion Blinds	|
| ✔️	| RDW	| 2022.10.5	| 	|
| ✔️	| Read Your Meter Pro	| 2023.7.3	| 	|
| ✔️	| ReCollect Waste	| 2021.1.5	| 	|
| ✔️	| Refoss	| 2024.12.5	| 	|
| ✔️	| Renault	| 2021.8.8	| 	|
| ✔️	| Renson	| 2023.7.3	| 	|
| ✔️	| Reolink	| 2023.7.3	| 	|
| ✔️	| Rexel Energeasy Connect	| 2022.10.5	| provided by Overkiz	|
| ✔️	| RFXCOM RFXtrx	| 0.118.5	| 	|
| ✔️	| Rhasspy	| 2022.10.5	| 	|
| ✔️	| Rheem EcoNet Products	| 2021.4.6	| 	|
| ✔️	| Ridwell	| 2022.10.5	| 	|
| ✔️	| Ring	| 0.114.2	| 	|
| ✔️	| Risco	| 0.118.5	| 	|
| ✔️	| Rituals Perfume Genie	| 2021.4.6	| 	|
|   	| RIVM Stookalert	| 2022.10.5	| <= 2023.7.3	|
| ✔️	| Roborock	| 2023.7.3	| 	|
| ✔️	| Roku	| 0.114.2	| 	|
| ❌️	| Rollease Acmeda Automate	| 0.114.2	| Error: Config flow could not be loaded: 500 Internal Server Error Server got itself in trouble	|
| ✔️	| RoonLabs music player	| 0.118.5	| 	|
| ✔️	| Roth ➜ Roth Touchline SL	| 2024.12.5	| 	|
| ✔️	| ROVA	| 2024.12.5	| 	|
| ✔️	| RTSPtoWebRTC	| 2024.12.5	| 	|
| ✔️	| RTSPtoWebRTC	| 2022.10.5	| 	|
| ✔️	| Ruckus	| 0.118.5	| 	|
| ✔️	| Russound ➜ Russound RIO	| 2024.12.5	| 	|
| ✔️	| Ruuvi ➜ Ruuvi Gateway	| 2023.7.3	| 	|
| ✔️	| Ruuvi ➜ RuuviTag BLE	| 2023.7.3	| 	|
| ✔️	| SABnzbd	| 2022.10.5	| 	|
| ✔️	| Sacramento Municipal Utility District (SMUD)	| 2024.12.5	| provided by Opower	|
| ✔️	| Salda Smarty	| 2024.12.5	| 	|
| ✔️	| SamSam	| 2024.12.5	| provided by EnergyZero	|
| ✔️	| Samsung ➜ Samsung Smart TV	| 0.114.2	| 	|
| ✔️	| Samsung ➜ Samsung SyncThru Printer	| 0.114.2	| 	|
| ✔️	| Sanix	| 2024.12.5	| 	|
| ✔️	| Schlage	| 2024.12.5	| 	|
| ✔️	| Scrape	| 2023.7.3	| 	|
| ✔️	| ScreenAway	| 2023.7.3	| provided by Motion Blinds	|
| ✔️	| Season	| 2022.10.5	| 	|
| ✔️	| Seattle City Light (SCL)	| 2024.12.5	| provided by Opower	|
| ✔️	| Sense	| 0.114.2	| 	|
| ✔️	| SenseME	| 2022.10.5, <= 2023.1.7	| 	|
| ✔️	| Sensibo	| 2022.10.5	| 	|
| ✔️	| Sensirion BLE	| 2023.7.3	| 	|
| ✔️	| Sensor.Community	| 2022.10.5	| 	|
| ✔️	| SensorBlue	| 2022.10.5	| provided by ThermoBeacon	|
| ✔️	| SensorPro	| 2022.10.5	| 	|
| ✔️	| SensorPush	| 2022.10.5	| 	|
| ✔️	| Sensoterra	| 2024.12.5	| 	|
| ✔️	| Sentry	| 0.114.2	| 	|
| ✔️	| SFR Box	| 2023.7.3	| 	|
| ✔️	| Shark IQ	| 0.118.5	| 	|
| ✔️	| Shelly	| 0.118.5	| 	|
| ✔️	| Shopping List	| 0.114.2	| 	|
| ✔️	| SIA Alarmsystems	| 2021.7.4	| 	|
| ✔️	| SimpleFin	| 2024.12.5	| 	|
| ✔️	| Simplepush	| 2022.10.5	| 	|
| ✔️	| SimpliSafe	| 0.114.2	| 	|
| ✔️	| Simply Automated	| 2023.7.3	| provided by Universal Powerline Bus (UPB)	|
| ✔️	| SIMU LiveIn2	| 2023.7.3	| provided by Overkiz	|
| ✔️	| SiteSage Emonitor	| 2021.5.4	| 	|
| ✔️	| Sky ➜ Sky Remote Control	| 2024.12.5	| 	|
| ✔️	| SkyBell	| 2022.10.5	| 	|
| ✔️	| Slack	| 2022.10.5	| 	|
| ✔️	| SleepIQ	| 2022.10.5	| 	|
| ✔️	| Slimproto (Squeezebox players)	| 2022.10.5	| 	|
| ✔️	| SMA Solar	| 2021.5.4	| 	|
| ✔️	| Smappee	| 0.118.5	| 	|
| ✔️	| Smart Home	| 2022.10.5	| provided by Motion Blinds	|
| ✔️	| Smart Meter Texas	| 0.118.5	| 	|
| 	| SmartHab	| 0.114.2, <= 2021.9.7	| 	|
| ✔️	| Smartblinds	| 2022.10.5	| provided by Motion Blinds	|
| ✔️	| Smarther	| 2022.10.5	| provided by Netatmo	|
| ⚙	| SmartThings	| 0.114.2	| 	|
| ✔️	| SmartTub	| 2021.4.6	| 	|
| ✔️	| SMHI	| 0.114.2	| 	|
| ✔️	| SMLIGHT SLZB	| 2024.12.5	| 	|
| ❌️	| SMS notifications via GSM-modem	| 0.114.2	| python-gammu: not supported on linux (Windows only)	|
| ✔️	| Snapcast	| 2023.7.3	| 	|
| ✔️	| Snooz	| 2023.7.3	| 	|
| ✔️	| Solar-Log	| 0.114.2	| 	|
| ✔️	| SolarEdge ➜ SolarEdge	| 0.114.2	| 	|
| ✔️	| SolaX Power	| 2022.10.5	| 	|
| ✔️	| Soma Connect	| 0.114.2	| 	|
| ✔️	| Somfy	| 0.114.2	| provided by Overkiz	|
| ✔️	| Somfy MyLink	| 2021.4.6	| 	|
| ✔️	| Sonarr	| 0.114.2	| 	|
| ✔️	| Sonos	| 0.114.2	| 	|
| ✔️	| Sony ➜ Sony Bravia TV	| 0.114.2	| 	|
| ✔️	| Sony ➜ Sony PlayStation 4	| 0.114.2	| 	|
| ✔️	| Sony ➜ Sony Songpal	| 0.114.2	| 	|
| ✔️	| Soundavo WS66i 6-Zone Amplifier	| 2022.10.5	| 	|
| ✔️	| Southwestern Electric Power Company (SWEPCO)	| 2024.12.5	| provided by Opower	|
| ✔️	| Spain electricity hourly pricing (PVPC)	| 0.114.2	| 	|
| ✔️	| Speedtest.net	| 0.114.2	| 	|
| ✔️	| Spotify	| 0.114.2	| 	|
| ✔️	| SQL	| 2022.10.5	| 	|
| ✔️	| SRP Energy	| 2021.1.5	| 	|
| ✔️	| StarLine	| 0.114.2	| 	|
| ✔️	| Starlink	| 2023.7.3	| 	|
| ✔️	| Steam	| 2022.10.5	| 	|
| ✔️	| Steamist	| 2022.10.5	| 	|
| ✔️	| Stookwijzer	| 2023.7.3	| 	|
| ✔️	| Subaru	| 2021.4.6	| 	|
| ✔️	| Suez Water	| 2024.12.5	| 	|
| ✔️	| Sun	| 2022.10.5	| 	|
| ✔️	| Sun WEG	| 2024.12.5	| 	|
| ✔️	| Sure Petcare	| 2022.10.5	| 	|
| ✔️	| Swiss public transport	| 2024.12.5	| 	|
| ✔️	| SwitchBee	| 2022.10.5	| 	|
| ✔️	| SwitchBot ➜ SwitchBot Bluetooth	| 2024.12.5	| 	|
| ✔️	| SwitchBot ➜ SwitchBot Cloud	| 2024.12.5	| 	|
| ✔️	| Switcher	| 2021.8.8	| 	|
| ✔️	| Syncthing	| 2021.7.4	| 	|
| ✔️	| Synology ➜ Synology DSM	| 0.114.2	| 	|
| ✔️	| System-Bridge	| 2021.7.4	| 	|
| ✔️	| System Monitor	| 2024.12.5	| 	|
| ✔️	| Tado	| 0.114.2	| 	|
| ✔️	| Tailscale	| 2022.10.5	| 	|
| ✔️	| Tailwind	| 2024.12.5	| 	|
| ✔️	| Tami4 Edge / Edge+	| 2024.12.5	| 	|
| ✔️	| Tankerkoenig	| 2022.10.5	| 	|
| ✔️	| Tasmota | 0.118.5	| 	|
| ✔️	| Tautulli	| 2022.10.5	| 	|
| ✔️	| Telldus ➜ Telldus Live	| 0.114.2	| 	|
| ✔️	| Tesla ➜ Tesla Fleet	| 2024.12.5	| 	|
| ✔️	| Tesla ➜ Tesla Powerwall	| 0.114.2	| 	|
| ✔️	| Tesla ➜ Tesla Wall Connector	| 2022.10.5	| 	|
| ✔️	| Teslemetry	| 2024.12.5	| 	|
| ✔️	| Tessie	| 2024.12.5	| 	|
| ✔️	| The Things Network	| 2024.12.5	| 	|
| ✔️	| ThermoBeacon	| 2022.10.5	| 	|
| ✔️	| ThermoPlus	| 2022.10.5	| provided by ThermoBeacon	|
| ✔️	| ThermoPro	| 2022.10.5	| 	|
| ⚙	| Third Reality ➜ Add Zigbee device	| 2022.10.5	| Requires Zigbee integration	|
| ✔️	| Thread	| 2023.7.3	| 	|
| ✔️	| Tibber	| 0.114.2	| 	|
| ✔️	| Tile	| 2021.1.5	| 	|
| ✔️	| Tilt Hydrometer BLE	| 2022.10.5	| 	|
| ✔️	| Time & Date	| 2024.12.5	| 	|
| ✔️	| Todoist	| 2024.12.5	| 	|
| ✔️	| TOLO Sauna	| 2022.10.5	| 	|
| ✔️	| Tomorrow.io	| 2022.10.5	| 	|
| ⚙	| Toon	| 0.114.2	| needs manual configuration	|
| ✔️	| Total Connect	| 2021.4.6	| 	|
| ✔️	| TP-Link ➜ Add Matter Device	| 2023.7.3	| 	|
|   	| TP-Link ➜ TP-Link	| 0.114.2	| <= 2023.7.3	|
| ✔️	| TP-Link ➜ TP-Link Omada	| 2023.7.3	| 	|
| ✔️	| TP-Link ➜ TP-Link Smart Home	| 2024.12.5	| 	|
| ✔️	| Traccar ➜ Traccar Client	| 0.114.2	| Webhook	|
| ✔️	| Traccar ➜ Traccar Server	| 2024.12.5	| 	|
| ✔️	| Tractive	| 2021.9.7	| 	|
| ✔️	| Trafikverket ➜ Trafikverket Camera	| 2024.12.5	| 	|
| ✔️	| Trafikverket ➜ Trafikverket Ferry	| 2022.10.5	| 	|
| ✔️	| Trafikverket ➜ Trafikverket Train	| 2022.10.5	| 	|
| ✔️	| Trafikverket ➜ Trafikverket Weather Station	| 2022.10.5	| 	|
| ✔️	| Transmission	| 0.114.2	| 	|
| ✔️	| Tuya	| 0.114.2	| 	|
| ✔️	| Twente Milieu	| 0.114.2	| 	|
| ✔️	| Twilio ➜ Twilio	| 0.114.2	| Webhook	|
| ✔️	| Twinkly	| 2021.1.5	| 	|
| ✔️	| Twitch	| 2024.12.5	| 	|
| ⚙	| U-tec ➜ Ultraloq ➜ Add Z-Wave device	| 2022.10.5	| Requires Z-Wave integration	|
| ✔️	| Ubiquiti ➜ UniFi Network	| 2022.10.5	| 	|
| ✔️	| Ubiquiti ➜ UniFi Protect	| 2022.10.5	| 	|
| 	| Ubiquiti UniFi	| 0.114.2, <= 2021.9.7	| 	|
| ✔️	| Ubiwizz	| 2023.7.3	| provided by Overkiz	|
| ✔️	| Ukraine Alarm	| 2022.10.5	| 	|
| ✔️	| Universal Devices ISY/IoX	| 0.114.2	| former name: Universal Devices ISY994	|
| ✔️	| Universal Powerline Bus (UPB)	| 0.114.2	| 	|
| ✔️	| Uonet+ Vulcan	| 2022.10.5	| 	|
| ✔️	| UpCloud	| 0.118.5	| 	|
| ✔️	| UPnP/IGD	| 0.114.2	| 	|
| ✔️	| Uprise Smart Shades	| 2022.10.5	| provided by Motion Blinds	|
| ✔️	| Uptime	| 2022.10.5	| 	|
| ✔️	| UptimeRobot	| 2021.9.7	| 	|
| ✔️	| V2C	| 2024.12.5	| 	|
| ✔️	| Vallox	| 2022.10.5	| 	|
| ✔️	| Velbus	| 0.114.2	| 	|
| ✔️	| Venstar	| 2022.10.5	| 	|
| ✔️	| Vera	| 0.114.2	| 	|
| ✔️	| Verisure	| 2021.4.6	| 	|
| ✔️	| Vermont Castings	| 2023.7.3	| provided by IntelliFire	|
| ✔️	| Version	| 2022.10.5	| 	|
| ✔️	| VeSync	| 0.114.2	| 	|
| ✔️	| VideoLAN ➜ VLC media player via Telnet	| 2022.10.5	| 	|
| ✔️	| Viessmann ViCare	| 2022.10.5	| 	|
| ✔️	| Vilfo Router	| 0.114.2	| 	|
| ✔️	| VIZIO SmartCast	| 0.114.2	| 	|
| ✔️	| Vodafone Station	| 2024.12.5	| 	|
| ✔️	| Vogel's MotionMount	| 2024.12.5	| 	|
| ✔️	| Voice over IP	| 2023.7.3	| 	|
| ✔️	| Volumio	| 0.114.2	| 	|
| ✔️	| Volvo On Call	| 2022.10.5	| 	|
| ✔️	| Wake on LAN	| 2024.12.5	| 	|
| ✔️	| Wallbox	| 2021.7.4	| 	|
| ✔️	| WattTime	| 2022.10.5	| 	|
| ✔️	| Waze Travel Time	| 2021.5.4	| 	|
| ❌️	| WeatherFlow ➜ WeatherFlow	| 2024.12.5	| Config flow could not be loaded: Unknown error	|
| ✔️	| WeatherFlow ➜ WeatherflowCloud	| 2024.12.5	| 	|
| ✔️	| Webmin	| 2024.12.5	| 	|
| ✔️	| Weheat	| 2024.12.5	| 	|
| ✔️	| Whirlpool Appliances	| 2022.10.5	| named 'Whirlpool Sixth Sense' until 2023.7.3	|
| ✔️	| Whisper	| 2023.7.3	| provided by Wyoming Protocol	|
| ✔️	| Whois	| 2022.10.5	| 	|
| ✔️	| Wiffi	| 0.114.2	| 	|
| ❌️	| WiLight	| 0.118.5	| Error 'not_implemented'	|
| ✔️	| Withings	| 0.114.2	| 	|
| ✔️	| WiZ	| 2022.10.5	| 	|
| ✔️	| WLED	| 0.114.2	| 	|
| ✔️	| WMS WebControl pro	| 2024.12.5	| 	|
| ✔️	| Wolf SmartSet Service	| 0.114.2	| 	|
| ✔️	| Workday	| 2022.10.5	| 	|
| ✔️	| World Air Quality Index (WAQI)	| 2024.12.5	| 	|
| ✔️	| Worldclock	| 2024.12.5	| 	|
| ✔️	| Wyoming Protocol	| 2022.10.5	| 	|
| ✔️	| Xiaomi ➜ Xiaomi BLE	| 2022.10.5	| 	|
| ✔️	| Xiaomi ➜ Xiaomi Gateway (Aqara)	| 0.118.5-11	| 	|
| ✔️	| Xiaomi ➜ Xiaomi Miio	| 0.118.5-11	| 	|
| ✔️	| Yale ➜ Yale	| 2024.12.5	| 	|
| ✔️	| Yale ➜ Yale Access Bluetooth	| 2022.10.5	| 	|
| ✔️	| Yale ➜ Yale Smart Living	| 2021.8.8	| 	|
| ✔️	| Yamaha ➜ MusicCast	| 2021.7.4	| 	|
| ✔️	| Yardian	| 2024.12.5	| 	|
| ✔️	| Yeelight ➜ Yeelight	| 0.118.5	| 	|
| ✔️	| YoLink	| 2022.10.5	| 	|
| ✔️	| YouLess	| 2021.8.8	| 	|
| ✔️	| Z-Wave	| 0.114.2	| deprecated as of 2021.4.6 => still available in 2024.12.5 |
| ✔️	| Z.Wave.Me	| 2022.10.5	| 	|
| 	| Z-Wave JS	| 2021.4.6, <= 2021.9.7	| 	|
|   	| Zentralanstalt für Meteorologie und Geodynamik (ZAMG)	| 2023.7.3	| <= 2023.7.3	|
| ✔️	| Zerproc	| 0.114.2	| 	|
| ✔️	| Zerversolar	| 2023.7.3	| 	|
| ✔️	| Zigbee Home Automation	| 0.118.5	| 	|
| ✔️	| Zodiac	| 2024.12.5	| 	|
| ✔️	| ZonderGas	| 2024.12.5	| provided by EnergyZero	|
| ⚙	| Zooz ➜ Add Z-Wave device	| 2022.10.5	| Requires Z-Wave integration	|
