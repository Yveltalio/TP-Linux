# Cinquième TP 🐱

# Partie 1 : Script carte d'identité

voici le fichier: [IDcard](./idcard.sh)

et voici la sortie :
```bash
Machine name : Scripting
OS : Rocky Linux and kernel version is 5.14.0-284.11.1.el9_2.x86_64
IP : 192.168.1.2
RAM : 482028 memory available on 790244 total memory
Disk : 5194052 space left
Top 5 processes by RAM usage :
- python3 - NetworkManager - systemd - systemd - systemd-udevd
Listening ports :
 - 323 udp : chronyd
 - 22 tcp : sshd
PATH directories :
/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin
Here is your random cat (jpg file) : https://cdn2.thecatapi.com/images/bf5.jpg
```
# II. Script youtube-dl

## B. Rendu attendu

voici le script: [youtube downloader](./youtoube.sh)

voici les logs de notre downloader

```bash
[aymeric@Scripting ~]$ cat /var/log/yt/download.log
[2024/03/04 16:43:53] Video https://www.youtube.com/watch?v=tZUo4K9yJr4 was downloaded. File path : /srv/yt/downloads/Luther - ALED/Luther - ALED.mp4
[2024/03/04 16:46:03] Video https://www.youtube.com/watch?v=mb79mnyZfUU was downloaded. File path : /srv/yt/downloads/RENOI SANS EAU - LOGOBI PIGNOUF/RENOI SANS EAU - LOGOBI PIGNOUF.mp4
```
et ce que le script ressort 

```bash
[aymeric@Scripting ~]$ ./youtoube.sh "https://www.youtube.com/watch?v=mb79mnyZfUU"
Video https://www.youtube.com/watch?v=mb79mnyZfUU was downloaded.
File path : /srv/yt/downloads/RENOI SANS EAU - LOGOBI PIGNOUF/RENOI SANS EAU - LOGOBI PIGNOUF.mp4
```

## 2. MAKE IT A SERVICE

### C. Rendu

voici le script: [youtube downloader](./toutoube.sh)

-> le fichier conf :

```bash
[aymeric@Scripting ~]$ sudo cat /etc/systemd/system/yt.service
[Unit]
Description="Petit Service qui va télécharger les videos avec les liens données du fichier /srv/yt/video"

[Service]
ExecStart=/srv/yt/toutoube.sh
User=yt

[Install]
WantedBy=multi-user.target
```
-> Status du service
```bash
[aymeric@Scripting ~]$ sudo systemctl status yt
● yt.service - "Petit Service qui va télécharger les videos avec les liens données du fichier /srv/yt/video"
     Loaded: loaded (/etc/systemd/system/yt.service; disabled; preset: disabled)
     Active: active (running) since Tue 2024-03-05 01:40:22 CET; 5min ago
   Main PID: 5553 (toutoube.sh)
      Tasks: 2 (limit: 4673)
     Memory: 325.9M
        CPU: 25.698s
     CGroup: /system.slice/yt.service
             ├─5553 /bin/bash /home/aymeric/toutoube.sh
             └─5810 sleep 10

Mar 05 01:43:57 Scripting toutoube.sh[5553]: Empty File
```
-> journal de log 
```bash
[aymeric@Scripting ~]$ journalctl -xe -u yt
Mar 05 01:40:26 Scripting toutoube.sh[5553]: Empty File
Mar 05 01:40:32 Scripting systemd[1]: yt.service: Current command vanished from the unit file, execution of the command list won't be resumed.
Mar 05 01:40:36 Scripting toutoube.sh[5553]: Empty File
Mar 05 01:40:46 Scripting toutoube.sh[5553]: Empty File
Mar 05 01:40:56 Scripting toutoube.sh[5553]: Empty File
Mar 05 01:41:06 Scripting toutoube.sh[5553]: Empty File
Mar 05 01:41:16 Scripting toutoube.sh[5553]: Empty File
Mar 05 01:41:26 Scripting toutoube.sh[5553]: Empty File
Mar 05 01:42:02 Scripting toutoube.sh[5553]: Video https://www.youtube.com/watch?v=H9dJPrs8qW4 was downloaded.
Mar 05 01:42:02 Scripting toutoube.sh[5553]: File path : /srv/yt/downloads/Les 165 BOSS SANS MOURIR et en RANDOMIZER/Les 165 BOSS SANS MOURIR et en RANDOMI>
Mar 05 01:42:06 Scripting toutoube.sh[5553]: Empty File
```