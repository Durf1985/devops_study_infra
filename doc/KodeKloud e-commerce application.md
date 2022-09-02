# KodeKloud 2-tier application

## Deployment Model -Single Node

1. install firewall

  ```bash
   * sudo yum install firewalld
   * sudo service firewalld start
   * systemctl enable firewalld
   * systemctl status firewalld (active(running))
   * firewall-cmd --list-all (check firewall rules )
   ```

## Maria DB

1. install MariaDB
   `sudo yum install mariadb-server`

2. Configure Maria DB
   `sudo vi /etc/my.cnf # configure the file with the right port`

3. Start Maria DB

   ```bash
   sudo systemctl start mariadb
   systemctl enable mariadb
   sudo systemctl status mariadb (active)
   ```

4. Configure FireWall

   ```bash
   sudo firewall-cmd --premanent --zone=public --add-port=3306/tcp
   sudo firewall-cmd --reload
   sudo firewall-cmd --list-all (check settings)
   ```

5. Configure Database

   ```bash
   mysql
   MariaDB > CREATE DATABASE ecomdb;
   show databases;
   MariaDB > CREATE USER 'ecomuser'@'localhost' IDENTIFIED BY 'ecompassword'; (user@% - % - connection from any host)
   GRANT ALL PRIVILEGES ON _._ TO 'ecomuser'@'localhost';
   FLUSH PRIVILEGES
   ```

6. Load Data

   ```bash
   cat > db-load-script.sql (copy script from git repos)
   mysql < db-load-script.sql
   mysql
   use ecomdb;
   select * from products (test DB)
   ```

## Php

1. install httpd (Apache)
   `sudo yum install -y httpd php php-mysqlnd`
2. instal php see 1.1

3. configure firewall

   ```bash
   sudo firewall-cmd --permanent --zone-public --add-port-80/tcp
   sudo firewall-cmd --reload
   sudo firewall-cmd --list-all
   ```

4. configure httpd

   ```bash
   * sudo vi /etc/httpd/conf/httpd.conf # configure DirectoryIndex to use index.php instead of index.html
   ```

   * service httpd restart (after each change, you need to restart apache)

5. start httpd

   ```bash
   * sudo systemctl start httpd
   * sudo systemctl enable httpd
   * sudo systemctl status httpd
   ```

6. Download Code
 Before curl <http://localhost>

   ```bash
   * git clone hhtps://github.com/"applicatio".git /var/www/html/
   * sudo yum install -y git
   ```

   * /var/www/html/ Update index.php to use the right database address, name and credentials (set localhost) if you create file index.html and then /etc/httpd/conf/httpd.conf takes this file, DirectoryIndex - select between php/html

7. Test
   * curl <http://localhost>

   ```MySQL
   Model -Multi Node
   Separated install module
   mariaDB ip -172.20.1.101
   mysql
   MariaDB > CREATE DATABASE ecomdb;
   MariaDB > CREATE USER 'ecomuser'@'172.20.1.102' IDENTIFIED BY 'ecompassword';
   GRANT ALL PRIVILEGES ON _._ TO 'ecomuser'@'172.20.1.102';
   FLUSH PRIVILEGES;

   apache,php ip 172.20.1.102
   configure index.php file on web server with the IP address of the database server. ($link = mysqli_connecti(172.20.1.101))
   ```
