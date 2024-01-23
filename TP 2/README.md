# Deuxième TP 🐱

## I. Fichiers

## 1. Find me

### 🌞 Trouver le chemin vers le répertoire personnel de votre utilisateur

```bash
[aymeric@localhost /]$ cd home/aymeric/
[aymeric@localhost ~]$ pwd
/home/aymeric
```
### 🌞 Trouver le chemin du fichier de logs SSH
```bash
[aymeric@localhost /]$ cat /etc/ssh/ssh_config
```
### 🌞 Trouver le chemin du fichier de configuration du serveur SSH
```bash
[aymeric@localhost /]$ cd /etc/ssh/ssh_config.d
```

## II. Users

## 1. Nouveau user

### 🌞 Créer un nouvel utilisateur
```bash
[aymeric@localhost /]$ sudo useradd -d /home/papier_alu -p password marmotte
[aymeric@localhost /]$ sudo passwd marmotte
```
## 2. Infos enregistrées par le système

### 🌞 Prouver que cet utilisateur a été créé
```bash
[aymeric@localhost /]$ cat /etc/passwd | grep "marmotte"
marmotte:x:1001:1002::/home/papier_alu:/bin/bash
```

### 🌞 Déterminer le hash du password de l'utilisateur marmotte

```bash
[aymeric@localhost /]$ sudo cat /etc/shadow | grep "marmotte"
marmotte:$6$iRBKDGKhPghoXClB$pUeziLP5y.Yri80PjbNPVL27kzgH7w.ggnXSokTHr3w0/M8Jiy6XP61IEA4xZ2oiLzrxBQ8FC.sXCMJWrpaLe0:19744:0:99999:7:::
```

## 3. Hint sur la ligne de commande

### 🌞 Tapez une commande pour vous déconnecter : fermer votre session utilisateur

```bash
[aymeric@localhost /]$ exit
```
### 🌞 Assurez-vous que vous pouvez vous connecter en tant que l'utilisateur marmotte
```bash
[marmotte@localhost ~]$ ls /home/aymeric/
ls: cannot open directory '/home/aymeric/': Permission denied
```

## 1. Run then kill

### 🌞 Lancer un processus sleep

```bash
[marmotte@localhost ~]$ sleep 1000
[marmotte@localhost ~]$ top | grep "sleep"
Tasks: 115 total,   1 running, 114 sleeping,   0 stopped,   0 zombie
```
### 🌞 Terminez le processus sleep depuis le deuxième terminal
```bash
[marmotte@localhost ~]$ ps -ef | grep sleep
marmotte    1818    1744  0 16:29 pts/0    00:00:00 sleep 1000
marmotte    1823    1783  0 16:29 pts/1    00:00:00 grep --color=auto sleep
[marmotte@localhost ~]$ kill 1818
```
### 🌞 Lancer un nouveau processus sleep, mais en tâche de fond
```bash
[marmotte@localhost ~]$ sleep 1000 &
[1] 1824
```
### 🌞 Visualisez la commande en tâche de fond
```bash
[marmotte@localhost ~]$ ps -ef | grep sleep
marmotte    1824    1744  0 16:31 pts/0    00:00:00 sleep 1000
marmotte    1829    1783  0 16:31 pts/1    00:00:00 grep --color=auto sleep
```

## 3. Find paths

### 🌞 Trouver le chemin où est stocké le programme sleep

```bash
[aymeric@localhost /]$ ls -a /bin | grep sleep
sleep
```

### 🌞 Tant qu'on est à chercher des chemins : trouver les chemins vers tous les fichiers qui s'appellent .bashrc
```bash
[aymeric@localhost /]$ sudo find / -name "*.bashrc"
[sudo] password for aymeric:
/etc/skel/.bashrc
/root/.bashrc
/home/slayz/.bashrc
/home/marmotte/.bashrc
/home/papier_alu/.bashrc
```
## 4. La variable PATH

### 🌞 Vérifier que les commandes sleep, ssh, et ping sont bien des programmes stockés dans l'un des dossiers listés dans votre PATH

```bash
[aymeric@localhost /]$ echo $PATH
/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin
[aymeric@localhost /]$ which sleep
/usr/bin/sleep
[aymeric@localhost /]$ which ssh
/usr/bin/ssh
[aymeric@localhost /]$ which ping
/usr/bin/ping
[aymeric@localhost /]$
```

## II. Paquets

### 🌞 Installer le paquet git

```bash
[aymeric@localhost ~]$ sudo dnf install git
```

### 🌞 Utiliser une commande pour lancer git

```bash
[aymeric@localhost /]$ ls -a /bin | grep git
git
git-receive-pack
git-shell
git-upload-archive
git-upload-pack
```

### 🌞 Installer le paquet nginx

```bash
[aymeric@localhost /]$ sudo dnf install nginx
```
### 🌞 Déterminer le chemin vers le dossier de logs de NGINX
```bash
[aymeric@localhost /]$ sudo cat /var/log/nginx/
```
### 🌞 Déterminer le chemin vers le dossier qui contient la configuration de NGINX
```bash
[aymeric@localhost /]$ cat /etc/nginx/nginx.conf
```
### 🌞 Mais aussi déterminer...

```bash
[aymeric@localhost yum.repos.d]$ grep -nri "http" /etc/yum.repos.d/
```  

## Partie 3 : Poupée russe

### 🌞 Récupérer le fichier meow

```bash
[aymeric@localhost ~]$ curl -SLO https://gitlab.com/it4lik/b1-linux-2023/-/raw/master/tp/2/meow?inline=false
[aymeric@localhost ~]$ file meow\?inline\=false
[aymeric@localhost ~]$ mv meow\?inline\=false meow
[aymeric@localhost ~]$ mv meow meow.zip
[aymeric@localhost ~]$ unzip meow.zip
```
### 🌞 Trouver le dossier dawa/

```bash
[aymeric@localhost ~]$ file meow
meow: HTML document, UTF-8 Unicode text, with very long lines
```
```bash
[aymeric@localhost ~]$ ls
dawa  meow.rar  meow.tar  meow.zip
```
### 🌞 Dans le dossier dawa/, déterminer le chemin vers
- 🌞 Dans le dossier dawa/, déterminer le chemin vers
```bash
[aymeric@localhost dawa]$ sudo find -size 15M
./folder31/19/file39
```
- 🌞 le seul fichier qui ne contient que des 7
```bash
[aymeric@localhost dawa]$ grep -r -E "^7*$"
grep: folder31/19/file39: binary file matches
folder43/38/file41:77777777777
```
- 🌞 le seul fichier qui est nommé cookie
```bash
[aymeric@localhost dawa]$ sudo find -name "cookie"
./folder14/25/cookie
```

- 🌞 le seul fichier caché (un fichier caché c'est juste un fichier dont le nom commence par un .)

```bash
[aymeric@localhost dawa]$ sudo find -name ".*"
.
./folder32/14/.hidden_file
```

- 🌞 le seul fichier qui date de 2014

```bash 
[aymeric@localhost dawa]$  find . -newermt '2014-01-01 00:00' -not -newermt '2015-01-01 00:00'
./folder36/40/file43
```

- 🌞 le seul fichier qui a 5 dossiers-parents

```bash
[aymeric@localhost dawa]$ find -wholename "**/*/*/*/*/*/*"
./folder37/45/23/43/54/file43
```