
# Installation du serveur Regovar

## Pré-requis

 * Linux Ubuntu Xenial (la seule distribution testé à ce jour).
 * Les droits admins sur le serveur
 * Accès internet depuis le serveur
 * Python 3.6
 * [Dépôt pour PostgresSQL 9.6](https://askubuntu.com/questions/831292/how-to-install-postgresql-9-6-on-any-ubuntu-version) ?


## Installation

Les commandes préfixées par '#' sont a exécuter en tant que root.


```
    # apt update && apt upgrade
    # apt install git ca-certificates nginx postgresql-9.6 build-essential libssl-dev libffi-dev python3.6-dev virtualenv libpq-dev libmagickwand-dev python3-venv
    # useradd regovar --create-home
    # adduser regovar sudo # We need sudo power 
    # sudo -u postgres createuser -P -s regovar # type "regovar" as password
    # sudo -u postgres createdb regovar
    # mkdir -p /var/regovar/{cache,downloads,files,pipelines,jobs,databases/hg19,databases/hg38}
    # cd /var/regovar/databases/hg38
    # wget http://hgdownload.soe.ucsc.edu/goldenPath/hg38/database/refGene.txt.gz
    # gunzip refGene.txt.gz
    # cd /var/regovar/databases/hg19
    # wget http://hgdownload.soe.ucsc.edu/goldenPath/hg19/database/refGene.txt.gz
    # gunzip refGene.txt.gz
    # chown -R regovar:regovar /var/regovar
    # su regovar
    $ cd
    $ git clone https://github.com/REGOVAR/Regovar.git ~/Regovar
    $ cd ~/Regovar
    $ virtualenv -p /usr/bin/python3.6 venv
    $ source venv/bin/activate
    => CHECK that you are using python 3.6
    $ python --version
    $ pip --version
    $ pip install -r requirements.txt
    $ cd regovar
    $ make init
    => Please, edit the $PWD/config.py file before proceed to the installation with the command 'make install'
    $ make install 
    $ make update_hpo
```

### If you get 'error FATAL peer authentication'
You need to update the postgresql server config to allow "trus connection" : /etc/postgresql/9.6/main/pg_hba.conf

```
# "local" is for Unix domain socket connections only
local   all             all                                     trust
```

## Configuration avec NginX


```
    $ nano ./config.py # edit the config file with your settings
    # echo 'upstream aiohttp_regovar
    {
        server 127.0.0.1:8500 fail_timeout=0;
    }

    server
    {
        listen 80;
        listen [::]:80;
        server_name dev.regovar.org;
        
        location / {
            # Need for websockets
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";

            proxy_set_header Host $http_host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_redirect off;
            proxy_buffering off;
            proxy_pass http://aiohttp_regovar;
        }

        location /static {
            root /var/regovar/regovar;
        }
    }' > /etc/nginx/sites-available/regovar
    # rm /etc/nginx/sites-enabled/default
    # ln -s /etc/nginx/sites-available/regovar /etc/nginx/sites-enabled
    # /etc/init.d/nginx restart
```


## Configurer HTTPS et la certification

TODO



## Démarrer et tester le serveur


```
    $ make app &!
```

