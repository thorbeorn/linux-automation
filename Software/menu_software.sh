function apache_check() {
        which "apache2" | grep -o "apache2" > /dev/null &&  return 0 || return 1
}
function apache_install(){
	echo "Apache2 n'est pas installer sur le disque, installation en cour..."
	echo " "
	apt-get install -y apache2
	echo"Installation de apache2 terminée avec success !"
}
function php_check() {
        which "php" | grep -o "php" > /dev/null &&  return 0 || return 1
}
function php_install(){
        echo "php n'est pas installer sur le disque, installation en cour..."
        echo " "
        apt-get install -y php7.4
	apt-get install -y php-fpm
	echo "Installation de php terminée avec success !"
}
function desactivate_apache_modules(){
	echo "desactivation du module $1..."
	a2dismod "$1"
}
function activate_apache_modules(){
        echo "activation du module $1..."
        a2enmod "$1"
}
function php_module_process(){
	if [ -f "/etc/apache2/mods-enabled/php7.4.conf" ];
                then desactivate_apache_modules "php7.4";
        else echo "module php7.4 est deja desactiver."; fi

	if [ -f "/etc/apache2/mods-enabled/mpm_prefork.conf" ];
		then desactivate_apache_modules "mpm_prefork";
	else echo "module mpm_prefork est deja desactiver."; fi

	if [ -f "/etc/apache2/mods-enabled/mpm_event.conf" ];
                then desactivate_apache_modules "mpm_event";
        else echo "module mpm_event est deja desactiver."; fi

	if [ -f "/etc/apache2/mods-enabled/mpm_worker.conf" ];
                then echo "module mpm_worker est deja activer.";
        else activate_apache_modules "mpm_worker"; fi

	if [ -f "/etc/apache2/mods-enabled/proxy_fcgi.load" ];
                then echo "module proxy_fcgi est deja activer.";
        else activate_apache_modules "proxy_fcgi"; fi

	if [ -f "/etc/apache2/mods-enabled/setenvif.conf" ];
                then echo "module setenvif est deja activer.";
        else activate_apache_modules "setenvif"; fi
}
function activate_apache_configs(){
	echo "activation de la config $1..."
        a2enconf "$1"
}
function php_conf_process(){
	if [ -f "/etc/apache2/conf-enabled/php7.4-fpm.conf" ];
                then echo "conf php7.4-fpm est deja activer.";
        else activate_apache_configs "php7.4-fpm"; fi
}
function activate_apache_site(){
	echo "activation du site $1..."
        a2enconf "$1"
}
function page_default_apache(){
	if [ -f "/etc/apache2/sites-enabled/000-default.conf" ];
                then echo "le site apache par default est deja activer.";
        else activate_apache_site "000-default"; fi
}
function page_php_info_create(){
	touch "/var/www/html/phpinfo.php"
	echo "<?php phpinfo(); ?>" >> "/var/www/html/phpinfo.php"
	echo "php_info page create succes"
}
function page_php_info_dejacreate(){
	rm "/var/www/html/phpinfo.php"
	page_php_info_create
}
function page_php_info(){
	if [ -f "/var/www/html/phpinfo.conf" ];
                then page_php_info_dejacreate;
        else page_php_info_create; fi
}

function apache_configuration(){
	echo "================================= APACHE2 ================================="
	echo "Verification de l'installation de apache2"
	if apache_check "apache2" == 0 ;
        	then echo "Apache2 est deja installer sur le disque !";
        else apache_install; fi
	echo " "
}
function php_configuration(){
	echo "================================= PHP ================================="
	echo "Verification de l'installation de PHP"
	if php_check "php" == 0 ;
                then echo "php est deja installer sur le disque !";
        else php_install; fi
	echo " "
	echo "Verification de l'environnement de php !"
	php_module_process
	php_conf_process
	systemctl restart apache2
	echo "environnement de php fonctionnel"
	echo " "
}
function page_test_php_apache(){
	echo "================================= Enabled page test ================================="
	page_default_apache
	page_php_info
	echo "les pages sont crée vous pouvez vous y rendre: http://localhost pour apache et http://localhost/phpinfo.php"
}

function installutilities() {
    apt install -y git wget nano vim net-tools tcpdump openssl ssh
}

function mariadb() {
    apt-get -y install mariadb-server
    sed -i "s/bind-address/#bind-address/" /etc/mysql/mariadb.conf.d/50-server.cnf
    sed -i "s/\\#skip-name-resolve/skip-name-resolve/" /etc/mysql/mariadb.conf.d/50-server.cnf
    systemctl restart mysql
    echo -e "create user root;\ngrant all on *.* to root  with grant option;\nalter user root identified by 'mdp';\ngrant all on *.* to root@localhost  with grant option;\nalter user root@localhost identified by 'mdp';" > conn.sql
    mysql -u "root" "-p " "mysql" < conn.sql
}

function phpmyadmin() {
    mkdir /phpmyadmin
    apt-get install -y unzip
    wget https://files.phpmyadmin.net/phpMyAdmin/5.1.1/phpMyAdmin-5.1.1-all-languages.zip -O /home/phpmyadmin.zip
    unzip /home/phpmyadmin.zip -d  /home/
    mv /home/phpMyAdmin-5.1.1-all-languages /home/phpmyadmin
    echo -e "Alias /phpmyadmin /home/phpmyadmin\n<Directory /home/phpmyadmin>\nRequire all granted\n</Directory>" > /etc/apache2/conf-available/phpmyadmin.conf
    a2enconf phpmyadmin 
    systemctl reload apache2
    apt-get install -y php-mysqli php-xml php-mbstring
    apt-get -y update && apt-get -y upgrade
    mv /home/phpmyadmin/config.sample.inc.php /home/phpmyadmin/config.inc.php
    sed -i -e "s/blowfish_secret'] = '';/blowfish_secret'] = 'Jlt;MiySEYxf]8WBJ4At2kFFh4Bdui99';/" /home/phpmyadmin/config.inc.php
    mkdir /home/phpmyadmin/tmp/
    chmod 777 /home/phpmyadmin/tmp 
}

function proftpd() {
    apt-get install -y proftpd
    sed -i 's/ServerName "Debian"/ServerName "192.168.1.90"/' /etc/proftpd/proftpd.conf
    sed -i 's/DisplayLogin welcome.msg/DisplayLogin "serveur FTP"/' /etc/proftpd/proftpd.conf
    echo "RequireValidShell  on" >> /etc/proftpd/proftpd.conf
    echo "RootLogin  off" >> /etc/proftpd/proftpd.conf
    echo "DefaultRoot ~" >> /etc/proftpd/proftpd.conf
    echo -e "<Limit LOGIN>\nDenyGroup  \\!ftpuser\n</Limit>" >> /etc/proftpd/proftpd.conf
    echo "/bin/false" >> /etc/shells
    adduser user1 --shell /bin/false --home /home/user1
    echo -e "<Directory /home /user1>\nUmask 022\nAllowOverwrite off\n<Limit LOGIN>\nAllowUser user1\nDenyAll\n</Limit>\n<Limit ALL>\nAllowUser user1\nDenyAll\n</Limit>\n</Directory>" >> /etc/proftpd/proftpd.conf
}

function afficher_choix_Software() {
    clear
    echo "1) Install Apache2 et PHP7.4"
    echo "2) Install utilities"
    echo "3) Install MariaDB"
    echo "4) Install PHPMyAdmin"
    echo "5) Install ProFTPD"
    echo "6) Quit"
    choisir_fonction_Software
}

function choisir_fonction_Software() {
    read -n1 -p "Choose action (1-6) : " Action_Software
    if [ "$Action_Software" == "1" ]; then
        clear
        apache_configuration
        php_configuration
        page_test_php_apache
    elif [ "$Action_Software" == "2" ]; then
        clear
        installutilities
    elif [ "$Action_Software" == "3" ]; then
        clear
        mariadb
    elif [ "$Action_Software" == "4" ]; then
        phpmyadmin
        exit
    elif [ "$Action_Software" == "5" ]; then
        proftpd
        exit
    elif [ "$Action_Software" == "6" ]; then
        clear
        exit
    else
        echo "incorrect entry, please retry !"
        choisir_fonction_Update
    fi
}

afficher_choix_Software