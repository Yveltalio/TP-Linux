# Troisième TP 🐱

## 1. Analyse du service

### 🌞 S'assurer que le service sshd est démarré

```bash
[aymeric@node1 ~]$ systemctl status | grep ssh
           │ ├─sshd.service
           │ │ └─683 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"
               │ ├─1275 "sshd: aymeric [priv]"
               │ ├─1290 "sshd: aymeric@pts/0"
               │ └─1316 grep --color=auto ssh
```
### 🌞 Analyser les processus liés au service SSH
```bash
[aymeric@node1 ~]$ ps -fu aymeric | grep sshd
aymeric     1290    1275  0 09:34 ?        00:00:00 sshd: aymeric@pts/0
aymeric     1330    1291  0 09:41 pts/0    00:00:00 grep --color=auto sshd
```

### 🌞 Déterminer le port sur lequel écoute le service SSH

```bash
[aymeric@node1 ~]$ ss | grep ssh
tcp   ESTAB  0      52                        10.2.1.11:🌞ssh🌞(22)           10.2.1.1:65486
```
### 🌞 Consulter les logs du service SSH
```bash
[aymeric@node1 ~]$ journalctl | grep ssh
Jan 29 09:34:03 node1.tp2.b1 systemd[1]: Created slice Slice /system/sshd-keygen.
Jan 29 09:34:06 node1.tp2.b1 systemd[1]: Reached target sshd-keygen.target.
Jan 29 09:34:08 node1.tp2.b1 sshd[683]: main: sshd: ssh-rsa algorithm is disabled
Jan 29 09:34:08 node1.tp2.b1 sshd[683]: Server listening on 0.0.0.0 port 22.
Jan 29 09:34:08 node1.tp2.b1 sshd[683]: Server listening on :: port 22.
Jan 29 09:34:16 node1.tp2.b1 sshd[1275]: main: sshd: ssh-rsa algorithm is disabled
Jan 29 09:34:15 node1.tp2.b1 sshd[1275]: Accepted password for aymeric from 10.2.1.1 port 65486 ssh2
Jan 29 09:34:16 node1.tp2.b1 sshd[1275]: pam_unix(sshd:session): session opened for user aymeric(uid=1000) by (uid=0)
```

## 2. Modification du service
### 🌞 Identifier le fichier de configuration du serveur SSH
```bash
[aymeric@node1 /]$ cat /etc/ssh/ssh_config
```
### 🌞 Modifier le fichier de conf

```bash
[aymeric@node1 /]$ echo $RANDOM
21771
[aymeric@node1 /]$ sudo cat /etc/ssh/sshd_config | grep Port
Port 21771
```
- Apres reconnexion :

```bash
[aymeric@node1 ~]$ ss | grep 21771
tcp   ESTAB  0      52                        10.2.1.11:21771         10.2.1.1:50519
```
- Le port est bien utilisé par ssh

## II. Service HTTP

## 1. Mise en place

### 🌞 Installer le serveur NGINX

```powershell
[aymeric@node1 ~]$ cat /etc/nginx/nginx.conf    
    server {
        listen       🌞80🌞;
        listen       [::]:80;
        server_name  _;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
    }
```

### 🌞 Déterminer les processus liés au service NGINX

```bash
[aymeric@node1 ~]$ ss -altnpu | grep 80
tcp   LISTEN 0      511          0.0.0.0:80         0.0.0.0:*
tcp   LISTEN 0      511             [::]:80            [::]:*
```

### 🌞 Déterminer le nom de l'utilisateur qui lance NGINX

```bash
[aymeric@node1 ~]$ ps  -ef | grep nginx
root       11353       1  0 14:32 ?        00:00:00 nginx: master process /usr/sbin/nginx
nginx      11354   11353  0 14:32 ?        00:00:00 nginx: worker process
```

### 🌞 Test !
```bash
$ curl http://10.2.1.11:80 | head*
bash: head*: command not found
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
 54  7620   54  4140    0     0  1732k      0 --:--:-- --:--:-- --:--:-- 2021k
curl: (23) Failure writing output to destination
```

## 2. Analyser la conf de NGINX

### 🌞 Déterminer le path du fichier de configuration de NGINX
```bash
[aymeric@node1 ~]$ ls -al /etc/nginx/
total 84
drwxr-xr-x.  4 root root 4096 Jan 29 14:30 .
drwxr-xr-x. 78 root root 8192 Jan 29 14:30 ..
drwxr-xr-x.  2 root root    6 Oct 16 20:00 conf.d
drwxr-xr-x.  2 root root    6 Oct 16 20:00 default.d
-rw-r--r--.  1 root root 1077 Oct 16 20:00 fastcgi.conf
-rw-r--r--.  1 root root 1077 Oct 16 20:00 fastcgi.conf.default
-rw-r--r--.  1 root root 1007 Oct 16 20:00 fastcgi_params
-rw-r--r--.  1 root root 1007 Oct 16 20:00 fastcgi_params.default
-rw-r--r--.  1 root root 2837 Oct 16 20:00 koi-utf
-rw-r--r--.  1 root root 2223 Oct 16 20:00 koi-win
-rw-r--r--.  1 root root 5231 Oct 16 20:00 mime.types
-rw-r--r--.  1 root root 5231 Oct 16 20:00 mime.types.default
-rw-r--r--.  1 root root 2334 Oct 16 20:00 nginx.conf
-rw-r--r--.  1 root root 2656 Oct 16 20:00 nginx.conf.default
-rw-r--r--.  1 root root  636 Oct 16 20:00 scgi_params
-rw-r--r--.  1 root root  636 Oct 16 20:00 scgi_params.default
-rw-r--r--.  1 root root  664 Oct 16 20:00 uwsgi_params
-rw-r--r--.  1 root root  664 Oct 16 20:00 uwsgi_params.default
-rw-r--r--.  1 root root 3610 Oct 16 20:00 win-utf
```
### 🌞 Trouver dans le fichier de conf

```bash
[aymeric@node1 ~]$ cat /etc/nginx/nginx.conf | grep server -A 10
    server {
        listen       80;
        listen       [::]:80;
        server_name  _;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
    }
```
```bash
[aymeric@node1 ~]$ cat /etc/nginx/nginx.conf | grep include
include /usr/share/nginx/modules/*.conf;
    include             /etc/nginx/mime.types;
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    include /etc/nginx/conf.d/*.conf;
        include /etc/nginx/default.d/*.conf;
#        include /etc/nginx/default.d/*.conf;
```

## 3. Déployer un nouveau site web

### 🌞 Créer un site web

```bash
[aymeric@node1 ~]$ sudo mkdir /var/www/ tp3_linux
[aymeric@node1 ~]$ sudo nano /var/www/tp3_linux index.html
```

### 🌞 Gérer les permissions

```bash
[aymeric@node1 www]$ sudo chown nginx tp3_linux/
[aymeric@node1 tp3_linux]$ sudo chown nginx index.html
```

### 🌞 Adapter la conf NGINX
```bash
[aymeric@node1 conf.d]$ echo $RANDOM
18641
[aymeric@node1 conf.d]$ sudo nano jesuismineur.conf
[aymeric@node1 conf.d]$ sudo firewall-cmd --add-port=18641/tcp --permanent
```
```bash
$ curl http://10.2.1.11:18641 | head*
bash: head*: command not found
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    38  100    38    0     0   7638      0 --:--:-- --:--:-- --:--:--  9500
curl: Failed writing body

```

## III. Your own services

## 2. Analyse des services existants

### 🌞 Afficher le fichier de service SSH
```bash
[aymeric@node1 /]$ systemctl status sshd
Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; preset: enabled)
```
### 🌞 Afficher le fichier de service NGINX

```bash
[aymeric@node1 /]$ sudo cat /usr/lib/systemd/system/sshd.service | grep ExecStart=
ExecStart=/usr/sbin/sshd -D $OPTIONS
```

## 3. Création de service
### 🌞 Créez le fichier /etc/systemd/system/tp3_nc.service
```bash
[aymeric@node1 /]$ echo $RANDOM
13734
[aymeric@node1 /]$ sudo nano /etc/systemd/system/tp3_nc.service
```

### 🌞 Indiquer au système qu'on a modifié les fichiers de service
```bash
[aymeric@node1 /]$ sudo systemctl daemon-reload
```

### 🌞 Démarrer notre service de ouf
```bash
[aymeric@node1 system]$ sudo nano tp3_nc.service
[aymeric@node1 system]$ sudo systemctl start tp3_nc.service
```

### 🌞 Vérifier que ça fonctionne
```bash
[aymeric@node1 system]$ systemctl status tp3_nc.service
● tp3_nc.service - Super netcat tout fou
     Loaded: loaded (/etc/systemd/system/tp3_nc.service; static)
     Active: active (running) since Tue 2024-01-30 07:51:59 CET; 5min ago
   Main PID: 12232 (nc)
      Tasks: 1 (limit: 4673)
     Memory: 792.0K
        CPU: 10ms
     CGroup: /system.slice/tp3_nc.service
             └─12232 /usr/bin/nc -l 13734 -k

Jan 30 07:51:59 node1.tp2.b1 systemd[1]: Started Super netcat tout fou.
```

### 🌞 Vérifier que ça fonctionne

```bash<<>>
[aymeric@node1 system]$ ss -altnp | grep 13734
LISTEN 0      10           0.0.0.0:13734      0.0.0.0:*
LISTEN 0      10              [::]:13734         [::]:*
```
```bash
[aymeric@node1 ~]$ nc -l 13734
quintuple monstre
```
```bash
[aymeric@localhost ~]$ nc 10.2.1.11 13734
quintuple monstre
```

### 🌞 Les logs de votre service
- une commande journalctl filtrée avec grep qui affiche la ligne qui indique le démarrage du service
```bash
[aymeric@node1 ~]$ sudo journalctl -xe -u tp3_nc | grep start
░░ Subject: A start job for unit tp3_nc.service has finished successfully
```
- une commande journalctl filtrée avec grep qui affiche un message reçu qui a été envoyé par le client
```bash
[aymeric@node1 ~]$ sudo journalctl -xe -u tp3_nc | grep monstre
Jan 30 14:08:55 node1.tp2.b1 nc[1422]: monstre
```
- une commande journalctl filtrée avec grep qui affiche la ligne qui indique l'arrêt du service
```bash
[aymeric@node1 ~]$ sudo journalctl -xe -u tp3_nc | grep stop
░░ Subject: A stop job for unit tp3_nc.service has begun execution
░░ A stop job for unit tp3_nc.service has begun execution.
```
### 🌞 Affiner la définition du service
```bash
[Unit]
Description=Super netcat tout fou

[Service]
ExecStart=/usr/bin/nc -l 13734 -k
Restart=always
```