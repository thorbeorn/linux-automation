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

phpmyadmin