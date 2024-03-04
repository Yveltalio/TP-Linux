# Quatrième TP 🐱

# Partie 1 : Partitionnement du serveur de stockage

## 🌞 Partitionner le disque à l'aide de LVM

```bash
[aymeric@storage ~]$ sudo pvcreate /dev/sdb
[aymeric@storage ~]$ sudo pvcreate /dev/sdc
[aymeric@storage ~]$ sudo pvs
  Devices file sys_wwid t10.ATA_VBOX_HARDDISK_VBd763fb9d-368c9587 PVID od2OrVtDlG9j6bs1jGB2VVvZBcChX69j last seen on /dev/sda2 not found.
  PV         VG Fmt  Attr PSize PFree
  /dev/sdb      lvm2 ---  2.00g 2.00g
  /dev/sdc      lvm2 ---  2.00g 2.00g
[aymeric@storage ~]$ sudo vgcreate storage /dev/sdb
[aymeric@storage ~]$ sudo vgextend storage /dev/sdc
[aymeric@storage ~]$ sudo vgdisplay
  Devices file sys_wwid t10.ATA_VBOX_HARDDISK_VBd763fb9d-368c9587 PVID od2OrVtDlG9j6bs1jGB2VVvZBcChX69j last seen on /dev/sda2 not found.
  --- Volume group ---
  VG Name               storage
  System ID
  Format                lvm2
  Metadata Areas        2
  Metadata Sequence No  2
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                0
  Open LV               0
  Max PV                0
  Cur PV                2
  Act PV                2
  VG Size               3.99 GiB
  PE Size               4.00 MiB
  Total PE              1022
  Alloc PE / Size       0 / 0
  Free  PE / Size       1022 / 3.99 GiB
  VG UUID               ntBuSE-ulMR-m27C-rF7B-yqlR-o8gi-vXr60w
[aymeric@storage ~]$ sudo lvcreate -l 100%FREE apaganan -n last_data
[aymeric@storage ~]$ sudo lvs
  Devices file sys_wwid t10.ATA_VBOX_HARDDISK_VBd763fb9d-368c9587 PVID od2OrVtDlG9j6bs1jGB2VVvZBcChX69j last seen on /dev/sda2 not found.
  LV       VG      Attr       LSize Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  apaganan storage -wi-a----- 3.99g

```

## 🌞 Formater la partition

```bash
[aymeric@storage ~]$ sudo mkfs -t ext4 /dev/storage/apaganan
```

## 🌞 Monter la partition

```bash
[aymeric@storage storage]$ df -h | grep apaganan
/dev/mapper/storage-apaganan  3.9G   24K  3.7G   1% /storage
[aymeric@storage storage]$ sudo nano /etc/fstab
[aymeric@storage storage]$ sudo umount /storage
[aymeric@storage ~]$ sudo mount -av
/                        : ignored
/boot                    : already mounted
none                     : ignored
mount: /storage does not contain SELinux labels.
       You just mounted a file system that supports labels which does not
       contain labels, onto an SELinux box. It is likely that confined
       applications will generate AVC messages and not be allowed access to
       this file system.  For more details see restorecon(8) and mount(8).
mount: (hint) your fstab has been modified, but systemd still uses
       the old version; use 'systemctl daemon-reload' to reload.
/storage                 : successfully mounted
[aymeric@storage ~]$ sudo reboot
[aymeric@storage ~]$ df -h | grep storage
/dev/mapper/storage-apaganan  3.9G   24K  3.7G   1% /storage
```
# Partie 2 : Serveur de partage de fichiers

## 🌞 Donnez les commandes réalisées sur le serveur NFS storage.tp4.linux

```bash
[aymeric@storage /]$ history
   72  sudo mkdir /storage/site_web_1 -p
   74  sudo mkdir /storage/site_web_2 -p
   75  ls /storage/
   76  ls -dl /storage/
   77  ls -dl /storage/site_web_1
   78  sudo chown aymeric /storage/site_web_1
   79  sudo chown aymeric /storage/site_web_2
   80  sudo nano /etc/exports
   81  sudo systemctl enable nfs-server
   82  sudo systemctl start nfs-server
   84  sudo systemctl status nfs-server
   86  sudo firewall-cmd --permanent --list-all | grep services
   88  sudo firewall-cmd --permanent --add-service=nfs
   89  sudo firewall-cmd --permanent --add-service=mountd
   91  sudo firewall-cmd --permanent --add-service=rpc-bind
   92  sudo firewall-cmd --reload
   94  sudo firewall-cmd --permanent --list-all | grep services
[aymeric@storage ~]$ cat /etc/exports
/storage 10.4.1.2(rw,sync,no_root_squash,no_subtree_check)
```

## 🌞 Donnez les commandes réalisées sur le client NFS web.tp4.linux

```bash
[aymeric@web ~]$ history
 mkdir /var/www
   8  sudo mkdir /var/www
   10  sudo mkdir /var/www/site_web_1
   11  sudo mkdir /var/www/site_web_2
   12  sudo mount 10.4.1.3:/storage/site_web_1 /var/www/site_web_1
   13  sudo mount 10.4.1.3:/storage/site_web_2 /var/www/site_web_2
   14  df -h
[aymeric@web ~]$ df -h
Filesystem                    Size  Used Avail Use% Mounted on
devtmpfs                      4.0M     0  4.0M   0% /dev
tmpfs                         386M     0  386M   0% /dev/shm
tmpfs                         155M  3.7M  151M   3% /run
/dev/mapper/rl-root           6.2G  1.2G  5.0G  20% /
/dev/sda1                    1014M  220M  795M  22% /boot
tmpfs                          78M     0   78M   0% /run/user/1000
10.4.1.3:/storage/site_web_1  3.9G     0  3.7G   0% /var/www/site_web_1
10.4.1.3:/storage/site_web_2  3.9G     0  3.7G   0% /var/www/site_web_2
[aymeric@storage ~]$ sudo cat /etc/fstab
[sudo] password for aymeric:
#
# /etc/fstab
# Created by anaconda on Mon Oct 23 13:18:44 2023
#
# Accessible filesystems, by reference, are maintained under '/dev/disk/'.
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info.
#
# After editing this file, run 'systemctl daemon-reload' to update systemd
# units generated from this file.
#
/dev/mapper/rl-root     /                       xfs     defaults        0 0
UUID=6e750898-cacf-4262-a22a-cc147c5256f1 /boot                   xfs     defaults        0 0
/dev/mapper/rl-swap     none                    swap    defaults        0 0
/dev/storage/apaganan /storage ext4 defaults 0 0

[aymeric@web ~]$ sudo touch /var/www/site_web_1/index.html
[sudo] password for aymeric:
[aymeric@web ~]$ ls -l /var/www/site_web_1/index.html
-rw-r--r--. 1 root root 0 Feb 20 13:59 /var/www/site_web_1/index.html

```
# Partie 3 : Serveur web

## 2. Install
```bash
[aymeric@web ~]$ sudo dnf install nginx -y
```

## 3. Analyse

```bash
[aymeric@web ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
success
[aymeric@web ~]$ sudo firewall-cmd --reload
success
[aymeric@web ~]$ sudo systemctl start nginx
[sudo] password for aymeric:
[aymeric@web ~]$ sudo systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; preset: disabled)
     Active: active (running) since Tue 2024-02-20 14:41:09 CET; 4s ago
    Process: 1641 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
    Process: 1642 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
    Process: 1643 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
   Main PID: 1644 (nginx)
      Tasks: 2 (limit: 4673)
     Memory: 1.9M
        CPU: 23ms
     CGroup: /system.slice/nginx.service
             ├─1644 "nginx: master process /usr/sbin/nginx"
             └─1645 "nginx: worker process"

Feb 20 14:41:09 web systemd[1]: Starting The nginx HTTP and reverse proxy server...
Feb 20 14:41:09 web nginx[1642]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
Feb 20 14:41:09 web nginx[1642]: nginx: configuration file /etc/nginx/nginx.conf test is successful
Feb 20 14:41:09 web systemd[1]: Started The nginx HTTP and reverse proxy server.
```

### 🌞 Analysez le service NGINX

```bash
[aymeric@web ~]$ ps -ef | grep nginx
root        1644       1  0 14:41 ?        00:00:00 nginx: master process /usr/sbin/nginx
nginx       1676    1644  0 14:43 ?        00:00:00 nginx: worker process
[aymeric@web ~]$ ss -salputen |grep nginx
tcp   LISTEN 0      511          0.0.0.0:80        0.0.0.0:*    ino:25264 sk:6 cgroup:/system.slice/nginx.service <->
tcp   LISTEN 0      511             [::]:80           [::]:*    ino:25265 sk:9 cgroup:/system.slice/nginx.service v6only:1 <->
```
## 4. Visite du service web

```bash
[aymeric@web ~]$ curl 10.4.1.2:80
<!doctype html>
...
```

### 🌞 Vérifier les logs d'accès
```bash
[aymeric@web ~]$ sudo tail -n 3 /var/log/nginx/error.log
2024/02/20 14:43:18 [notice] 1675#1675: signal process started
2024/02/20 14:43:22 [error] 1676#1676: *2 open() "/usr/share/nginx/html/favicon.ico" failed (2: No such file or directory), client: 10.4.1.1, server: _, request: "GET /favicon.ico HTTP/1.1", host: "10.4.1.2", referrer: "http://10.4.1.2/"
```

## 5. Modif de la conf du serveur web

### 🌞 Changer le port d'écoute

```bash
[aymeric@web ~]$ sudo firewall-cmd --add-port=8080/tcp --permanent
success
[aymeric@web ~]$ sudo firewall-cmd --reload
success
[aymeric@web ~]$ sudo cat /etc/nginx/nginx.conf |grep 8080
        listen       8080;
        listen       [::]:8080;
[aymeric@web ~]$ curl 10.4.1.2:8080
<!doctype html>
...
```

### 🌞 Changer l'utilisateur qui lance le service

```bash
[aymeric@web ~]$ sudo useradd -m web
[aymeric@web ~]$ sudo passwd web
[aymeric@web ~]$ ps -ef | grep web
web         1871    1870  0 15:08 ?        00:00:00 nginx: worker process
```

### 🌞 Changer l'emplacement de la racine Web

```bash
[aymeric@web ~]$ sudo cat /etc/nginx/conf.d/site_web_1.conf
[aymeric@web ~]$ cat /etc/nginx/conf.d/site_web_1.conf
server {
    listen       8080;
    listen       [::]:8080;
    server_name  _;
    root         /var/www/site_web_1;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
}
[aymeric@web ~]$ sudo systemctl restart nginx
[aymeric@web ~]$ sudo curl 10.4.1.2:8080
<h1>Leo le goat</h1>
```

## 6. Deux sites web sur un seul serveur

### 🌞 Repérez dans le fichier de conf

```bash
[aymeric@web ~]$ cat /etc/nginx/conf.d/site_web_1.conf | grep conf
        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;
```

### 🌞 Créez le fichier de configuration pour le deuxieme site

```bash
[aymeric@web ~]$ cat /etc/nginx/conf.d/site_web_2.conf
server {
    listen       8888;
    listen       [::]:8888;
    server_name  _;
    root         /var/www/site_web_2;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
}
[aymeric@web ~]$ sudo cat /var/www/site_web_2/index.html
<h1>kakoukakou</h1>
[aymeric@web ~]$ sudo systemctl restart nginx
[aymeric@web ~]$ sudo firewall-cmd --add-port=8888/tcp --permanent
success
[aymeric@web ~]$ sudo firewall-cmd --reload
success

```

### 🌞  Prouvez que les deux sites sont disponibles

```bash
[aymeric@web ~]$ sudo curl 10.4.1.2:8080
<h1>Leo le goat</h1>
[aymeric@web ~]$ sudo curl 10.4.1.2:8888
<h1>kakoukakou</h1>
```