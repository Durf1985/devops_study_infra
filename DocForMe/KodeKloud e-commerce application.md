# KodeKloud 2-tier application

## Deployment Model -Single Node

1. install firewall
   1 sudo yum install firewalld
   2 sudo service firewalld start
   3 systemctl enable firewalld
   4 systemctl status firewalld (active(running))
   5 firewall-cmd --list-all (check firewall rules )

## Maria DB

1. install MariaDB
   1. sudo yum install mariadb-server

2. Configure Maria DB
   1 sudo vi /etc/my.cnf # configure the file with the right port

3. Start Maria DB
   1 sudo systemctl start mariadb
   2 systemctl enable mariadb
   3 sudo systemctl status mariadb (active)

4. Configure FireWall
   1 sudo firewall-cmd --premanent --zone=public --add-port=3306/tcp
   2 sudo firewall-cmd --reload
   3 sudo firewall-cmd --list-all (check settings)

5. Configure Database
   1 mysql
   2 MariaDB > CREATE DATABASE ecomdb;
      1 show databases;
   3 MariaDB > CREATE USER 'ecomuser'@'localhost' IDENTIFIED BY 'ecompassword'; (user@% - % - connection from any host)
   4 GRANT ALL PRIVILEGES ON _._ TO 'ecomuser'@'localhost';
   5 FLUSH PRIVILEGES

6. Load Data
   1 cat > db-load-script.sql (copy script from git repos)
   2 mysql < db-load-script.sql
   3 mysql
   4 use ecomdb;
   5 select * from products (test DB)

## Php

1. install httpd (Apache)
   1 sudo yum install -y httpd php php-mysqlnd
2. instal php see 1.1

3. configure firewall
   1 sudo firewall-cmd --permanent --zone-public --add-port-80/tcp
   2 sudo firewall-cmd --reload
   3 sudo firewall-cmd --list-all

4. configure httpd
   1 sudo vi /etc/httpd/conf/httpd.conf # configure DirectoryIndex to use index.php instead of index.html
   2 service httpd restart (после каждого изменения нужно рестартовать апач)

5. start httpd
   1 sudo systemctl start httpd
   2 sudo systemctl enable httpd
   3 sudo systemctl status httpd

6. Download Code
 Before curl <http://localhost>
   1 git clone hhtps://github.com/"applicatio".git /var/www/html/
      1 sudo yum install -y git
   2 /var/www/html/ Update index.php to use the right database address, name and credentials (set localhost) if you create file index.html and then /etc/httpd/conf/httpd.conf takes this file, DirectoryIndex - select between php/html

7. Test
   1 curl http://localhost

Model -Multi Node
Separated install module
mariaDB ip -172.20.1.101
-mysql
-MariaDB > CREATE DATABASE ecomdb;
-MariaDB > CREATE USER 'ecomuser'@'172.20.1.102' IDENTIFIED BY 'ecompassword';
-GRANT ALL PRIVILEGES ON _._ TO 'ecomuser'@'172.20.1.102';
-FLUSH PRIVILEGES

apache,php ip 172.20.1.102
configure index.php file on webserver with the IP address of the database server. ($link = mysqli_connecti(172.20.1.101))
