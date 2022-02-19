function mariadb() {
    apt-get -y install mariadb-server
    sed -i "s/bind-address/#bind-address/" /etc/mysql/mariadb.conf.d/50-server.cnf
    sed -i "s/\\#skip-name-resolve/skip-name-resolve/" /etc/mysql/mariadb.conf.d/50-server.cnf
    systemctl restart mysql
    echo -e "create user root;\ngrant all on *.* to root  with grant option;\nalter user root identified by 'mdp';\ngrant all on *.* to root@localhost  with grant option;\nalter user root@localhost identified by 'mdp';" > conn.sql
    mysql -u "root" "-p " "mysql" < conn.sql
}

mariadb