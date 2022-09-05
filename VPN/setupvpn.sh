sudo tee /etc/apt/sources.list.d/pritunl.list << EOF
deb <http://repo.pritunl.com/stable/apt> focal main
EOF
sudo apt --assume-yes install gnupg
gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 7568D9BB55FF9E5287D586017AE645C0CF8E292A
gpg --armor --export 7568D9BB55FF9E5287D586017AE645C0CF8E292A | sudo tee /etc/apt/trusted.gpg.d/pritunl.asc
wget -qO - <https://www.mongodb.org/static/pgp/server-6.0.asc> | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] <https://repo.mongodb.org/apt/ubuntu> focal/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.  list
sudo apt update
sudo apt install -y mongodb-org pritunl
sudo systemctl start mongod pritunl
sudo systemctl enable mongod pritunl
