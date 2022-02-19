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

proftpd