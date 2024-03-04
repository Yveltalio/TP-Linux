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